

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
	
	
;; turning routine

;; goto safety position
G0 X[#1810] Z[#1809]

;; enable spindle constant cutting speed
; -------------------------------------------------------------
;; gosub start_spindle_constant_cutting_speed

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
	G4 P1.5 ;; wait for Pxx seconds
	
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

M9
M5
M30

