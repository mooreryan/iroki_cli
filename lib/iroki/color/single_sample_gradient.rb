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
      attr_accessor :counts, :rel_abunds, :single_color

      def initialize samples, counts, single_color=false
        @single_color = single_color
        @samples = samples
        @counts = counts
        @rel_abunds = counts_to_rel_abunds
        @lumins = rel_abunds_to_lumins

        if @single_color
          @color_hex_codes = single_color_gradient_hex_codes
        else
          @color_hex_codes = two_color_gradient_hex_codes
        end
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
          Gradient.scale_reverse count, new_min=50, new_max=97
        end
      end

      def two_color_gradient_hex_codes
        @rel_abunds.map.with_index do |rel_abund, idx|
          lumin = @lumins[idx]

          col =
            Iroki::Color::GREEN.mix_with Iroki::Color::BLUE, rel_abund

          col.luminosity = lumin

          col.html
        end
      end

      def single_color_gradient_hex_codes
        @rel_abunds.zip(@lumins).map do |rel_abund, lumin|
          amt_of_orig_color =
            Gradient.scale rel_abund, new_min=10, new_max=95

          col =
            Iroki::Color::DARK_GREEN.lighten_by amt_of_orig_color

          col.html
        end
      end
    end
  end
end
