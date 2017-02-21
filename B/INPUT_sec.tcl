# DEFINE SECTION PARAMETERS ---------------------------------------------------------
# set C_dim2 100.928;
# wall
set Acol 	8000.0;#in2
set Izcol 	[expr 1/12.0*(236.0*pow(16.0,3)+16.0*pow(132.0,3))+132.0*16*pow((66.0-$C_dim2),2)*2+236.0*16.0*pow((100.928-140.0),2)];#in4
set Iycol 	[expr 1/12.0*(16.0*pow(236.0,3)+132.0*pow(16.0,3))+132.0*16*pow(110,2)*2];#in4
set Jcol 	[expr 1/3.0*pow(16,3)*(236.0+132.0*2)];#in4
# puts $Acol
# puts $Izcol
# puts $Iycol
# puts $Jcol

# coupling beam
set Ibeam 	[expr 1/12.0*16*pow(48,3)];#in4
set phi [expr 12.0*$E*$Ibeam/($G*640.00*pow(64.00,2))];
set Atruss 	[expr 4*16.0*pow(48,3)/((1+$phi)*pow(128,3))*pow((pow(64.0,2)+pow(18.50,2)),1.5)/1369.0];#in2