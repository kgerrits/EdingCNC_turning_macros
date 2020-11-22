;########## X-offset ##############
;;sub offset_set_X

;;[5012] actual tool X offset (X offset + xDelta)
;;[5014] actual G43 X offset (X offset + xDelta)

;;[5601 - 5699] tool x-offset (for turning) tool 1 - tool 99
;;[5008] = actual tool no.

;;[5398] return value for dlgmsg (+1 ok, -1 cancel)

;;[5001] = pos x --> work position 

	dlgmsg "set tool X-offset" "D" 1200

    if [#5398 == -1]
		m30
	endif
	
	;; calculate offset
	#1201 = [#5001 - #1200]
	msg "calculated offset = "#1201" "
	
	
	;; write offset to correct tool
	#1202 = [#5012 + #1201] ;; new offset for current tool
	
	#[5600 + #5008] = #1202
	
	msg "X-offset tool "#5008" = "#1202" mm"
	
	m30


