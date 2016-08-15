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
  let(:nexus_files) { File.join test_files, "nexus_files" }

  let(:empty_name_map) { File.join test_files, "empty.name_map" }

  let(:two_group_biom) { File.join test_files, "two_group.biom" }
  let(:two_group_tre) { File.join test_files, "two_group.tre" }
  let(:two_group_nex) { File.join nexus_files, "two_group.nex" }

  let(:single_sample_biom) { File.join test_files, "single_sample.biom" }
  let(:single_sample_tre) { File.join test_files, "single_sample.tre" }
  let(:single_sample_nex) { File.join nexus_files, "single_sample.nex" }
  let(:single_sample_one_color_nex) { File.join nexus_files, "single_sample_one_color.nex" }

  let(:newick) { File.join test_files, "test.tre" }
  let(:expected_nexus) { File.join nexus_files, "expected.nex" }
  let(:output_nexus) { File.join nexus_files, "output.nex" }
  let(:color_map) { File.join test_files, "test.color_map" }

  let(:jess_newick) { File.join test_files, "jess.tre" }
  let(:jess_nexus)  { File.join nexus_files, "jess.nex" }

  let(:small_newick)    { File.join test_files, "small.tre" }
  let(:small_nexus)     { File.join nexus_files, "small.nex" }
  let(:small_color_map) { File.join test_files, "small.color_map" }

  let(:kelly_newick)    { File.join test_files, "23.tre" }
  let(:kelly_nexus)     { File.join nexus_files, "23.nex" }
  let(:kelly_out)       { File.join nexus_files, "23.out.nex" }
  let(:kelly_color_map) { File.join test_files, "23.color_map" }


  let(:regex_bug_tre) {
    File.join test_files, "regex_bug.tre"
  }
  let(:regex_bug_color_map) {
    File.join test_files, "regex_bug.color_map"
  }
  let(:regex_bug_nexus) {
    File.join nexus_files, "regex_bug.nex"
  }

  # deep dive into testing command line options in conjunction with a
  # complicated color map
  let(:basic_tre) { File.join test_files, "basic.tre" }

  let(:basic_color_map_with_tags) {
    File.join test_files, "basic_color_map_with_tags.txt" }
  let(:basic_color_map_regex) {
    File.join test_files, "basic_color_map_regex.txt" }

  let(:basic_branches) {
    File.join nexus_files, "basic_branches_only.nex" }
  let(:basic_branches_regex) {
    File.join nexus_files, "basic_branches_only_regex.nex" }

  let(:basic_labels) {
    File.join nexus_files, "basic_labels_only.nex"}
  let(:basic_labels_regex) {
    File.join nexus_files, "basic_labels_only_regex.nex"}

  let(:basic_labels_and_branches) {
    File.join nexus_files, "basic_labels_and_branches.nex"}
  let(:basic_labels_and_branches_regex) {
    File.join nexus_files, "basic_labels_and_branches_regex.nex"}

  let(:apple_name_map) {
    File.join test_files, "apple.name_map" }
  let(:apple_newick) {
    File.join test_files, "apple.tre" }
  let(:apple_no_color_nexus) {
    File.join nexus_files, "apple.no_color.nexus" }



  describe "::main" do
    context "with renaming" do
      context "no coloring options" do
        it "renames node labels with a name map" do
          # this also tests what happens when (1) names are in the
          # tree but missing from the name map, (2) names are in the
          # name map but not in the tree, (3) illegal characters are
          # used (parentheses and spaces only)
          Iroki::Main::main name_map_f: apple_name_map,
                            newick_f:   apple_newick,
                            out_f:      output_nexus

          check_output output_nexus, apple_no_color_nexus
        end
      end
    end

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

    it "handles seanie's weird chars" do
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

    it "handles Jess's bug (RAxML terminal leaf node with no name)" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        auto_color:       "kelly",
                        color_map_f:      small_color_map,
                        newick_f:         jess_newick,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read jess_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    it "handles single sample biom files with single color gradient" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        biom_f:           single_sample_biom,
                        single_color:     true,
                        newick_f:         single_sample_tre,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read single_sample_one_color_nex

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end


    it "handles single sample biom files with two color gradient" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        biom_f:           single_sample_biom,
                        newick_f:         single_sample_tre,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read single_sample_nex

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    it "handles two group biom files with two color gradient" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        biom_f:           two_group_biom,
                        newick_f:         two_group_tre,
                        out_f:            output_nexus

      check_output output_nexus, two_group_nex
    end

    context "Testing of command line args with tricky color map" do
      context "exact string matching" do
        it "colors the labels" do
          Iroki::Main::main color_branches: false,
                            color_taxa_names: true,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_labels
        end

        it "colors the branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: false,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_branches
        end

        it "colors labels and branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: true,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_labels_and_branches
        end
      end

      it "handles biom file and color map file"

      context "regular expression matching" do
        it "colors the labels" do
          Iroki::Main::main color_branches: false,
                            color_taxa_names: true,
                            exact: false,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_regex,
                            out_f: output_nexus

          check_output output_nexus, basic_labels_regex
        end

        it "colors the branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: false,
                            exact: false,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_regex,
                            out_f: output_nexus

          check_output output_nexus, basic_branches_regex
        end

        it "colors labels and branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: true,
                            exact: false,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_regex,
                            out_f: output_nexus

          check_output output_nexus, basic_labels_and_branches_regex
        end

        it "works with the ^ (match at beginning character) (bug fix)" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: true,
                            exact: false,
                            newick_f: regex_bug_tre,
                            color_map_f: regex_bug_color_map,
                            out_f: output_nexus

          check_output output_nexus, regex_bug_nexus
        end
      end
    end

    # it "looks good with kelly colors" do
    #   Iroki::Main::main color_branches:   true,
    #                     color_taxa_names: true,
    #                     exact:            true,
    #                     auto_color:       "kelly",
    #                     color_map_f:      kelly_color_map,
    #                     newick_f:         kelly_newick,
    #                     out_f:            kelly_out

    #   actual_output   = File.read kelly_out
    #   expected_output = File.read kelly_nexus

    #   expect(actual_output).to eq expected_output

    #   # FileUtils.rm output_nexus
    # end

    it "raises SystemExit when display-auto-color-options is passed" do
      expect { Iroki::Main::main display_auto_color_options: true }.
        to raise_error SystemExit
    end

    context "bad user input" do

      it "raises AbortIf::Exit when the auto-color option is invalid" do
        auto_color = "asldkfjaldj"

        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       auto_color,
                                   color_map_f:      small_color_map,
                                   newick_f:         small_newick,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit

      end

      it "raises AbortIf::Exit when the newick file doesn't exist" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         "sldfjalsdjf",
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when the color file doesn't exist" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      "alsdkjf",
                                   newick_f:         small_newick,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when the newick file is nil" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         nil,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the newick file is given" do
        expect { Iroki::Main::main newick_f: small_newick }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the color map file is given" do
        expect { Iroki::Main::main color_map_f: small_color_map }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the name map file is given" do
        expect { Iroki::Main::main name_map_f: small_color_map }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the biom file is given" do
        expect { Iroki::Main::main biom_f: two_group_biom }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given newick, color branches " +
         " and neither a biom file nor a color map file" do
        expect { Iroki::Main::main color_branches: true,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given newick, color labels " +
         " and neither a biom file nor a color map file" do
        expect { Iroki::Main::main color_taxa_names: true,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given no output file" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         small_newick,
                                   out_f:            nil }.
          to raise_error AbortIf::Exit
      end

      it "raises when given biom f but no color options" do
        expect { Iroki::Main::main exact: true,
                                   biom_f: two_group_biom,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises when given color map but no color options" do
        expect { Iroki::Main::main exact: true,
                                   color_map_f: small_color_map,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises when given --single-color with no biom file" do
        expect { Iroki::Main::main exact: true,
                                   color_branches: true,
                                   color_taxa_names: true,
                                   color_map_f: small_color_map,
                                   newick_f: small_newick,
                                   out_f: output_nexus,
                                   single_color: true}.
          to raise_error AbortIf::Exit
      end

      it "raises when given single color with two group biom file" do
        expect { Iroki::Main::main exact: true,
                                   color_branches: true,
                                   color_taxa_names: true,
                                   color_map_f: two_group_biom,
                                   newick_f: small_newick,
                                   out_f: output_nexus,
                                   single_color: true}.
          to raise_error AbortIf::Exit
      end
    end
  end
end

def check_output actual, expected
  expect(File.read(actual)).to eq File.read(expected)
end
