# DEFINE GEOMETERIC TRANSFORMATION FOR ELEMENTS ---------------------------------------------------------
set transfTagCol 1;
set transfTagBeam 2;

#geomTransf Corotational  $transfTag $vecxzX $vecxzY $vecxzZ <-jntOffset $dXi $dYi $dZi $dXj $dYj $dZj>
geomTransf Corotational  $transfTagCol 0 1 0;
geomTransf Corotational  $transfTagBeam 0 0 1;