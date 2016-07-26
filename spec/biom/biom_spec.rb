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
  let(:test_files) { File.join this_dir, "..", "test_files" }
  let(:single_sample_biom_f) { File.join test_files, "single_sample.biom" }
  let(:two_sample_biom_f) { File.join test_files, "two_sample.biom" }

  let(:single_sample_biom) { Iroki::Biom.open single_sample_biom_f }
  let(:two_sample_biom) { Iroki::Biom.open two_sample_biom_f }
  let(:samples) { %w[seq_1 seq_2 seq_3 seq_4 seq_5] }

  it "is a File" do
    expect(single_sample_biom).to be_a File
  end

  describe "#parse" do
    context "when passed a single sample biom file" do
      it "calls #parse_single_sample"
    end

    context "when passed a two sample biom file" do
      it "calls #parse_two_sample"
    end
  end

  describe "#parse_single_sample" do
    context "with valid biom file" do
      it "returns samples and counts" do
        counts = [0, 25, 50, 75, 100]

        expect(single_sample_biom.parse_single_sample).
          to eq [samples, counts]
      end
    end
  end

  describe "#parse_two_sample" do
    context "with valid biom file" do
      it "returns samples and counts for both" do
        counts1 = [100, 75, 50, 25, 0]
        counts2 = [0, 25, 50, 75, 100]

        expect(two_sample_biom.parse_two_sample).
          to eq [samples, counts1, counts2]
      end
    end
  end
end
