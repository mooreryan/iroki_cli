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
    class Gradient
      attr_accessor :samples,
                    :color_hex_codes,
                    :lumins,
                    :single_color,
                    :min_lumin,
                    :max_lumin

      # scales [old_min, old_max] to [new_min, new_max]
      def scale x,
                new_min=0.05,
                new_max=0.9,
                old_min=0.0,
                old_max=1.0

        x = x.to_f
        new_min = new_min.to_f
        new_max = new_max.to_f
        old_min = old_min.to_f
        old_max = old_max.to_f

        ((((new_max - new_min) * (x - old_min.to_f)) / (old_max - old_min)) + new_min)
      end

      # scales [old_min, old_max] to [new_max, new_min]
      def scale_reverse x,
                        new_min=0.0,
                        new_max=0.0,
                        old_min=0.0,
                        old_max=1.0

        x = x.to_f
        new_min = new_min.to_f
        new_max = new_max.to_f
        old_min = old_min.to_f
        old_max = old_max.to_f

        (new_max - ((((new_max - new_min) * (x - old_min.to_f)) / (old_max - old_min)) + new_min)) + new_min
      end

      def patterns
        hash = {}
        @samples.zip(@color_hex_codes).each do |(sample, hexcode)|
          tag = Iroki::Color.get_tag hexcode
          hash[sample] = { label: tag, branch: tag }
        end

        hash
      end

      def counts_to_rabunds counts
        max_count = counts.max.to_f

        counts.map do |count|
          count / max_count
        end
      end

      def rabunds_to_lumins rabunds
        rabunds.map do |count|
          # scale_reverse count, new_min=50, new_max=97
          # scale_reverse count, new_min=35, new_max=85
          scale_reverse count, new_min=@min_lumin, new_max=@max_lumin
          # scale_reverse count, 0.0, 50.0
        end
      end
    end
  end
end
