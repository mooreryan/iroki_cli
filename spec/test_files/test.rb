require "bio"

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
        # return "\'" + str.gsub(/\'/, "\'\'") + "\'"
        return str
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

puts

str = File.read(File.join File.dirname(__FILE__), "z.tre")#.gsub(/"/, %q{''})

puts :z_tre, str

tree = Bio::Newick.new(str, parser: :iroki)

puts :after_parsing, tree.tree.newick(indent: false)

idx = -1
realname = {}
puts
tree.tree.each_node do |node|
  if node.name
    idx += 1
    iroki_name = "iroki#{idx}iroki"
    realname[iroki_name] = %Q{'#{node.name}'}
    puts [iroki_name, node.name].join "\t"
    node.name = iroki_name
  end
end
puts

tree_string = tree.tree.newick(indent: false)

puts :after_changing_names, tree_string

tree_string.gsub!(/iroki[0-9]+iroki/, realname)

puts :after_gsub, tree_string
puts :z_tre, str

File.open('lalalala.tre', 'w') { |f| f.puts tree.tree.newick(indent: false) }

puts
