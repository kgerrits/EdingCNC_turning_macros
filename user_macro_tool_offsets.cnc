;########## X-offset ##############
;;sub set_tool+offset_X

;;[5012] actual tool X offset (X offset + xDelta)
;;[5014] actual G43 X offset (X offset + xDelta)

;;[5601 - 5699] tool x-offset (for turning) tool 1 - tool 99
;;[5008] = actual tool no.

;;[5398] return value for dlgmsg (+1 ok, -1 cancel)

;;[5001] = pos x --> work position 

	dlgmsg "Set tool X-offset. Enter measured diameter:" "D" 1200

    if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	if [#5008 > 1]	
	
		;; make sure tool offset is active
		G43
		
		;; calculate offset
		#1201 = [#5001 - #1200] ;; #5001 = position Z in work coordinates; #1200 = diameter from dialog
		msg "calculated offset = "#1201" "
		
		;; write offset to correct tool
		#1202 = [#5012 + #1201] ;; new offset for current tool | #5012 = actual tool X offset
		#[5600 + #5008] = #1202 ;; write offset | #56xx --> tool nr. xx X-offset
	
		msg "X-offset tool "#5008" = "#1202" mm"
	
	else ;; current tool = tool 1: reference tool
		;; do not adjust offset, but set work offset to measured/desired value
		
		G92 X[#1200]
		
	endif
	
	M30

;; endsub

;;sub set_tool_offset_Z
dlgmsg "Set tool Z-offset. Enter Z-distance:" "Z:" 1300

    if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	if [#5008 > 1]	
	
		;; make sure tool offset is active
		G43
		
		;; calculate offset
		#1301 = [#5003 - #1300] ;; #5003 = position Z in work coordinates; #1300 = offset from dialog
		msg "calculated offset = "#1301" "
		
		;; write offset to correct tool
		#1302 = [#5010 + #1301] ;; new offset for current tool | #5010 = actual tool Z offset
		#[5400 + #5008] = #1302 ;; write offset | #54xx --> tool nr. xx Z-offset
	
		msg "Z-offset tool "#5008" = "#1302" mm"
	
	else ;; current tool = tool 1: reference tool
		;; do not adjust offset, but set work offset to measured/desired value
		
		G92 Z[#1300]
		
	endif
	
	

;;endsub

