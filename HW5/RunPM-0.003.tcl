#  P-M Interaction Diagram analysis example for SE 201B 
#  Feb. 6th 2008. Quan and Andre
#  Revised: Feb. 2012. Hamed Ebrahimian
#  Revised: Feb. 2015. Giovanni Montefusco
#  Revised: Feb. 2016. Angshuman Deb


# Units:   kips, in, s. 
# Example section shown in Tutorial Slides.


set Flag 1;
set fileID [open "PM_Results0.003.txt"  "w"]; #this command is used to write an output file
set criterion -0.003; #when the maximum compressed fiber reaches this value, the section fails 

# ---------- Section Properties
# Cross-section dimensions
set colWidth  400.0;
set colDepth  400.0;
set cover     40.0; # for the section given in fig.1.(b)

set divlayAC	20	 
set divlayB		5

# Define steel parameters
set As    314.16;  # area of long bars
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

# Reinforcing steel
set fy 455.0;      # Yield stress
set E 215.0e3;    # Young's modulus

# Define steel parameters
set d [expr $colDepth-$cover]; 
# Estimate approximate yield curvature
set epsy [expr $fy/$E];  # steel yield strain
set Ky [expr ($epsy + 0.003)/$d];
puts "Estimated yield curvature: $Ky"
set dK [expr 0.01*$Ky];


# ------------------ Estimate Pmax
set K0 1.0;   # confinement factor amplifying fc^prime

set P0 [expr 1.2*$K0*0.85*-$f_c*$colWidth*$colDepth+8*$fy*$As]; # Estimated Axial load Capacity
# ----- Define Parameters:
set P 0.0;    # initial axial load
set incrP [expr 1e-3*$P0]; # axial load increment

# ------------------ Loop over all axial loads
while { $Flag > 0  && $P <= $P0 }  {
	# ------------------ Read in Model.tcl file
	source Model.tcl

	# Get axial strain and curvature
	set e1 [ nodeDisp 2  1]; #get the centroid strain 
	set e3 [ nodeDisp 2  3]; #get the curvature

	set Flag  1;
	puts $e1
	if { abs($e1) >  abs($criterion) }  {
        # check if axial load is too big
        puts " Oops, axial force P is too big."
	    set Flag 0  ; # end the loop
	} else {
		
		# Use displacement control at node 2 for section analysis
		# integrator DisplacementControl $node $dof $incr
		integrator DisplacementControl $controlNode $controlDOF $dK;
		
		set maxStrain [expr $e1-$e3*$colDepth/2.0]; # compute extreme concrete fiber compressive strain (negative)
		
		set step 0  
			
		while  { abs($maxStrain) < abs($criterion) } {
			set ok [analyze 1]
			
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
			
			set step [expr $step+1] 
			set e1 [ nodeDisp 2  1]
			set e3 [ nodeDisp 2  3]
			set maxStrain [expr $e1-$e3*$colDepth/2.0]
		}
		
		set moment [getTime]; # this a trick.. the "time" is the loadstep which is set to 1.0 in model.tcl 
		puts "step: $step,  maxStrain: $maxStrain, Moment: $moment"
		
		# write results to file
		puts -nonewline $fileID "\n";    # go to new line in output file 
		set data "$P		$moment"
		puts -nonewline $fileID $data ;  # write data to file 
		
	}   ; # end of if (p is not too big)
	
	set P [expr $P + $incrP]; # update P
}; # end of while

close $fileID
puts "Done!"

 
 
 
 
 
 
 
 


