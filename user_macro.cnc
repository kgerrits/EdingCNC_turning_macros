; user macro for Emcoturn 120
; -----------------------------------------------------------
; Author: 	Koen Gerrits
; E-mail: 	kgerrits@live.nl
; Version: 	0.2
; Date: 	20/07/2022
; -----------------------------------------------------------

sub set_default_cycle_parameters
	;; sets all parameters related to turning cycles to default value
	
	;; cycle facing
	#1500 = 1 ;; Z1
	#1501 = 0 ;; Z2
	#1502 = 20 ;; diameter A
	#1503 = -0.1 ;; diameter B
	#1504 = 0.3 ;; Depth of cut
	#1505 = 0.2 ;; Finish amount
	#1506 = 150 ;; Vc, cutting speed [m/s]
	#1507 = 400 ;; F, cutting feed [mm/min]
	#1508 = 2 ;; Z clearance
	#1509 = 2 ;; X clearance
	#1513 = 3000 ;; max spindle speed [rpm]
	
	;; cycle_OD_turning
	#1400 = 0 ;; Z1
	#1401 = -5 ;; Z2
	#1402 = 20 ;; diameter A
	#1403 = 10 ;; diameter B
	#1404 = 0.75 ;; Depth of cut
	#1405 = 0.4 ;; Finish amount
	#1406 = 150 ;; Vc, cutting speed [m/min]
	#1407 = 0.1 ;; F, feed per rev [mm/rev]
	#1408 = 2 ;; Z clearance
	#1409 = 0.5 ;; retract amount
	#1413 = 3000 ;; max spindle speed
	#1415 = 0.05 ;; Finish amount face
	
	;; cycle drilling
	#1450 = 0 ;; Z1
	#1451 = -5 ;; Z2
	#1452 = 1 ;; include tip (0 = no, 1 = yes)
	#1453 = 118 ;; tip angle
	#1454 = [#5009 * 2] ;; drill diameter (Actual tool diameter)
	#1455 = 2 ;; Z clearance
	#1456 = 2 ;; peck depth (0 = no pecking)
	#1457 = 0.2 ;; retract value
	#1458 = 0 ;; full retract (0 = no, 1 = yes)
	#1459 = 70 ;; Vc
	#1460 = 0.05 ;; fn [mm/rev]
	
	;; cycle external threading
	#1550 = 0 ;; Z1
	#1551 = -10 ;; Z2
	#1552 = 12 ;; diameter A
	#1553 = 10.773 ;; diameter B
	#1554 = 1.00 ;; Pitch
	#1555 = 0.08 ;; depth per pass
	#1556 = 800 ;; spindle speed [rev/min] | negative for left hand threads
	#1558 = 1	;; number of spring passes
	
	;; cycle ID turning
	#1600 = 0 ;; Z1
	#1601 = -5 ;; Z2
	#1602 = 8 ;; diameter A
	#1603 = 12 ;; diameter B
	#1604 = 0.2 ;; Depth of cut
	#1605 = 0.1 ;; Finish amount diameter
	#1606 = 150 ;; Vc, cutting speed [m/min]
	#1607 = 0.1 ;; F, feed per rev [mm/rev]
	#1608 = 2 ;; Z clearance
	#1609 = 0.5 ;; retract amount
	#1610 = 3000 ;; max spindle speed
	#1615 = 0.05 ;; Finish amount wall
	
	;; cycle parting off
	#1650 = 0 ;; Zstart
	#1651 = 20 ;; diameter A
	#1652 = -0.1 ;; diameter B
    #1653 = 2.5 ;; tool width
	#1654 = 0.1 ;; F, feed per rev [mm/rev]
    #1655 = 1500 ;; spindle speed [rev/min]
	#1656 = 1.0 ;; pecking depth
    #1657 = 0.05 ;; retract amount
    #1658 = 0.1 ;; dwell time
	#1662 = 0.5 ;; X-clearance
	
	;; cycle internal threading
	#1700 = 0 ;; Z1
	#1701 = -10 ;; Z2
	#1702 = 12 ;; diameter A
	#1703 = 10.917 ;; diameter B
	#1704 = 1.00 ;; Pitch
	#1705 = 0.08 ;; depth per pass
	#1706 = 800 ;; spindle speed [rev/min] | negative for left hand threads
	#1708 = 2 ;; Z clearance
	#1709 = 1 ;; spring passes
	
	;; cycle OD turning chamfer parameters
	#1750 = 0 ;; Z1
	#1751 = -5 ;; Z2
	#1752 = 20 ;; diameter A
	#1753 = 10 ;; diameter B
	#1754 = 45 ;; chamfer angle
	#1755 = 1.5 ;; chamfer length
	#1756 = 0.75 ;; Depth of cut
	#1757 = 0.1 ;; Finish amount
	#1758 = 150 ;; Vc, cutting speed [m/min]
	#1759 = 0.1 ;; F, feed per rev [mm/rev]
	#1760 = 2 ;; Z clearance
	#1761 = 0.5 ;; retract amount
	#1762 = 3000 ;; max spindle speed
	#1763 = 0.05 ;; Finish amount face
	#1772 = 0.4 ;; Tool nose radius
	
	;; cycle groove turning parameters
	#1800 = -2 ;; Z1
	#1801 = -10 ;; Z2
	#1802 = 20 ;; X1
	#1803 = 10 ;; X2
	#1804 = 2.5 ;; tool width
	#1805 = 0.05 ;; Z allowance
	#1806 = 0.1 ;; X allowance
	#2001 = 150 ;; Vc, cutting speed [m/min]
	#1808 = 200 ;; F, cutting feed [mm/min]
	#1809 = 2 ;; Z safety
	#1810 = 22 ;; X safety
	#2002 = 3000 ;; max spindle speed
	#1807 = 0.2 ;; pass overlap
	
	msg "default cycle parameters set"

endsub

