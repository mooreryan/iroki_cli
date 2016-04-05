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

describe IrokiLib::CoreExt::Hash do
  let(:klass) { Class.new { extend IrokiLib::CoreExt::Hash } }

  describe "#duplicate_values?" do
    it "is true when the hash has duplicate values" do
      h = { a: 1, b: 1 }
      expect(klass.duplicate_values? h).to be true
    end

    it "is false when the hash has no duplicate values" do
      h = { a: 1, b: 2 }
      expect(klass.duplicate_values? h).to be false
    end
  end
end
