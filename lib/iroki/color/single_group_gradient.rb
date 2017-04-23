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
    class SingleGroupGradient < Gradient
      attr_accessor :counts, :rel_abunds

      def initialize samples,
                     counts,
                     single_color=false,
                     min_lumin,
                     max_lumin

        abort_unless samples.count == counts.count,
                     "Samples (#{samples.count}) and counts " +
                     "#{counts.count} are different size."

        @min_lumin = min_lumin
        @max_lumin = max_lumin

        @single_color = single_color
        @samples = samples
        @counts = counts
        @rel_abunds = counts_to_rabunds counts
        @lumins = rabunds_to_lumins @rel_abunds

        if @single_color
          @color_hex_codes = single_color_gradient_hex_codes
        else
          @color_hex_codes = two_color_gradient_hex_codes
        end
      end

      def two_color_gradient_hex_codes
        @rel_abunds.map.with_index do |rel_abund, idx|
          lumin = @lumins[idx]

          col =
            Iroki::Color::GREEN.mix_with Iroki::Color::BLUE, rel_abund
          # col =
          #   Iroki::Color::BLUE.mix_with Iroki::Color::GREEN, rel_abund

          col.luminosity = lumin

          col.html
        end
      end

      def single_color_gradient_hex_codes
        @rel_abunds.zip(@lumins).map do |rel_abund, lumin|
          amt_of_orig_color =
            # scale rel_abund, new_min=10, new_max=95
            scale rel_abund, new_min=@min_lumin, new_max=@max_lumin

          col =
            Iroki::Color::DARK_GREEN.lighten_by amt_of_orig_color

          col.html
        end
      end
    end
  end
end
