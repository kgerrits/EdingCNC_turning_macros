;########## X-offset ##############
;;sub offset_set_X

;;[5012] actual tool X offset (X offset + xDelta)
;;[5014] actual G43 X offset (X offset + xDelta)

;;[5601 - 5699] tool x-offset (for turning) tool 1 - tool 99
;;[5008] = actual tool no.

;;[5398] return value for dlgmsg (+1 ok, -1 cancel)

;;[5001] = pos x --> work position 

	dlgmsg "Set tool X-offset. Enter measured diameter:" "D" 1200

    if [#5398 == -1] ;; dialog canceled
		m30
	endif
	
	if [#5008 > 1]	
		;; calculate offset
		#1201 = [#5001 - #1200] ;; #5001 = position x in work coordinates; #1200 = diameter from dialog
		msg "calculated offset = "#1201" "
		
		;; write offset to correct tool
		#1202 = [#5012 + #1201] ;; new offset for current tool | #5012 = actual tool X offset
		#[5600 + #5008] = #1202 ;; write offset | #56xx --> tool nr. xx X-offset
	
		msg "X-offset tool "#5008" = "#1202" mm"
	
	else ;; current tool = tool 1: reference tool
		;; do not adjust offset, but set work offset to measured/desired value
		
		G92 X[#1200]
		
	endif
	
	m30

;; endsub

