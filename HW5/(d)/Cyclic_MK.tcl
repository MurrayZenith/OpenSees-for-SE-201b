#  Cyclic Moment Curvatue analysis example for SE 201B

# set fileID [open "Cyclic.txt"  "w"]; #this command is used to write an output file
set criterion -0.003; #when the maximum compressed fiber reaches this value, the section fails 

# Source Model File(s) containing Nodes, Boundary Conditions, Materials, Sections, and zeroLengthSection element definitions.

# divide layers
set divlayAC	20	 
set divlayB		5
model basic -ndm 2 -ndf 3

# ------ Define two nodes at (0,0)
node 1 0.0 0.0
node 2 0.0 0.0


# ------ Fix all degrees of freedom except axial and bending
fix 1 1 1 1
fix 2 0 1 0

# ------ Material Properties
# Reinforcing steel
# set fy  455.0;      # Yield stress
# set E   215.0e3;    # Young's modulus
# Unconfined Concrete
set f_c     -32.5
set E_c     27.0e3
set eps_c   [expr 2*$f_c/$E_c]
set f_t     1.9
# Confined Concrete
set f_cc    -47.9
set eps_cc  [expr 2*$f_cc/$E_c]

# ---------- Generate  materials
set cfconcrete    1
set uncfconcrete  2
set steel         3
# Core concrete:
# uniaxialMaterial Concrete02 $matTag        $fpc  $epsc0  $fpcu             $epsU   $lambda $ft   $Ets 
  uniaxialMaterial Concrete02 $cfconcrete    $f_cc $eps_cc [expr 0.85*$f_cc] -0.0276 0.25    $f_t  [expr 0.1*$E_c]

# Cover concrete (unconfined):
# uniaxialMaterial Concrete02 $matTag        $fpc  $epsc0  $fpcu             $epsU   $lambda $ft   $Ets 
  uniaxialMaterial Concrete02 $uncfconcrete  $f_c  $eps_c  [expr 0.20*$f_c]  -0.004  0.25    $f_t  [expr 0.1*$E_c]

# Reinforcing steel
# uniaxialMaterial Steel02    $matTag   $Fy   $E0       $b   $R0  $cR1  $cR2 <$a1 $a2 $a3 $a4 $sigInit> 
  uniaxialMaterial Steel02    $steel    455.0 215.0e3   0.01 20   0.925 0.15 0.0 1.0 0.0 1.0

# ---------- Section Properties
# Cross-section dimensions
set colWidth  400.0;
set colDepth  400.0;
set cover     40.0; # for the section given in fig.1.(b)
# Define steel parameters
set As    314.16;  # area of long bars


#  -------------- Define fiber section:
set y1 [expr $colDepth/2.0];
set z1 [expr $colWidth/2.0];

