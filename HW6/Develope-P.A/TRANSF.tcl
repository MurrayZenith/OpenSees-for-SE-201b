

# TRANSFORMATIONS FOR FLEXIBLE ELEMENTS ---------------------------------------------
# vertical elements
set transfTagVertLeft 1001; 				# associate a tag to the transformation
geomTransf $gT $transfTagVertLeft -1 0 0; 	# geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set transfTagVertRight 1002; 				# associate a tag to the transformation
geomTransf $gT $transfTagVertRight 1 0 0; 	# geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system



# TRANSFORMATIONS FOR RIGID ELEMENTS ---------------------------------------------
set transfTagVertRig 1003; 					# associate a tag to the transformation
geomTransf $gT $transfTagVertRig -1 0 0; 	# geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set transfTagHorizRig 1004; 				# associate a tag to the transformation
geomTransf $gT $transfTagHorizRig 0 0 1; 	# geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system

