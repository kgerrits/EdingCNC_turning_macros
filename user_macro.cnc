;user macro

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

sub cycle_facing

;; lathe facing macro
	
	;; default values for dialog window
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
	;; dialog with picture
	
	dlgmsg "dialog_facing" "Z1" 1500 "Z2" 1501 "diameter A" 1502 "diameter B" 1503 "DOC" 1504 "finish amount" 1505 "Vc [m/min]" 1506 "F [mm/min]" 1507 "Z clearance" 1508 "X clearance" 1509
	
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
	
	;; turning routine
	;; -------------------------------------------------------------

	;; goto safety position
	G0 X[#1502 + #1509] Z[#1500 + #1508]
	
	;; enable spindle
	G96 S#1506 D4000
	;; check sign of Vc for spindle directions
	if [#1506 > 0] ;; turn CW
		M3
	else ;; turn CCW
		M4
	endif
	
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
	G30 ;; go to safe/home position
	M30 ;; end program
	
endsub

sub cycle_simple_turning
	;; simple outside diameter turning macro
	
	;; default values for dialog window
	#1400 = 0 ;; Z1
	#1401 = -5 ;; Z2
	#1402 = 20 ;; diameter A
	#1403 = 10 ;; diameter B
	#1404 = 0.75 ;; Depth of cut
	#1405 = 0.4 ;; Finish amount
	#1406 = 150 ;; Vc, cutting speed [m/s]
	#1407 = 400 ;; F, cutting feed [mm/min]
	#1408 = 2 ;; Z clearance
	#1409 = 0.5;; retract amount
	;; dialog with picture
	
	dlgmsg "simple_turning" "Z1" 1400 "Z2" 1401 "diameter A" 1402 "diameter B" 1403 "DOC" 1404 "finish amount" 1405 "Vc [m/min]" 1406 "F [mm/min]" 1407 "Z clearance" 1408 "retract amount" 1409
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO: 
	;; - Z & diameter add allowance to checks
	;; - cutting speed not 0
	;; - Z clearance and retract amount >= 0
	;; finish amount >= 0 & <= DOC
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
	
	;; turning routine
	;; -------------------------------------------------------------
	M53 ;; feed hold. Macro does not start immediately, toolpath can be checked in window

	;; goto safety position
	G0 X#1402 Z[#1400 + #1408]
	
	;; enable spindle
	G96 S#1406
	;; check sign of Vc for spindle directions
	if [#1406 > 0] ;; turn CW
		M3
	else ;; turn CCW
		M4
	endif
	
	;; roughing
	#1410 = 0 ;; roughing complete flag
	#1411 = [#1402 - #1404] ;; desired cutting depth
	#1412 = #1402 ;; last cut diameter
	while [#1410 < 1]
		
		if [#1411 > [#1403+#1405]] ;; perform cut with full DOC if resulting diameter > final + finish allowance
			msg "next roughing pass X:"#1411
			G0 X#1411 ;; x down
			G1 Z[#1401 + #1405] F#1407 ;; cut
			G1 X[#5001 + #1409] ;; retract X
			G0 Z[#1400 + #1408] ;; rapid Z to clearance
			#1412 = #1411 ;; update last cut diameter
			msg "roughing pass at X:"#1412
			#1411 = [#1412 - #1404] ;; calculate new desired diameter to cut
			
		endif

		if [#1411 <= [#1403+#1405]] ;; perform cut up to finish allowance diameter
			msg "next roughing pass X:"[#1403 + #1405]
			G0 X[#1403 + #1405] ;; x down to final diameter + finish amount
			G1 Z[#1401 + #1405] F#1407 ;; cut
			G1 X[#5001 + #1409] ;; retract X
			G0 Z[#1400 + #1408] ;; rapid Z to clearance
			#1410 = 1 ;; roughing completed
			msg "roughing passes completed"
		
		endif
		
		;;else
		;;	errmsg "chosen parameters caused a roughing error"
		;;endif
		
		
	endwhile
	
	;; finish pass
	msg "Finishing pass X:"#1403
	G0 X[#1403] ;; x down to final diameter + finish amount
	G1 Z[#1401] F#1407 ;; cut
	G1 X[#1402 + #1409] ;; cut backface to start diameter + retract amount
	G0 Z[#1400 + #1408] ;; rapid Z to clearance
	msg "finish pass completed"
	
	;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program
endsub

sub cycle_drilling
;; lathe drilling macro
	
	;; default values for dialog window
	#1450 = 0 ;; Z1
	#1451 = -5 ;; Z2
	#1452 = 1 ;; include tip (0 = no, 1 = yes)
	#1453 = 118 ;; tip angle
	#1454 = 4.2 ;; drill diameter
	#1455 = 2 ;; Z clearance
	#1456 = 2 ;; peck depth (0 = no pecking)
	#1457 = 0.2 ;; retract amount
	#1458 = 0 ;; full retract (0 = no, 1 = yes)
	#1459 = 70 ;; Vc
	#1460 = 0.05 ;; fn [mm/rev]
	

	;; dialog with picture
	
	dlgmsg "drilling" "Z1" 1450 "Z2" 1451 "tip include" 1452 "tip angle" 1453 "diameter" 1454 "Z clearance" 1455 "peck depth" 1456 "retract amount" 1457 "full retract" 1458 "Vc [m/min]" 1459 "feed [mm/rev]" 1460
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity checks
	;; -------------------------------------------------------------
	;; TODO:
	;; check start positions of axes
	
	
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
	

	;; -------------------------------------------------------------
	M53 ;; feed hold. Macro does not start immediately, toolpath can be checked in window
	
	;; move to home
	G28
	
	;; move to Z clearance position
	G0 X0
	G0 Z#1455
	
	;; start spindle
	;; limit speed to 4000 RPM
	if [#1461 > 4000]
		G97 S4000
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
			G90 G0 Z#1455 ;; rapid to safe position 
		else
			G1 Z#1451 F#1462
			G4 P0.1 ;; dwell for 0.1 to get flat bottom 
			G91 G1 Z#1457 ;; retract with feed in incremental mode
			G90 G0 Z#1455 ;; rapid to safe position 
		endif
		
	endif
	
	if [[#1456 > 0] and [#1458 == 0]] ;; standard pecking
		msg "standard pecking"
		
		if [#1452 == 0] ;; full diameter drilling --> extend Z2 with tip extension

			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G73 X0 Z[#1451-#1463] R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z#1455 ;; rapid to safe position 
		else
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G73 X0 Z#1451 R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z#1455 ;; rapid to safe position 
		endif
	endif
	
	if [[#1456 > 0] and [#1458 == 1]] ;; full retract pecking
		msg "full retract pecking"
		
		if [#1452 == 0] ;; full diameter drilling --> extend Z2 with tip extension
		
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G83 X0 Y0 Z[#1451-#1463] R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z#1455 ;; rapid to safe position 

		else
			G17 ;; switch plane --> G18 creates bug function error message in Eding CNC
			G83 X0 Y0 Z#1451 R#1457 Q#1456 F#1462
			G18 ;; switch back to XZ plane
			G0 Z#1455 ;; rapid to safe position 
			
		endif
		
	endif
	
	

	M9 ;; stop cooling
	M5 ;; stop spindle
	;; TODO retract Z axis before calling home position
	G30 ;; go to safe position
	M30 ;; end program
	

endsub



