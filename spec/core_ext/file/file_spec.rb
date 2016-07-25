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

describe Iroki::CoreExt::File do
  let(:klass) { Class.new { extend Iroki::CoreExt::File } }

  let(:this_dir) { File.dirname __FILE__ }
  let(:test_files) { File.join this_dir, "..", "..", "test_files" }
  let(:good_name_map) { File.join test_files, "name_map.good.test" }


  let(:color_map) { File.join test_files, "color_map_with_tags.txt" }
  let(:auto_color_map) { File.join test_files, "auto_color_map.txt" }

  let(:label_tag_twice) {
    File.join test_files, "label_tag_twice.txt"
  }

  let(:branch_tag_twice) {
    File.join test_files, "branch_tag_twice.txt"
  }

  let(:bad_name_color_map) { File.join test_files,
                                       "bad_names.color_map" }

  let(:bad_name_patterns) {
    { "ap_ple_3_2_pie"     => { label: Iroki::Color.get_tag("blue"),
                                branch: Iroki::Color.get_tag("blue"), },
      "pie_is_really_good" => { label: Iroki::Color.get_tag("red"),
                                branch: Iroki::Color.get_tag("red"), }, }
  }

  let(:auto_purple) {
    Iroki::Color.get_tag Iroki::Color::Palette::KELLY["1"][:hex]
  }
  let(:auto_orange) {
    Iroki::Color.get_tag Iroki::Color::Palette::KELLY["2"][:hex]
  }
  let(:red) { Iroki::Color.get_tag "red" }

  let(:auto_color_patterns) {
    {
      "auto_1" => { label: auto_purple, branch: auto_purple },
      "auto_2" => { label: auto_orange, branch: auto_orange },
      "ryan_3" => { label: red, branch: red },
    }
  }

  let(:patterns) {
    { "apple" =>     { label: Iroki::Color.get_tag("red"),
                       branch: Iroki::Color.get_tag("red"), },
      "grape" =>     { label: Iroki::Color.get_tag("green"),
                       branch: Iroki::Color.get_tag("blue"), },
      "peanut" =>    { label: Iroki::Color.get_tag("green"),
                       branch: Iroki::Color.get_tag("green"), },
      "amelionia" => { label: Iroki::Color.get_tag("brown"),
                       branch: Iroki::Color.get_tag("brown"), },
      "ice_cream" => { label: Iroki::Color.get_tag("brown"),
                       branch: Iroki::Color.get_tag("blue"), },
      "thingy" =>    { label: Iroki::Color.get_tag("green"),
                       branch: "", },
      "pi_ece" =>    { label: Iroki::Color.get_tag("orange"),
                       branch: Iroki::Color.get_tag("purple"), },
      "teehee" =>    { label: "",
                       branch: Iroki::Color.get_tag("tomato"), },
      "pie" =>       { label: "",
                       branch: Iroki::Color.get_tag("goldenrod3"), },
      "water" =>     { label: Iroki::Color.get_tag("black"),
                       branch: Iroki::Color.get_tag("thistle"), },

    }
  }

  describe "#check_file" do
    it "aborts if file is nil" do
      fname = nil
      expect{klass.check_file fname, :apple}.to raise_error SystemExit
    end

    it "aborts if file doesn't exist" do
      fname = "hehe.txt"
      expect{klass.check_file fname, :apple}.to raise_error SystemExit
    end

    it "returns fname if file exists" do
      fname = __FILE__
      expect(klass.check_file fname, :apple).to eq fname
    end
  end

  describe "::parse_color_map" do
    context "when file doesn't exist" do
      it "raises SystemExit" do
        expect{klass.parse_color_map "apple.txt"}.
          to raise_error SystemExit
      end
    end

    context "misc bad user input" do
      it "raises SystemExit if label tag is given twice" do
        expect{klass.parse_color_map label_tag_twice}.
          to raise_error SystemExit
      end

      it "raises SystemExit if branch tag is given twice" do
        expect{klass.parse_color_map branch_tag_twice}.
          to raise_error SystemExit
      end
    end

    context "exact matching" do
      context "with good input" do
        it "reads the color file and returns a hash of patterns" do
          expect(klass.parse_color_map color_map).to eq patterns
        end

        it "runs every non regex pattern through str.clean method" do
          expect(klass.parse_color_map bad_name_color_map).
            to eq bad_name_patterns
        end

        it "treats the pattern as a string" do
          pattern = klass.parse_color_map(color_map).first.first

          expect(pattern).to be_a String
        end
      end
    end

    context "regex pattern matching" do
      it "treats the pattern column as a regular expression" do
        pattern =
          klass.parse_color_map(color_map, exact_matching: false).
          first.
          first

        expect(pattern).to be_a Regexp
      end

      it "raises SystemExit if the regexp is invalid"
    end

    context "with auto-coloring turned on" do
      it "selects colors automatically from the given palette" do
        kelly = Iroki::Color::Palette::KELLY
        expect(klass.parse_color_map(auto_color_map, auto_color: kelly)).
          to eq auto_color_patterns
      end
    end
  end

  describe "#parse_name_map" do
    context "with good input" do
      it "returns a hash with clean old name => clean new name" do
        fname = File.join test_files, "name_map.good.txt"
        name_map = { "app_le" => "pie",
                     "is" => "g_o_o_d" }

        expect(klass.parse_name_map fname).to eq name_map
      end
    end

    context "with bad input" do
      context "when col 1 is empty" do
        it "raises SystemExit" do
          fname = File.join test_files, "name_map.col1_empty.txt"

          expect{klass.parse_name_map fname}.to raise_error SystemExit
        end
      end

      context "when col 2 is empty" do
        it "raises SystemExit" do
          fname = File.join test_files, "name_map.col2_empty.txt"

          expect{klass.parse_name_map fname}.to raise_error SystemExit
        end
      end

      context "when col 2 is missing" do
        it "raises SystemExit" do
          fname = File.join test_files, "name_map.col2_missing.txt"

          expect{klass.parse_name_map fname}.to raise_error SystemExit
        end
      end

      context "when col 2 has duplicate values" do
        it "raises SystemExit" do
          fname = File.join test_files, "name_map.duplicate_vals.txt"

          expect{klass.parse_name_map fname}.to raise_error SystemExit
        end
      end

      context "with line ending issues" do
        it "raises SystemExit"
      end
    end
  end
end
