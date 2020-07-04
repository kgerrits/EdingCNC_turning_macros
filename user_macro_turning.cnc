;;Turning macro example
;;;;;;;;;;;;;;;;;;;;;;;;;
;;Requires dialog picture cycle_turn_concave.png and cycle_turn_connvex.png and cycle_turn_thread_straight.png in c:\cnc4.03\dialogPictures
;;Requires icon directory set ton c:\cnc4.03\icons_turning with user button bitmaps changed
;;user_macro set to this file

;;(#199) remembers last cycle number
;;(#200) D is diameter of stock material
;;
;;(#201), #202) X1,Z1 start turning position  
;;(#203), #204) X2, Z2 end position of arc
;;(#205), R radius of arc
;;(#206), rouging-step is step is delta-x for rouching phase
;;(#207), finish-step is left over after roughing
;;(#208), Rouching Feed
;;(#209), Finish Feed
;;(#251), X Start point
;;(#252), Z start point 

sub user_11
 ;g0 x70 Z200 ;;Just for testing, remove!!!
 gosub cycle_turn_concave_diameterprogramming
endsub

sub user_12
 ;g0 x70 Z200 ;;Just for testing, remove!!!
 gosub cycle_turn_convex_diameterprogramming
endsub

sub user_13
 ;g0 x70 Z200 ;;Just for testing, remove!!!
 gosub cycle_turn_thread_straight
endsub



;########## Concave ##############
sub cycle_turn_concave_diameterprogramming

  ;;For testing, defaults, change if you like
  if [#199 <> 1]
    #199 = 1
    #200 = 60
    #201 = 30
    #202 = 190
    #203 = 50  
    #204 = 150
    #205 = 10
    #206 = 2.0
    #207 = 0.2
    #208 = 2000
    #209 = 400
  endif


  dlgmsg "cycle_turn_concave" "D" 200 "X1" 201 "Z1" 202 "X2" 203 "Z2" 204 "R" 205 "Roughing-step" 206 "Finish-step" 207 "R-Feed" 208 "F-Feed" 209
    if [#5398 == -1]
    m30
  endif
  
  ;;Store our start point, so we can move back to it after
  #251 = #5001  ;X See system-parameters in manual
  #252 = #5003  ;Z See system-parameters in manual
  
  
  ;;checks
  if [#201 > #203]
    errmsg "Error X1 > X2"
  endif
  
  if [#202 < #204]
    errmsg "Error Z1 < Z2"
  endif
  
  if [#5001 < #200]
    errmsg "Wrong start position for X"
  endif

  if [#5003 < #204]
    errmsg "Wrong start position for Z"
  endif

  
  
  ;;Roughing
  ;;1. Loop from X=D to where the radius starts, this is at X2 + R-Feed
  ;;#301 --> loop X
  ;;#302 --> loop Z
  ;;#303 --> X where arc ends X1 + Radius
  ;;#304 --> Z where arc starts Z2 + Radius 
  ;;#305 --> X delta inside ARC
  ;;#306 --> Z delta inside ARC, calculated by pythagoras
  
  #303 = [#201 + #205] ;Arc end point X value, Z value == Z2
  #304 = [#204 + #205] ;Arc start point Z value, X value == X1
  
  #301 = [#200] ;First roughing pass start X at stock radius D
  
  while [#301 > [#201 + #207]] ;;Continue until loop X has reached X1+Finish

    ;;Next rouging-step, Loop X = Loop X - Roughing-step
    #301 = [#301 - #206]

    
    ;;Limit loop X if passed X1 and finish allowance
    if [#301 < [#201 + #207]]
      #301 = [#201 + #207]
    endif
  
    ;;Calculate Z pos for roughing
    if [#301 < #203]
      ;We are in the arc, use pythaoras to calulate the pieze of Z inside the arc
      ;X delta is X2 - loop X, we have a triangle with diagonal R and vertical X delta, so we can calculate Z delta
      #305 = [[#203 - #301] / 2]
      #306 = SQRT[[#205 * #205] - [#305 * #305]] 
      #302 = [#204 + [#205 - #306] + #207] 
      msg "Xloop="#301 " Xdelta="#305 " Zdelta="#306 " newZ="#302
      
    else
      ;Not yet in the arc, z value becomes Z2 + finish step
      #302 = [#204 + #207]
    endif

    ;;Now that we have calculated all, do the movement, back off 1mm and go back
    G0 F#208 X#301
    G1 F#208 Z#302
    G0 X[#301+1] Z[#302+1] ;1 mm away from material
    G0 Z#252 ;back to start
    ;;Done 1 pass rouching
    
  endwhile
  
  ;;Roughing done, now do the finishing pass
  m1 ; Debugging
  G0 X#201
  G1 F#209 Z#304
  G3 X#203 Z#204 R#205
  G1 X[#200+#206] ; + rouging step to be out of the stock material .
  G0 Z#252 ;Back to start

endsub


;########## Convex ##############

sub cycle_turn_convex_diameterprogramming

  ;;For testing, defaults, change if you like
  if [#199 <> 2]
    #199 = 2
    #200 = 60
    #201 = 30
    #202 = 190
    #203 = 50  
    #204 = 150
    #205 = 10
    #206 = 2.0
    #207 = 0.2
    #208 = 2000
    #209 = 400
  endif


  dlgmsg "cycle_turn_convex" "D" 200 "X1" 201 "Z1" 202 "X2" 203 "Z2" 204 "R" 205 "Roughing-step" 206 "Finish-step" 207 "R-Feed" 208 "F-Feed" 209
  if [#5398 == -1]
    m30
  endif
  
  
  
  ;;Store our start point, so we can move back to it after
  #251 = #5001  ;X See system-parameters in manual
  #252 = #5003  ;Z See system-parameters in manual
  
  
  ;;checks
  if [#201 > #203]
    errmsg "Error X1 > X2"
  endif
  
  if [#202 < #204]
    errmsg "Error Z1 < Z2"
  endif
  
    if [#5001 < #200]
    errmsg "Wrong start position for X"
  endif

  if [#5003 < #204]
    errmsg "Wrong start position for Z"
  endif
  
  
  ;;Roughing
  ;;1. Loop from X=D to where the radius starts, this is at X2 + R-Feed
  ;;#301 --> loop X
  ;;#302 --> loop Z
  ;;#303 --> X where arc ends X1 + Radius
  ;;#304 --> Z where arc starts Z2 + Radius 
  ;;#305 --> X delta inside ARC
  ;;#306 --> Z delta inside ARC, calculated by pythagoras
  
  #303 = [#201 + #205] ;Arc end point X value, Z value == Z2
  #304 = [#204 + #205] ;Arc start point Z value, X value == X1
  
  #301 = [#200] ;First roughing pass start X at stock diameter D
  
  while [#301 > [#201 + #207]] ;;Continue until loop X has reached X1+Finish

    ;;Next rouging-step, Loop X = Loop X - Roughing-step
    #301 = [#301 - #206]

    
    ;;Limit loop X if passed X1 and finish allowance
    if [#301 < [#201 + #207]]
      #301 = [#201 + #207]
    endif
  
    ;;Calculate Z pos for roughing
    if [#301 < #203]
      m1 ; Debugging
      ;We are in the arc, use pythaoras to calulate the pieze of Z inside the arc
      ;X delta is X2 - loop X, we have a triangle with diagonal R and vertical X delta, so we can calculate Z delta
      
      ;For diameter programming and calculation of the Z delta value, 
      ;the X coordinate needs to be divided by 2.
      
      #305 = [[#301 - #201] / 2]
      #306 = SQRT[ [#205 * #205] - [#305 * #305]] 
      #302 = [#204 + #306 + #207] 
      msg "Xloop="#301 " Xdelta="#305 " Zdelta="#306 " newZ="#302
      
    else
      ;Not yet in the arc, z value becomes Z2 + finish step
      #302 = [#204 + #207]
    endif

    ;;Now that we have calculated all, do the movement, back off 1mm and go back
    G0 F#208 X#301
    G1 F#208 Z#302
    G0 X[#301+1] Z[#302+#206] ;roughing step away from material
    G0 Z#252
    ;;Done 1 pass rouching
    
  endwhile
  
  ;;Roughing done, now do the finishing pass
  G0 X#201
  G1 F#209 Z#304
  G2 X#203 Z#204 R#205
  G1 X[#200+#206] ; + rouging step to be out of the stock material .
  G0 Z#252 ;Back to start

endsub


;########## Straight Thread ##############

sub cycle_turn_thread_straight


    ;For testing. change if you like
    if [#199 <> 3]
      #199 = 3
      #200 = 3   ;;Depth of thread
      #201 = 30  ;;Thread from start Z to this value
      #202 = 50  ;;Thread outside diameter
      #203 = 0.5 ;;Cut-depth per cycle
      #204 = 3   ;;Thread-depth
      #205 = 400 ;;Spindle speed, spindle must be turned on before starting G76.
    endif

    dlgmsg "cycle_turn_thread_straight" "P" 200 "Z" 201 "I" 202 "J" 203 "K" 204 "Speed" #205
    if [#5398 == -1]
      m30
    endif
    
    if [[#5003 - #201] < 1] 
        errmsg "Thread length < 1 mm ?"
    endif
    

    m3 S#205
    G76 P#200 Z#201 I#202 J#203 K#204
    m5
endsub



