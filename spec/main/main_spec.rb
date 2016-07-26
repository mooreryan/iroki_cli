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
require "fileutils"

describe Iroki::Main do
  let(:this_dir) { File.dirname __FILE__ }
  let(:spec_dir) { File.join this_dir, ".." }
  let(:test_files) { File.join spec_dir, "test_files" }

  let(:newick) { File.join test_files, "test.tre" }
  let(:expected_nexus) { File.join test_files, "expected.nex" }
  let(:output_nexus) { File.join test_files, "output.nex" }
  let(:color_map) { File.join test_files, "test.color_map" }

  let(:small_newick)    { File.join test_files, "small.tre" }
  let(:small_nexus)     { File.join test_files, "small.nex" }
  let(:small_color_map) { File.join test_files, "small.color_map" }

  describe "::main" do
    it "runs Iroki main program" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        color_map_f:      color_map,
                        newick_f:         newick,
                        out_f:            output_nexus

      expected_output = File.read expected_nexus
      actual_output   = File.read output_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    it "handles auto colors mixed with specified colors" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        auto_color:       "kelly",
                        color_map_f:      small_color_map,
                        newick_f:         small_newick,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read small_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end
  end
end
