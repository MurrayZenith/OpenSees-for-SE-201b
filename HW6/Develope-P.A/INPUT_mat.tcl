# ##############################################################################################################################################################################################
# #################################################################################### CONCRETE ################################################################################################
# ##############################################################################################################################################################################################
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ##############################################################################################################################################################################################
# ################################################################################## WALL CONCRETE #############################################################################################
# ##############################################################################################################################################################################################
set UConcMatTagWall 1;
set CConcMatTagWall 2;

set fpc     [expr -1.0*$fpcFac*$fpcNom];					# Unconfined Concrete strength. fpcfac decides expected or nominal
set Ec		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
set nuc 0.2; 												# Poisson's Ratio of Concrete
set Gc 	[expr $Ec/(2.0*(1.0+$nuc))];						# Shear Modulus of Concrete
set epsc0 [expr 2.0*$fpc/$Ec]; 								# 

set fpcc	[expr -1.0*$fpcFac*$fpccNom];					# Confined Concrete strength. fpcfac decides expected or nominal
set Ecc		[expr 57000.0*sqrt(-1.0*$fpcc/$psi)*$psi];		# Concrete Initial Young's Modulus
set epscc0	[expr 2.0*$fpcc/$Ecc]; 							# 

# set ft		[expr 0.430*$ksi];								#

if {$ConcMatTypeWall == "Concrete01"} {
  # uniaxialMaterial Concrete01 $matTag 		 	$fpc	$epsc0	$fpcu 				$epsU 
	uniaxialMaterial Concrete01 $UConcMatTagWall	$fpc	$epsc0	[expr 0.2*$fpc]		-0.004
	puts $ExportID "uniaxialMaterial Concrete01 $UConcMatTagWall	$fpc	$epsc0	[expr 0.2*$fpc]		-0.004"
	uniaxialMaterial Concrete01 $CConcMatTagWall	$fpcc	$epscc0	[expr 0.85*$fpcc]	-0.015
	puts $ExportID "uniaxialMaterial Concrete01 $CConcMatTagWall	$fpcc	$epscc0	[expr 0.85*$fpcc]	-0.015"
} elseif {$ConcMatTypeWall == "Concrete02"} {
  # uniaxialMaterial Concrete02 $matTag 		 	$fpc	$epsc0	$fpcu				$epsU	$lambda	$ft		$Ets 
	uniaxialMaterial Concrete02 $UConcMatTagWall	$fpc	$epsc0	[expr 0.2*$fpc]		-0.004	0.25	$ft		[expr 0.1*$Ec]
	uniaxialMaterial Concrete02 $CConcMatTagWall	$fpcc	$epscc0	[expr 0.85*$fpc]	-0.015	0.25	$ft		[expr 0.1*$Ec]
} else {
	uniaxialMaterial Elastic $UConcMatTagWall    $Ec
	uniaxialMaterial Elastic $CConcMatTagWall    $Ec
}


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ##############################################################################################################################################################################################
# #################################################################################	BEAM CONCRETE  #############################################################################################
# ##############################################################################################################################################################################################
set ConcMatTagBeam 3; 

set ft_eq   [expr 0.43*$ksi];
set fpc     [expr -10.*$ft_eq];
set Ec		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
set nuc 0.2; 												# Poisson's Ratio of Concrete
set Gc 	[expr $Ec/(2.0*(1.0+$nuc))];						# Shear Modulus of Concrete
set epsc0	[expr 2.0*$fpc/$Ec]; 							# 

if {$ConcMatTypeBeam == "Concrete01"} {
  # uniaxialMaterial Concrete01 $matTag 		 	$fpc	$epsc0	$fpcu 				$epsU 
	uniaxialMaterial Concrete01 $ConcMatTagBeam		$fpc	$epsc0	[expr 0.2*$fpc]		-0.004
} elseif {$ConcMatTypeBeam == "Concrete02"} {
  # uniaxialMaterial Concrete02 $matTag 		 	$fpc	$epsc0	$fpcu				$epsU	$lambda	$ft		$Ets 
	uniaxialMaterial Concrete02 $ConcMatTagBeam		$fpc	$epsc0	[expr 0.2*$fpc]		-0.004	0.25	$ft_eq	[expr 0.1*$Ec]
	puts $ExportID "uniaxialMaterial Concrete02 $ConcMatTagBeam		$fpc	$epsc0	[expr 0.2*$fpc]		-0.004	0.25	$ft_eq	[expr 0.1*$Ec]"
} else {
	uniaxialMaterial Elastic $ConcMatTagBeam		$Ec
}

# ##############################################################################################################################################################################################
# #####################################################################################  STEEL  ################################################################################################
# ##############################################################################################################################################################################################
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set StelMatTag 4

set Fy     [expr $fyFac*$fyNom];					# Steel strength. fyfac decides expected or nominal
set E0		[expr 29000*$ksi];						# Steel  Initial Young's Modulus

# Reinforcing steel
# uniaxialMaterial Steel02	$matTag		$Fy		$E0		$b  	$R0	$cR1 	$cR2	<$a1 $a2 $a3 $a4 $sigInit> 
  uniaxialMaterial Steel02	$StelMatTag	$Fy		$E0		0.0165	20 	0.925	0.15	0.0 1.0 0.0 1.0 0.0 
  puts $ExportID "uniaxialMaterial Steel02	$StelMatTag	$Fy		$E0		0.0165	20 	0.925	0.15	0.0 1.0 0.0 1.0 0.0 "