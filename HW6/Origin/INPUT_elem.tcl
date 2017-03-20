
 ############################# WALL 1 and 2 #######################################
 
for {set i 1} {$i <= $nStory} {incr i 1} {

	if {$i == 1} {
		set iNode1 1100;
		set iNode2 1200;
	} else {
		set iNode1 $jNode1;
		set iNode2 $jNode2;
	}
	
	set jNode1 [expr 1000*$i + 100 + 1];
	set jNode2 [expr 1000*$i + 200 + 1];
	
	# First element of each floor ---------------------------------------------------------------------------------------------------------------------------
	if {$eleTypeWall == "elasticBeamColumn"} {
		element elasticBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertLeft
		element elasticBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertRight
		
		puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertLeft"
		puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertRight"
		
	} elseif {$eleTypeWall == "dispBeamColumn"} {
		element dispBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto
		element dispBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto
		
		puts $ExportID "element dispBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto"
		puts $ExportID "element dispBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto"
		
	}
	# --------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	# Remaining elements of each floor -----------------------------------------------------------------------------------------------------------------------
	for {set j 1} {$j <= [expr $nEleFloor - 1]} {incr j 1} {
	
		set iNode1 $jNode1;
		set iNode2 $jNode2;
		
		set jNode1 [expr 1000*$i + 100 + ($j + 1)];
		set jNode2 [expr 1000*$i + 200 + ($j + 1)];
		
		if {$eleTypeWall == "elasticBeamColumn"} {
		
			element elasticBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertLeft
			element elasticBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertRight
			
			puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertLeft"
			puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $AWall $Ec $Gc $JWall $IyWall $IzWall $transfTagVertRight"
		
		} elseif {$eleTypeWall == "dispBeamColumn"} {
		
			element dispBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto
			element dispBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto
			
			puts $ExportID "element dispBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto"
			puts $ExportID "element dispBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto"
		
		}
		
		
	}
	# -----------------------------------------------------------------------------------------------------------------------------------------------------

	
	# Rigid elements in each floor --------------------------------------------------------------------------------------------------------------------
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 1] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 1] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 2] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 2] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 3] [expr 1000*$i + 100 + $nEleFloor + 1]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 4] [expr 1000*$i + 100 + $nEleFloor + 2]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 100 + $nEleFloor + 5]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 100 + $nEleFloor + 6]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 100 + $nEleFloor + 7]	[expr 1000*$i + 100 + $nEleFloor + 5] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 100 + $nEleFloor + 8]	[expr 1000*$i + 100 + $nEleFloor + 6] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	
	
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 1] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 1] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 2] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 2] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 3] [expr 1000*$i + 100 + $nEleFloor + 1]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 4] [expr 1000*$i + 100 + $nEleFloor + 2]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 100 + $nEleFloor + 5]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 100 + $nEleFloor + 6]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 100 + $nEleFloor + 7]	[expr 1000*$i + 100 + $nEleFloor + 5] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 100 + $nEleFloor + 8]	[expr 1000*$i + 100 + $nEleFloor + 6] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"
	
	
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 1] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 1] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 2] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 2] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 3] [expr 1000*$i + 200 + $nEleFloor + 1]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 4] [expr 1000*$i + 200 + $nEleFloor + 2]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 5]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 6]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 7]	[expr 1000*$i + 200 + $nEleFloor + 5] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 8]	[expr 1000*$i + 200 + $nEleFloor + 6] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig
	
	
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 1] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 1] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 2] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 2] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 3] [expr 1000*$i + 200 + $nEleFloor + 1]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 4] [expr 1000*$i + 200 + $nEleFloor + 2]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 5]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"   
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 6]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"   
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 7]	[expr 1000*$i + 200 + $nEleFloor + 5] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"   
	puts $ExportID "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 8]	[expr 1000*$i + 200 + $nEleFloor + 6] $ARigid $Ec $Gc $JRigid $IyRigid $IzRigid $transfTagVertRig"


	# Truss Elements for Coupling Beam ---------------------------------------------------------------------------------------------------------
	
	if {$eleTypeTruss == "truss"} {
		element truss [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $ATruss $ConcMatTagBeam
		element truss [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $ATruss $ConcMatTagBeam
		element truss [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $ATruss $ConcMatTagBeam
		element truss [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $ATruss $ConcMatTagBeam
		
		puts $ExportID "element truss [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $ATruss $ConcMatTagBeam"
		puts $ExportID "element truss [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $ATruss $ConcMatTagBeam"
		puts $ExportID "element truss [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $ATruss $ConcMatTagBeam"
		puts $ExportID "element truss [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $ATruss $ConcMatTagBeam"
	
	} elseif {$eleTypeTruss == "corotTruss"} {
	
		element corotTruss [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $ATruss $ConcMatTagBeam
		element corotTruss [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $ATruss $ConcMatTagBeam
		element corotTruss [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $ATruss $ConcMatTagBeam
		element corotTruss [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $ATruss $ConcMatTagBeam
		
		puts $ExportID "element corotTruss [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $ATruss $ConcMatTagBeam"
		puts $ExportID "element corotTruss [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $ATruss $ConcMatTagBeam"
		puts $ExportID "element corotTruss [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $ATruss $ConcMatTagBeam"
		puts $ExportID "element corotTruss [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $ATruss $ConcMatTagBeam"
	
	}

}
