
# ##############################################################################################
# 						  SE 201B: NONLINEAR STRUCTURAL ANALYSIS                               #
#						       Angshuman Deb, Winter 2017                                      #
# ##############################################################################################

# INITIALIZATION --------------------------------------------------------------------
wipe;										# clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;			# define the model builder, ndm=#dimension, ndf=#dofs


set ModelDirectory "Model";
set DeflectedShapeDirectory "DeflectedShape";


file mkdir $ModelDirectory;
file mkdir $DeflectedShapeDirectory;


			
source UNITS.tcl;							# define units
puts "MODEL SET-UP OK"


#              ================================
# 				  Global Coordinate System
#              ================================
#           ____________		 _____________		   ^ Y-axis
#          |  __________|=======|___________  |		   |        
#          | |                              | |		   |        
#          | |                              | |		   |          
#          | |                              | |        o-------->  X-axis
#          | |                              | |        
#          | |                              | |        
#          | |                              | |        
#          | |__________          __________| |        
#          |____________|========|____________|
#          


# SET MODEL PARAMETERS ----------------------------------------------------------------------------------------------------------------------------------
set nStory 10;								# number of story
set storyH1 [expr 16.0*$ft];				# Height of 1st story
set storyHup [expr 14.0*$ft];				# Height of remaining stories
set storyH {StoryHeights $storyH1 $storyHup $storyHup $storyHup $storyHup $storyHup $storyHup $storyHup $storyHup $storyHup};
set buildingHeight	[expr 1.*$storyH1 + ($nStory - 1)*$storyHup];
set eleTypeWall "forceBeamColumn";          # forceBeamColumn / dispBeamColumn
set eleTypeTruss "corotTruss";              # truss / corotTruss
set numIntgrPts 2;							# number of integration points
set nEleFloor 1;							# number of column elements per floor
set C_dim1 [expr 9.1667*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set C_dim2 [expr 8.4108*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set C_dim3 [expr 0.4583*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set C_dim4 [expr 3.0833*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set C_dim5 [expr 27.48825*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set C_dim6 [expr 10.6667*$ft];				# Dimensions of Core Wall (see picture CWallDims.jpeg)
set GravityAnalysisDone "No";
set DoModalAnalysis "Yes";
set modes 10;								# how many modes?

# Using P-D as question asked
set gT "Linear";							# Choose between Linear, PDelta, and Corotational

set analysisType "TimeHistory";				# Choose between PushOver, and TimeHistory
set pushDir "EW";							# Specify push direction, EW, or NS, if $analysisType = "PushOver"


# MATERIAL DEFINITION ----------------------------------------------------------------------------------------------------------------------------------------------
set fpcFac  [expr 1.7];										# Factor to be multiplied to get expected material properties
set fpcNom  [expr 5.*$ksi];									# Nominal concrete strength
set fpccNom  [expr 6.*$ksi];									# Nominal concrete strength

set fyFac   [expr 1.15];									# Factor to be multiplied to get expected material properties
set fyNom   [expr 60.];										# Nominal steel yield strength

set ConcMatTypeWall "LinearElastic"; 					# Choose between LinearElastic, Concrete01, Concrete02
set ConcMatTypeBeam "LinearElastic";					# Choose between LinearElastic, Concrete01, Concrete02


# GEOMETRY/MATERIAL/SECTIONS --------------------------------------------------------------------------

set ExportID [open "$ModelDirectory/modelData.txt" "w"];

source "INPUT_nodes.tcl" 
puts "NODES OK"

source "INPUT_mat.tcl"
puts "MATERIALS OK"

source "INPUT_sec.tcl"
puts "SECTIONS OK"

# GEOMETRIC TRANSFORMATIONS --------------------------------------------------------------------------

source "TRANSF.tcl"
puts "TRANSFORMATIONS OK"

# ELEMENTS --------------------------------------------------------------------------

source "INPUT_elem.tcl"
puts "ELEMENTS OK"

# MASS ------------------------------------------------------------------------------
source "GENERATE_mass.tcl"
puts "MASS OK"

if {$DoModalAnalysis == "Yes"} {
	source "Analysis_Modal.tcl"
	puts "Modal Analysis Results Pre - Gravity"
	puts "---------------------------------------"
	for {set i 1} {$i <= $modes} {incr i 1} {
		puts "T$i = [lindex $T [expr $i-1]]";
	}
}

# GRAVITY ANALYSIS --------------------------------------------------------------------------
source "GRAVITY.tcl"
puts "Gravity Analysis Done"



if {$DoModalAnalysis == "Yes"} {
	source "Analysis_Modal.tcl"
	puts "Modal Analysis Results Post - Gravity"
	puts "-----------------------------------------"
	for {set i 1} {$i <= $modes} {incr i 1} {
		puts "T$i = [lindex $T [expr $i-1]]";
	}
}


# ANALYSIS --------------------------------------------------------------------------
 source "Analysis_$analysisType.tcl"

close $ExportID
wipe;