sub tool_plus_one

	if [#5008 < 99]
		;; advance tool with 1 position
		M6 T[#5008 + 1] 
	endif

endsub

sub tool_minus_one

	if [#5008 > 1]
		;; move back tool with 1 position
		M6 T[#5008 - 1] 
	endif
endsub

sub cycle_facing_parameters

;; lathe facing macro
;; ---------------------------------------------------------------
	
	;; default values for dialog window
	;; #1500 = 1 ;; Z1
	;; #1501 = 0 ;; Z2
	;; #1502 = 20 ;; diameter A
	;; #1503 = -0.1 ;; diameter B
	;; #1504 = 0.3 ;; Depth of cut
	;; #1505 = 0.2 ;; Finish amount
	;; #1506 = 150 ;; Vc, cutting speed [m/s]
	;; #1507 = 400 ;; F, cutting feed [mm/min]
	;; #1508 = 2 ;; Z clearance
	;; #1509 = 2 ;; X clearance
	;; #1513 = 3000;; max spindle speed
	
	;; dialog with picture
	
	dlgmsg "dialog_facing" "Z1" 1500 "Z2" 1501 "diameter A" 1502 "diameter B" 1503 "DOC" 1504 "finish amount" 1505 "Vc [m/min]" 1506 "Max spindle speed [rpm]" 1513 "F [mm/min]" 1507 "Z clearance" 1508 "X clearance" 1509
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO: check start positions of axes
	
	if [#1500 <= #1501] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif
	
	if [#1503 > #1502] ;; Diameter B must be smaller than diameter A
		errmsg "Diameter B must be smaller than diameter A."
	endif
	
	if [#1508 < 0] ;; Z clearance must be positive
		errmsg "Clearance value must be positive."
	endif
	
	if [#1509 < 0] ;; X clearance must be positive
		errmsg "Clearance value must be positive."
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%.
	
	;; parameters verified, go to facing cycle
	gosub cycle_facing
	
	gosub end_macro
	
endsub

sub cycle_facing
	;; turning routine
	;; -------------------------------------------------------------

	;; goto safety position
	G0 X[#1502 + #1509] Z[#1500 + #1508]
	
	;; overwrite max spindle speed
	#1513 = ABS[#1513] ;; max spindle speed not accepted as negative parameter
	
	;; enable spindle
	if [#1513 == 0] ;; run G96 at max machine set spindle speed
		if [#1506 < 0]
			#1506 = [#1506 * -1] ;; negative cutting speed not allowed, use this for M4 (CCW) enable
			M4 G96 S#1506
			
		else
			;; turn CW
			M3 G96 S#1506 ;; max spindle speed = max spindle speed of machine
		endif 

	else ;; run G96 at limit speed from dialog
		if [#1506 < 0]
			#1506 = [#1506 * -1] ;; negative cutting speed not allowed, use this for M4 (CCW) enable
			M4 G96 S#1506 D#1513
			
		else
			;; turn CW
			M3 G96 S#1506 D#1513
		endif 
		
	endif
	
	;; wait for spindle to ramp up (#5070 settling)
	G4 P1.5 ;; wait for Pxx seconds
	
	;; roughing cut(s)
	
	#1510 = 0 ;; roughing complete flag
	#1511 = [#1500 - #1504] ;; desired cutting depth (Z distance)
	#1512 = #1500 ;; last cut Z face value
	
	while [#1510 < 1] ;; roughing not completed
	
		if [#1511 > [#1501+#1505]] ;; perform roughing cut if desired cutting depth greater than final depth + finish amount
			G0 Z#1511
			G1 X#1503 F#1507
			#1512 = #1511 ;; update last Z faced value
			G91 G0 Z0.5 ;; retract in incremental mode
			G90 G0 X[#1502 + #1509] ;; rapid to clearance diameter in absolute mode
			#1511 = [#1512 - #1504] ;; calculate new desired cutting depth (Z distance)
		endif
		
		if [#1511 <= [#1501+#1505]] ;; perform final roughing cut to desired finish amount
			G0 Z[#1501 + #1505]
			G1 X#1503 F#1507
			G91 G0 Z0.5 ;; retract in incremental mode
			G90 G0 X[#1502 + #1509] ;; rapid to clearance diameter in absolute mode
			#1510 = 1 ;; set roughing complete flag
			msg "roughing passes completed"
		endif
	endwhile
	
	;; finish cut
	G0 Z[#1501]
	G1 X#1503 F#1507
	G91 G0 Z0.5 ;; retract in incremental mode
	G90 G0 X[#1502 + #1509] ;; rapid to clearance diameter in absolute mode

	msg "finish cut completed"
		
	;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle

endsub

sub cycle_OD_turning_parameters
	;; simple outside diameter turning macro
	;; -------------------------------------------------------------
	
	;; default values for dialog window
	;; #1400 = 0 ;; Z1
	;; #1401 = -5 ;; Z2
	;; #1402 = 20 ;; diameter A
	;; #1403 = 10 ;; diameter B
	;; #1404 = 0.75 ;; Depth of cut
	;; #1405 = 0.4 ;; Finish amount diameter
	;; #1406 = 150 ;; Vc, cutting speed [m/min]
	;; #1407 = 0.1 ;; F, feed per rev [mm/rev]
	;; #1408 = 2 ;; Z clearance
	;; #1409 = 0.5 ;; retract amount
	;; #1413 = 3000 ;; max spindle speed
	;; #1415 = 0.05 ;; Finish amount face
	
	;; dialog with picture
	
	dlgmsg "dialog_OD_turning" "Z1" 1400 "Z2" 1401 "diameter A" 1402 "diameter B" 1403 "DOC" 1404 "finish amount diameter" 1405 "finish amount face" 1415 "Vc [m/min]" 1406 "F [mm/rev]" 1407 "Z clearance" 1408 "retract amount" 1409 "max spindle speed [rpm]" 1413
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif

	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO: 
	;; - Z & diameter add allowance to checks
	;; TODO: check start positions of axes
	
	if [#1400 <= #1401] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif
	
	if [#1403 >= #1402] ;; diameter B larger or equal than diameter A
		errmsg "Diameter B must be smaller than diameter A."
	endif
	
	if [#1404 <= 0] ;; DOC 0 or negative
		errmsg "DOC cannot be negative or equal to 0"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to OD turning cycle
	gosub cycle_OD_turning
	
	gosub end_macro
	
endsub 

sub cycle_OD_turning
	;; turning routine
	;; -------------------------------------------------------------
	
	;; multiply depth of cut and finish alowance diameter by 2: diameter programming
	#1404 = [2* #1404]
	#1405 = [2* #1405]
	
	;; goto safety position
	G0 X#1402 Z[#1400 + #1408]
	
	;; enable spindle
	if [#1413 == 0]
		G96 S#1406 ;; max spindle speed = max spindle speed of machine
	else
		G96 S#1406 D#1413
	endif
	
	;; check sign of Vc for spindle directions
	if [#1406 > 0] ;; turn CW
		M3
	else ;; turn CCW
		M4
	endif
	
	;; wait for spindle to ramp up (#5070 settling)
	G4 P2 ;; wait for 2 second

	;; roughing
	#1410 = 0 ;; roughing complete flag
	#1411 = [#1402 - #1404] ;; desired cutting depth
	#1412 = #1402 ;; last cut diameter
	while [#1410 < 1]
		
		if [#1411 > [#1403+#1405]] ;; perform cut with full DOC if resulting diameter > final + finish allowance
			msg "next roughing pass X:"#1411
			G0 X#1411 ;; x down
			#1414 = [[#1406 * 1000] / [3.14159 * #1411]] ;; rpm calculation
			if [#1414 > #1413] ; check if calculated rpm is less than max set rpm
				#1414 = #1413
			endif
			msg "spindle RPM:"#1414
			G1 Z[#1401 + #1415] F[#1414 * #1407] ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			G1 X[#5001 + #1409] ;; retract X
			G0 Z[#1400 + #1408] ;; rapid Z to clearance
			#1412 = #1411 ;; update last cut diameter
			msg "roughing pass at X:"#1412
			#1411 = [#1412 - #1404] ;; calculate new desired diameter to cut
			
		endif

		if [#1411 <= [#1403 + #1405] ] ;; perform cut up to finish allowance diameter
			msg "next roughing pass X:"[#1403 + #1405]
			G0 X[#1403 + #1405] ;; x down to final diameter + finish amount
			#1414 = [[#1406 * 1000] / [3.14159 * [#1403 + #1405]]] ;; rpm calculation
			if [#1414 > #1413] ; check if calculated rpm is less than max set rpm
				#1414 = #1413
			endif
			msg "spindle RPM:"#1414
			G1 Z[#1401 + #1415] F[#1414 * #1407] ;; cut
			G1 X[#5001 + #1409] ;; retract X
			G0 Z[#1400 + #1408] ;; rapid Z to clearance
			#1410 = 1 ;; roughing completed
			msg "roughing passes completed"
		
		endif
		
	endwhile
	
	;; finish pass
	msg "Finishing pass X:"#1403
	G0 X[#1403] ;; x down to final diameter + finish amount
	#1414 = [[#1406 * 1000] / [3.14159 * #1403]] ;; rpm calculation
	if [#1414 > #1413] ; check if calculated rpm is less than max set rpm
		#1414 = #1413
	endif
	msg "spindle RPM:"#1414
	G1 Z[#1401] F[#1414 * #1407] ;; cut
	G1 X[#1402 + #1409] ;; cut backface to start diameter + retract amount
	G0 Z[#1400 + #1408] ;; rapid Z to clearance
	msg "finish pass completed"
	
	;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle

	;; divide depth of cut and finish alowance by 2: for storing parameters
	#1404 = [#1404 / 2]
	#1405 = [#1405 / 2]

endsub

sub cycle_OD_turning_chamfer_parameters
	;; Outside diameter turning with front chamfer
	;; -------------------------------------------------------------
	
	;; cycle OD turning chamfer parameters
	;#1750 = 0 ;; Z1
	;#1751 = -5 ;; Z2
	;#1752 = 20 ;; diameter A
	;#1753 = 10 ;; diameter B
	;#1754 = 45 ;; chamfer angle
	;#1755 = 1.5 ;; chamfer length
	;#1756 = 0.75 ;; Depth of cut
	;#1757 = 0.1 ;; Finish amount
	;#1758 = 150 ;; Vc, cutting speed [m/min]
	;#1759 = 0.1 ;; F, feed per rev [mm/rev]
	;#1760 = 2 ;; Z clearance
	;#1761 = 0.5 ;; retract amount
	;#1762 = 3000 ;; max spindle speed
	;#1763 = 0.05 ;; Finish amount face
	#1772 = #5009 ;;Tool nose radius --> Get tool nose radius from tool table
	
	;; dialog with picture
	
	dlgmsg "dialog_OD_turning_chamfer" "Z1" 1750 "Z2" 1751 "diameter A" 1752 "diameter B" 1753 "chamfer angle" 1754 "chamfer length" 1755 "DOC" 1756 "finish amount" 1757 "finish amount face" 1763 "Vc [m/min]" 1758 "F [mm/rev]" 1759 "Z clearance" 1760 "retract amount" 1761 "max spindle speed" 1762 "tool nose radius" 1772
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO: 
	;; - Z & diameter add allowance to checks
	;; TODO: check start positions of axes
	
	if [#1750 <= #1751] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif
	
	if [#1753 >= #1752] ;; diameter B larger or equal than diameter A
		errmsg "Diameter B must be smaller than diameter A."
	endif
	
	if [#1756 <= 0] ;; DOC 0 or negative
		errmsg "DOC cannot be negative or equal to 0"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to cycle
	gosub cycle_OD_turning_chamfer
	
	gosub end_macro
	
endsub 

sub cycle_OD_turning_chamfer
	;; turning routine
	;; -------------------------------------------------------------
	
	;; multiply depth of cut and finish alowance by 2: diameter programming
	#1756 = [2* #1756]
	#1757 = [2* #1757]
	
	;; calculate tool radius offsets
	#1773 = [#1772 * [1 - TAN[ [#1754/2] ] ] * TAN[#1754] ]	;;Xc radial compensation offset: =Rn*(1-tan(angle/2))*tan(angle)
	#1774 = [#1773 / TAN[#1754] ]							;;Zc axial compensation offset = Xc/tan(angle)
	
	msg "Calculated diametral compensation Xc:"[2*#1773]
	msg "Calculated axial compensation Zc:"#1774
	
	;; start cycle
	;; goto safety position
	G0 X#1752 Z[#1750 + #1760]
	
	;; enable spindle
	if [#1762 == 0]
		G96 S#1758 ;; max spindle speed = max spindle speed of machine
	else
		G96 S#1758 D#1762
	endif
	
	;; check sign of Vc for spindle directions
	if [#1758 > 0] ;; turn CW
		M3
	else ;; turn CCW
		M4
	endif
	
	;; wait for spindle to ramp up (#5070 settling)
	G4 P2 ;; wait for 2 second
	
	;; roughing
	#1764 = 0 ;; roughing complete flag
	#1765 = [#1752 - #1756] ;; desired cutting depth
	#1766 = #1752 ;; last cut diameter
	while [#1764 < 1]
		
		if [#1765 > [#1753+#1757]] ;; perform cut with full DOC if resulting diameter > final + finish allowance
			msg "next roughing pass X:"#1765
			G0 X#1765 ;; x down
			#1767 = [[#1758 * 1000] / [3.14159 * #1765]] ;; rpm calculation
			if [#1767 > #1762] ; check if calculated rpm is less than max set rpm
				#1767 = #1762
			endif
			msg "spindle RPM:"#1767
			G1 Z[#1751 + #1763] F[#1767 * #1759] ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			G1 X[#5001 + #1761] ;; retract X
			G0 Z[#1750 + #1760] ;; rapid Z to clearance
			#1766 = #1765 ;; update last cut diameter
			msg "roughing pass at X:"#1766
			#1765 = [#1766 - #1756] ;; calculate new desired diameter to cut
			
		endif

		if [#1765 <= [#1753 + #1757] ] ;; perform cut up to finish allowance diameter
			#1766 = [#1753 + #1757] ;; finish allowance diameter
			msg "next roughing pass X:"#1766
			G0 X#1766 ;; x down to final diameter + finish amount
			#1767 = [[#1758 * 1000] / [3.14159 * #1766]] ;; rpm calculation
			if [#1767 > #1762] ; check if calculated rpm is less than max set rpm
				#1767 = #1762
			endif
			msg "spindle RPM:"#1767
			G1 Z[#1751 + #1763] F[#1767 * #1759] ;; cut
			G1 X[#5001 + #1761] ;; retract X
			G0 Z[#1750 + #1760] ;; rapid Z to clearance
			
			#1764 = 1 ;; roughing completed
			;;msg "roughing passes completed"
			
		endif
		
	endwhile
	
	;; chamfer roughing
	#1768 = [ #1755 * TAN[#1754] ] ;; height of chamfer
	msg "chamfer height:"#1768
	#1769 = [ #1753 - 2 * #1768 ] ;; chamfer diameter
	msg "chamfer diameter:"#1769

	;; apply cutter radius offset compensation
	#1768 = [#1768 + #1773]
	#1769 = [#1769 - [2*#1773] ] ;; subtract calculated radial offset Xc, multiply by 2 for diameter
	#1755 = [#1755 + #1774] ;; add calculated axial offset Zc
	
	msg "chamfer height compensated:"#1768
	msg "chamfer diameter compensated:"#1769
	
	#1770 = [[#1756/2] / TAN[#1754]] ;; calculate Z-cutting depth reduction for chamfer roughing
	msg "Z-reduction:"#1770
	
	
	#1765 = [#1766 - #1756] ;; desired cutting diameter
	#1771 = [#1750 - [#1755 - #1770]] ;; initial chamfer roughing cutting depth Z
	msg "initial chamfer roughing cutting depth Z:"#1771
	
	#1764 = 0 ;; roughing complete flag
		
	while [#1764 < 1]
	
	if [#1765 >= [#1769 + #1757]]  ;; chamfer height minus finish amount greater equal to depth of cut, then rough chamfer
		
			msg "next roughing pass X:"#1765
			G0 X#1765 ;; x down
			#1767 = [[#1758 * 1000] / [3.14159 * #1765]] ;; rpm calculation
			if [#1767 > #1762] ; check if calculated rpm is less than max set rpm
				#1767 = #1762
			endif
			msg "spindle RPM:"#1767
			
			G1 Z#1771 F[#1767 * #1759]
			G1 X[#5001 + #1761] ;; retract X
			G0 Z[#1750 + #1760] ;; rapid Z to clearance
			
			#1766 = #1765 ;; update last cut diameter
			
			msg "roughing pass at X:"#1766
			
			#1765 = [#1766 - #1756] ;; calculate new desired diameter to cut
			#1771 = [#1771 + #1770] ;; next pass Z cutting depth
			
	endif

	if [#1765 <= [#1769 + #1757]]  ;; chamfer height minus finish amount greater equal to depth of cut, then rough chamfer
	
		#1764 = 1 ;; roughing completed
			;;msg "roughing passes completed"
	endif
	
	endwhile
	
	;; finish pass
	G0 X[#1753 - [#1768*2] ] ;; x down to chamfer start
	
	G1 Z#1750 F[#1767 * #1759]
	G1 X#1753 Z[#1750 - #1755]  F[#1767 * #1759]
	
	#1767 = [[#1758 * 1000] / [3.14159 * #1753]] ;; rpm calculation
	if [#1767 > #1762] ; check if calculated rpm is less than max set rpm
			#1767 = #1762
	endif
	msg "spindle RPM:"#1767
	
	G1 Z[#1751] F[#1767 * #1759] ;; cut
	G1 X[#1752 + #1761] ;; cut backface to start diameter + retract amount
	G0 Z[#1750 + #1760] ;; rapid Z to clearance
	msg "finish pass completed"
	
	;; end of cycle
	M9 ;; stop cooling
	M5 ;; stop spindle
	
		;; multiply depth of cut and finish alowance by 2: diameter programming
	#1756 = [#1756 / 2]
	#1757 = [#1757 / 2]

endsub

sub cycle_drilling_parameters
;; lathe drilling macro
	
	;; default values for dialog window
	;;#1450 = 0 ;; Z1
	;;#1451 = -5 ;; Z2
	;;#1452 = 1 ;; include tip (0 = no, 1 = yes)
	;;#1453 = 118 ;; tip angle
	#1454 = [#5009 * 2] ;; drill diameter --> (Take tool diameter from tool table)
	;;#1455 = 2 ;; Z clearance
	;;#1456 = 2 ;; peck depth (0 = no pecking)
	;;#1457 = 0.2 ;; retract value
	;;#1458 = 0 ;; full retract (0 = no, 1 = yes)
	;;#1459 = 70 ;; Vc
	;;#1460 = 0.05 ;; fn [mm/rev]
		

	;; dialog with picture
	
	dlgmsg "dialog_drilling" "Z1" 1450 "Z2" 1451 "tip include" 1452 "tip angle" 1453 "diameter" 1454 "Z clearance" 1455 "peck depth" 1456 "retract amount" 1457 "full retract" 1458 "Vc [m/min]" 1459 "feed [mm/rev]" 1460
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;;#1457 = [#1450 + #1455]
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO:
	;; check start positions of axes
	;; retract value > Z2
	
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately

	;; parameters verified, go to OD turning cycle
	gosub cycle_drilling
	
	gosub end_macro

endsub

sub cycle_drilling
	
	;; Calculate parameters
	;; spinde speed
	#1461 = [[#1459*1000] / [3.14159 * #1454]] ;; n = Vc*1000/pi*D
	msg "drill RPM:" #1461
	;; cutting speed
	#1462 = [#1460 * #1461]
	msg "drill feed mm/min:" #1462
	;; full diameter Z-extension
	#1463 = [[#1454 / 2] / TAN[#1453 / 2]]
	msg "drill tip extension amount:" #1463 
	

	;; move to Z clearance position
	G0 X0 Z[#1450 + #1455]
	
	;; start spindle
	;; limit speed to 3000 RPM
	if [#1461 > 3000]
		G97 S3000
	else
		G97 S#1461
	endif

	M4 ;; spindle CCW for drilling
	
	;; determine drilling cycle
	if [#1456 == 0] ;; full depth drilling
		msg "full depth drilling"
		
		if [#1452 == 0] ;; full diameter drilling --> extend Z2 with tip extension
		
			G1 Z[#1451-#1463] F#1462
			G4 P0.1 ;; dwell for 0.1 to get flat bottom 
			G91 G1 Z#1457 ;; retract with feed in incremental mode
			G90 G0 Z[#1450 + #1455] ;; rapid to safe position 
		else
			G1 Z#1451 F#1462
			G4 P0.1 ;; dwell for 0.1 to get flat bottom 
			G91 G1 Z#1457 ;; retract with feed in incremental mode
			G90 G0 Z[#1450 + #1455] ;; rapid to safe position 
		endif
		
	endif
	
	if [[#1456 > 0] and [#1458 == 0]] ;; standard pecking
		msg "standard pecking"
		
		if [#1452 == 0] ;; full diameter drilling --> extend Z2 with tip extension

			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G73 X0 Z[#1451-#1463] R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z[#1450 + #1455] ;; rapid to safe position 
		else
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G73 X0 Z#1451 R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z[#1450 + #1455] ;; rapid to safe position 
		endif
	endif
	
	if [[#1456 > 0] and [#1458 == 1]] ;; full retract pecking
		msg "full retract pecking"
		
		if [#1452 == 0] ;; full diameter drilling --> extend Z2 with tip extension
		
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G83 X0 Y0 Z[#1451-#1463] R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z[#1450 + #1455] ;; rapid to safe position 

		else
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G83 X0 Y0 Z#1451 R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z[#1450 + #1455] ;; rapid to safe position 
			
		endif
		
	endif

	M9 ;; stop cooling
	M5 ;; stop spindle
	
endsub

sub cycle_external_threading_parameters
;; threading macro

	;; default values for dialog window
	;; #1550 = 0 ;; Z1
	;; #1551 = -10 ;; Z2
	;; #1552 = 12 ;; diameter A
	;; #1553 = 10.773 ;; diameter B
	;; #1554 = 1.00 ;; Pitch
	;; #1555 = 0.08 ;; depth per pass
	;; #1556 = 800 ;; spindle speed [rev/min] | negative for left hand threads
	;; #1558 = 1	;; number of spring passes

	;; dialog with picture
	
	dlgmsg "dialog_external_threading" "Z1" 1550 "Z2" 1551 "Nominal thread size" 1552 "pitch" 1554 "depth per pass" 1555 "spindle speed [rev/min]" 1556 "spring passes" 1558
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif

    ;; sanity checks
    ;; TODO: axis position, threading cycle parameters, spindle speed not 0
	;; TODO: add Z-clearance parameter to dialog

    if [#1550 <= #1551] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif

    if [#1556 == 0] ;; spindle speed 0
		errmsg "spindle speed must be larger than 0"
	endif
	
	;; check pitch and calculate thread minor diameter
	if [#1554 == 0.2] ;; pitch = 0.2
		;; d3 = D-0.245
		#1553 = [#1552 - 0.245]	
	endif
	if [#1554 == 0.25] ;; pitch = 0.25
		;; d3 = D-0.307
		#1553 = [#1552 - 0.307]
	endif
	if [#1554 == 0.30] ;; pitch = 0.30
		;; d3 = D-0.368
		#1553 = [#1552 - 0.368]	
	endif
	if [#1554 == 0.35] ;; pitch = 0.35
		;; d3 = D-0.429
		#1553 = [#1552 - 0.429]	
	endif
	if [#1554 == 0.4] ;; pitch = 0.4
		;; d3 = D-0.491
		#1553 = [#1552 - 0.491]	
	endif	
	if [#1554 == 0.45] ;; pitch = 0.45
		;; d3 = D-0.552
		#1553 = [#1552 - 0.552]	
	endif		
	if [#1554 == 0.5] ;; pitch = 0.5
		;; d3 = D-0.613
		#1553 = [#1552 - 0.613]
	endif
	if [#1554 == 0.6] ;; pitch = 0.6
		;; d3 = D-0.736
		#1553 = [#1552 - 0.736]
	endif	
	if [#1554 == 0.70] ;; pitch = 0.70
		;; d3 = D-0.859
		#1553 = [#1552 - 0.859]	
	endif	
	if [#1554 == 0.75] ;; pitch = 0.75
		;; d3 = D-0.92
		#1553 = [#1552 - 0.92]	
	endif
	if [#1554 == 0.8] ;; pitch = 0.8
		;; d3 = D-0.981
		#1553 = [#1552 - 0.981]	
	endif	
	if [#1554 == 1.0] ;; pitch = 1.0
		;; d3 = D-1.227
		#1553 = [#1552 - 1.227]	
	endif
	if [#1554 == 1.25] ;; pitch = 1.25
		;; d3 = D-1.534
		#1553 = [#1552 - 1.534]
	endif
	if [#1554 == 1.5] ;; pitch = 1.5
		;; d3 = D-1.84
		#1553 = [#1552 - 1.84]
	endif
	if [#1554 == 1.75] ;; pitch = 1.75
		;; d3 = D-2.147
		#1553 = [#1552 - 2.147]	
	endif	
	if [#1554 == 2.0] ;; pitch = 2.0
		;; d3 = D-2.454
		#1553 = [#1552 - 2.454]	
	endif
	if [#1554 == 2.5] ;; pitch = 2.5
		;; d3 = D-3.007
		#1553 = [#1552 - 3.007]	
	endif	
	if [#1554 == 3.0] ;; pitch = 3.0
		;; d3 = D-3.681
		#1553 = [#1552 - 3.681]			
	endif
	if [#1554 == 3.5] ;; pitch = 3.5
		;; d3 = D-4.294
		#1553 = [#1552 - 4.294]	
	endif		
	if [#1554 == 4.0] ;; pitch = 4.0
		;; d3 = D-4.907
		#1553 = [#1552 - 4.907]	
	endif	
	
	;; --------------------
	if [#1553 > 0] ;; check if minor diameter > 0
		msg "Thread nominal size: "#1552
		msg "Thread pitch: "#1554
		msg "Thread minor diameter: "#1553
	else
		errmsg "Invalid thread size and pitch combination"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to external threading cycle
	gosub cycle_external_threading
	
	gosub end_macro
	
endsub

sub cycle_external_threading
	
    ;; calculate threading parameters
    #1557 = [[#1552 - #1553]/2] ;; full thread depth beyond thread peak

    ;; start threading cycle
    ;; -------------------------------------------------------------
	
	;; start spindle
	if [#1556 > 0]
		G97 S#1556 M4 ;; turn spindle CCW (back tool lathe, CCW equals right hand threads)
	else
		G97 S[-1*#1556] M3 ;; turn spindle CW (left hand thread)
	endif
	

    ;; goto thread start position
	G0 X#1552 Z#1550

    ;; threading cycle (radial feed)
    G76 P#1554 Z#1551 I#1552 J#1555 K#1557 H#1558

    ;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	
	
	;; move to thread start position + clearance
	
	G0 X[#1552+2] Z[#1550+2]

endsub

sub cycle_ID_turning_parameters

;; simple inside diameter turning macro
	
	;; default values for dialog window
	;; #1600 = 0 ;; Z1
	;; #1601 = -5 ;; Z2
	;; #1602 = 8 ;; diameter A
	;; #1603 = 12 ;; diameter B
	;; #1604 = 0.2 ;; Depth of cut
	;; #1605 = 0.1 ;; Finish amount diameter
	;; #1606 = 150 ;; Vc, cutting speed [m/min]
	;; #1607 = 0.1 ;; F, feed per rev [mm/rev]
	;; #1608 = 2 ;; Z clearance
	;; #1609 = 0.5 ;; retract amount
	;; #1610 = 3000 ;; max spindle speed
	;; #1615 = 0.05 ;; Finish amount wall

	;; dialog with picture
	
	dlgmsg "dialog_ID_turning" "Z1" 1600 "Z2" 1601 "diameter A" 1602 "diameter B" 1603 "DOC" 1604 "finish amount diameter" 1605 "Finish amount wall" 1615 "Vc [m/min]" 1606 "F [mm/rev]" 1607 "Z clearance" 1608 "retract amount" 1609 "max spindle speed [rpm]" 1610
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; multiply depth of cut and finish alowance by 2: diameter programming
	#1604 = [2* #1604]
	#1605 = [2* #1605]
	
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
	
	;; check if current Z position clears starting Z position
	if [#5003 < #1600] ;; current Z position smaller than starting position
		errmsg "Current Z-position smaller than starting position"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to ID turning cycle
	gosub cycle_ID_turning

	gosub end_macro
	
endsub 

sub cycle_ID_turning

    ;; turning routine
	;; -------------------------------------------------------------

	;; goto safety position
	G0 X[#1602 + #1604] Z[#1600 + #1608]
	
	;; take absolute value of max spindle speed, negative setting not allowed for G96
	#1610 = ABS[#1610]
	
	;; enable spindle
	if [#1610 == 0] ;; run G96 at max machine set spindle speed
		if [#1606 < 0]
			#1606 = [#1606 * -1] ;; negative cutting speed not allowed, use this for M4 (CCW) enable
			M4 G96 S#1606
			
		else
			;; turn CW
			M3 G96 S#1606 ;; max spindle speed = max spindle speed of machine
		endif 

	else ;; run G96 at limit speed from dialog
		if [#1606 < 0]
			#1606 = [#1606 * -1] ;; negative cutting speed not allowed, use this for M4 (CCW) enable
			M4 G96 S#1606 D#1610
			
		else
			;; turn CW
			M3 G96 S#1606 D#1610
		endif 
		
	endif
	
	;; wait for spindle to ramp up (#5070 settling)
	G4 P2 ;; wait for Px seconds

	;; roughing
	#1611 = 0 ;; roughing complete flag
	#1612 = [#1602 + #1604] ;; desired cutting depth
	#1613 = #1602 ;; last cut diameter
	while [#1611 < 1]
		
		if [#1612 < [#1603-#1605]] ;; perform cut with full DOC if resulting diameter > final + finish allowance
			msg "next roughing pass X:"#1612
			G0 X#1612 ;; x up
			#1614 = [[#1606 * 1000] / [3.14159 * #1612]] ;; rpm calculation
			if [#1614 > #1610] ;; check if calculated RPM is less than set max rpm
				#1614 = #1610
			endif
			G1 Z[#1601 + #1615] F[#1614 * #1607] ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			;;G1 Z[#1601 + #1605] F100 ;; cut and calculate feedrate in mm/min --> workaround for edingCNC "bug" where feedoverride does not work icm with G95 and G96 active
			G1 X[#5001 - #1609] ;; retract X
			G0 Z[#1600 + #1608] ;; rapid Z to clearance
			#1613 = #1612 ;; update last cut diameter
			msg "roughing pass at X:"#1613
			#1612 = [#1613 + #1604] ;; calculate new desired diameter to cut
			
		endif

		if [#1612 > [#1603-#1605]] ;; perform cut up to finish allowance diameter
			msg "next roughing pass X:"[#1603 - #1605]
			G0 X[#1603 - #1605] ;; x up to final diameter - finish amount
			#1614 = [[#1606 * 1000] / [3.14159 * [#1603 - #1605]]] ;; rpm calculation
			if [#1614 > #1610] ;; check if calculated RPM is less than set max rpm
				#1614 = #1610
			endif
			G1 Z[#1601 + #1615] F[#1614 * #1607] ;; cut
			;;G1 Z[#1601 + #1605] F100 ;; cut
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
	#1614 = [[#1606 * 1000] / [3.14159 * #1603]] ;; rpm calculation
	if [#1614 > #1610] ;; check if calculated RPM is less than set max rpm
		#1614 = #1610
	endif
	G1 Z[#1601] F[#1614 * #1607] ;; cut
	;;G1 Z[#1601] F100 ;; cut
	G1 X[#1602 - #1609] ;; cut backface to start diameter + retract amount
	G0 Z[#1600 + #1608] ;; rapid Z to clearance
	msg "finish pass completed"
	
	;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	
	;; divide depth of cut and finish alowance by 2: for storing parameters
	#1604 = [#1604 / 2]
	#1605 = [#1605 / 2]

endsub

sub cycle_parting_off_parameters
;; parting-off macro

	;; default values for dialog window
	;; #1650 = 0 ;; Zstart
	;; #1651 = 20 ;; diameter A
	;; #1652 = -0.1 ;; diameter B
    ;; #1653 = 2.5 ;; tool width
	;; #1654 = 0.1 ;; F, feed per rev [mm/rev]
    ;; #1655 = 1500 ;; spindle speed [rev/min]
	;; #1656 = 1.0 ;; pecking depth
    ;; #1657 = 0.05 ;; retract amount
    ;; #1658 = 0.1 ;; dwell time
	;; #1662 = 0.5 ;; X-clearance 

	;; dialog with picture
	
	dlgmsg "dialog_parting" "Zstart" 1650 "diameter A" 1651 "diameter B" 1652 "tool width" 1653 "X-clearance" 1662 "F, feed/rev" 1654 "spindle speed" 1655 "pecking depth " 1656 "retract amount" 1657 "dwell time" 1658
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
    ;; sanity checks
    ;; -------------------------------------------------------------
    ;; TODO: axis position, parameters

    if [#1651 <= #1652] ;; end diameter larger than start diameter
		errmsg "diameter B must be smaller than diameter A."
	endif

    if [#1655 == 0] ;; spindle speed 0
		errmsg "spindle speed must be larger than 0"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to parting off cycle
	gosub cycle_parting_off
	
	gosub end_macro
	
endsub

sub cycle_parting_off

    ;; parting off routine
	;; -------------------------------------------------------------

    ;; enable spindle
	G97 S#1655 M3

    if [#1656 == 0] ;; no pecking

        G0 Z[#1650 - #1653] ;; rapid to Z-position
        G0 X[#1651 + #1662] ;; rapid down to start diameter + clearance
        G1 X[#1652] G95 F#1654 ;; feed per rev
        G4 P#1658
        G0 X[#1651 + #1662] ;; rapid up to start diameter + clearance

    else ;; pecking cycle

        G0 Z[#1650 - #1653] ;; rapid to Z-position
        G0 X[#1651 + #1662] ;; rapid down to start diameter + clearance

        #1659 = 0 ;; pecking cycle complete flag
        #1660 = [#1651 - #1656] ;; desired cutting depth
        #1661 = #1651 ;; last cutting depth

        while [#1659 == 0]

            if [#1660 > #1652] ;; do pecking

                G1 X[#1660] G95 F#1654 ;; feed per rev
                G0 X[#1660 + #1657] ;; retract
                G4 P#1658 ;; dwell

                #1661 = #1660 ;; update last cut diameter
                #1660 = [#1661 - #1656] ;; calculate new desired cutting depth

            else ;; last cut to final diameter

                G1 X[#1652] G95 F#1654 ;; feed per rev
                G4 P#1658 ;; dwell
                #1659 = 1; 
            endif

        endwhile

    G0 X[#1651 + #1662] ;; rapid up to start diameter + clearance

    endif

	;; end macro
    G94 ;; back to feed in mm/min mode
	M9 ;; stop cooling
	M5 ;; stop spindle

endsub

sub cycle_internal_threading_parameters

;; internal threading macro

	;; default values for dialog window
	;; #1700 = 0 ;; Z1
	;; #1701 = -10 ;; Z2
	;; #1702 = 12 ;; diameter A
	;; #1703 = 10.917 ;; diameter B
	;; #1704 = 1.00 ;; Pitch
	;; #1705 = 0.08 ;; depth per pass
	;; #1706 = 800 ;; spindle speed [rev/min] | negative for left hand threads
	;; #1708 = 2 ;; Z clearance
	;; #1709 = 1 ;; spring passes


	;; dialog with picture
	
	dlgmsg "dialog_internal_threading" "Z1" 1700 "Z2" 1701 "Nominal thread size" 1702 "pitch" 1704 "depth per pass" 1705 "spindle speed [rev/min]" 1706 "Z clearance " 1708 "spring passes" 1709
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif

    ;; sanity checks
    ;; TODO: axis position, threading cycle parameters, spindle speed not 0

    if [#1700 <= #1701] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif

    if [#1706 == 0] ;; spindle speed 0
		errmsg "spindle speed must be larger than 0"
	endif
	
	;; check pitch and calculate thread minor diameter
	if [#1704 == 0.2] ;; pitch = 0.2
		;; D1 = D-0.217
		#1703 = [#1702 - 0.217]	
	endif
	if [#1704 == 0.25] ;; pitch = 0.25
		;; D1 = D-0.271
		#1703 = [#1702 - 0.271]
	endif
	if [#1704 == 0.30] ;; pitch = 0.30
		;; D1 = D-0.325
		#1703 = [#1702 - 0.325]	
	endif
	if [#1704 == 0.35] ;; pitch = 0.35
		;; D1 = D-0.379
		#1703 = [#1702 - 0.379]	
	endif
	if [#1704 == 0.4] ;; pitch = 0.4
		;; D1 = D-0.433
		#1703 = [#1702 - 0.433]	
	endif	
	if [#1704 == 0.45] ;; pitch = 0.45
		;; D1 = D-0.487
		#1703 = [#1702 - 0.487]	
	endif		
	if [#1704 == 0.5] ;; pitch = 0.5
		;; D1 = D-0.541
		#1703 = [#1702 - 0.541]
	endif
	if [#1704 == 0.6] ;; pitch = 0.6
		;; D1 = D-0.65
		#1703 = [#1702 - 0.65]
	endif	
	if [#1704 == 0.70] ;; pitch = 0.70
		;; D1 = D-0.758
		#1703 = [#1702 - 0.758]	
	endif	
	if [#1704 == 0.75] ;; pitch = 0.75
		;; D1 = D-0.812
		#1703 = [#1702 - 0.812]	
	endif
	if [#1704 == 0.8] ;; pitch = 0.8
		;; D1 = D-0.866
		#1703 = [#1702 - 0.866]	
	endif	
	if [#1704 == 1.0] ;; pitch = 1.0
		;; D1 = D-1.083
		#1703 = [#1702 - 1.083]	
	endif
	if [#1704 == 1.25] ;; pitch = 1.25
		;; D1 = D-1.353
		#1703 = [#1702 - 1.353]
	endif
	if [#1704 == 1.5] ;; pitch = 1.5
		;; D1 = D-1.624
		#1703 = [#1702 - 1.624]
	endif
	if [#1704 == 1.75] ;; pitch = 1.75
		;; D1 = D-1.894
		#1703 = [#1702 - 1.894]	
	endif	
	if [#1704 == 2.0] ;; pitch = 2.0
		;; D1 = D-2.165
		#1703 = [#1702 - 2.165]	
	endif
	if [#1704 == 2.5] ;; pitch = 2.5
		;; D1 = D-2.606
		#1703 = [#1702 - 2.606]	
	endif	
	if [#1704 == 3.0] ;; pitch = 3.0
		;; D1 = D-3.248
		#1703 = [#1702 - 3.248]			
	endif
	if [#1704 == 3.5] ;; pitch = 3.5
		;; D1 = D-3.789
		#1703 = [#1702 - 3.789]	
	endif		
	if [#1704 == 4.0] ;; pitch = 4.0
		;; D1 = D-4.33
		#1703 = [#1702 - 4.33]	
	endif	
	
	;; --------------------
	if [#1703 > 0] ;; check if minor diameter > 0
		msg "Thread nominal size: "#1702
		msg "Thread pitch: "#1704
		msg "Thread minor diameter: "#1703
	else
		errmsg "Invalid thread size and pitch combination"
	endif

    ;; calculate threading parameters
    #1707 = [[#1702 - #1703]/2] ;; full thread depth beyond thread peak
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately

	;; parameters verified, go to internal threading cycle
	gosub cycle_internal_threading
	
	gosub end_macro

endsub


Sub cycle_internal_threading
    ;; start threading cycle
    ;; -------------------------------------------------------------
	
	;; start spindle
	if [#1706 > 0]
		G97 S#1706 M4 ;; turn spindle CCW (back tool lathe, CCW equals right hand threads)
	else
		G97 S[-1*#1706] M3 ;; turn spindle CW (left hand thread)
	endif
	
    ;; goto thread start position
	G0 X[#1703-#1704] Z#1700

    ;; threading cycle (radial feed)
    G76 P#1704 Z#1701 I[#1702 - [2*#1707]] J#1705 K#1707 H#1709
	
	G0 Z[#1700 + #1708]

    ;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle

endsub

sub cycle_groove_turning_parameters

	;; cycle groove turning parameters
	#1800 = -2 ;; Z1
	#1801 = -10 ;; Z2
	#1802 = 20 ;; X1
	#1803 = 10 ;; X2
	#1804 = 2.5 ;; tool width
	#1805 = 0.05 ;; Z allowance
	#1806 = 0.1 ;; X allowance
	#2001 = 150 ;; Vc, cutting speed [m/min]
	#1808 = 200 ;; F, cutting feed [mm/min]
	#1809 = 2 ;; Z safety
	#1810 = 22 ;; X safety
	#2002 = 3000 ;; max spindle speed
	#1807 = 0.2 ;; pass overlap
	
	;; dialog with picture
	
	dlgmsg "dialog_groove_turning" "Z1" 1800 "Z2" 1801 "X1" 1802 "X2" 1803 "tool width" 1804 "Z allowance" 1805 "X allowance" 1806 "Vc [m/min]" 2001 "F [mm/min]" 1808 "Z safety" 1809 "X safety" 1810 "max spindle RPM" 2002 "pass overlap" 1807
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif

	;; Sanity checks
	if [#1800 <= #1801] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif
	
	if [#1802 < #1803] ;; X1 larger than diameter X2
		errmsg "Diameter X1 must be larger than diameter X2."
	endif
	
	;; check if current Z position clears starting Z position
	if [#5003 < #1809] ;; current Z position smaller than starting position
		errmsg "Current Z-position smaller than safety position"
	endif
	
	;; check if current X position clears starting Z position
	if [#5001 < #1810] ;; current Z position smaller than starting position
		errmsg "Current X-position smaller than safety position"
	endif
	
	;; set feed override to 0% so macro does not start immediately
	M48 ;; enable feed and speed override
	M50 P0 ;; feed override to 0%. Macro does not start immediately
	
	;; parameters verified, go to cycle
	gosub cycle_groove_turning
	
	gosub end_macro

endsub

sub cycle_groove_turning
	;; turning routine

	;; goto safety position
	G0 X[#1810] Z[#1809]

	gosub start_spindle_constant_cutting_speed ;; enable spindle constant cutting speed

	; -------------------------------------------------------------
	;; roughing cut(s)
	#1811 = 0 ; roughing complete flag
	#1812 = [#1800 - #1804 - #1805] ; desired Z grooving distance (Z1 - toolwidth - Z allowance)

	#1814 = [#1801 + #1805] ; maximum roughing Z value
	#1815 = [#1803 + #1806] ; roughing diameter

	while [#1811 < 1] ;; while roughing not completed

		if [#1812 > #1814] ;; perform rough cut if cutting depth is greater than final depth + allowance
			G0 Z#1812
			G1 X#1815 F#1808 ;; feed to roughing depth
			G0 X[#1802 + 0.5] ;; rapid retract
			#1813 = #1812 ; last Z-value of grooving passes
			#1812 = [#1813-#1804+#1807] ; new desired grooving Z value (last value - tool width + overlap)
		endif
		
		if [#1812 <= #1814] ;; perform final roughing step at maximum Z value
			G0 Z#1814
			G1 X#1815 F#1808 ;; feed to roughing depth
			G0 X[#1802 + 0.5] ;; rapid retract
			#1811 = 1 ; roughing complete flag
			msg "roughing passes completed"
		endif
		
	endwhile

	; -------------------------------------------------------------
	;; finish pass (peck at both end, finish turn middle section
	G0 Z[#1801] ;; rapid to Z end
	G1 X#1803 F#1808 ;; feed to finishing diameter
	G0 X[#1802 + 0.5] ;; rapid retract

	G0 Z[#1800 - #1804] ;; rapid to Z start - toolwidth
	G1 X#1803 F#1808 ;; feed to finishing diameter
	G1 Z#1801  ;; feed to finishing depth
	G1 X[#1802 + 0.5] ;; feed retract
	G0 X[#1810] Z[#1809];; rapid to safety position

endsub


sub cycle_OD_turning_chamfer_radius

	;; outside diameter turning macro with corner radius and chamfer
	
	;; default values for dialog window
	#1750 = 0 ;; Z1
	#1751 = -5 ;; Z2
	#1752 = 20 ;; diameter A
	#1753 = 10 ;; diameter B
	#1754 = 2 ;; chamfer 1
	#1755 = 3 ;; chamfer 2
	#1756 = 2 ;; radius 1
	#1757 = 0.75 ;; Depth of cut
	#1758 = 0.4 ;; Finish amount
	#1759 = 150 ;; Vc, cutting speed [m/min]
	#1760 = 0.1 ;; F, feed per rev [mm/rev]
	#1761 = 2 ;; Z clearance
	#1762 = 0.5 ;; retract amount
	#1763 = 3000 ;; max spindle speed
	;; dialog with picture
	
	dlgmsg "cycle OD turning" "Z1" 1750 "Z2" 1751 "diameter A" 1752 "diameter B" 1753 "Chamfer 1" 1754 "Chamfer 2" 1755 "Radius 1" 1756 "Depth of cut" 1757 "Finish amount" 1758 "Vc [m/min]" 1759 "F [mm/rev]" 1760 "Z clearance" 1761 "retract amount" 1762 "max spindle speed [rpm]" 1763
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; multiply depth of cut and finish alowance by 2: diameter programming
	#1757 = [2* #1757]
	#1758 = [2* #1758]
	
	; #5009 = actual tool radius
	
	if [#5009 >= #1756] ;; if actual tool radius greater or equal to corner radius --> do simple turning without radius
	
	else
	; stair down roughing with corner radius
	
	endif

endsub

sub start_spindle_constant_cutting_speed
;; starts spindle with G96 constant surface speed
;; #2001 = cutting speed in [m/s]
;; #2002 = maximum spindle speed --> if #2002 == 0, maximum of machine is used

;check if max RPM limit is set
if [#2002 > 0] ;; enable spindle with set maximum RPM

	if [#2001 < 0] ;; CCW
		M4 G96 S[ABS[#2001]] D#2002 
	else ;; CW
		M3 G96 S#2001 D#2002 
	endif
	
else ;; enable spindle with machine maximum RPM

	if [#2001 < 0] ;; CCW
		M4 G96 S[ABS[#2001]] 
	else ;; CW
		M3 G96 S#2001 
	endif
	
endif	

	;; wait for spindle to ramp up (#5070 settling)
	;;G4 P1.5 ;; wait for Pxx seconds

endsub

sub end_macro

	M9 ;; stop cooling
	;;M3 ;; --> M4 stopped spindle in position control, M3 free rotating --> need to fix in spindle drive setting
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program

endsub
