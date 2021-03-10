;; internal threading macro

	;; default values for dialog window
	#1700 = 0 ;; Z1
	#1701 = -10 ;; Z2
	#1702 = 12 ;; diameter A
	#1703 = 10.917 ;; diameter B
	#1704 = 1.00 ;; Pitch
	#1705 = 0.08 ;; depth per pass
	#1706 = 800 ;; spindle speed [rev/min] | negative for left hand threads
	#1708 = 2 ;; spindle speed [rev/min] | negative for left hand threads


	;; dialog with picture
	
	dlgmsg "dialog_internal_threading" "Z1" 1700 "Z2" 1701 "diameter A" 1702 "diameter B" 1703 "pitch" 1704 "depth per pass" 1705 "spindle speed [rev/min]" 1706 "Z clearance " 1708
	
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


    ;; calculate threading parameters
    #1707 = [[#1702 - #1703]/2] ;; full thread depth beyond thread peak

    ;; start threading cycle
    ;; -------------------------------------------------------------
	
	;; start spindle
	if [#1706 > 0]
		G97 S#1556 M4 ;; turn spindle CCW (back tool lathe, CCW equals right hand threads)
	else
		G97 S[-1*#1706] M3 ;; turn spindle CW (left hand thread)
	endif

    ;; goto thread start position
	G0 X[#1703-#1704] Z[#1700 + #1708]

    ;; threading cycle (radial feed)
    G76 P#1704 Z#1701 I[#1702 - [2*#1707]] J#1705 K#1707
	
	G0 Z[#1700 + #1708]

    ;; end macro
	M9 ;; stop cooling
	M5 ;; stop spindle
	G30 ;; go to safe position
	M30 ;; end program