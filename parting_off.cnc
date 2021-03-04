;; parting-off macro

	;; default values for dialog window
	#1650 = 0 ;; Zstart
	#1651 = 20 ;; diameter A
	#1652 = -0.1 ;; diameter B
    #1653 = 2.5 ;; tool width
	#1654 = 0.1 ;; F, feed per rev [mm/rev]
    #1655 = 1500 ;; spindle speed [rev/min]
	#1656 = 1.0 ;; pecking depth
    #1657 = 0.05 ;; retract amount
    #1658 = 0.1 ;; dwell time

	;; dialog with picture
	
	dlgmsg "dialog_parting" "Zstart" 1650 "diameter A" 1651 "diameter B" 1652 "tool width" 1653 "F, feed/rev" 1654 "spindle speed" 1655 "pecking depth " 1656 "retract amount" 1657 "dwell time" 1658
	
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

    ;; parting off routine
	;; -------------------------------------------------------------

    ;; enable spindle
	G97 S#1655 M3

    if [#1656 == 0] ;; no pecking

        G0 Z[#1650 + #1653] ;; rapid to Z-position
        G0 X[#1651 + 0.5] ;; rapid down to start diameter + clearance
        G1 X[#1652] G95 F#1654 ;; feed per rev
        G4 P#1658
        G0 X[#1651 + 0.5] ;; rapid up to start diameter + clearance

    else ;; pecking cycle

        G0 Z[#1650 + #1653] ;; rapid to Z-position
        G0 X[#1651 + 0.5] ;; rapid down to start diameter + clearance

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

    G0 X[#1651 + 0.5] ;; rapid up to start diameter + clearance

    endif

	;; end macro
    G94 ;; back to feed in mm/min mode
	M9 ;; stop cooling
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program