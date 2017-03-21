
set Nodes {}; # This will be used to store all nodeTags created. This is useful if displacement recorders for all nodes are to be set in order to plot deflected shapes.

# Base Nodes ------------
node 1100 0. 0. 0.; #Wall 1
node 1200 $C_dim5 0. 0.; #Wall 2

lappend Nodes 1100 1200;

puts $ExportID "node 1100 0. 0. 0.;"
puts $ExportID "node 1200 $C_dim5 0. 0.;"


# Boundary Conditions -------------
fix 1100 1 1 1 1 1 1;
fix 1200 1 1 1 1 1 1;





# All other nodes -----------------------------------

set z 0.; # Current node height
for {set i 1} {$i <= $nStory} {incr i 1} {


	set H [lindex $storyH $i]; # H = storyH(i)
	
	# Wall nodes ------------------------------------------
	for {set j 1} {$j <= $nEleFloor} {incr j 1} {
		set z [expr $z + $H/$nEleFloor]; # z = z + H/nEleFloor
		node [expr 1000*$i + 100 + $j] 0. 0. $z; #Wall 1
		node [expr 1000*$i + 200 + $j] $C_dim5 0. $z; #Wall 2
		
		lappend Nodes [expr 1000*$i + 100 + $j];
		lappend Nodes [expr 1000*$i + 200 + $j];
		
		puts $ExportID "node [expr 1000*$i + 100 + $j] 0. 0. $z;"
		puts $ExportID "node [expr 1000*$i + 200 + $j] $C_dim5 0. $z;"
	}
	
	# Floor nodes ------------------------------------------
	# Wall 1
	node [expr 1000*$i + 100 + ($nEleFloor+1)] 0. $C_dim1 $z
	node [expr 1000*$i + 100 + ($nEleFloor+2)] 0. -$C_dim1 $z
	node [expr 1000*$i + 100 + ($nEleFloor+3)] $C_dim2 $C_dim1 $z 
	node [expr 1000*$i + 100 + ($nEleFloor+4)] $C_dim2 -$C_dim1 $z
	node [expr 1000*$i + 100 + ($nEleFloor+5)] $C_dim2 $C_dim1 [expr $z - $C_dim3]
	node [expr 1000*$i + 100 + ($nEleFloor+6)] $C_dim2 -$C_dim1 [expr $z - $C_dim3]
	node [expr 1000*$i + 100 + ($nEleFloor+7)] $C_dim2 $C_dim1 [expr $z - $C_dim3 - $C_dim4]
	node [expr 1000*$i + 100 + ($nEleFloor+8)] $C_dim2 -$C_dim1 [expr $z - $C_dim3 - $C_dim4]
	
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+1)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+2)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+3)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+4)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+5)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+6)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+7)]
	lappend Nodes [expr 1000*$i + 100 + ($nEleFloor+8)]
	
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+1)] 0. $C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+2)] 0. -$C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+3)] $C_dim2 $C_dim1 $z "
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+4)] $C_dim2 -$C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+5)] $C_dim2 $C_dim1 [expr $z - $C_dim3]"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+6)] $C_dim2 -$C_dim1 [expr $z - $C_dim3]"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+7)] $C_dim2 $C_dim1 [expr $z - $C_dim3 - $C_dim4]"
	puts $ExportID "node [expr 1000*$i + 100 + ($nEleFloor+8)] $C_dim2 -$C_dim1 [expr $z - $C_dim3 - $C_dim4]"
		
	
	# Wall 2
	node [expr 1000*$i + 200 + ($nEleFloor+1)] $C_dim5 $C_dim1 $z
	node [expr 1000*$i + 200 + ($nEleFloor+2)] $C_dim5 -$C_dim1 $z
	node [expr 1000*$i + 200 + ($nEleFloor+3)] [expr $C_dim5 - $C_dim2] $C_dim1 $z 
	node [expr 1000*$i + 200 + ($nEleFloor+4)] [expr $C_dim5 - $C_dim2] -$C_dim1 $z
	node [expr 1000*$i + 200 + ($nEleFloor+5)] [expr $C_dim5 - $C_dim2] $C_dim1 [expr $z - $C_dim3]
	node [expr 1000*$i + 200 + ($nEleFloor+6)] [expr $C_dim5 - $C_dim2] -$C_dim1 [expr $z - $C_dim3]
	node [expr 1000*$i + 200 + ($nEleFloor+7)] [expr $C_dim5 - $C_dim2] $C_dim1 [expr $z - $C_dim3 - $C_dim4]
	node [expr 1000*$i + 200 + ($nEleFloor+8)] [expr $C_dim5 - $C_dim2] -$C_dim1 [expr $z - $C_dim3 - $C_dim4]
	
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+1)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+2)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+3)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+4)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+5)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+6)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+7)]
	lappend Nodes [expr 1000*$i + 200 + ($nEleFloor+8)]
	
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+1)] $C_dim5 $C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+2)] $C_dim5 -$C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+3)] [expr $C_dim5 - $C_dim2] $C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+4)] [expr $C_dim5 - $C_dim2] -$C_dim1 $z"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+5)] [expr $C_dim5 - $C_dim2] $C_dim1 [expr $z - $C_dim3]"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+6)] [expr $C_dim5 - $C_dim2] -$C_dim1 [expr $z - $C_dim3]"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+7)] [expr $C_dim5 - $C_dim2] $C_dim1 [expr $z - $C_dim3 - $C_dim4]"
	puts $ExportID "node [expr 1000*$i + 200 + ($nEleFloor+8)] [expr $C_dim5 - $C_dim2] -$C_dim1 [expr $z - $C_dim3 - $C_dim4]"
		

}

