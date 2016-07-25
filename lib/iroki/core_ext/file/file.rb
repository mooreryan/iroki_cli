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

module Iroki
  module CoreExt
    module File
      def check_file arg, which
        help = " Try iroki --help for help."

        abort_if arg.nil?,
                 "You must provide a #{which} file.#{help}"

        abort_unless Object::File.exists?(arg),
                     "The file '#{arg}' doesn't exist.#{help}"

        arg
      end

      def parse_color_map fname, exact_matching=true
        check_file fname, :color_map

        patterns = {}
        Object::File.open(fname).each_line do |line|
          pattern, color = line.chomp.split "\t"

          color = "black" if color.nil? || color.empty?

          assert pattern, "pattern was nil"

          if exact_matching # TODO should this really be everytime?
            pattern = pattern.clean
          else
            pattern = Regexp.new pattern
          end

          # if auto_color
          #   patterns[pattern] = "[&!color=\"#{auto_colors[color]}\"]"
          # else
          #   patterns[pattern] = Iroki::Color.get_tag color
          # end

          patterns[pattern] = Iroki::Color.get_tag color
        end

        patterns
      end

      def parse_name_map fname
        check_file fname, :name_map

        name_map = {}
        Object::File.open(fname).each_line do |line|
          oldname, newname = line.chomp.split "\t"


          abort_if oldname.nil? || oldname.empty?,
                   "Column 1 missing for line: #{line.inspect}"

          abort_if newname.nil? || newname.empty?,
                   "Column 2 missing for line: #{line.inspect}"

          oldname = oldname.clean
          newname = newname.clean

          abort_if name_map.has_key?(oldname),
                   "#{oldname} is repeated in column 1"

          name_map[oldname] = newname
        end

        abort_if duplicate_values?(name_map),
                 "Names in column 2 of name map file must be unique"

        name_map
      end
    end
  end
end
