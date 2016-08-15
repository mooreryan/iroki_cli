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

module Bio
  class Tree
    # formats Newick label (unquoted_label or quoted_label)
    def __to_newick_format_label(str, options)
      if __get_option(:parser, options) == :naive then
        return str.to_s
      end

      str = str.to_s
      if /([\(\)\,\:\[\]\_\'\x00-\x1f\x7f])/ =~ str then
        # quoted_label
        if __get_option(:parser, options) == :iroki
          return str
        else
          return "\'" + str.gsub(/\'/, "\'\'") + "\'"
        end
      end
      # unquoted_label
      return str.gsub(/ /, '_')
    end
    private :__to_newick_format_label
  end

  class Newick
    # splits string to tokens
    def __parse_newick_tokenize(str, options)
      str = str.chop if str[-1..-1] == ';'
      # http://evolution.genetics.washington.edu/phylip/newick_doc.html
      # quoted_label ==> ' string_of_printing_characters '
      # single quote in quoted_label is '' (two single quotes)
      #

      if __get_option(:parser, options) == :naive then
        ary = str.split(/([\(\)\,\:\[\]])/)
        ary.collect! { |x| x.strip!; x.empty? ? nil : x }
        ary.compact!
        ary.collect! do |x|
          if /\A([\(\)\,\:\[\]])\z/ =~ x then
            x.intern
          else
            x
          end
        end
        return ary
      end

      tokens = []
      ss = StringScanner.new(str)

      while !(ss.eos?)
        if ss.scan(/\s+/) then
          # do nothing

        elsif ss.scan(/[\(\)\,\:\[\]]/) then
          # '(' or ')' or ',' or ':' or '[' or ']'
          t = ss.matched
          tokens.push t.intern

        elsif ss.scan(/\'/) then
          # quoted_label
          t = ''
          while true
            if ss.scan(/([^\']*)\'/) then
              t.concat ss[1]
              if  ss.scan(/\'/) then
                # single quote in quoted_label
                t.concat ss.matched
              else
                break
              end
            else
              # incomplete quoted_label?
              break
            end
          end #while true
          unless ss.match?(/\s*[\(\)\,\:\[\]]/) or ss.match?(/\s*\z/) then
            # label continues? (illegal, but try to rescue)
            if ss.scan(/[^\(\)\,\:\[\]]+/) then
              t.concat ss.matched.lstrip
            end
          end
          tokens.push t

        elsif ss.scan(/[^\(\)\,\:\[\]]+/) then
          # unquoted_label
          t = ss.matched.strip
          t.gsub!(/[\r\n]/, '')

          unless __get_option(:parser, options) == :iroki then
            # unquoted underscore should be converted to blank
            t.gsub!(/\_/, ' ')
          end
          tokens.push t unless t.empty?

        else
          # unquoted_label in end of string
          t = ss.rest.strip
          t.gsub!(/[\r\n]/, '')

          unless __get_option(:parser, options) == :iroki then
            # unquoted underscore should be converted to blank
            t.gsub!(/\_/, ' ')
          end

          tokens.push t unless t.empty?
          ss.terminate

        end
      end #while !(ss.eos?)

      tokens
    end
  end
end

module Iroki
  module Main
    def self.main(color_branches: nil,
                  color_taxa_names: nil,
                  exact: nil,
                  remove_bootstraps_below: nil,
                  color_map_f: nil,
                  biom_f: nil,
                  single_color: nil,
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

      abort_if single_color && biom_f.nil?,
               "--single-color was passed but no biom file was given"

      # this should be allowed
      abort_if biom_f && color_map_f,
               "--color-map and --biom-file cannot both be specified. Try iroki --help for help."

      abort_if (biom_f || color_map_f) && color_branches.nil? && color_taxa_names.nil?,
               "No coloring options selected."

      newick = check_file newick_f, :newick

      abort_if out_f.nil?,
               "--outfile is a required arg. Try iroki --help for help."

      if color_branches || color_taxa_names
        abort_if biom_f.nil? && color_map_f.nil?,
                 "Color options were provided, but no biom file " +
                 "or color map file was provided"
      end

      color_f = nil
      if !biom_f && (color_taxa_names || color_branches)
        color_f = check_file color_map_f, :color_map_f
      end

      check = color_map_f &&
              !color_taxa_names &&
              !color_branches

      abort_if check,
               "A color map file was provided without specifying " +
               "any coloring options"

      abort_if(newick_f &&
               color_map_f.nil? &&
               biom_f.nil? &&
               name_map_f.nil?,
               "Newick file was given but no other files were given")

      # treeio = Bio::FlatFile.open(Bio::Newick, newick)

      # newick = treeio.next_entry
      str = File.read newick
      newick = Bio::Newick.new str, parser: :iroki
      tree = newick.tree

      # puts [:tree_first_parsed, tree.newick(indent: false)]

      iroki_to_name = Iroki::Tree.change_names tree


      #################################################################
      # parse name map
      ################

      if name_map_f
        name_map = parse_name_map name_map_f
      else
        name_map = nil
      end

      if name_map_f && color_map_f.nil? && biom_f.nil? # just name map
        # put node names back
      end

      ################
      # parse name map
      #################################################################

      if name_map_f && color_map_f.nil? && biom_f.nil?
        AbortIf.logger.info "Only renaming was requested."
      end

      #################################################################
      # get color patterns
      ####################

      if color_f
        patterns = parse_color_map_iroki color_f,
                                         iroki_to_name,
                                         exact_matching: exact,
                                         auto_color: auto_color_hash
      elsif biom_f
        samples, counts, is_single_group = Biom.open(biom_f, "rt").parse

        if is_single_group
          patterns = SingleGroupGradient.new(samples, counts, single_color).patterns
        else
          g1_counts = counts.map(&:first)
          g2_counts = counts.map(&:last)
          patterns = TwoGroupGradient.new(samples, g1_counts, g2_counts).patterns
        end

        # these patterns have the original name for the key, so change
        # the key to the iroki name
        name_to_iroki = iroki_to_name.invert
        h = {}
        patterns.each do |name, val|
          h[name_to_iroki[name]] = val
        end

        patterns = h
      else
        patterns = nil
      end

      ####################
      # get color patterns
      #################################################################


      # puts [:tree_after_change_names, tree.newick(indent: false)]
      nil_val = { label: "", branch: "" }

      # do this first cos everything after will use the "new" names
      # if name_map_f
      #   name_map = parse_name_map name_map_f

      #   tree.collect_node! do |node|
      #     unless node.name.nil?
      #       # every name is cleaned no matter what
      #       # node.name = node.name.clean_name

      #       if name_map.has_key?(node.name)
      #         node.name = name_map[node.name]
      #       end
      #     end

      #     node
      #   end
      # end

      leaves_with_names = tree.leaves.reject { |leaf| leaf.name.nil? }
      if color_taxa_names
        leaves = leaves_with_names.map do |n|
          name = n.name#.clean_name

          if (color = add_color_to_leaf_branch(patterns, name, exact, iroki_to_name))
            name.single_quote + color[:label]
          else
            name.single_quote
          end
        end
      else
        leaves = leaves_with_names.map { |n| n.name.single_quote }
      end

      if color_branches
        total = tree.nodes.count
        n = 0
        tree.collect_node! do |node|
          n += 1
          $stderr.printf "Node: %d of %d\r", n, total

          color_nodes patterns, tree, node, exact, iroki_to_name
        end
      end
      $stderr.puts

      # if remove_bootstraps_below
      #   tree.collect_node! do |node|
      #     if node.bootstrap && node.bootstrap < remove_bootstraps_below
      #       node.bootstrap_string = ""
      #     end

      #     node
      #   end
      # end

      tre_str = tree.newick(indent: false)
      # tree.each_node do |node|
      #   p [:node, node.name]
      # end
      # puts [:tree_str, tre_str]
      # puts [:iroki_to_name, iroki_to_name]
      # puts [:after_change, Iroki::Tree.gsub_iroki_newick_string(tre_str, iroki_to_name)]

      # this hash can be used regardless of whether a name map was used
      silly_iroki_to_name = {}
      iroki_to_name.each do |iname, oldname|
        if name_map && name_map.has_key?(oldname)
          silly_iroki_to_name[iname] = name_map[oldname]
        else
          silly_iroki_to_name[iname] = oldname
        end
      end

      # puts str
      # puts tre_str



      nexus = "#NEXUS
begin taxa;
dimensions ntax=#{leaves.count};
taxlabels
#{leaves.join("\n").gsub(/iroki[0-9]+iroki/, silly_iroki_to_name)}
;
end;

begin trees;
  tree tree_1 = [&R] #{Iroki::Tree.gsub_iroki_newick_string tre_str, silly_iroki_to_name}
end;

#{FIG}"

      File.open(out_f, "w") { |f| f.puts nexus }
    end
  end
end
