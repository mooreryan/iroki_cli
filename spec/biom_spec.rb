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

describe Iroki::Biom do
  let(:this_dir) { File.dirname __FILE__ }
  let(:test_files) { File.join this_dir, "test_files" }
  let(:single_sample_biom_f) { File.join test_files, "single_sample.biom" }
  let(:two_sample_biom_f) { File.join test_files, "two_sample.biom" }

  let(:single_sample_biom) { Iroki::Biom.open single_sample_biom_f }
  let(:two_sample_biom) { Iroki::Biom.open two_sample_biom_f }
  let(:samples) { %w[seq_1 seq_2 seq_3 seq_4 seq_5 seq_6] }

  let(:different_number_of_columns) {
    File.join test_files, "different_number_of_columns.biom"
  }

  let(:with_bad_counts_single_sample_biom) {
    File.join test_files, "with_bad_counts_single_sample.biom" }

  let(:iroki_net_issue_2_biom) {
    File.join test_files, "iroki_net_issues", "issue_2", "biom" }

  let(:empty_first_col_biom) {
    File.join test_files, "empty_first_col.biom" }
  let(:empty_second_col_biom) {
    File.join test_files, "empty_second_col.biom" }
  let(:empty_thrid_col_biom) {
    File.join test_files, "empty_third_col.biom" }

  it "is a File" do
    expect(single_sample_biom).to be_a File
  end

  describe "#valid_numerical_val?" do
    it "returns true when str is good numerical data" do
      strings = [
        "2.3e4",
        "-2.3e4",
        "2.3e-4",
        "-2.3e-4",

        "2.3E4",
        "-2.3E4",
        "2.3E-4",
        "-2.3E-4",

        "+2.3e4",
        "2.3e+4",
        "+2.3e+4",

        "+2.3E4",
        "2.3E+4",
        "+2.3E+4",

        "2.3",
        "2.",
        ".3",
        "2.",
        "23",
      ]

      strings.each do |str|
        expect(valid_numerical_val? str).to be_truthy
      end
    end

    it "returns nil if the value is wonky" do
      # not really the best regex here, but it's something
      strings = [
        "apple",
        # "a34",
        # "34a",
        # "2.3.4",
        # "e23",
        # "23e",
      ]

      strings.each do |str|
        expect(valid_numerical_val? str).not_to be_truthy
      end
    end
  end


  describe "#parse" do
    context "bad input" do
      context "when passed a file where not all rows have the same number of columns" do
        it "raises AbortIf::Exit" do
          expect { Iroki::Biom.open(different_number_of_columns).parse }.
            to raise_error AbortIf::Exit
        end
      end

      context "with bad counts" do
        it "raises AbortIf::Exit" do
          expect { Iroki::Biom.open(with_bad_counts_single_sample_biom).parse }.
            to raise_error AbortIf::Exit
        end
      end

      context "the biom file from iroki.net issue 2" do
        it "raises AbortIf::Exit" do
          expect { Iroki::Biom.open(iroki_net_issue_2_biom, "rt").parse }.
            to raise_error AbortIf::Exit
        end
      end

      context "with empty columns" do
        context "first col empty" do
          it "raises AbortIf::Exit" do
            expect { Iroki::Biom.open(empty_first_col_biom, "rt").parse }.
              to raise_error AbortIf::Exit
          end
        end

        context "second col empty" do
          it "raises AbortIf::Exit" do
            expect { Iroki::Biom.open(empty_second_col_biom, "rt").parse }.
              to raise_error AbortIf::Exit
          end
        end

        context "third col empty" do
          it "raises AbortIf::Exit" do
            expect { Iroki::Biom.open(empty_thrid_col_biom, "rt").parse }.
              to raise_error AbortIf::Exit
          end
        end
      end
    end


    context "good input" do
      context 'it handles \r as line ending char with passed "rt" option' do
        it "returns the samples and the counts" do
          fname = File.join File.dirname(__FILE__), "tmpfile"
          File.open(fname, "w") do |f|
            f.print "s1\t100\rs2\t200"
          end

          is_single_group = true
          samples = ["s1", "s2"]
          counts = [100.0, 200.0]

          expect(Iroki::Biom.open(fname, "rt").parse).
            to eq [samples, counts, is_single_group]

          FileUtils.rm fname
        end
      end

      context "when passed a single sample biom file" do
        it "returns the samples and the counts" do
          is_single_group = true
          counts = [0.0, 25.0, 50.0, 75.0, 100.0, 0.0]

          expect(single_sample_biom.parse).
            to eq [samples, counts, is_single_group]

        end
      end

      context "when passed a two sample biom file" do
        it "returns samples and counts for both" do
          is_single_group = nil
          counts1 = [100.0, 75.0, 50.0, 25.0, 0.0, 0.0]
          counts2 = [0.0, 25.0, 50.0, 75.0, 100.0, 0.0]

          expect(two_sample_biom.parse).
            to eq [samples, counts1.zip(counts2), is_single_group]
        end
      end
    end
  end
end
