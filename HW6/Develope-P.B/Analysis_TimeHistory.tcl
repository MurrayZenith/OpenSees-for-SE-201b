# ###################################################################################################################################################################################################
# ########################################################################### DATA PROCESSING FOR GROUND MOTION INPUT FILES #########################################################################
# ###################################################################################################################################################################################################


set GMdirectionX 1;			# ground-motion direction in global coordinates
set GMdirectionY 2;			# ground-motion direction in global coordinates

set GMfileX "GM_X.txt";		# GM input filename in X direction
set GMfileY "GM_Y.txt";		# GM input filename in Y direction

set GMfactX 1.;				# GM scaling factor in X direction
set GMfactY 1.;				# GM scaling factor in Y direction

# Read ground-motion-analysis parameters
set dataX [open $GMfileX "r"];
set dataY [open $GMfileY "r"];

set GMDataAllX [read $dataX]; 
set GMDataAllY [read $dataY];

close $dataX;
close $dataY;
# file read as 0 for 1st line
set NPTS_X [lindex $GMDataAllX 0]; 
set NPTS_Y [lindex $GMDataAllY 0];

set NPTS [expr min($NPTS_X,$NPTS_Y)]; # number of ground acceleration data points

set dtX [lindex $GMDataAllX 1]; 
set dtY [lindex $GMDataAllY 1];
set dt $dtX;	#dt_recorded

set gAccXFile [open "gAccX.txt" "w"];
set gmfileNameX "gAccX.txt";
for {set i 1} {$i <= $NPTS} {incr i} {
puts $gAccXFile [expr [lindex $GMDataAllX [expr $i + 1]]];
}
close $gAccXFile

set gAccYFile [open "gAccY.txt" "w"];
set gmfileNameY "gAccY.txt";
for {set i 1} {$i <= $NPTS} {incr i} {
puts $gAccYFile [expr [lindex $GMDataAllY [expr $i + 1]]];
}
close $gAccYFile


set DtAnalysis	   		[expr $dt/0.5];	# time-step Dt for lateral analysis
set TmaxAnalysis	 	[expr $dt*$NPTS]; # duration of earthquake

# ###################################################################################################################################################################################################
# ############################################################################### ASSIGN DAMPING ####################################################################################################
# ###################################################################################################################################################################################################

# this damping method is guided by Note of 201b

if {$DoModalAnalysis == "Yes"} {
	set w1 [lindex $omega 0];	# omega heir from Analysis_Modal
	set w2 [lindex $omega 3];
} else {
	source "Analysis_Modal.tcl";
	puts "Modal Analysis Results Post - Gravity"
	puts "-----------------------------------------"
	for {set i 1} {$i <= $modes} {incr i 1} {
		puts "T$i = [lindex $T [expr $i-1]]";
	}
	set w1 [lindex $omega 0];
	set w2 [lindex $omega 3];
}

# define DAMPING
# D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set ksi 0.025; # 2.5% damping ratio
set alphaM    [expr 2.*$ksi*$w1*$w2/($w1+$w2)];	
set betaKinit [expr 2.*$ksi/($w1+$w2)];         
set betaKcurr 0.0; 			
set betaKcomm 0.0;
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm


#  Set up timeSeries and UniformExcitation patterns
set TSTagX 1;
set TSTagY 2;

timeSeries Path $TSTagX -dt $dt -filePath "gAccX.txt" -factor [expr $g*$GMfactX];
timeSeries Path $TSTagY -dt $dt -filePath "gAccY.txt" -factor [expr $g*$GMfactY];

set IDloadTag_TH_X 2;	# LoadTag for Uniform ground motion excitation
set IDloadTag_TH_Y 3;	# LoadTag for Uniform ground motion excitation

pattern UniformExcitation  $IDloadTag_TH_X  $GMdirectionX -accel  $TSTagX;		# create Uniform excitation
pattern UniformExcitation  $IDloadTag_TH_Y  $GMdirectionY -accel  $TSTagY;		# create Uniform excitation



# ###################################################################################################################################################################################################
# ############################################################################### SET ANALYSIS PARAMETERS ###########################################################################################
# ###################################################################################################################################################################################################

set NewmarkGamma 0.50;	# Newmark-integrator gamma parameter (also HHT)
set NewmarkBeta  0.25;	# Newmark-integrator beta parameter
set TolDynamic 1.e-6;  
set maxNumIterDynamic 200; 

constraints Transformation; #Transformation
numberer Plain
system BandGeneral;	
test EnergyIncr $TolDynamic $maxNumIterDynamic 0;
algorithm Newton; 
integrator Newmark $NewmarkGamma $NewmarkBeta
analysis Transient


# ###############################################################################################################################################################################
# #########################################################################  SOURCE RECORDERS  ##################################################################################
# ###############################################################################################################################################################################

source "RECORDERS_dyn.tcl";
puts "Recorders OK"



# ###############################################################################################################################################################################
# ############################################################################  DISPLAY MODEL  ##################################################################################
# ###############################################################################################################################################################################

#display displaced shape of the building
recorder display "Displaced shape" 10 10 500 500 -wipe

prp 0 -100 [expr $buildingHeight/2];
vup  0 0 1;
vpn  0 -1 0;
display 10 0 50

# ###################################################################################################################################################################################################
# ############################################################################### RUN ANALYSIS ######################################################################################################
# ###################################################################################################################################################################################################

set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)];

set tCurrent [getTime];
set ok 0;
while {$ok == 0 && $tCurrent <= $TmaxAnalysis} {
	set ok [analyze 1 $DtAnalysis];
	if {$ok == 0} { puts " TIME: $tCurrent >> CONVERGED" }
	set tCurrent [getTime];
	if {$ok != 0} {
		puts "Test Relative Force"
		test RelativeNormUnbalance $TolDynamic $maxNumIterDynamic 0;
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Test Relative Displacement"
		test RelativeNormDispIncr $TolDynamic $maxNumIterDynamic 0;
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "ModifiedNewton"
		algorithm ModifiedNewton
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Test Relative Energy"
		algorithm Newton -initial;
		test RelativeEnergyIncr $TolDynamic $maxNumIterDynamic 0;
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Newton Modified -initial"
		test RelativeEnergyIncr $TolDynamic $maxNumIterDynamic
		algorithm ModifiedNewton -initial
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Test Relative Force"
		algorithm Newton -initial;
		test RelativeNormUnbalance $TolDynamic $maxNumIterDynamic 0
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Test Relative Displ"
		test RelativeNormDispIncr $TolDynamic $maxNumIterDynamic 0
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Broyden"
		algorithm Broyden 8
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "Newton Line Search"
		algorithm NewtonLineSearch .8
		set ok [analyze 1 $DtAnalysis];
	};
	if {$ok != 0} {
		puts "BFGS"
		algorithm BFGS
		set ok [analyze 1 $DtAnalysis];
	};
}


puts "Time-history response analysis complete"
