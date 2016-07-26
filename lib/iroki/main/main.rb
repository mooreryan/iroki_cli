# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of Iroki.
#
# Iroki is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Iroki is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Iroki.  If not, see <http://www.gnu.org/licenses/>.

require "bio"
require "set"
require "trollop"

module Iroki
  module Main
    def self.main(color_branches: nil,
                  color_taxa_names: nil,
                  exact: nil,
                  remove_bootstraps_below: nil,
                  color_map_f: nil,
                  biom_f: nil,
                  name_map_f: nil,
                  auto_color: nil,
                  display_auto_color_options: nil,
                  newick_f: nil,
                  out_f: nil)

      if display_auto_color_options
        STDERR.puts "\n  Choices for --auto-color ..."
        STDERR.print "    - kelly: up to 19 high contrast colors (purple, orange, light blue, red, ...)\n\n"
        exit
      end

      auto_color_options = ["kelly"]

      abort_if !auto_color.nil? && !auto_color_options.include?(auto_color),
               "'#{auto_color}' is not a valid option. Try iroki --help for help."

      case auto_color
      when nil
        auto_color_hash = nil
      when "kelly"
        auto_color_hash = Iroki::Color::Palette::KELLY
      end

      abort_if biom_f && color_map_f,
               "--color-map and --biom-file cannot both be specified. Try iroki --help for help."

      newick = check_file newick_f, :newick

      color_f = nil
      if !biom_f && (color_taxa_names || color_branches)
        color_f = check_file color_map_f, :color_map_f
      end

      check = color_map_f &&
              !color_taxa_names &&
              !color_branches

      abort_if check,
               "A pattern file was provided without specifying " +
               "any coloring options"

      # get the color patterns
      if color_f
        patterns = parse_color_map color_f,
                                   exact_matching: exact,
                                   auto_color: auto_color_hash
      else
        samples, counts = Biom.open(biom_f).parse_single_sample
        patterns = SingleSampleGradient.new(samples, counts).patterns
      end

      treeio = Bio::FlatFile.open(Bio::Newick, newick)

      newick = treeio.next_entry
      tree = newick.tree

      # do this first cos everything after will use the "new" names
      if name_map_f
        name_map = parse_name_map name_map_f

        tree.collect_node! do |node|
          unless node.name.nil?
            # every name is cleaned no matter what
            node.name = clean node.name

            if name_map.has_key?(node.name)
              node.name = name_map[node.name]
            end
          end

          node
        end
      end

      if color_taxa_names
        leaves = tree.leaves.map do |n|
          name = n.name.clean_name

          if (color = add_color_to_leaf_branch(patterns, name, exact))
            name + color[:label]
          else
            name
          end
        end
      else
        leaves = tree.leaves.map { |n| clean_name n.name }
      end

      if color_branches
        total = tree.nodes.count
        n = 0
        tree.collect_node! do |node|
          n += 1
          $stderr.printf "Node: %d of %d\r", n, total

          color_nodes patterns, tree, node, exact
        end
      end
      $stderr.puts

      if remove_bootstraps_below
        tree.collect_node! do |node|
          if node.bootstrap && node.bootstrap < remove_bootstraps_below
            node.bootstrap_string = ""
          end

          node
        end
      end



      tre_str = tree.newick(indent: false).gsub(/'/, '')

      nexus = "#NEXUS
begin taxa;
dimensions ntax=#{leaves.count};
taxlabels
#{leaves.join("\n")}
;
end;

begin trees;
  tree tree_1 = [&R] #{tre_str}
end;

#{FIG}"

      File.open(out_f, "w") { |f| f.puts nexus }
    end
  end
end
