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

require "spec_helper"

describe Iroki::Color::Gradient do
  it { should respond_to :samples }
  it { should respond_to :color_hex_codes }
  it { should respond_to :lumins }
  it { should respond_to :single_color }

  describe "#patterns" do
    it "returns the patterns hash" do

      gradient = Iroki::Color::Gradient.new
      gradient.samples = ["s1", "s2"]
      gradient.color_hex_codes = ["#00FF00", "#FF00FF"]

      the_patterns = {
        "s1" => { label:  %q{[&!color="#00FF00"]},
                  branch: %q{[&!color="#00FF00"]}, },
        "s2" => { label:  %q{[&!color="#FF00FF"]},
                  branch: %q{[&!color="#FF00FF"]}, },
      }

      expect(gradient.patterns).to eq the_patterns
    end
  end
end
