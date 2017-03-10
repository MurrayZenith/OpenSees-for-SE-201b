#  Monotonic Moment Curvatue analysis file for SE 201B
# Units MPa mm s

# set recording file and system initialize
set Flag 1;
set fileID [open "Monotonic_a.3.txt"  "w"]; #this command is used to write an output file
set criterion -0.003; #when the maximum compressed fiber reaches this value, the section fails 

# AXIAL LOAD ANALYSIS (FORCE-CONTROLLED)
set P [expr 0]; # Based on axial load ratio given in question statement

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


  
# load apllied  
pattern Plain 1 "Constant" {
	load 2 -$P 0.0 0.0
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

# set time back to 0
loadConst -time 0.0  
  
# MONOTONIC MOMENT CURVATURE ANALYSIS (DISPLACEMENT-CONTROLLED)
set Kyestimate [expr (445/215e3 + 0.003)/($colDepth-$cover)];	# Estimate of the yield curvature for balanced section
set du [expr 0.02*$Kyestimate];			# Rotation (or curvature) increment to be set to 2% of estimated yield curvature (i.e. 0.02*$Kyestimate)
set Umax [expr 0.03/400];		# Given in question statement (max curvature to be imposed)
set NSteps [expr $Umax/$du];				





# Define reference load pattern
pattern Plain 2 "Linear" {
	load 2 0.0 0.0 1.0
}

set controlNode 2
set controlDOF 3

# integrator DisplacementControl $node $dof $incr
  integrator DisplacementControl $controlNode $controlDOF $du;


# set analysis parameters ***********************(test and algorithm defined later)*****************************
system ProfileSPD 
numberer Plain
constraints Plain
analysis Static

set ok 0;
set step 1;
set currentDisp 0.; # This is the current value of the displacement at the control DOF.


# Perform the analysis one step at a time.
# This is done so that alternative analysis algorithms and test options can be included in case the analysis fails.

while {$ok == 0 && $step <= $NSteps} {
	
	test EnergyIncr $tol $iter;
	algorithm Newton;
	set ok [analyze 1];
	
	# This list of alternative analysis options is not all-inclusive. You can add more to it.
	if {$ok != 0} {
		puts "Test Relative Force"
		test RelativeNormUnbalance $tol $iter 0;
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
		test RelativeEnergyIncr $tol $iter
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
	
	set step [expr $step + 1];
	set moment [getTime];
	set currentDisp [nodeDisp $controlNode $controlDOF];
	puts "Current Displ. at Control DOF = $currentDisp"

	# write results to file
	puts -nonewline $fileID "\n";    # go to new line in output file 
	set data "$currentDisp		$moment"
	puts -nonewline $fileID $data ;  # write data to file 

}

# spit out a SUCCESS or FAILURE message
if {$ok == 0} {
  puts "Analysis completed SUCCESSFULLY!";
} else {
  puts "Analysis FAILED!";
}

wipe;