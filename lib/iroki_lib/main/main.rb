# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of IrokiLib.
#
# IrokiLib is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# IrokiLib is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with IrokiLib.  If not, see <http://www.gnu.org/licenses/>.

require "bio"

module IrokiLib
  module Main
    def self.main(color_branches: nil,
                  color_taxa_names: nil,
                  exact: nil,
                  remove_bootstraps_below: nil,
                  color_map_f: nil,
                  name_map_f: nil,
                  auto_color: nil,
                  display_auto_color_options: nil,
                  newick_f: nil,
                  out_f: nil)



      if display_auto_color_options
        puts "\n  Choices for --auto-color ..."
        print "  basic, basic_light, basic_dark, funky, funky_light, " +
              "funky_dark\n\n"
        exit
      end

      auto_color_options =
        ["basic", "basic_light", "basic_dark",
         "funky", "funky_light", "funky_dark",]


      if(!auto_color.nil? &&
         !auto_color_options.include?(auto_color))
        puts "\n  Choices for --auto-color ..."
        print "  basic, basic_light, basic_dark, funky, funky_light, " +
              "funky_dark\n\n"

        Trollop.die :auto_color, "#{auto_color} is not a valid option"
      end

      case auto_color
      when nil
        auto_colors = BASIC
      when "basic"
        auto_colors = BASIC
      when "basic_light"
        auto_colors = BASIC_LIGHT
      when "basic_dark"
        auto_colors = BASIC_DARK
      when "funky"
        auto_colors = FUNKY
      when "funky_light"
        auto_colors = FUNKY_LIGHT
      when "funky_dark"
        auto_colors = FUNKY_DARK
      end

      # color_branches = true
      # color_taxa_names = true
      # exact = false
      # color_map_f = "test_files/500.patterns_with_name_map"
      # name_map_f = "test_files/500.name_map"
      # ARGV[0] = "test_files/500.zetas.tre"
      newick = check_file newick_f, :newick

      color_f = nil
      if color_taxa_names || color_branches
        color_f = check_file color_map_f, :color_map_f
      end

      check = color_map_f &&
              !color_taxa_names &&
              !color_branches

      abort_if check,
               "A pattern file was provided without specifying " +
               "any coloring options"


      # if passed color other than one defined, return black
      black = "#000000"
      red = "#FF1300"
      yellow = "#FFD700"
      blue = "#5311FF"
      green = "#00FF2C"
      color2hex = Hash.new "[&!color=\"#{black}\"]"
      color2hex.merge!({
                         "black" => "[&!color=\"#{black}\"]",
                         "red" => "[&!color=\"#{red}\"]",
                         "blue" => "[&!color=\"#{blue}\"]",
                         "yellow" => "[&!color=\"#{yellow}\"]",
                         "green" => "[&!color=\"#{green}\"]"
                       })

      # check if complementary colors requested
      if color_f
        colors = Set.new
        File.open(color_f).each_line do |line|
          _, color = line.chomp.split "\t"

          colors << color
        end

        auto_color = colors.all? { |color| color.match /\A[0-4]\Z/ }
      end

      # get the color patterns
      if color_f
        patterns = {}
        File.open(color_f).each_line do |line|
          pattern, color = line.chomp.split "\t"

          color = "black" if color.nil? || color.empty?

          if name_map_f || color_taxa_names || color_branches
            pattern = clean_name pattern
          end

          if !exact
            pattern = Regexp.new pattern
          end

          if auto_color
            patterns[pattern] = "[&!color=\"#{auto_colors[color]}\"]"
          else
            if hex? color
              patterns[pattern] = "[&!color=\"#{color}\"]"
            else
              patterns[pattern] = color2hex[color]
            end
          end
        end
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
          name = clean_name n.name

          if (color = add_color_to_leaf_branch(patterns, name, exact))
            name + color
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
