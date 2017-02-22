# DEFINE GEOMETERIC TRANSFORMATION FOR ELEMENTS ---------------------------------------------------------
set transfTagCol 1;
set transfTagBeam 2;

#geomTransf Linear $transfTag $vecxzX $vecxzY $vecxzZ <-jntOffset $dXi $dYi $dZi $dXj $dYj $dZj>
geomTransf PDelta $transfTagCol 0 1 0;
geomTransf PDelta $transfTagBeam 0 0 1;