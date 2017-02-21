
 ############################# WALL 1 and 2 #######################################
# Loop over number of stories (nStory)
for {set i 1} {$i <= $nStory} {incr i 1} {



	# ##########################################################
	# Element for Walls 
	# ##########################################################


	# First element of each floor
	if {$i == 1} {
		# Floor 1
		
		# set iNodeTag_1 as baseNodeTag
		set iNodeTag_1 1100;
		# set jNodeTag_1 as [expr 1000*$i + wall_no*100 + 1]
		set jNodeTag_1 [expr 1000*$i + 100 + 1];
		
		set iNodeTag_2 1200;
		set jNodeTag_2 [expr 1000*$i + 200 + 1];

	} else {
		# Other floors
		
		# set iNodeTag_1 as jNodeTag1_previousFloor_lastElement
		set iNodeTag_1 $jNodeTag1_previousFloor_lastElement;
		# set jNodeTag_1 as [expr 1000*$i + wall_no*100 + 1]
		set jNodeTag_1 [expr 1000*$i + 100 + 1];

		set iNodeTag_2 $jNodeTag2_previousFloor_lastElement;
		set jNodeTag_2 [expr 1000*$i + 200 + 1];
	
	}
	
	# Add element as per element command in OpenSees Wiki, and write element command line to $ExportID
	# element ElementType ElementTag iNodeTag_1 jNodeTag_1 ........ (see uploaded Tutorial PDF file for ElementTag)
	element elasticBeamColumn [expr 1000*$i + 100 + 1] $iNodeTag_1 $jNodeTag_1 $Acol $E $G $Jcol $Iycol $Izcol $transfTagCol;
	element elasticBeamColumn [expr 1000*$i + 200 + 1] $iNodeTag_2 $jNodeTag_2 $Acol $E $G $Jcol $Iycol $Izcol $transfTagCol;
	
	# puts $ExportID "..."
	puts $ExportID "element [expr 1000*$i + 100 + 1] $iNodeTag_1 $jNodeTag_1;"
	puts $ExportID "element [expr 1000*$i + 200 + 1] $iNodeTag_2 $jNodeTag_2;"

	# # Remaining elements of each floor -----------------------------------------------------------------------------------------------------------------------
	# for {set j 1} {$j <= [expr $nEleFloor - 1]} {incr j 1} {
	
	# 	#set iNodeTag_1 $jNodeTag_1;
	# 	#set jNodeTag_1 [expr 1000*$i + 100 + ($j + 1)];
		
		
	# 	# Add element as per element command in OpenSees Wiki, and write element command line to $ExportID
	# 	# element ElementType ElementTag iNodeTag_1 jNodeTag_1 ........ (see uploaded Tutorial PDF file for ElementTag)
	# 	# puts $ExportID "..."
		
	# }
	
	# ########################################################################################################################
	# Rigid elements in each floor (use elasticBeamColumn element with very high section properties to simulate rigidity)
	# ########################################################################################################################
	# Add elements as per element command in OpenSees Wiki, and write element command line to $ExportID

	# rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+1];
	# rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+2];
	# rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+3];
	# rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+4];
	rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+5];
	rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+6];
	rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+7];
	rigidLink beam $jNodeTag_1 [expr $jNodeTag_1+8];

	# rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+1];
	# rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+2];
	# rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+3];
	# rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+4];
	rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+5];
	rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+6];
	rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+7];
	rigidLink beam $jNodeTag_2 [expr $jNodeTag_2+8];

	
	# ##########################################################
	# Truss Elements for Coupling Beam 
	# ##########################################################
	# Add elements as per element command in OpenSees Wiki, and write element command line to $ExportID
	
	element truss [expr 1000*$i + 1] [expr $jNodeTag_1+5] [expr $jNodeTag_2+7] $Atruss $Eqtruss
	element truss [expr 1000*$i + 2] [expr $jNodeTag_1+6] [expr $jNodeTag_2+8] $Atruss $Eqtruss
	element truss [expr 1000*$i + 3] [expr $jNodeTag_2+5] [expr $jNodeTag_1+7] $Atruss $Eqtruss
	element truss [expr 1000*$i + 4] [expr $jNodeTag_2+6] [expr $jNodeTag_1+8] $Atruss $Eqtruss

	puts $ExportID "element [expr 1000*$i + 1] [expr $jNodeTag_1+5] [expr $jNodeTag_2+7];"
	puts $ExportID "element [expr 1000*$i + 2] [expr $jNodeTag_1+6] [expr $jNodeTag_2+8];"
	puts $ExportID "element [expr 1000*$i + 3] [expr $jNodeTag_2+5] [expr $jNodeTag_1+7];"
	puts $ExportID "element [expr 1000*$i + 4] [expr $jNodeTag_2+6] [expr $jNodeTag_1+8];"

	# for next loop
	set jNodeTag1_previousFloor_lastElement $jNodeTag_1;
	set jNodeTag2_previousFloor_lastElement $jNodeTag_2;
}
