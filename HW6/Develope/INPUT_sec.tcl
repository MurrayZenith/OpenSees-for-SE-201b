
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


# COUPLING BEAM SECTION --------------------------------------------------------------------------
set ABeam [expr 48.*16.*$in2];
set ATruss [expr 0.362*$ABeam];


# RIGID LINK SECTION PROPERTIES --------------------------------------------------------------------------
set ARigid [expr 1e10];
set JRigid [expr 1e10];
set IyRigid [expr 1e10];
set IzRigid [expr 1e10];