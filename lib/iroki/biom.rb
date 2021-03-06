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

def valid_numerical_val? str
  # looks something like sci notation
  str.match(/[-+]?[0-9]?\.?[0-9]?[eE]?[-+]?[0-9]+/)
end

module Iroki
  class Biom < File
    attr_accessor :single_group

    # Parse a biom plain text file.
    #
    # @note The samples returned by this function will be Strings and
    #   NOT regex's.
    #
    # @return an array of three items. 1. An array of samples, 2. an
    #   array of counts, 3. single_group flag
    def parse
      samples = []
      counts  = []
      lineno = -1
      first_line_count = -1

      self.each_line.with_index do |line, idx|
        unless line.start_with? "#"
          lineno += 1
          sample, *the_counts = line.chomp.split "\t"

          abort_if sample.nil? || sample.empty? || sample =~ / +/,
                   "Line #{idx+1} has no sample"

          the_counts.flatten.each do |count|
            abort_unless valid_numerical_val?(count),
                         "The value '#{count}' in the " +
                         "biom file might not be valid"
          end

          if lineno.zero?
            first_line_count = the_counts.count
          else
            abort_unless first_line_count == the_counts.count,
                         "Line number #{idx+1} (#{line.inspect}) " +
                         "in the " +
                         "biom file has #{the_counts.count} " +
                         "columns when it should have " +
                         "#{first_line_count} columns like the " +
                         "first row does."
          end

          samples << sample

          if the_counts.length == 1
            counts << the_counts.first.to_f
            @single_group = true
          else
            counts << the_counts.map(&:to_f)
          end
        end
      end

      [samples, counts, @single_group]
    end
  end
end
