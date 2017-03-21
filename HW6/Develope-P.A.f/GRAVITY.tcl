# ################################################################################################################
# ######################################## GRAVITY ANALYSIS ######################################################
# ################################################################################################################

set topFloorLoad 	[expr 138.83*$kip];
set floorLoad 		[expr 197.16*$kip];
set botFloorLoad 	[expr 205.49*$kip];

set patternTagGravity 1;
pattern Plain $patternTagGravity "Constant" {
	for {set i 1} {$i <= $nStory} {incr i} {
		
		if {$i == 1} {
			set floorGravityLoad $botFloorLoad;
		} elseif {$i == $nStory} {
			set floorGravityLoad $topFloorLoad;
		} else {
			set floorGravityLoad $floorLoad;
		};
		
		#load $nodeTag (ndf $LoadValues)
		load [expr 1000*$i + 100 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0; #Wall 1
		load [expr 1000*$i + 200 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0; #Wall 2
		puts $ExportID "load [expr 1000*$i + 100 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0"
		puts $ExportID "load [expr 1000*$i + 200 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0"
	}
}

# Define analysis parameters
integrator LoadControl 1;
system BandGeneral;
test NormDispIncr 1.0e-6 500 1;
numberer Plain;
constraints Transformation;
algorithm Newton;
analysis Static;
set ok [analyze 1];

if {$ok != 0}  {
	puts "NOT CONVERGED for Gravity.";
	puts "============================";
} else {
	puts "GRAVITY ANALYSIS DONE!!";
	puts "=========================";
}
loadConst -time 0.0;
set GravityAnalysisDone "Yes"