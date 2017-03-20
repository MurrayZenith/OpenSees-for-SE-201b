
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

if {$eleTypeWall == "dispBeamColumn"} {
	set secTagWall 1
	section Elastic $secTagWall $Ec $AWall $IzWall $IyWall $Gc $JWall
}

# section Fiber 1 {
#     # Create the concrete core fibers
#     # Area C
#     #patch  rect $matTag      $numSubdivY   $numSubdivZ  $yI               $zI               $yJ               $zJ              
#     patch   rect $cfconcrete  $divlayAC     1            [expr $cover-$y1] [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover]

#     # Create the concrete cover fibers (top, bottom, left, right)
#     # Area A
#     patch rect $uncfconcrete $divlayAC 1  [expr $cover-$y1] [expr -$z1]       [expr $y1-$cover] [expr $cover-$z1]
#     patch rect $uncfconcrete $divlayAC 1  [expr $cover-$y1] [expr $z1-$cover] [expr $y1-$cover] [expr $z1]
#     # Area B
#     patch rect $uncfconcrete $divlayB 1  [expr -$y1]        [expr -$z1]       [expr $cover-$y1] $z1
#     patch rect $uncfconcrete $divlayB 1  [expr $y1-$cover]  [expr -$z1]       $y1               $z1

#     # Create the reinforcing fibers 
#     layer straight $steel 3 $As [expr $y1-$cover] [expr $z1-$cover] [expr $y1-$cover] [expr $cover-$z1]
#     layer straight $steel 2 $As 0.0               [expr $z1-$cover] 0.0               [expr $cover-$z1]
#     layer straight $steel 3 $As [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
# }

# COUPLING BEAM SECTION --------------------------------------------------------------------------
set ABeam [expr 48.*16.*$in2];
set ATruss [expr 0.362*$ABeam];
# 0.362*48.*16 = 278.02

# RIGID LINK SECTION PROPERTIES --------------------------------------------------------------------------
set ARigid [expr 1e10];
set JRigid [expr 1e10];
set IyRigid [expr 1e10];
set IzRigid [expr 1e10];