section Fiber 1 {
    # Create the concrete core fibers
    # Area C
    #patch  rect $matTag      $numSubdivY   $numSubdivZ  $yI               $zI               $yJ               $zJ              
    patch   rect $cfconcrete  $divlayAC     1            [expr $cover-$y1] [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover]

    # Create the concrete cover fibers (top, bottom, left, right)
    # Area A
    patch rect $uncfconcrete $divlayAC 1  [expr $cover-$y1] [expr -$z1]       [expr $y1-$cover] [expr $cover-$z1]
    patch rect $uncfconcrete $divlayAC 1  [expr $cover-$y1] [expr $z1-$cover] [expr $y1-$cover] [expr $z1]
    # Area B
    patch rect $uncfconcrete $divlayB 1  [expr -$y1]        [expr -$z1]       [expr $cover-$y1] $z1
    patch rect $uncfconcrete $divlayB 1  [expr $y1-$cover]  [expr -$z1]       $y1               $z1

    # Create the reinforcing fibers 
    layer straight $steel 3 $As [expr $y1-$cover] [expr $z1-$cover] [expr $y1-$cover] [expr $cover-$z1]
    layer straight $steel 2 $As 0.0               [expr $z1-$cover] 0.0               [expr $cover-$z1]
    layer straight $steel 3 $As [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
}


# ---------- Define element
# element zeroLengthSection $eleTag $iNode $jNode $secTag <-orient $x1 $x2 $x3 $yp1 $yp2 $yp3>
  element zeroLengthSection 1       1      2      1        -orient 1 0 0 0 1 0

# Also Source RECORDERS HERE !!!!!!!!!!!!!!!!!!!!!!
# recorder Element -file Cyclic_force.txt -time -ele 1 globalForce
# recorder Node -file Cyclic_disp.txt -time -node 2 -dof 3 disp
recorder Node -file Cyclic.txt -time -node 2 -dof 1 3 disp

# AXIAL LOAD ANALYSIS (FORCE-CONTROLLED)
set P [expr 0]; # Based on axial load ratio given in question statement
  
  
pattern Plain 1 "Constant" {
	load 2 $P 0.0 0.0
}


# set analysis parameters
set tol 1e-10;
set iter 2000;
integrator LoadControl 1.;
system ProfileSPD
test EnergyIncr $tol $iter 
numberer Plain
constraints Plain
algorithm Newton
analysis Static
set ok [analyze 1];			# 0: if successful, <0 if NOT successful	


if { $ok<0 } {
   puts "Unsuccessful convergence!" 
} else {
   puts "All Successful!"
}

loadConst -time 0.0  

# CYCLIC MOMENT CURVATURE ANALYSIS (DISPLACEMENT-CONTROLLED)
set cyclelabel {1 2 3 4 5 6 7 8 9 10}; # How many cycles.

set d1 [expr 0.000/$colDepth]; # Peak displacement of cycle 1 ------ Value of Kz, NOT Kz.H for Homework #5
set d2 [expr 0.005/$colDepth]; # Peak displacement of cycle 2 ------ Value of Kz, NOT Kz.H for Homework #5
set d3 [expr -0.005/$colDepth]; # Peak displacement of cycle 3 ------ Value of Kz, NOT Kz.H for Homework #5
set d4 [expr 0.010/$colDepth]; # Peak displacement of cycle 4 ------ Value of Kz, NOT Kz.H for Homework #5
set d5 [expr -0.010/$colDepth]; 
set d6 [expr 0.020/$colDepth]; 
set d7 [expr -0.020/$colDepth]; 
set d8 [expr 0.030/$colDepth]; 
set d9 [expr -0.030/$colDepth];
set d10 [expr 0.000/$colDepth];

set peakDisp {$d1 $d2 $d3 $d4 $d5 $d6 $d7 $d8 $d9 $d10}; #peak displacement of control DOF for each cycle

set Kyestimate [expr (445/215e3 + 0.003)/($colDepth-$cover)];	# Estimate of the yield curvature for balanced section
set du [expr 0.02*$Kyestimate];			# Rotation (or curvature) increment to be set to 2% of estimated yield curvature

# Define reference load pattern
pattern Plain 2 "Linear" {
	load 2 0.0 0.0 1.0
}

set controlNode 2
set controlDOF 3
set ok 0; 
set currentDisp 0.; # This is the current value of the displacement at the control DOF.

# Loop over the peak of cycles
for {set ii 1} {$ii<=[llength $peakDisp]} {incr ii} {
    # Convergence check
	if {$ok == 0} { 
		set cycleDisp [expr [lindex $peakDisp [expr $ii-1]] - $currentDisp]; # the total deformation of the loading cycle
		# determine the sign of loading:
		if {$cycleDisp>0} {
			set sign 1.;
		} else {
			set sign -1.;
		};
		set dU [expr $du*$sign];
		# General analysis properties
		constraints Plain;     			
		numberer Plain;			
		system BandGeneral;
		integrator DisplacementControl $controlNode $controlDOF $dU;
		test NormDispIncr $tol $iter;
		algorithm Newton;
		analysis Static;
		set NSteps [expr int(abs($cycleDisp/$dU))];
		puts "";
		puts "Starting Cycle # [lindex $cyclelabel [expr $ii-1]] with target displacement of [expr [lindex $peakDisp [expr $ii-1]]]"
		puts "======================================================"
		puts "---> Running $NSteps steps with step size = $dU mm to go from displ. = $currentDisp to displ. = [expr [lindex $peakDisp [expr $ii-1]]]"
		set ok1 [analyze $NSteps];
		set currentDisp [nodeDisp $controlNode $controlDOF];
		#If it does not converge, change strategies
		if {$ok1 !=0 } {
			set ok 0;
			puts "		Try stuff, peak disp = [expr [lindex $peakDisp [expr $ii-1]]]";
			puts "	    Current disp = $currentDisp";
			puts "		Cycle disp  = $cycleDisp";
			set counter 1;
			while {( ( ([expr $currentDisp] <= [expr [lindex $peakDisp [expr $ii-1]]]) && ($sign == 1)  ) || (  ([expr $currentDisp] >= [expr [lindex $peakDisp [expr $ii-1]]]) && ($sign == -1)   ) )&&($ok==0)} {
				set ok 1;
				while {$ok!=0} {
					if {$counter == 0} {
						# return to initial conditions
						set dU [expr $du*$sign*1.00];
						test NormDispIncr $tol $iter 0;
						set counter 1;
					} elseif {$counter == 1} {
						# increase load stepsize
						set dU [expr $du*$sign*1.5];
						puts "dU = $du*$sign*1.5 = $dU";
						set counter 2;
					} elseif {$counter == 2} {
						# increase load stepsize
						set dU [expr $du*$sign*2.00];
						puts "dU = $du*$sign*2.0 = $dU";
						set counter 3;
					} elseif {$counter == 3} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.5];
						puts "dU = $du*$sign*0.5 = $dU";
						set counter 4;
					} elseif {$counter == 4} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.1];
						puts "dU = $du*$sign*0.1 = $dU";
						set counter 5;
					} elseif {$counter == 5} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.05];
						puts "dU = $du*$sign*0.05 = $dU";
						set counter 6;
					} elseif {$counter == 6} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.01];
						puts "dU = $du*$sign*0.01 = $dU";
						set counter 7;
					} elseif {$counter == 7} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.001];
						puts "dU = $du*$sign*0.001 = $dU";
						set counter 8;
					};
					integrator DisplacementControl $controlNode  $controlDOF  $dU;
					set ok [analyze 1]
					if {$ok != 0} {
						puts "Try Newton Initial"
						algorithm Newton -initial
						test NormDispIncr $tol $iter 1;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Displacement"
						test RelativeNormDispIncr $tol $iter 0;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "ModifiedNewton"
						algorithm ModifiedNewton
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Energy"
						algorithm Newton -initial;
						test RelativeEnergyIncr $tol $iter 0;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Newton Modified -initial"
						algorithm ModifiedNewton -initial
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Force"
						algorithm Newton -initial;
						test RelativeNormUnbalance $tol $iter 0
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Displ"
						test RelativeNormDispIncr $tol $iter 0
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Broyden"
						algorithm Broyden 8
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Newton Line Search"
						algorithm NewtonLineSearch .8
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "BFGS"
						algorithm BFGS
						set ok [analyze 1];
					};
				};
				set counter 0;
				set currentDisp [nodeDisp $controlNode $controlDOF];
                puts $currentDisp
				# set moment [getTime];
				# set e1 [ nodeDisp 2  1]
				# set e3 [ nodeDisp 2  3]
				# set maxStrain [expr $e1-$e3*$colDepth/2.0]
				
				# # write results to file
    #         	puts -nonewline $fileID "\n";    # go to new line in output file 
				# set data "$currentDisp		$moment		$maxStrain"
				# puts -nonewline $fileID $data ;  # write data to file 

			};
			puts "Cycle # [lindex $cyclelabel [expr $ii-1]] successfully finished!"
			puts "target displ.  = [expr [lindex $peakDisp [expr $ii-1]]]"
			puts "current displ. = [nodeDisp $controlNode $controlDOF]"
			puts "---------------------------------x---------------------------------------";
		} else {
			puts "Cycle # [lindex $cyclelabel [expr $ii-1]] successfully finished!"
			puts "target displ.  = [expr [lindex $peakDisp [expr $ii-1]]]"
			puts "current displ. = [nodeDisp $controlNode $controlDOF]"
			puts "---------------------------------x---------------------------------------";
		};
	};
};
if { $ok<0 } {
   puts "FAILED TO CONVERGE!!" 
} else {
   puts "";
   puts "ALL SUCCESSFUL!!"
}
