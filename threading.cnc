;; threading macro


	;; default values for dialog window
	#1550 = 0 ;; Z1
	#1551 = -10 ;; Z2
	#1552 = 12 ;; diameter A
	#1553 = 10.773 ;; diameter B
	#1554 = 1.00 ;; Pitch
	#1555 = 0.08 ;; depth per pass
	#1556 = 800 ;; spindle speed [rev/min] | negative for left hand threads


	;; dialog with picture
	
	dlgmsg "dialog_external_threading" "Z1" 1550 "Z2" 1551 "diameter A" 1552 "diameter B" 1553 "pitch" 1554 "depth per pass" 1555 "spindle speed [rev/min]" 
	
	if [#5398 == -1] ;; dialog canceled
		M30
	endif

    ;; sanity checks
    ;; TODO: axis position, threading cycle parameters, spindle speed not 0

    if [#1550 <= #1551] ;; Z1 larger or equal than Z2
		errmsg "Z2 must be smaller than Z1."
	endif

    if [#1556 == 0] ;; spindle speed 0
		errmsg "spindle speed must be larger than 0"
	endif


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
    G76 P#1554 Z#1551 I#1552 J#1555 K#1557

    ;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program

