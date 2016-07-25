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


  let(:color_map) { File.join test_files, "test.color_map" }
  let(:bad_name_color_map) { File.join test_files,
                                       "bad_names.color_map" }

  let(:bad_name_patterns) {
    { "ap_ple_3_2_pie"     => %q{[&!color="#0000FF"]},
      "pie_is_really_good" => %q{[&!color="#FF0000"]}, }
  }

  let(:patterns) {
    { "Desulfobul" => %q{[&!color="#FF0000"]},
      "Nitrospina" => %q{[&!color="#FF0000"]},
      "Geobacterh" => %q{[&!color="#FF0000"]},
      "Geobacterp" => %q{[&!color="#FF0000"]},
      "Thermotoga" => %q{[&!color="#FF0000"]},
      "Aquifexpyr" => %q{[&!color="#FF0000"]},
      "Desurellaa" => %q{[&!color="#FF0000"]},
      "Desurellap" => %q{[&!color="#FF0000"]},
      "Nitratirup" => %q{[&!color="#0000FF"]},
      "Sulfurimon" => %q{[&!color="#FF0000"]},
      "Sulfurovum" => %q{[&!color="#FF0000"]},
      "Hyphomonas" => %q{[&!color="#00FF00"]},
      "Rhodobacte" => %q{[&!color="#00FF00"]},
      "Roseobacte" => %q{[&!color="#00FF00"]},
      "Thiomicroh" => %q{[&!color="#00FF00"]},
      "Thiomicrop" => %q{[&!color="#00FF00"]},
      "Marinobact" => %q{[&!color="#00FF00"]},
      "Thiothrixe" => %q{[&!color="#00FF00"]},
      "Thiothrixd" => %q{[&!color="#00FF00"]},
      "Leptothrsp" => %q{[&!color="#00FF00"]},
      "Leptothrdi" => %q{[&!color="#00FF00"]},
      "Gallionesp" => %q{[&!color="#00FF00"]},
      "Gallionefe" => %q{[&!color="#00FF00"]}, }
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
        expect{klass.parse_color_map "apple.txt", true}.
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
        pattern = klass.parse_color_map(color_map, false).first.first

        expect(pattern).to be_a Regexp
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
