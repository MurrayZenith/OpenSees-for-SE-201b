set nStory 10;
set nEleFloor 1;

set Nodes {}; # This will be used to store all nodeTags created. This is useful if displacement recorders for all nodes are to be set in order to plot deflected shapes.

# ##########################################################
# Define Base Nodes
# ##########################################################
set C_dim1 110.0;
set C_dim2 100.928;
set C_dim3 5.5;
set C_dim4 37.0;
set C_dim6 128.0;
set C_dim5 [expr $C_dim2*2+$C_dim6];


#node $nodeTag (ndm $coords)
node 1100 0.0 0.0 0.0; #Wall 1
node 1200 $C_dim5 0.0 0.0; #Wall 2

# Append Node Tags (only) to the list 'Nodes'
lappend Nodes 1100;
lappend Nodes 1200;

# write node definition command line to 'modelData.txt'
puts $ExportID "node 1100 0.0 0.0 0.0;"
puts $ExportID "node 1200 $C_dim5 0.0 0.0;"

# ##########################################################
# Add Boundary Conditions	
# ##########################################################

# fix $nodeTag (ndf $constrValues)
fix 1100 1 1 1 1 1 1
fix 1200 1 1 1 1 1 1

# ##########################################################
# Define all other nodes
# ##########################################################

# Loop over number of stories (nStory)
for {set i 1} {$i <= $nStory} {incr i 1} {

	# ##########################################################
	# Nodes for Walls 
	# ##########################################################

	# Loop over number of elements per floor (nEleFloor)
	for {set j 1} {$j <= $nEleFloor} {incr j 1} {
		
	
	# Add nodes for both walls, append node Tags to 'Nodes', and write command line to File
	
	# node $nodeTag (ndm $coords)
	
	# lappend Nodes $nodeTag
	
	# puts $ExportID "node $nodeTag (ndm $coords)"
	set height [expr 16*$ft+14*$ft*($i-1)];

	node [expr 1000*$i+100+$j] 0.0 0.0 $height;		
	node [expr 1000*$i+200+$j] $C_dim5 0.0 $height;		
		
	lappend Nodes [expr 1000*$i+100+$j];
	lappend Nodes [expr 1000*$i+200+$j];

	puts $ExportID "node [expr 1000*$i+100+$j] 0.0 0.0 $height;"
	puts $ExportID "node [expr 1000*$i+200+$j] $C_dim5 0.0 $height;"
		
	# ##########################################################
	# C - section Nodes
	# ##########################################################

	# Add nodes to define the C - section for story 'i' for both walls, append node Tags to 'Nodes', and write command line to File 
	node [expr 1000*$i+100+$j+1] 0.0 $C_dim1 $height;
	node [expr 1000*$i+100+$j+2] 0.0 -$C_dim1 $height;
	node [expr 1000*$i+100+$j+3] $C_dim2 $C_dim1 $height;
	node [expr 1000*$i+100+$j+4] $C_dim2 -$C_dim1 $height;
	node [expr 1000*$i+100+$j+5] $C_dim2 $C_dim1 [expr $height-$C_dim3];
	node [expr 1000*$i+100+$j+6] $C_dim2 -$C_dim1 [expr $height-$C_dim3];
	node [expr 1000*$i+100+$j+7] $C_dim2 $C_dim1 [expr $height-$C_dim3-$C_dim4];
	node [expr 1000*$i+100+$j+8] $C_dim2 -$C_dim1 [expr $height-$C_dim3-$C_dim4];

	lappend Nodes [expr 1000*$i+100+$j+1] ;
	lappend Nodes [expr 1000*$i+100+$j+2] ;
	lappend Nodes [expr 1000*$i+100+$j+3] ;
	lappend Nodes [expr 1000*$i+100+$j+4] ;
	lappend Nodes [expr 1000*$i+100+$j+5] ;
	lappend Nodes [expr 1000*$i+100+$j+6] ;
	lappend Nodes [expr 1000*$i+100+$j+7] ;
	lappend Nodes [expr 1000*$i+100+$j+8] ;

	puts $ExportID "node [expr 1000*$i+100+$j+1] 0.0 $C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+100+$j+2] 0.0 -$C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+100+$j+3] $C_dim2 $C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+100+$j+4] $C_dim2 -$C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+100+$j+5] $C_dim2 $C_dim1 [expr $height-$C_dim3];"
	puts $ExportID "node [expr 1000*$i+100+$j+6] $C_dim2 -$C_dim1 [expr $height-$C_dim3];"
	puts $ExportID "node [expr 1000*$i+100+$j+7] $C_dim2 $C_dim1 [expr $height-$C_dim3-$C_dim4];"
	puts $ExportID "node [expr 1000*$i+100+$j+8] $C_dim2 -$C_dim1 [expr $height-$C_dim3-$C_dim4];"

	node [expr 1000*$i+200+$j+1] $C_dim5 $C_dim1 $height;
	node [expr 1000*$i+200+$j+2] $C_dim5 -$C_dim1 $height;
	node [expr 1000*$i+200+$j+3] [expr $C_dim5-$C_dim2] $C_dim1 $height;
	node [expr 1000*$i+200+$j+4] [expr $C_dim5-$C_dim2] -$C_dim1 $height;
	node [expr 1000*$i+200+$j+5] [expr $C_dim5-$C_dim2] $C_dim1 [expr $height-$C_dim3];
	node [expr 1000*$i+200+$j+6] [expr $C_dim5-$C_dim2] -$C_dim1 [expr $height-$C_dim3];
	node [expr 1000*$i+200+$j+7] [expr $C_dim5-$C_dim2] $C_dim1 [expr $height-$C_dim3-$C_dim4];
	node [expr 1000*$i+200+$j+8] [expr $C_dim5-$C_dim2] -$C_dim1 [expr $height-$C_dim3-$C_dim4];

	lappend Nodes [expr 1000*$i+200+$j+1] ;
	lappend Nodes [expr 1000*$i+200+$j+2] ;
	lappend Nodes [expr 1000*$i+200+$j+3] ;
	lappend Nodes [expr 1000*$i+200+$j+4] ;
	lappend Nodes [expr 1000*$i+200+$j+5] ;
	lappend Nodes [expr 1000*$i+200+$j+6] ;
	lappend Nodes [expr 1000*$i+200+$j+7] ;
	lappend Nodes [expr 1000*$i+200+$j+8] ;

	puts $ExportID "node [expr 1000*$i+200+$j+1] $C_dim5 $C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+200+$j+2] $C_dim5 -$C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+200+$j+3] [expr $C_dim5-$C_dim2] $C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+200+$j+4] [expr $C_dim5-$C_dim2] -$C_dim1 $height;"
	puts $ExportID "node [expr 1000*$i+200+$j+5] [expr $C_dim5-$C_dim2] $C_dim1 [expr $height-$C_dim3];"
	puts $ExportID "node [expr 1000*$i+200+$j+6] [expr $C_dim5-$C_dim2] -$C_dim1 [expr $height-$C_dim3];"
	puts $ExportID "node [expr 1000*$i+200+$j+7] [expr $C_dim5-$C_dim2] $C_dim1 [expr $height-$C_dim3-$C_dim4];"
	puts $ExportID "node [expr 1000*$i+200+$j+8] [expr $C_dim5-$C_dim2] -$C_dim1 [expr $height-$C_dim3-$C_dim4];"
	}
}

