# MASS ASSIGNMENT -----------------------------------------------------------------------------------------
set topFloorMass 	[expr 15461*$lbf*pow($sec,2)/$ft];;
set floorMass 		[expr 17294*$lbf*pow($sec,2)/$ft];
set botFloorMass 	[expr 17702*$lbf*pow($sec,2)/$ft];

for {set i 1} {$i <= $nStory} {incr i} {
	
	if {$i == 1} {
		set floorMass $botFloorMass;
	} elseif {$i == $nStory} {
		set floorMass $topFloorMass;
	} else {
		set floorMass $floorMass;
	};
	
	#load $nodeTag (ndf $LoadValues)
	mass [expr 1000*$i + 100 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0; #Wall 1
	mass [expr 1000*$i + 200 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0; #Wall 2
	puts $ExportID "mass [expr 1000*$i + 100 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0;"
	puts $ExportID "mass [expr 1000*$i + 200 + $nEleFloor] $floorMass $floorMass 0.0 0.0 0.0 0.0;"
}