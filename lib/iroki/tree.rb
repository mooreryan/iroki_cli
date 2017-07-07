module Iroki
  class Tree
    def self.iroki_name idx
      "iroki#{idx}iroki"
    end

    # @note The newick standard changes unquoted underscores to spaces
    #
    # @note The reason we have to bother with this is because when the
    #   bioruby parser calls the __to_newick method, it does some
    #   annoying things to the output and changes the names. Making
    #   the names like this lets us easily gsub the names to what they
    #   should be after the name map.
    #
    # @param [Bio::Tree] a bio ruby tree object
    #
    # @return [Hash] iroki_name (string) => quoted_orig_name (string)
    #
    # @todo not a good name as it doesn't actually change the names in
    #   the tree
    def self.change_names tree
      idx = -1
      realname = {}
      tree.each_node do |node|
        if node.name && !node.name.empty?
          idx += 1

          realname[iroki_name(idx)] = %Q{#{node.name}}

          node.name = iroki_name(idx)
        end
      end

      realname
    end

    def self.combine_hashes h1, h2, nil_val=nil
      h_new = {}
      h1.each do |h1_key, h1_val|
        if h2.has_key? h1_val
          h_new[h1_key] = h2[h1_val]
        else
          h_new[h1_key] = nil_val
        end
      end

      h_new
    end

    def self.quoted_vals hash
      # p [:a, hash.values]
      # p [:b, hash.values.map(&:single_quote)]
      hash.values.map(&:single_quote)
    end

    def self.gsub_iroki_newick_string tre_str,
                                      iroki_to_name,
                                      name_map=nil
      if name_map
        vals = self.quoted_vals name_map
        name_map_quoted = Hash[name_map.keys.zip(vals)]

        iroki_to_new_name =
          self.combine_hashes iroki_to_name, name_map_quoted
      else
        vals = self.quoted_vals iroki_to_name

        iroki_to_new_name = Hash[iroki_to_name.keys.zip(vals)]
      end

      tre_str.gsub(/iroki[0-9]+iroki/, iroki_to_new_name)
    end

    def self.iroki_to_color iroki_to_name,
                            color_map,
                            name_map,
                            nil_val=nil
      if name_map
        old_names = name_map.keys
        new_names = name_map.values

        color_map_is_for_old_names =
          color_map.keys.all? { |key| old_names.include? key }

        color_map_is_for_new_names =
          color_map.keys.all? { |key| new_names.include? key }

        if color_map_is_for_old_names
          iroki_to_color =
            self.combine_hashes iroki_to_name, color_map, nil_val
        elsif color_map_is_for_new_names
          iroki_to_new_name =
            self.combine_hashes iroki_to_name, name_map

          iroki_to_color =
            self.combine_hashes iroki_to_new_name, color_map, nil_val
        else # some old, some new
          abort_if true,
                   "The color map has both old and new names in " +
                   "the first column."
        end

        iroki_to_color
      else # no name map
        self.combine_hashes iroki_to_name, color_map, nil_val
      end
    end
  end
end
