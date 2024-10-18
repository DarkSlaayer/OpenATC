;V0.1 written by https://github.com/DarkSlaayer
; --- Begin Tool Loading Macro ---
#<pos_x> = -280.6 ;first spot in mag x
#<pos_y> = -729.5 ;first spot in mag y
#<collet_height> = -124.5 ;where spindle meets collet
#<safe_height> = -20.0
#<load_rpm> = 1600.0
#<unload_rpm> = 1800.0

;Probe vars

#<fast_rate>=500    ; Fast probing speed
#<slow_rate>=25   ; Slow probing speed
#<probe_dist>=100   ; Maximum distance to probe
#<safe_height>=-20 ; Safe Z height to travel and return to after probing
#<retract_height>=10 ; Height to retract after probing the first time
#<probe_x>=-24.3
#<probe_y>=-784.6

#<travel_feedrate>=4000 ; Feedrate for X and Y travel


;dont touch below this line

#<cur_temp_x> = 0.0
#<sel_temp_x> = 0.0

o100 if [#<_selected_tool> LT 0]
	(Print, Unknown tool currently loaded)
o100 else

o101 if [#<_loaded_Tool> EQ 0]
	(Print, No tool loaded continueing)
o101 endif
		
	

		#<sel_temp_x> = [#<pos_x> + [38 * #<_selected_tool>] - 38]

		#<cur_temp_x> = [#<pos_x> + [38 * #<_loaded_Tool>] - 38]
	
	
			(Print, Selected Pocket #5400 selected at #<sel_temp_x>)
			(Print, Current tool Pocket #5400 selected at #<cur_temp_x>)
	
	o202 if [FIX[#<_selected_tool>] NE FIX[#<_loaded_Tool>]] ; if not requesting the tool we already have
	
	o203 if [FIX[#<_loaded_Tool>] EQ 0] ; no loaded tool
	
			M5                          ; 1. Ensure the spindle is off
		G53 Z[#<safe_height>] F1000              ; 2. Move to safe height Z = -20 mm using machine coordinates
		G53 X[#<sel_temp_x>] Y[#<pos_y>] F1200   ; 3. Move to Tool 1 position using machine coordinates
		M3 S#<load_rpm>
		G53 Z[#<collet_height>] F1200         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G0 Z30 F1000             
		M3 S#<load_rpm>
		G53 Z[#<collet_height>] F2000         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G53 Z[#<safe_height>] F1000              ; 15. Return to safe height Z = -20 mm
		#<_loaded_Tool> = [#<_selected_tool>]
		(print, Tool loaded)
		;probing
		G53 G0 Z#<safe_height>

		G53 G0 X#<probe_x> Y#<probe_y> F#<travel_feedrate>   ; Move to probe point location

		G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> P0 ; Fast probe towards workpiece
		G0 Z3                                 ; Retract a little to compensate overtravel
		G38.2 G91 Z[-#<retract_height> - 1] F#<slow_rate>  ; Probe slowly for precision
		G53 G0 Z#<safe_height>   
	
	o203 else
	
		o204 if [FIX[#<_selected_tool>] EQ 0] ;if unloading a tool to original spot
		M5                          ; 1. Ensure the spindle is off
		G53 Z[#<safe_height>] F1000              ; 2. Move to safe height Z = -20 mm using machine coordinates
		G53 X[#<cur_temp_x>] Y[#<pos_y>] F1200   ; 3. Move to Tool 1 position using machine coordinates
		M4 S#<unload_rpm>
		G53 Z[#<collet_height>] F2000         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G53 Z[#<safe_height>] F1000              ; 15. Return to safe height Z = -20 mm
		#<_loaded_Tool> = [#<_selected_tool>]
		(print, Tool unloaded)
		o204 else
				M5                          ; 1. Ensure the spindle is off
		G53 Z[#<safe_height>] F1000              ; 2. Move to safe height Z = -20 mm using machine coordinates
		G53 X[#<cur_temp_x>] Y[#<pos_y>] F1200   ; 3. Move to Tool 1 position using machine coordinates
		M4 S#<unload_rpm>
		G53 Z[#<collet_height>] F2000         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G53 Z[#<safe_height>] F1000              ; 15. Return to safe height Z = -20 mm
		(print, Tool unloaded)
		
					M5                          ; 1. Ensure the spindle is off
		G53 Z[#<safe_height>] F1000              ; 2. Move to safe height Z = -20 mm using machine coordinates
		G53 X[#<sel_temp_x>] Y[#<pos_y>] F1200   ; 3. Move to Tool 1 position using machine coordinates
		M3 S#<load_rpm>
		G53 Z[#<collet_height>] F1200         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G0 Z30 F1000              ; 15. Return to safe height Z = -20 mm
				M3 S#<load_rpm>
		G53 Z[#<collet_height>] F2000         ; 5. Move down to Z = -124.500 mm using machine coordinates
		M5                          ; 6. Turn off the spindle
		G53 Z[#<safe_height>] F1000              ; 15. Return to safe height Z = -20 mm
		#<_loaded_Tool> = [#<_selected_tool>]
		
		G53 G0 Z#<safe_height>

		G53 G0 X#<probe_x> Y#<probe_y> F#<travel_feedrate>   ; Move to probe point location

		G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> P0 ; Fast probe towards workpiece
		G0 Z3                                  ; Retract a little to compensate overtravel
		G38.2 G91 Z[-#<retract_height> - 1] F#<slow_rate>  ; Probe slowly for precision
		G53 G0 Z#<safe_height>   
		
		(print, Tool loaded)
		o204 endif

		
	o203 endif
	o202 endif
	

o100 endif

; --- End Tool Loading Macro ---
