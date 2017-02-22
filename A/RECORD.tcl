set dataDir "Results";					# set up name of data directory
file mkdir $dataDir; 					# create data directory

for {set i 1} {$i <= $nStory} {incr i 1} {
	set dispNodeTag [expr 1000*$i + 200 + $nEleFloor];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	recorder Node -file $dataDir/$dispNodeFile -time -node $dispNodeTag -dof $controlDOF disp  
}


recorder Element -file $dataDir/BaseWallForces.txt -time -ele [expr 1000*1 + 100 + 1] [expr 1000*1 + 200 + 1] globalForce 
recorder Element -file $dataDir/RoofCBForces.txt -time -ele [expr 1000*$nStory + 1] [expr 1000*1 + 1] globalForce
recorder Element -file $dataDir/RoofCBForcest.txt -time -ele [expr 1000*$nStory + 3] [expr 1000*1 + 3] globalForce








# ##################### FOR PLOTTING DEFLECTED SHAPE IN MATLAB ###########################################
set dataDir1 "DeflectedShape";					# set up name of data directory
file mkdir $dataDir1; 					# create data directory
for {set i 1} {$i <= [llength $Nodes]} {incr i 1} {
	set dispNodeTag [lindex $Nodes [expr $i-1]];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	recorder Node -file $dataDir1/$dispNodeFile -time -node $dispNodeTag -dof 1 2 3 disp
}