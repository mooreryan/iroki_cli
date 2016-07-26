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
    def parse_single_sample
      samples = []
      counts  = []

      self.each_line do |line|
        unless line.start_with? "#"
          sample, count = line.chomp.split "\t"

          samples << sample
          counts << count.to_f
        end
      end

      [samples, counts]
    end


    def parse_two_sample
      samples = []
      counts_group1  = []
      counts_group2  = []

      self.each_line do |line|
        unless line.start_with? "#"
          sample, count1, count2 = line.chomp.split "\t"

          samples << sample
          counts_group1 << count1.to_f
          counts_group2 << count2.to_f
        end
      end

      [samples, counts_group1, counts_group2]
    end
  end
end
