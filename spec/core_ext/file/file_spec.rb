# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of IrokiLib.
#
# IrokiLib is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# IrokiLib is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with IrokiLib.  If not, see <http://www.gnu.org/licenses/>.

require "spec_helper"

describe IrokiLib::CoreExt::File do
  let(:klass) { Class.new { extend IrokiLib::CoreExt::File } }

  let(:this_dir) { File.dirname __FILE__ }
  let(:test_files) { File.join this_dir, "..", "..", "test_files" }
  let(:good_name_map) { File.join test_files, "name_map.good.test" }


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
