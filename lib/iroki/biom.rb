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
  class Biom < File
    attr_accessor :single_group

    def parse
      samples = []
      counts  = []
      lineno = -1
      first_line_count = -1

      self.each_line.with_index do |line, idx|
        unless line.start_with? "#"
          lineno += 1
          sample, *the_counts = line.chomp.split "\t"

          if lineno.zero?
            first_line_count = the_counts.count
          else
            abort_unless first_line_count == the_counts.count,
                         "The biom file has rows with different " +
                         "numbers of columns"
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
