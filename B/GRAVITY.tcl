#GRAVITY ANALYSIS

set patternTagGravity 500;

pattern Plain $patternTagGravity "Constant" {
	# Apply gravity loads for each floor on each wall at the top node (for that floor)
	set botfloorload [expr 181.8*$kip]
	load 1101 0.0 0.0 -$botfloorload 0.0 0.0 0.0;
	load 1201 0.0 0.0 -$botfloorload 0.0 0.0 0.0;


	set midfloorload [expr 173.5*$kip]
	for {set i 2} {$i <= 9} {incr i 1} {
	load [expr 1000*$i+100+1] 0.0 0.0 -$midfloorload 0.0 0.0 0.0;
	load [expr 1000*$i+200+1] 0.0 0.0 -$midfloorload 0.0 0.0 0.0;
	}
	

	set topfloorload [expr 139.4*$kip]
	load 10101 0.0 0.0 -$topfloorload 0.0 0.0 0.0;
	load 10201 0.0 0.0 -$topfloorload 0.0 0.0 0.0;
}

# Define analysis parameters (Fill in the blanks)
set Tol 1.0e-6;# convergence tolerance for test
integrator LoadControl 1;
system BandGeneral;
test NormDispIncr $Tol 100;
numberer Plain;
constraints Plain;
algorithm Newton;
analysis Static;
set ok [analyze 1];

if {$ok != 0}  {
	puts "NOT CONVERGED for Gravity.";
	puts "============================";
} else {
	puts "GRAVITY ANALYSIS DONE!!";
	puts "=========================";
}


loadConst -time 0.0; # Resets pseudo time to zero. Ready to start Pushover Analysis with t = 0.