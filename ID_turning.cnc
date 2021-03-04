;; simple inside diameter turning macro
	
	;; default values for dialog window
	#1600 = 0 ;; Z1
	#1601 = -5 ;; Z2
	#1602 = 8 ;; diameter A
	#1603 = 12 ;; diameter B
	#1604 = 0.2 ;; Depth of cut
	#1605 = 0.1 ;; Finish amount
	#1606 = 150 ;; Vc, cutting speed [m/min]
	#1607 = 0.1 ;; F, feed per rev [mm/rev]
	#1608 = 2 ;; Z clearance
	#1609 = 0.5 ;; retract amount
	#1610 = 3000 ;; max spindle speed

	;; dialog with picture
	
	dlgmsg "dialog_ID_turning" "Z1" 1600 "Z2" 1601 "diameter A" 1602 "diameter B" 1603 "DOC" 1604 "finish amount" 1605 "Vc [m/min]" 1606 "F [mm/rev]" 1607 "Z clearance" 1608 "retract amount" 1609 "max spindle speed [rpm]" 1610
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO: 
	;; - Z & diameter add allowance to checks
	;; - Z clearance and retract amount >= 0
	;; finish amount >= 0 & <= DOC
	;; TODO: check start positions of axes
	
	if [#1600 <= #1601] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif
	
	if [#1603 < #1602] ;; diameter A larger than diameter B
		errmsg "Diameter B must be larger than diameter A."
	endif
	
	if [#1604 <= 0] ;; DOC 0 or negative
		errmsg "DOC cannot be negative or equal to 0"
	endif

    ;; turning routine
	;; -------------------------------------------------------------
	;;M53 ;; feed hold. Macro does not start immediately, toolpath can be checked in window

	;; goto safety position
	G0 X[#1602 + #1604] Z[#1600 + #1608]
	
	;; enable spindle
	if [#1610 == 0]
		G96 S#1606 ;; max spindle speed = max spindle speed of machine
	else
		G96 S#1606 D#1610
	endif
	
	;; check sign of Vc for spindle directions
	if [#1606 > 0] ;; turn CW
		M3
	else ;; turn CCW
		M4
	endif
	
	;; wait for spindle to ramp up (#5070 settling)
	G4 P1 ;; wait for 1 second

	;; roughing
	#1611 = 0 ;; roughing complete flag
	#1612 = [#1602 + #1604] ;; desired cutting depth
	#1613 = #1602 ;; last cut diameter
	while [#1611 < 1]
		
		if [#1612 < [#1603-#1605]] ;; perform cut with full DOC if resulting diameter > final + finish allowance
			msg "next roughing pass X:"#1612
			G0 X#1612 ;; x up
			;;G1 Z[#1601 + #1605] F[#5070 * 60 * #1607] ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			G1 Z[#1601 + #1605] F100 ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			G1 X[#5001 - #1609] ;; retract X
			G0 Z[#1600 + #1608] ;; rapid Z to clearance
			#1613 = #1612 ;; update last cut diameter
			msg "roughing pass at X:"#1613
			#1612 = [#1613 + #1604] ;; calculate new desired diameter to cut
			
		endif

		if [#1612 > [#1603-#1605]] ;; perform cut up to finish allowance diameter
			msg "next roughing pass X:"[#1603 - #1605]
			G0 X[#1603 - #1605] ;; x up to final diameter - finish amount
			;;G1 Z[#1601 + #1605] F[#5070 * 60 * #1607] ;; cut
			G1 Z[#1601 + #1605] F100 ;; cut
			G1 X[#5001 - #1609] ;; retract X
			G0 Z[#1600 + #1608] ;; rapid Z to clearance
			#1611 = 1 ;; roughing completed
			msg "roughing passes completed"
		
		endif
		
		;;else
		;;	errmsg "chosen parameters caused a roughing error"
		;;endif

	endwhile

	;; finish pass
	msg "Finishing pass X:"#1603
	G0 X[#1603] ;; x down to final diameter + finish amount
	;;G1 Z[#1601] F[#5070 * 60 * #1607] ;; cut
	G1 Z[#1601] F100 ;; cut
	G1 X[#1602 - #1609] ;; cut backface to start diameter + retract amount
	G0 Z[#1600 + #1608] ;; rapid Z to clearance
	msg "finish pass completed"
	
	;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program