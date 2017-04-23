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

TwoGroupGradient = Iroki::Color::TwoGroupGradient
Gradient = Iroki::Color::Gradient

describe Iroki::Color::TwoGroupGradient do

  let(:min_lumin) { 50 }
  let(:max_lumin) { 90 }

  let(:samples) { %w[s1 s2 s3 s4 s5] }
  let(:g1_counts) { [0, 50, 10, 20, 100] }
  let(:g2_counts) { [0, 50, 20, 10, 100] }
  let(:color_hex_codes) {
    %w[#bebebe #66ffff #a3d1ff #a3ffd1 #00ffff]
  }

  let(:tsg) {
    TwoGroupGradient.new samples,
                         g1_counts,
                         g2_counts,
                         min_lumin,
                         max_lumin
  }

  it "is a Gradient" do
    expect(tsg).to be_a Gradient
  end

  subject { tsg }
  it { should respond_to :g1_counts }
  it { should respond_to :g2_counts }
  it { should respond_to :g1_rabunds }
  it { should respond_to :g2_rabunds }


  describe "::initialize" do
    it "raises an error if the samples and counts are different sized" do
      expect { TwoGroupGradient.new ["a", "b"],
                                    [1,2,3],
                                    [4,5,6],
                                    min_lumin,
                                    max_lumin}.
        to raise_error AbortIf::Assert::AssertionFailureError
    end

    it "sets the max lumin" do
      expect(tsg.max_lumin).to eq max_lumin
    end

    it "sets the min lumin" do
      expect(tsg.min_lumin).to eq min_lumin
    end

    it "validates max lumin vals"
    it "validates min lumin vals"

    it "sets the samples" do
      expect(tsg.samples).to eq samples
    end

    it "sets the counts for sample 1" do
      expect(tsg.g1_counts).to eq g1_counts
    end

    it "sets the counts for sample 2" do
      expect(tsg.g2_counts).to eq g2_counts
    end

    it "sets the relative abundances for sample 1" do
      expect(tsg.g1_rabunds).to eq [0, 0.5, 0.1, 0.2, 1.0]
    end

    it "sets the relative abundances for sample 2" do
      expect(tsg.g2_rabunds).to eq [0, 0.5, 0.2, 0.1, 1.0]
    end

    it "sets the color hex codes" do
      expect(tsg.color_hex_codes).to eq color_hex_codes
    end
  end
end
