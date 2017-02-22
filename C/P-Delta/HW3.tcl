# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2017)
# Maorui Zeng A53211064
# HW3 
wipe; 

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


# Define the model builder, ndm=#dimension, ndf=#dofs
model BasicBuilder -ndm 3 -ndf 6;

source UNITS.tcl;
puts "MODEL SET-UP OK"


# set pushDir "NS";
set pushDir "EW";


# SET MODEL PARAMETERS ----------------------------------------------------------------------------------------------------------------------------------
set ExportID [open "modelData.txt" "w"]; # Open File to write node and element information for plotting model in MATLAB (MATLAB file provided)

source "INPUT_nodes.tcl"; 
puts "NODES OK"

# MATERIAL PARAMETERS ----------------------------------------------------------------------------------------------------------------------------------------------
source "INPUT_mat.tcl"; # Sources the user defined file INPUT_mat.tcl which contains material defintions based on parameters defined above
puts "MATERIALS OK"

# ELEMENTS PARAMETERS ----------------------------------------------------------------------------------------------------------------------------------------------
source "INPUT_sec.tcl"; # Sources the user defined file INPUT_sec.tcl which contains section defintions based on parameters defined above
puts "SECTIONS OK"

source "TRANSF.tcl"; # Sources the user defined file TRANSF.tcl which contains geometric transformation definitions
puts "TRANSFORMATIONS OK"

if {$pushDir == "EW"} {
	source "INPUT_elem_EW.tcl";
} elseif {$pushDir == "NS"} {
	source "INPUT_elem_NS.tcl"
}
puts "ELEMENTS OK"

# GRAVITY ANALYSIS --------------------------------------------------------------------------
source "GRAVITY.tcl"
puts "MODEL SET UP"

# PUSHOVER ANALYSIS --------------------------------------------------------------------------


source "PO.tcl"


# End of Analysis
close $ExportID
wipe;