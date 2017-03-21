
# WALL SECTION --------------------------------------------------------------------------



#           ____________
#          |  __________|
#          | |    ^ y    
#          | |    |    
#          | |    |    
#          z <----o    
#          | |           
#          | |           
#          | |__________ 
#          |____________|
#          





# local y-z axis defined for C - wall section (left wall)
set AWall 	[expr 8000.0*$in2];
set IyWall 	[expr 17131457.004*$in4];
set IzWall 	[expr 68726186.138*$in4];
set JWall [expr 641379.*$in4]; # from SAP2000
set JBeam [expr 701.83*$in4];


# WALL SECTION --------------------------------------------------------------------------

# if {$eleTypeWall == "dispBeamColumn"} {
# 	set secTagWall 1
# 	section Elastic $secTagWall $Ec $AWall $IzWall $IyWall $Gc $JWall
# }
set secTagWall 1
# section Fiber secTag <-GJ > {}
section Fiber $secTagWall -GJ [expr $Gc*$JWall] {
    # Create the concrete fibers
    # Area Orange
    set z_dim [expr 148.0 - $C_dim2 - 16.0]
    #patch	rect	$matTag				$numSubdivY		$numSubdivZ	$yI		$zI			$yJ			$zJ              
    patch   rect	$UConcMatTagWall	60				5			-102.0	$z_dim		102.0		[expr $z_dim+16.0]
    puts $ExportID "patch   rect	$UConcMatTagWall	60				5			-102.0	$z_dim		102.0		[expr $z_dim+16.0]"
    # Area Blue
    patch   rect	$UConcMatTagWall	5				30			-118.00	[expr -$C_dim2+25.75]	-102.0	[expr $z_dim+16.0]
    puts $ExportID "patch   rect	$UConcMatTagWall	5				30			-118.00	[expr -$C_dim2+25.75]	-102.0	[expr $z_dim+16.0]"
    patch   rect	$UConcMatTagWall	5				30			102.0	[expr -$C_dim2+25.75]	118.0	[expr $z_dim+16.0]
    puts $ExportID "patch   rect	$UConcMatTagWall	5				30			102.0	[expr -$C_dim2+25.75]	118.0	[expr $z_dim+16.0]"    
	# Area Yellow
	patch   rect	$UConcMatTagWall	2				5			-118.00	[expr -$C_dim2+1.75]	-116.25	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	2				5			-118.00	[expr -$C_dim2+1.75]	-116.25	[expr -$C_dim2+25.75]"
	patch   rect	$UConcMatTagWall	2				5			-103.75	[expr -$C_dim2+1.75]	-102.0	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	2				5			-103.75	[expr -$C_dim2+1.75]	-102.0	[expr -$C_dim2+25.75]"
	patch   rect	$UConcMatTagWall	2				5			102.0	[expr -$C_dim2+1.75]	103.75	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	2				5			102.0	[expr -$C_dim2+1.75]	103.75	[expr -$C_dim2+25.75]"
	patch   rect	$UConcMatTagWall	2				5			116.25	[expr -$C_dim2+1.75]	118.00	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	2				5			116.25	[expr -$C_dim2+1.75]	118.00	[expr -$C_dim2+25.75]"
	# Area purper
	patch   rect	$UConcMatTagWall	5				2			-118.00	-$C_dim2	-102.0	[expr -$C_dim2+1.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	5				2			-118.00	-$C_dim2	-102.0	[expr -$C_dim2+1.75]"
	patch   rect	$UConcMatTagWall	5				2			102.0	-$C_dim2	118.00	[expr -$C_dim2+1.75]
	puts $ExportID "patch   rect	$UConcMatTagWall	5				2			102.0	-$C_dim2	118.00	[expr -$C_dim2+1.75]"
	# Area Green Confined
	patch   rect	$CConcMatTagWall	3				5			-116.25	[expr -$C_dim2+1.75]	-103.75	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$CConcMatTagWall	3				5			-116.25	[expr -$C_dim2+1.75]	-103.75	[expr -$C_dim2+25.75]"
	patch   rect	$CConcMatTagWall	3				5			103.75	[expr -$C_dim2+1.75]	116.25	[expr -$C_dim2+25.75]
	puts $ExportID "patch   rect	$CConcMatTagWall	3				5			103.75	[expr -$C_dim2+1.75]	116.25	[expr -$C_dim2+25.75]"

    # Create the reinforcing fibers
    # layer straight $matTag $numFiber $areaFiber 			$yStart $zStart 				$yEnd 	$zEnd 
	layer straight $StelMatTag 11		[expr 2*0.79]		-110.0	[expr -$C_dim2+1.75]	-110.0	[expr $z_dim+14.25]
	layer straight $StelMatTag 11		[expr 2*0.79]		110.0	[expr -$C_dim2+1.75]	110.0	[expr $z_dim+14.25]

	layer straight $StelMatTag 9		[expr 2*0.79]		-102.0	[expr $z_dim+8.0]		102.0	[expr $z_dim+8.0]
	# #fiber	$yLoc	$zLoc	$A	$matTag
 	# fiber	$yLoc $zLoc $A $StelMatTag
}

# COUPLING BEAM SECTION --------------------------------------------------------------------------
set ABeam [expr 48.*16.*$in2];
set ATruss [expr 0.362*$ABeam];
# 0.362*48.*16 = 278.02
set secTagBeam 2
# define 2D for this due to no torsion here
section Fiber $secTagBeam {
	# Concrete02
	# patch   rect	$ConcMatTagBeam	1		1			-116.25	[expr -$C_dim2+1.75]	-103.75	[expr -$C_dim2+25.75]
	#fiber	$yLoc	$zLoc	$A			$matTag
	fiber	0.0 	0.0 	$ATruss		$ConcMatTagBeam
	fiber	0.0 	0.0 	[expr 4*0.6]	$StelMatTag
}

# RIGID LINK SECTION PROPERTIES --------------------------------------------------------------------------
set ARigid [expr 1e10];
set JRigid [expr 1e10];
set IyRigid [expr 1e10];
set IzRigid [expr 1e10];