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

  let(:blue_tag) { Iroki::Color.get_tag "blue" }
  let(:red_tag) { Iroki::Color.get_tag "red" }

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

  let(:bad_name_patterns) do
    { %q{ap-"p"le*'3'_2!#$#@.()p,ie} => { label: blue_tag,
                                          branch: blue_tag, },
      %q{   pie '"is"' "'really'" good } => { label: red_tag,
                                             branch: red_tag, } }
  end

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
      "ryan_3" => { label: red_tag, branch: red_tag },
    }
  }

  let(:patterns) do
    { "apple" =>     { label: Iroki::Color.get_tag("red"),
                       branch: Iroki::Color.get_tag("red"), },
      "grape" =>     { label: Iroki::Color.get_tag("green"),
                       branch: Iroki::Color.get_tag("blue"), },
      "peanut" =>    { label: Iroki::Color.get_tag("green"),
                       branch: Iroki::Color.get_tag("green"), },
      "amelionia" => { label: Iroki::Color.get_tag("brown"),
                       branch: Iroki::Color.get_tag("brown"), },
      "ice cream" => { label: Iroki::Color.get_tag("brown"),
                       branch: Iroki::Color.get_tag("blue"), },
      "thingy" =>    { label: Iroki::Color.get_tag("green"),
                       branch: "", },
      "pi--ece" =>    { label: Iroki::Color.get_tag("orange"),
                       branch: Iroki::Color.get_tag("purple"), },
      "teehee" =>    { label: "",
                       branch: Iroki::Color.get_tag("tomato"), },
      "pie" =>       { label: "",
                       branch: Iroki::Color.get_tag("goldenrod3"), },
      "water" =>     { label: Iroki::Color.get_tag("black"),
                       branch: Iroki::Color.get_tag("thistle"), },

    }
  end


  let(:patterns_iroki) do
    { "iroki0iroki" => { label: red_tag, branch: red_tag },
      "iroki1iroki" => { label: blue_tag, branch: blue_tag },
      "iroki2iroki" => { label: red_tag, branch: red_tag }, }
  end
  let(:color_map_iroki) { File.join test_files, "color_map_iroki.txt" }

  let(:tre) { File.join test_files, "basic.tre" }
  let(:nex) { File.join test_files, "nexus_files", "small.nex" }


  describe "#valid_newick?" do
    it "returns true when newick file looks like a newick file" do
      expect(klass.valid_newick? tre).to be true
    end

    it "returns fales when newick file does not look like newick" do
      expect(klass.valid_newick? nex).to be false
    end
  end

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


  # NAMETHING
  describe "::parse_color_map_iroki" do

    context "blueberry crumblepie bug" do
      it "handles the empty tab at the end of the color map"
    end

    context "exact matching" do
      # note, this also tests the spaces in the names and colors
      it "reads the color file and returns a hash of patterns" do
        iroki_to_name = { "iroki0iroki" => "s1",
                          "iroki1iroki" => "s2",
                          "iroki2iroki" => "s3" }

        expect(klass.parse_color_map_iroki color_map_iroki, iroki_to_name).to eq patterns_iroki
      end
    end

    context "regex matching" do
      it "reads the color file and returns a hash of patterns" do
        iroki_to_name = { "iroki0iroki" => "s1",
                          "iroki1iroki" => "s2",
                          "iroki2iroki" => "s3" }

        output = { /s1/ => { label: red_tag, branch: red_tag },
                   /s2/ => { label: blue_tag, branch: blue_tag },
                   /s3/ => { label: red_tag, branch: red_tag }, }

        expect(klass.parse_color_map_iroki color_map_iroki, iroki_to_name, exact_matching: false).to eq output
      end
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
      it "returns a hash with old name => new name" do
        # note, this also tests trimming whitespace from the ends
        fname = File.join test_files, "name_map.good.txt"
        name_map = { %q{a"p"p&^%$le} => %q{p'i'e},
                     %q{i's'} => %q{g o "o" !@#$ d}, }

        expect(klass.parse_name_map fname).to eq name_map
      end
    end

    context "with bad input" do
      context "when name map has more than two columns" do
        it "raises AbortIf::Exit" do
          iroki_net_issue_2_name_map = File.join test_files, "iroki_net_issues", "issue_2", "name_map"

          expect{klass.parse_name_map iroki_net_issue_2_name_map}.to raise_error AbortIf::Exit
        end
      end

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

      it "raises when col 1 has duplicate values"

      context "when col 2 has duplicate values" do
        it "raises SystemExit" do
          fname = File.join test_files, "name_map.duplicate_vals.txt"

          expect{klass.parse_name_map fname}.to raise_error SystemExit
        end
      end

      context "with line ending issues" do
        it "handles line feeds only" do
          fname =
            File.join test_files, "line_endings_line_feed.txt"
          name_map = { "a" => "A", "b" => "B", "c" => "C" }

          expect(klass.parse_name_map fname).to eq name_map
        end

        it "handles carriage returns only" do
          fname =
            File.join test_files, "line_endings_car_return.txt"
          name_map = { "a" => "A", "b" => "B", "c" => "C" }

          expect(klass.parse_name_map fname).to eq name_map
        end

        it "handles carriage returns and line feeds" do
          fname =
            File.join test_files, "line_endings_car_return_line_feed.txt"
          name_map = { "a" => "A", "b" => "B", "c" => "C" }

          expect(klass.parse_name_map fname).to eq name_map
        end
      end
    end
  end
end
