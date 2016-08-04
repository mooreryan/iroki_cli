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

  it "is a File" do
    expect(single_sample_biom).to be_a File
  end

  describe "#parse" do
    context "when passed a file where not all rows have the same number of columns" do
      it "raises AbortIf::Exit" do
        expect { Iroki::Biom.open(different_number_of_columns).parse }.
          to raise_error AbortIf::Exit
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
