
# ###################################################################################################################################################################################################
# ################################################################################ DYNAMIC ANALYSIS RECORDERS #######################################################################################
# ###################################################################################################################################################################################################

set ResultsDirectory "Results_dyn";
file mkdir $ResultsDirectory;

set controlDOF 1;
set controlNode [expr 1000*$nStory + 200 + $nEleFloor];

recorder Node -file $ResultsDirectory/Reaction.txt -time -node 1100 1200 -dof $controlDOF reaction
recorder Node -file $ResultsDirectory/Disp.txt -time -node $controlNode -dof $controlDOF disp

recorder Element -file $ResultsDirectory/SecF_W1_base.txt -time -ele 1101 section 1 force 		; # N_x 	M_y 	M_z 	Torsion
recorder Element -file $ResultsDirectory/SecD_W1_base.txt -time -ele 1101 section 1 deformation 	; # eps_x 	kappa_y	kappa_z	Theta

recorder Element -file $ResultsDirectory/SecF_W2_base.txt -time -ele 1201 section 1 force
recorder Element -file $ResultsDirectory/SecD_W2_base.txt -time -ele 1201 section 1 deformation


recorder Element -file $ResultsDirectory/EleF_CB_f10.txt	-time -ele 10001 10003 globalForce
recorder Element -file $ResultsDirectory/EleF_CB_f1.txt 	-time -ele 1001 1003 globalForce

recorder Element -file $ResultsDirectory/AxialDef_CB_f10.txt	-time -ele 10001 10003 deformations
recorder Element -file $ResultsDirectory/AxialDef_CB_f1.txt		-time -ele 1001 1003 deformations

# # For N - and M - diagrams
# for {set i 2} {$i <= $nStory} {incr i 2} {
# 	for {set j 1} {$j <= $nEleFloor} {incr j 1} {
		
# 		set eleTag [expr 1000*$i + 200 + $j];
# 		set filename1 "SecD_$eleTypeWall$eleTag.txt"
# 		set filename2 "LocEleD_$eleTypeWall$eleTag.txt"
# 		set filename3 "GlobEleD_$eleTypeWall$eleTag.txt"
		
# 		recorder Element -file $ResultsDirectory/$filename1 -ele $eleTag section force
# 		recorder Element -file $ResultsDirectory/$filename2 -ele $eleTag localForce
# 		recorder Element -file $ResultsDirectory/$filename3 -ele $eleTag globalForce
# 	}
# };

# ##################################################################################################################


# ##################################################################################################################
# ############################## PLOT DEFLECTED SHAPE IN MATLAB ####################################################
# ##################################################################################################################

for {set i 1} {$i <= [llength $Nodes]} {incr i 1} {
	set dispNodeTag [lindex $Nodes [expr $i-1]];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	set accNodeFile "accNode_$dispNodeTag.txt"
	recorder Node -file $DeflectedShapeDirectory/$dispNodeFile -time -node $dispNodeTag -dof 1 disp
	recorder Node -file $DeflectedShapeDirectory/$accNodeFile -time -node $dispNodeTag -dof 1 accel
}

