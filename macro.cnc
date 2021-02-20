;*****************************************
;* This is file macro.cnc version changed at V4.03.20
;* It is automatically loaded
;* Customize this file yourself if you like
;* It contains:
;* - subroutine change_tool this is called on M6T..
;* - subroutine home_x .. home_z, called when home functions in GUI are activated
;* - subroutine home_all, called when home all button in GUI are activated
;* - subroutine user_1 .. user_11, called when user functions are activated
;*   user_1 contains an example of zeroing Z using a moveable tool setter
;*   user_2 contains an example of measuring the tool length using a fixed tool setter
;*
;* You may also add frequently used macro's in this file.
;****************************************


;* #4995 = ...  ;(Variable tool setter height for zeroing Z, used in zero_z)
;* #4996 = ...  ;(Tool measurement safe hight, used inside m_tool)
;* #4997 = ...  ;(X position of tool length measurement)
;* #4998 = ...  ;(Y position of tool length measurement)
;* #4999 = ...  ;(Chuck height, or zero - tool length height)




Sub zero_z

  #4995 = 43      ;set value for compatibility with previous macro.cnc

  if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering
    msg "user_1, Zero Z (G92) using tool-setter"
    (Start probe move, slow)
    f30
    g53 g38.2 z[#5103 + #4995] ;Probe move, not below variable tool setter height
    (Move back to touch point)
    g90 g0 z#5063
    (Set position, the measuring device is 43mm in height, adapt for your measuring device)
    G92 z#4995
    (move 5 mm above measuring device)
    g91 (incremental distance mode)
    g0 z5
    g90 (absolute distance mode)
  endif
Endsub

sub m_tool
    if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering
        ;Check if toolsetter is calibrated
        if [[#4996 == 0] and [#4997 == 0] and [#4998 == 0] and [#4999 == 0]]
            errmsg "calibrate first, MDI: gosub calibrate_tool_setter"
        else
            g0 g53 z#4996 ; move to safe z
            dlgmsg "enter tool dimensions" "tool number" 5016 "approx tool length" 5017 "tool diameter" 5018
            ;Check user pressed OK
            if [#5398 == 1] 
                if [[#5016 < 1] OR [#5016 > 99]]
                    ErrMsg "Tool must be in range of 0 .. 99"
                endif
        
                ;move to toolsetter coordinates
                g00 g53 x#4997 y#4998 
                ;move to 10mm above chuck height + approx tool length + 10
                g00 g53 z[#4999+10+#5017]
                ;measure tool length and pull 5mm back up
                g38.2 g91 z-20 f30
                g90
                ;back to safe height
                g0 g53 z#4996
                ;Store tool length, diameter in tool table
                ;but only if actually measured, 
                ;so leave tool table as is while rendering 
                if [#5397 == 0]
                    #[5400 + #5016] = [#5053-#4999]
                    #[5500 + #5016] = #5018
                    #[5600 + #5016] = 0 ;Tool X offset is 0
                    msg "tool length measured="#[5400 + #5016]" stored at tool "#5016
                endif
            endif
        endif
    endif
endsub

;Same but no dialog
;Tool number is set in 5025
;Tool length an diameter is retrieved from tool table.
;Warning the length in the tool table must not be 10 mm or more shorter as the tool,
;Otherwise collision with the tool-setter will happen!!!!!!!
sub m_tool_no_dlg
    if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering
        ;Check if toolsetter is calibrated
        if [[#4996 == 0] and [#4997 == 0] and [#4998 == 0] and [#4999 == 0]]
            errmsg "calibrate first, MDI: gosub calibrate_tool_setter"
        else
            
            ;dlgmsg "enter tool dimensions" "tool number" 5016 "approx tool length" 5017 "tool diameter" 5018
            
            ;In stead of the dialog we get the values from the tool table.
            #5016 = #5025           ;Tool number
            #5017 = #[5400 + #5016] ;Approx tool-length from tool table
            #5018 = #[5500 + #5016] ;Tool diameter from tool table
                        
            if [[#5016 < 1] OR [#5016 > 99]]
                ErrMsg "Tool must be in range of 0 .. 99"
            endif
            
            ;Check if tool is loaded, if not do so.
            if [#5016 <> #5008]
                m6 t#5016
            endif
    
            g0 g53 z#4996 ; move to safe z
            ;move to toolsetter coordinates
            g00 g53 x#4997 y#4998 
            ;move to 10mm above chuck height + approx tool length + 10
            g00 g53 z[#4999+10+#5017]; change this to g00 g53 z[#5113] to go fully up.
            ;measure tool length and pull 5mm back up
            g38.2 g91 z-20 f30
            g90
            ;back to safe height
            g0 g53 z#4996
            ;Store tool length, diameter in tool table
            ;but only if actually measured, 
            ;so leave tool table as is while rendering 
            if [#5397 == 0]
                #[5400 + #5016] = [#5053-#4999]
                #[5500 + #5016] = #5018
                #[5600 + #5016] = 0 ;Tool X offset is 0
                msg "tool length measured="#[5400 + #5016]" stored at tool "#5016
            endif
        endif
    endif
endsub


;Example to enumerate tools used in a job end measure them using a dialogue
;Can e.g. be used to measure the length of all tools at once before running the job.
;This example is made for maximum 6 tools.
sub measure_used_tools
    GetToolInfo num 5025 ;get the number of tools used in the loaded g-code.
    Msg "number of tools used = " #5025
    
    ;Initialise our tool Array (6 tools)
    #5026 = 0 ;Used as counter, tool 0 .. 6
    While [#5026 <= 6]
        #[5030 + #5026] = 0
        #5026 = [#5026 + 1]
    endwhile
    ;#5030 .. #5036 is now 0
    
    ;Get all used tools an set it to 1 in array which goes from #5030 to #5036
    GetToolInfo first 5025
    while [[#5025 >= 0] and [#5025 <= 6]] ;#5025 becomes -1 at last tool.
        msg "Tool "#5025" is used"
        ;Store in array
         #[5030 + #5025] = 1
        GetToolInfo next 5025
    endwhile
    
    ;Suppose maximum tools in the machine is 6
    ;We ask the customer which tool to measure and set the used ones e default as yes (1)
    dlgmsg "Select tools to measure 1 => YES 0 => NO)" "tool 1" 5031 "tool 2" 5032 "tool 3" 5033 "tool 4" 5034 "tool 5" 5035 "tool 6" 5036
    
     if [#5398 == 1] ; user pressed ok
     
        msg "starting tool measurement"
        G4 P1 ;Wait 1 sec to show message

        ;Perform tool measurement for all selected tools
        #5026 = 0 ;Used as counter, tool 0 .. 6
        While [#5026 <= 6]
            if [#[5030 + #5026] == 1]
                #5025 = #5026 
                gosub m_tool_no_dlg
            else
                ;skip because it was not selected
            endif
            #5026 = [#5026 + 1] ; next
        endwhile
        
     else
        ;User pressed cancel in the dialog
        msg "measurement cancelled"
     endif
    
endsub


;* calibrate tool length measurement position and hight.
;* variables #4996 - #4999 are set to be used in m_tool.
Sub calibrate_tool_setter
    warnmsg "close MDI, check correct calibr. tool nr 99 in tool table, press ctrl-g"
    warnmsg "jog to toolchange safe height, when done press ctrl-g"
    #4996=#5073 ;Store toolchange safe height machine coordinates
    warnmsg "insert cal. tool 99 len="#5499", jog above tool setter, press ctrl-g"
    ;store x y in non volatile parameters (4000 - 4999)
    #4997=#5071 ;machine pos X
    #4998=#5072 ;machine pos Y
    ;Determine minimum toochuck height and store into #4999
    g38.2 g91 z-20 f30
    #4999=[#5053 - #5499] ;probepos Z - calibration tool length = toolchuck height
    g90
    g0 g53 z#4996
    msg "calib. done safe height="#4996 " X="#4997 " Y="#4998 " Chuck height="#4999
endSub

sub set_tool_offset_X

	dlgmsg "Set tool X-offset. Enter measured diameter:" "D" 1200

    if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; sanity check if diameter > 0
	if [#1200 < 0] ;; 
		warnmsg "entered diameter < 0"
	endif
		
	;; make sure tool offset is active
	G43
		
	;; calculate offset
	#1201 = [#5001 - #1200] ;; #5001 = position X in work coordinates; #1200 = diameter from dialog
	msg "calculated offset = "#1201" "
		
	;; write offset to correct tool
	#1202 = [#5012 + #1201] ;; new offset for current tool | #5012 = actual tool X offset
	#[5600 + #5008] = #1202 ;; write offset | #56xx --> tool nr. xx X-offset
	
	msg "X-offset tool "#5008" = "#1202" mm"

endsub

sub set_tool_offset_Z

	dlgmsg "Set tool Z-offset. Enter Z-distance:" "Z:" 1300

    if [#5398 == -1] ;; dialog canceled
		M30
	endif
	
	;; make sure tool offset is active
	G43
		
	;; calculate offset
	#1301 = [#5003 - #1300] ;; #5003 = position Z in work coordinates; #1300 = offset from dialog
	msg "calculated offset = "#1301" "
		
	;; write offset to correct tool
	#1302 = [#5010 + #1301] ;; new offset for current tool | #5010 = actual tool Z offset
	#[5400 + #5008] = #1302 ;; write offset | #54xx --> tool nr. xx Z-offset
	
	msg "Z-offset tool "#5008" = "#1302" mm"

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

sub simple_turning
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
;; simple outside diameter turning macro
	
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
	;; TODO
	
	
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

;User functions, F1..F11 in user menu


Sub user_1
	msg "set X offset of active tool"
	goSub set_tool_offset_X
Endsub

Sub user_2
	msg "set Z offset of active tool"
	goSub set_tool_offset_Z
Endsub

Sub user_3 
	gosub simple_turning
Endsub

Sub user_4
	gosub cycle_drilling
Endsub

Sub user_5
    msg "sub user_5"
Endsub

Sub user_6
    msg "sub user_6"
Endsub

Sub user_7
    msg "sub user_7"
Endsub

Sub user_8
    msg "sub user_8"
Endsub

Sub user_9
    msg "sub user_9"
Endsub

Sub user_10
    msg "sub user_10"
Endsub

Sub user_11
    goSub tool_plus_one
Endsub

Sub user_12
    goSub tool_minus_one
Endsub

;Homing per axis
Sub home_x
    home x
    ;;if A is slave of X uncomment next lines and comment previous line
    ;homeTandem X
Endsub

Sub home_y
    home y
Endsub

Sub home_z
    home z
Endsub

Sub home_a
    ;;If a is slave comment out next line
    ;;For homing a master-slave axis only homeTandem <master> should be done
    home a
Endsub

Sub home_b
    home b
Endsub

Sub home_c
    home c
Endsub

Sub home_toolchanger
	#724 = 0 ;; timeout counter
	#725 = 0 ;; use #725 to indicate succesfull homing
	
	;; check if homing is required
	if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering
		modbus s1 f2 a23 n1 u723 ;; request homing status from toolchanger and store in variable 723
	
	
	if [#723 == 0]
		;; write a 1 to address 23, this is the home command for the toolchanger 
		modbus s1 f5 a23 v1
		
		while [#723 == 0]
			modbus s1 f2 a23 n1 u723 ;; poll homing status store in variable 723
			G4 P0.1 ;; wait 0.1 seconds
			#724 = [#724 + 1] ;; increment timeout counter
			
			if [#724 >= 60] ;; timeout occured, raise error
				errmsg "Failed to home toolchanger, timeout occured!"
			endif
		
		endwhile
		
			#725 = 1 ;; set homeing succesfull flag
		
		else
			msg "Toolchanger homing requirement already satisfied"
			#725 = 1
		endif
	
	else
	
	#725 = 1
	
	endif
	
	if [#725 == 1]
		#5011 = 1 ;; set tool during toolchange to 1, this is home position of toolchanger
		M6 T#5011 ;; set current tool to 1, without performing a toolchange
		#5015 = 1 ;; indicate succesfull toolchange
		msg "Home toolchanger"
	else
		errmsg "Toolchanger homing failed"
	endif
	
Endsub

;Home all axes, uncomment or comment the axes you want.
sub home_all
	gosub home_x
    gosub home_z
    gosub home_y
    gosub home_a
    gosub home_b
    gosub home_c
	gosub home_toolchanger
    msg "Home complete"
endsub

Sub zero_set_rotation
    msg "move to first point, press control-G to continue"
    m0
    #5020 = #5071 ;x1
    #5021 = #5072 ;y1
    msg "move to second point, press control-G to continue"
    m0
    #5022 = #5071 ;x2
    #5023 = #5072 ;y2
    #5024 = ATAN[#5023 - #5021]/[#5022 - #5020]
    if [#5024 > 45]
      #5024 = [#5024 - 90] ;points are in Y direction
    endif
    g68 R#5024
    msg "G68 R"#5024" applied, now zero XYZ normally"
Endsub


sub change_tool
    ;Switch off guard for tool change area collision
    ;TCAGuard off 

    ;Check ZHeight comp and switch off when on, remember the state in #5019
    ;#5151 indicates that ZHeight comp is on    
    ;#5019 = #5151
    ;if [#5019 == 1]
     ;   ZHC off
    ;endif
	
	#5021 = 0 ; timeout counter variable
    
   ;Switch off spindle
    M5
	
	; Goto toolchange position
	G0 ; rapid motion
	G30 ; move to safe position
	;G1 ;Set default motion type to G1   
	
    ;Use #5015 to indicate succesfull toolchange
    #5015 = 0 ; Tool change not performed
	
	; Only perform actual toolchange when not rendering or simulating
	if [[#5380==0] and [#5397==0]] ;do this only when not simulating and not rendering

		; check active tool and exit sub
		If [ [#5011] <> [#5008] ]
			if [[#5011] > 80 ]
				errmsg "Please select a tool in range from 1 to 80." 
			else
				;; command a toolchange
				modbus s1 f16 a2 n1 u5011 ;; TODO: check write single register, seemed to contain a bug.
			
				while [#5015 == 0]
			
					modbus s1 f3 a2 n1 u5020 ;; poll confirmed tool to variable ....
				
				
					if [[#5011 mod 8] == 0]
						; this is when requested tool is integer multiple of 8 (8 mod 8 = 0)
						if [#5020 == [#5020 + [#5011 mod 8]]];; 
						#5015 = 1 ;; confirmed tool equals requested, indicate succesfull toolchange
						endif
				
					else
						; this is for all tools not 0 and not integer multiple of 8
						if [#5020 == [#5011 mod 8]];; toolchanger confirms tools 1-7, so take 5011 modulo 8 for check condition
						#5015 = 1 ;; confirmed tool equals requested, indicate succesfull toolchange
						endif
					
					endif
				
				
			
					G4 P0.1 ;; wait 0.1 seconds
					#5021 = [#5021 + 1] ;; increment timeout counter
			
					if [#5021 >= 60] ;; timeout occured, raise error (timeout set to 6 seconds)
						errmsg "Toolchange failed, timeout occured!"
					endif
			
				endwhile
			
			endif
			
			
		else
			msg "Tool already active"
			#5015 = 1 ;indicate tool change performed
		endif
	
	else
		;; simulation or rendering: always succesfull toolchange
		#5015 = 1 ;indicate tool change performed
    endif    
	
                
    If [[#5015] == 1]   
        msg "Tool "#5008" Replaced by tool "#5011" G43 switched on"
        M6T[#5011]

        if [#5011 <> 0]
            G43  ;we use tool-length compensation.
        else
            G49  ;tool length compensation off for tool 0.
        endif
    else
        errmsg "tool change failed"
    endif
            
    ;Switch on guard for tool change area collision
    ;TCAGuard on
    
    ;Check if ZHeight comp was on before and switch ON again if it was.
    ;if [#5019 == 1]
    ;    ZHC on
    ;endif
        
EndSub      
     

sub zhcmgrid
;;;;;;;;;;;;;
;probe scanning routine for eneven surface milling
;scanning starts at x=0, y=0

  if [#4100 == 0]
   #4100 = 10  ;nx
   #4101 = 5   ;ny
   #4102 = 40  ;max z 
   #4103 = 10  ;min z 
   #4104 = 1.0 ;step size
   #4105 = 100 ;probing feed
  endif    

  #110 = 0    ;Actual nx
  #111 = 0    ;Actual ny
  #112 = 0    ;Missed measurements counter
  #113 = 0    ;Number of points added
  #114 = 1    ;0: odd x row, 1: even xrow

  ;Dialog
  dlgmsg "gridMeas" "nx" 4100 "ny" 4101 "maxZ" 4102 "minZ" 4103 "gridSize" 4104 "Feed" 4105 
    
  if [#5398 == 1] ; user pressed OK
    ;Move to startpoint
    g0 z[#4102];to upper Z
    g0 x0 y0 ;to start point
        
    ;ZHCINIT gridSize nx ny
    ZHCINIT [#4104] [#4100] [#4101] 
    
    #111 = 0    ;Actual ny value
    while [#111 < #4101]
        if [#114 == 1]
          ;even x row, go from 0 to nx
          #110 = 0 ;start nx
          while [#110 < #4100]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 + 1] ;next nx
          endwhile
          #114=0
        else
          ;odd x row, go from nx to 0
          #110 = [#4100 - 1] ;start nx
          while [#110 > -1]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 - 1] ;next nx
          endwhile
          #114=1
        endif
	  
      #111 = [#111 + 1] ;next ny
    endwhile
        
    g0 z[#4102];to upper Z
    ;Save measured table
    ZHCS zHeightCompTable.txt
    msg "Done, "#113" points added, "#112" not added" 
        
  else
    ;user pressed cancel in dialog
    msg "Operation canceled"
  endif
endsub

;Remove comments if you want additional reset actions
;when reset button was pressed in UI
;sub user_reset
;    msg "Ready for operation"
;endsub 

;The 4 subroutines below can be used to add extra code
;add the beginning and end for engrave or laser_engrave
sub laser_engrave_start
  msg "laser_engrave_start"
endsub

sub laser_engrave_end
  msg "laser_engrave_end"
endsub

sub engrave_start
  msg "laser_engrave_start"
endsub

sub engrave_end
  msg "laser_engrave_end"
endsub


; Functions below are used with sheetCAM 
; postprocessor Eding CNC plasma with THC-V2.scpost
sub thcOn
  m20
endsub

sub thcOff
  m21
endsub

sub thcPenDown
  gosub thcReference ; Determine zero pint always at start
  G0 Z4 ; 4 is pierce height. 0 is material surface.
  M3    ; plasma on
  G4 P3 ; pierce delay
endSub

sub thcPenUp
  m5    ; Plasma off
  g4 p1 ; end delay
endsub


sub thcReference
  if [[#5380 == 0] and [#5397 == 0]] ;Probe only when running
    G53 G38.2 Z[#5103+1] F50 ;lowest point 1 mm above negative Z limit with low Feed
    G0 Z[#5063] ;move back to toch point
    G92 Z0 ;Use 0 if the totch itself touches the material, otherwise use the switch offset
  endif
endsub

; The start subroutine is called when a job is started
sub start
  ; msg "start macro called"
endsub
