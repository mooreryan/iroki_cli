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

SingleGroupGradient = Iroki::Color::SingleGroupGradient
Gradient = Iroki::Color::Gradient

describe Iroki::Color::SingleGroupGradient do
  let(:samples) { %w[s1 s2 s3 s4 s5] }
  let(:counts)  { [0, 25, 50, 75, 100] }

  let(:ssg) {
    SingleGroupGradient.new samples, counts
  }

  it "is a Gradient" do
    expect(ssg).to be_a Gradient
  end

  subject { ssg }
  it { should respond_to :counts }
  it { should respond_to :rel_abunds }

  describe "::initialize" do
    it "raises an error if the samples and counts are different sized" do
      expect { SingleGroupGradient.new %w[s], [1,2] }.
        to raise_error AbortIf::Exit
    end

    it "sets the samples" do
      expect(ssg.samples).to eq samples
    end

    it "sets the counts" do
      expect(ssg.counts).to eq counts
    end

    it "sets the relative abundances" do
      expect(ssg.rel_abunds).to eq [0, 0.25, 0.5, 0.75, 1]
    end
  end
end
