set lat 1.0;# totol horizontal force 

if {$pushDir == "EW"} {

	set patternTagPush 501;
	set controlDOF 1;
	
	pattern Plain $patternTagPush "Linear" {
		# Apply inverted triangular lateral loads for each floor on wall 2 at the top node (for that floor) along +x direction.
		# Make sure that the loads for each floor sum up to 1; (YOU WILL SEE THE BENEFIT OF THIS LATER)
		load 1201 [expr 1.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 2201 [expr 2.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 3201 [expr 3.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 4201 [expr 4.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 5201 [expr 5.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 6201 [expr 6.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 7201 [expr 7.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 8201 [expr 8.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 9201 [expr 9.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;
		load 10201 [expr 10.0/55*$lat] 0.0 0.0 0.0 0.0 0.0;

	};
	
	
	
} elseif {$pushDir == "NS"} {
	
	set patternTagPush 502;
	set controlDOF 2;
	
	pattern Plain $patternTagPush "Linear" {
		# Apply inverted triangular lateral loads for each floor on both walls at the top node (for that floor) along +y direction.
		# Make sure that the loads for each floor sum up to 1/2 for one wall; (YOU WILL SEE THE BENEFIT OF THIS LATER)
		load 1101  0.0 [expr 0.5*1.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 2101  0.0 [expr 0.5*2.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 3101  0.0 [expr 0.5*3.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 4101  0.0 [expr 0.5*4.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 5101  0.0 [expr 0.5*5.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 6101  0.0 [expr 0.5*6.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 7101  0.0 [expr 0.5*7.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 8101  0.0 [expr 0.5*8.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 9101  0.0 [expr 0.5*9.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 10101 0.0 [expr 0.5*10.0/55*$lat]	0.0 0.0 0.0 0.0 ;

		load 1201  0.0 [expr 0.5*1.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 2201  0.0 [expr 0.5*2.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 3201  0.0 [expr 0.5*3.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 4201  0.0 [expr 0.5*4.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 5201  0.0 [expr 0.5*5.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 6201  0.0 [expr 0.5*6.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 7201  0.0 [expr 0.5*7.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 8201  0.0 [expr 0.5*8.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 9201  0.0 [expr 0.5*9.0/55*$lat] 	0.0 0.0 0.0 0.0 ;
		load 10201 0.0 [expr 0.5*10.0/55*$lat]	0.0 0.0 0.0 0.0 ;
	};
	
	
}


set displacementIncrement 1.0;# in
set maximumDisplacement [expr 17.04*3];# 17.04 is 1% of (16+14*9)*12
set NSteps [expr int(abs($maximumDisplacement/$displacementIncrement))] ; 

# Define analysis parameters (Fill in the blanks)
# integrator DisplacementControl $node $dof $incr <$numIter $ΔUmin $ΔUmax> 
set Tol 1.0e-6
integrator DisplacementControl 10201 $controlDOF $displacementIncrement; # See OpenSees Wiki
system BandGeneral;
test NormDispIncr $Tol 500;
numberer Plain;
constraints Plain;
algorithm Newton;
analysis Static;



# DISPLAY DISPLACEMENT SHAPE OF THE BUILDING IN OPENSEES DURING ANALYSIS (only works in Windows)
# Don't confuse this with the MATLAB code I provided for plotting deflected shape. The MATLAB code will work for all.
# We'll talk more about this later.
# --------------------------------------------------------------------------------------------------------------------------------
set scale 50; 
recorder display "Displaced shape" 10 10 500 500 -wipe; #x,y location of the window & pixels
prp 0. 0. 850.; #Projector reference point
#Next, we have to define view-up (vup) vector and view-plane normal (vpn) vector. 
#They are (0,1,0) and (0,0,1), respectively. 
#Finally, we use display command to display the deflected shapes. The first argument following the command specifies the type of response to be plotted.
#The second argument following display command is magnification factor for nodes and the third argument is magnification factor for the response quantity to be displayed.
vup 0 0 1; # dirn defining up direction of view plane
if {$pushDir == "EW"} {
vpn 0 -1 0; # direction of outward normal to view plane
} elseif {$pushDir == "NS"} {
vpn -1 0 0; # direction of outward normal to view plane
}
display 1 5 $scale;
# ----------------------------------------------------------------------------------------------------------------------------------


# GENERATE RECORDERS FOR ANALYSIS ---------------------------------------------------------------------------------------------------
# should be before analyze command
source RECORD.tcl
puts "OUTPUT SET-UP OK"


set ok [analyze $NSteps];


if { $ok !=0 } {
   puts "FAILED TO CONVERGE!!" 
} else {
   puts "";
   puts "ALL SUCCESSFUL!!"
}
