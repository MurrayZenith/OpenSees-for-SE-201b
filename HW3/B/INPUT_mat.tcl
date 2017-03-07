# DEFINE MATERIAL PARAMETERS ---------------------------------------------------------
# source UNITS.tcl

set fc 		5.0;#ksi
set E		[expr 57*pow($fc*1000,0.5)];#ksi
set nu		0.3;
set G		[expr $E/(2.0*(1.0+$nu))];#ksi
set rho 	[expr 150*$pcf];
# puts $rho

set Eqtruss 100;
uniaxialMaterial Elastic $Eqtruss $E;