# DEFINE GEOMETERIC TRANSFORMATION FOR ELEMENTS ---------------------------------------------------------
set transfTagCol 1;
set transfTagColr 2;

#geomTransf Linear $transfTag $vecxzX $vecxzY $vecxzZ <-jntOffset $dXi $dYi $dZi $dXj $dYj $dZj>
geomTransf Linear $transfTagCol 0 1 0;
geomTransf Linear $transfTagColr 0 -1 0;