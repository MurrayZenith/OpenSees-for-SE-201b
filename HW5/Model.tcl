
# Units MPa mm s
# Model generation with two-dimensions and 3 DOF/node
wipe
model basic -ndm 2 -ndf 3

# ------ Define two nodes at (0,0)
node 1 0.0 0.0
node 2 0.0 0.0


# ------ Fix all degrees of freedom except axial and bending
fix 1 1 1 1
fix 2 0 1 0


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


# --------------- Set axial load
set axialLoad -$P

# print axial load value on the screen:
puts "axialLoad: $axialLoad"


# -------------- Define constant axial load
pattern Plain 1 "Constant" {
	load 2 $axialLoad 0.0 0.0
}


# ------------- Define analysis parameters for the axial load
set tol 1.e-9;
set iter 2000;
integrator LoadControl 1
system ProfileSPD
test EnergyIncr $tol $iter
numberer Plain
constraints Plain
algorithm Newton
analysis Static


# Do one analysis to apply axial load
set ok [analyze 1]
puts $ok
if { $ok <0 } { puts "Analysis FAILED for axial load!"}


# ----------------- Define reference load pattern
pattern Plain 2 "Linear" {
	load 2 0.0 0.0 1.0
}

set controlNode 2;
set controlDOF 3;
