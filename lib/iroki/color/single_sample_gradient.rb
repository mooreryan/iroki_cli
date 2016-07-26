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
    class SingleSampleGradient < Gradient
      attr_accessor :counts, :rel_abunds

      def initialize samples, counts
        @samples = samples
        @counts = counts
        @rel_abunds = counts_to_rel_abunds
        @lumins = rel_abunds_to_lumins
        @color_hex_codes = get_color_hex_codes
      end

      private

      def counts_to_rel_abunds
        max_count = @counts.max.to_f

        @counts.map do |count|
          count / max_count
        end
      end

      def rel_abunds_to_lumins
        @rel_abunds.map do |count|
          Gradient.scale_reverse(count,
                                 new_min=0.5,
                                 new_max=0.97,
                                 old_min=0,
                                 old_max=1) * 100
        end
      end

      def get_color_hex_codes
        @rel_abunds.map.with_index do |rel_abund, idx|
          lumin = @lumins[idx]

          col =
            Iroki::Color::GREEN.mix_with Iroki::Color::BLUE, rel_abund

          col.luminosity = lumin

          col.html
        end
      end
    end
  end
end
