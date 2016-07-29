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
  module Color
    class TwoGroupGradient < Gradient
      attr_accessor :g1_counts, :g2_counts, :g1_rabunds, :g2_rabunds

      def initialize samples, g1_counts, g2_counts
        assert(samples.count == g1_counts.count &&
                     g1_counts.count == g2_counts.count,
                     "Samples and counts are different lengths. " +
                     "Check your biom file.")

        @samples = samples
        @g1_counts = g1_counts
        @g2_counts = g2_counts
        @g1_rabunds = counts_to_rabunds g1_counts
        @g2_rabunds = counts_to_rabunds g2_counts
        @color_hex_codes = calc_hex_codes @g1_rabunds, @g2_rabunds
      end

      def percent_of_group1_color ra1, ra2
        if ra1 > ra2
          1 - scale(ra2 / ra1, new_min=0.0, new_max=0.5, old_min=0.0, old_max=1.0)
        elsif ra1 < ra2
          scale(ra1 / ra2, new_min=0.0, new_max=0.5, old_min=0.0, old_max=1.0)
        else
          0.5
        end
      end

      def mix_percent ra1, ra2
        1 - percent_of_group1_color(ra1, ra2)
      end

      def lumin_level ra1, ra2
        if ra1 > ra2
          scale_reverse ra1, new_min=50, new_max=90, old_min=0.0, old_max=1.0
        else
          scale_reverse ra2, new_min=50, new_max=90, old_min=0.0, old_max=1.0
        end
      end

      def hex_code ra1, ra2
        perc = mix_percent ra1, ra2

        col = Iroki::Color::GREEN.mix_with Iroki::Color::BLUE, perc

        col.luminosity = lumin_level ra1, ra2

        col.html
      end

      def calc_hex_codes g1_rabunds, g2_rabunds
        g1_rabunds.zip(g2_rabunds).map do |ra1, ra2|
          if ra1.zero? && ra2.zero?
            Iroki::Color::GRAY.html
          else
            hex_code ra1, ra2
          end
        end
      end
    end
  end
end
