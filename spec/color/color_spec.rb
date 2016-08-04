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

describe Iroki::Color do
  let(:aliceblue_hex) { "#F0F8FF" }

  it "has the colors hash" do
    expect(Iroki::Color::COLORS).not_to be nil
  end

  describe "::get_tag" do
    it "calls ::tag_from_hex when input is a hex code" do
      input = "#ff0000"
      expected = "#FF0000"

      expect(Iroki::Color.get_tag input).
        to eq %Q{[&!color="#{expected}"]}
    end

    it "calls ::tag_from_color when input is a color name" do
      input = "red"
      hex = "#FF0000"

      expect(Iroki::Color.get_tag input).
        to eq %Q{[&!color="#{hex}"]}
    end

    it "knows about the kelly palette" do
      input = "1"
      hex = "#875692"
      palette = Iroki::Color::Palette::KELLY

      expect(Iroki::Color.get_tag input, palette).
        to eq %Q{[&!color="#{hex}"]}
    end
  end

  describe "::tag_from_hex" do
    it "takes a hex code and outputs the FigTree hex tag" do
      hex = "#ff00ff"
      expected = "#FF00FF"

      expect(Iroki::Color.tag_from_hex hex).
        to eq %Q{[&!color="#{expected}"]}
    end

    context "when hex doesn't pass hex?" do
      it "raisese SystemExit" do
        expect { Iroki::Color.tag_from_hex "apple" }.
          to raise_error AbortIf::Assert::AssertionFailureError
      end
    end
  end

  describe "::tag_from_color" do
    context "when palette is given" do
      it "combines the palette with the original R colors" do
        palette = { "1"  => { name: "purple", hex: "#875692" } }
        color = "1"

        expect(Iroki::Color.tag_from_color color, palette).
          to eq %Q{[&!color="#{palette[color][:hex]}"]}
      end
    end

    context "when color exists in the hash" do
      it "takes a color name and outputs the FigTree hex tag" do
        color = "aliceblue"

        expect(Iroki::Color.tag_from_color color).
          to eq %Q{[&!color="#{aliceblue_hex}"]}
      end
    end

    context "when color does not exist in the hash" do
      # it "returns the FigTree hex tag for black" do
      #   color = "sdlkfjaslfjasldfjlasjkfasdkjf"
      #   hex = "#000000"

      #   expect(Iroki::Color.tag_from_color color).
      #     to eq %Q{[&!color="#{hex}"]}
      # end

      it "raises AbortIf::Exit (still debating this one)" do
        color = "sdlkfjaslfjasldfjlasjkfasdkjf"
        hex = "#000000"

        expect { Iroki::Color.tag_from_color color }.
          to raise_error AbortIf::Exit
      end
    end

    context "when the color is there but bad user input" do
      it "downcases the color to begin with" do
        color = "AliceBlue"

        expect(Iroki::Color.tag_from_color color).
          to eq %Q{[&!color="#{aliceblue_hex}"]}
      end

      it "strips whitespace from the begininng and end" do
        color = "     aliceblue  \t  "

        expect(Iroki::Color.tag_from_color color).
          to eq %Q{[&!color="#{aliceblue_hex}"]}
      end
    end
  end
end
