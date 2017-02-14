# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2017)
# HW3 
wipe; 

# Define the model builder, ndm=#dimension, ndf=#dofs
model BasicBuilder -ndm 3 -ndf 6;

# SETUP DATA DIRECTORY FOR SAVING OUTPUTS --------------------------------------------
set dataDir "Results";	# Set up name of data directory
file mkdir $dataDir; # Create data directory

source UNITS.tcl;

# DEFINE NODES -----------------------------------------------------------------------
set Lx [expr 24.0*$ft];
set Ly [expr 15.0*$ft];
set Lz [expr 18.0*$ft];

#node $nodeTag (ndm $coords) <-mass (ndf $massValues)>
node 1	0.0	0.0	$Lz;
node 2	$Lx	0.0	$Lz;
node 3	$Lx	0.0	0.0;
node 4	0.0	0.0	0.0;
node 5	0.0	$Ly	$Lz;
node 6	$Lx	$Ly	$Lz;
node 7	$Lx	$Ly	0.0;
node 8	0.0	$Ly	0.0;
