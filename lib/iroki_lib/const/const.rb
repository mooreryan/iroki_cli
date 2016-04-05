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

module IrokiLib
  module Const
    COPYRIGHT = "2016 Ryan Moore"
    CONTACT   = "moorer@udel.edu"
    WEBSITE   = "https://github.com/mooreryan/color_tree"
    LICENSE   = "GPLv3"

    VERSION_BANNER = "  # Version: #{IrokiLib::VERSION}
  # Copyright #{COPYRIGHT}
  # Contact: #{CONTACT}
  # Website: #{WEBSITE}
  # License: #{LICENSE}"

    FIG = 'begin figtree;
	set appearance.backgroundColorAttribute="Default";
	set appearance.backgroundColour=#-1;
	set appearance.branchColorAttribute="User selection";
	set appearance.branchLineWidth=1.0;
	set appearance.branchMinLineWidth=0.0;
	set appearance.branchWidthAttribute="Fixed";
	set appearance.foregroundColour=#-16777216;
	set appearance.selectionColour=#-2144520576;
	set branchLabels.colorAttribute="User selection";
	set branchLabels.displayAttribute="Branch times";
	set branchLabels.fontName="sansserif";
	set branchLabels.fontSize=8;
	set branchLabels.fontStyle=0;
	set branchLabels.isShown=false;
	set branchLabels.significantDigits=2;
	set colour.scheme.label="label:InterpolatingContinuous{{false,false,0.0,0.0},#000000,#000000}";
	set layout.expansion=0;
	set layout.layoutType="RECTILINEAR";
	set layout.zoom=0;
	set legend.attribute=null;
	set legend.fontSize=10.0;
	set legend.isShown=false;
	set legend.significantDigits=2;
	set nodeBars.barWidth=4.0;
	set nodeBars.displayAttribute=null;
	set nodeBars.isShown=false;
	set nodeLabels.colorAttribute="label";
	set nodeLabels.displayAttribute="label";
	set nodeLabels.fontName="sansserif";
	set nodeLabels.fontSize=8;
	set nodeLabels.fontStyle=0;
	set nodeLabels.isShown=true;
	set nodeLabels.significantDigits=2;
	set nodeShape.colourAttribute=null;
	set nodeShape.isShown=false;
	set nodeShape.minSize=10.0;
	set nodeShape.scaleType=Width;
	set nodeShape.shapeType=Circle;
	set nodeShape.size=4.0;
	set nodeShape.sizeAttribute=null;
	set polarLayout.alignTipLabels=false;
	set polarLayout.angularRange=0;
	set polarLayout.rootAngle=0;
	set polarLayout.rootLength=100;
	set polarLayout.showRoot=true;
	set radialLayout.spread=0.0;
	set rectilinearLayout.alignTipLabels=false;
	set rectilinearLayout.curvature=0;
	set rectilinearLayout.rootLength=100;
	set scale.offsetAge=0.0;
	set scale.rootAge=1.0;
	set scale.scaleFactor=1.0;
	set scale.scaleRoot=false;
	set scaleAxis.automaticScale=true;
	set scaleAxis.fontSize=8.0;
	set scaleAxis.isShown=false;
	set scaleAxis.lineWidth=1.0;
	set scaleAxis.majorTicks=1.0;
	set scaleAxis.origin=0.0;
	set scaleAxis.reverseAxis=false;
	set scaleAxis.showGrid=true;
	set scaleBar.automaticScale=true;
	set scaleBar.fontSize=10.0;
	set scaleBar.isShown=true;
	set scaleBar.lineWidth=1.0;
	set scaleBar.scaleRange=0.0;
	set tipLabels.colorAttribute="User selection";
	set tipLabels.displayAttribute="Names";
	set tipLabels.fontName="sansserif";
	set tipLabels.fontSize=8;
	set tipLabels.fontStyle=0;
	set tipLabels.isShown=true;
	set tipLabels.significantDigits=2;
	set trees.order=true;
	set trees.orderType="increasing";
	set trees.rooting=false;
	set trees.rootingType="User Selection";
	set trees.transform=false;
	set trees.transformType="cladogram";
end;
'
  end
end
