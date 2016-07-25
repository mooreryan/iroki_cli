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

describe Iroki::CoreExt::String do
  describe "#hex?" do
    it "returns nil if str is not a color hex code" do
      expect("0az03d".hex?).to be nil
    end

    it "returns the match if str is a color hex code" do
      expect("#00Ff00".hex?).to be_a MatchData
    end
  end

  describe "#clean" do
    it "stips outer whitespace then replaces non _ or " +
       "alphanumeric chars with a _" do
      str = "   a!3.*pp   le  "
      expect(str.clean).to eq "a_3_pp_le"
    end
  end

  describe "#has_color?" do
    it "returns MatchData if a name has been 'colored'" do
      name = 'KM042485_1_864[&!color="#5311FF"]'

      expect(name.has_color?).to be_a MatchData
    end

    it 'has the seq name in \1' do
      name = 'KM042485_1_864[&!color="#5311FF"]'

      expect(name.has_color?[1]).to eq "KM042485_1_864"
    end

    it 'has the color in \2' do
      name = 'KM042485_1_864[&!color="#5311FF"]'

      expect(name.has_color?[2]).to eq '[&!color="#5311FF"]'
    end

    it "returns nil if name hasn't been colored" do
      name = "KM042485_1_864"

      expect(name.has_color?).to be nil
    end
  end

  describe "#clean_name" do
    context "with colored name" do
      it "cleans only the name part" do
        old = 'KM042485 1* 864[&!color="#5311FF"]'
        new = 'KM042485_1_864[&!color="#5311FF"]'

        expect(old.clean_name).to eq new
      end
    end

    context "with non-colored name" do
      it "cleans the whole thing" do
        old = "KM042485 1* 864"
        new = "KM042485_1_864"

        expect(old.clean_name).to eq new
      end
    end
  end
end
