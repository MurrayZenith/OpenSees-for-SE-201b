# ##############################################################################################################################
# ###################################################### MODAL ANALYSIS ########################################################
# ##############################################################################################################################

set ModalAnalysisDirectory "Modal Analysis";
set ModeShapePreGravDirectory "Pre-gravity"
set ModeShapePostGravDirectory "Post-gravity"

file mkdir $ModalAnalysisDirectory/$ModeShapePreGravDirectory
file mkdir $ModalAnalysisDirectory/$ModeShapePostGravDirectory

set omega {};
set F {};
set T {};
set PI [expr 2.0*asin(1.0)];
set lambda [eigen $modes];
foreach lam $lambda {
         lappend omega [expr sqrt($lam)];
         lappend F [expr sqrt($lam)/(2*$PI)];
         lappend T [expr (2.0*$PI)/sqrt($lam)];
}

# ##########################################################################################################
# ####################################### SAVE TIME PERIODS ################################################
# ##########################################################################################################

if {$GravityAnalysisDone == "No" || $GravityAnalysisDone == "no"} {
	set PeriodFile [open "$ModalAnalysisDirectory/$ModeShapePreGravDirectory/TimePeriods.txt" "w"];
	puts $PeriodFile "$T";
} else {
	set PeriodFile [open "$ModalAnalysisDirectory/$ModeShapePostGravDirectory/TimePeriods.txt" "w"];
	puts $PeriodFile "$T";
}
close $PeriodFile;

# ###########################################################################################################

for {set iMode 1} {$iMode <= $modes} {incr iMode} {

	if {$GravityAnalysisDone == "No" || $GravityAnalysisDone == "no"} {
		set modeFile [open "$ModalAnalysisDirectory/$ModeShapePreGravDirectory/ModeShape_$iMode.txt" "w"];
	} else {
		set modeFile [open "$ModalAnalysisDirectory/$ModeShapePostGravDirectory/ModeShape_$iMode.txt" "w"];	
	}


	for {set i 1} {$i <= [llength $Nodes]} {incr i} {
		puts $modeFile "[lindex $Nodes [expr $i - 1]] [nodeEigenvector [lindex $Nodes [expr $i - 1]] $iMode]";
	}
	close $modeFile;
}

