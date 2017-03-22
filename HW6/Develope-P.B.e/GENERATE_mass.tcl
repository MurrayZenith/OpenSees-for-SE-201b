# MASS ASSIGNMENT -----------------------------------------------------------------------------------------
set topFloorMass 	[expr 15461*$lbf*pow($sec,2)/$ft]; # 61844/4 = 15461.00
set midfloorMass 	[expr 17294*$lbf*pow($sec,2)/$ft]; # 69176/4 = 17294.00
set botFloorMass 	[expr 17702*$lbf*pow($sec,2)/$ft]; # 70808/4 = 17702.00

for {set i 1} {$i <= $nStory} {incr i} {
	
	if {$i == 1} {
		set floorMass $botFloorMass;
	} elseif {$i == $nStory} {
		set floorMass $topFloorMass;
	} else {
		set floorMass $midfloorMass;
	};
	
	#load $nodeTag (ndf $LoadValues)
	mass [expr 1000*$i + 100 + $nEleFloor] $floorMass [expr 0.0*$floorMass] 0.0 0.0 0.0 0.0; #Wall 1
	mass [expr 1000*$i + 200 + $nEleFloor] $floorMass [expr 0.0*$floorMass] 0.0 0.0 0.0 0.0; #Wall 2
	puts $ExportID "mass [expr 1000*$i + 100 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0;"
	puts $ExportID "mass [expr 1000*$i + 200 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0;"
}