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

require "abort_if"

require "iroki_lib/version"
require "iroki_lib/const/const"
require "iroki_lib/color/color"
require "iroki_lib/core_ext/hash/hash"
require "iroki_lib/core_ext/string/string"
require "iroki_lib/core_ext/file/file"
require "iroki_lib/utils/utils"


include IrokiLib::Const
include IrokiLib::Color
include IrokiLib::CoreExt::Hash
include IrokiLib::CoreExt::String
include IrokiLib::CoreExt::File
include IrokiLib::Utils

include AbortIf


module IrokiLib
end
