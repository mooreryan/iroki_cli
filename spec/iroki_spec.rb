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

describe Iroki do
  it "has a version" do
    expect(Iroki::VERSION).not_to be nil
  end

  it "has a copyright" do
    expect(Iroki::COPYRIGHT).not_to be nil
  end

  it "has a contact" do
    expect(Iroki::CONTACT).not_to be nil
  end

  it "has a website" do
    expect(Iroki::WEBSITE).not_to be nil
  end

  it "has a license" do
    expect(Iroki::LICENSE).not_to be nil
  end

  it "has a version banner" do
    version_banner = "  # Version: #{Iroki::VERSION}
  # Copyright #{Iroki::COPYRIGHT}
  # Contact: #{Iroki::CONTACT}
  # Website: #{Iroki::WEBSITE}
  # License: #{Iroki::LICENSE}"

    expect(Iroki::VERSION_BANNER).to eq version_banner
  end
end
