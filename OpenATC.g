; V0.1 written by https://github.com/DarkSlaayer

; --- Begin Tool Loading Macro ---

#<pos_x> = -280.6                 ; First spot in magazine (X)
#<pos_y> = -729.5                 ; First spot in magazine (Y)
#<collet_height> = -124.5         ; Height where spindle meets collet
#<safe_height> = -20.0            ; Safe height
#<load_rpm> = 1600.0              ; Spindle speed for loading tool
#<unload_rpm> = 1800.0            ; Spindle speed for unloading tool

; Probe variables
#<fast_rate> = 500                ; Fast probing speed
#<slow_rate> = 25                 ; Slow probing speed
#<probe_dist> = 100               ; Maximum distance to probe
#<safe_height> = -20.0            ; Safe Z height to travel and return to after probing
#<retract_height> = 10            ; Height to retract after probing the first time
#<probe_x> = -24.3                ; X position for probing
#<probe_y> = -784.6               ; Y position for probing

#<travel_feedrate> = 4000         ; Feedrate for X and Y travel

; Temporary tool positions
#<cur_temp_x> = 0.0
#<sel_temp_x> = 0.0

o100 if [#<_selected_tool> LT 0]
    (Print, Unknown tool currently loaded)
o100 else

o101 if [#<_loaded_tool> EQ 0]
    (Print, No tool loaded, continuing)
o101 endif

#<sel_temp_x> = [#<pos_x> + [38 * #<_selected_tool>] - 38]
#<cur_temp_x> = [#<pos_x> + [38 * #<_loaded_tool>] - 38]

(Print, Selected Pocket #5400 selected at #<sel_temp_x>)
(Print, Current tool Pocket #5400 selected at #<cur_temp_x>)

o202 if [FIX[#<_selected_tool>] NE FIX[#<_loaded_tool>]] ; If the requested tool is not already loaded

o203 if [FIX[#<_loaded_tool>] EQ 0] ; No tool loaded
    M5                              ; 1. Ensure the spindle is off
    G53 Z[#<safe_height>] F1000     ; 2. Move to safe height Z = -20 mm using machine coordinates
    G53 X[#<sel_temp_x>] Y[#<pos_y>] F1200 ; 3. Move to selected tool position
    M3 S#<load_rpm>                 ; 4. Start spindle at loading RPM
    G53 Z[#<collet_height>] F1200   ; 5. Move down to collet height
    M5                              ; 6. Turn off the spindle
    G91 G0 Z30 F1000                ; 7. Retract spindle up by 30 mm relative
    M3 S#<load_rpm>                 ; 8. Start spindle again for second tightening
    G53 Z[#<collet_height>] F2000   ; 9. Move down to collet height again
    M5                              ; 10. Turn off the spindle
    G53 Z[#<safe_height>] F1000     ; 11. Return to safe height
    #<_loaded_tool> = [#<_selected_tool>]
    (Print, Tool loaded)

    ; Probing routine
    G53 G0 Z#<safe_height>
    G53 G0 X#<probe_x> Y#<probe_y> F#<travel_feedrate> ; Move to probe point location
    G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> P0       ; Fast probe towards workpiece
    G0 Z3                                              ; Retract to compensate overtravel
    G38.2 G91 Z[-#<retract_height> - 1] F#<slow_rate>  ; Probe slowly for precision
    G53 G0 Z#<safe_height>
o203 else
    o204 if [FIX[#<_selected_tool>] EQ 0] ; Unloading current tool to original spot
        M5                              ; 1. Ensure the spindle is off
        G53 Z[#<safe_height>] F1000     ; 2. Move to safe height
        G53 X[#<cur_temp_x>] Y[#<pos_y>] F1200 ; 3. Move to current tool position
        M4 S#<unload_rpm>               ; 4. Start spindle at unloading RPM
        G53 Z[#<collet_height>] F2000   ; 5. Move down to collet height
        M5                              ; 6. Turn off the spindle
        G53 Z[#<safe_height>] F1000     ; 7. Return to safe height
        #<_loaded_tool> = [#<_selected_tool>]
        (Print, Tool unloaded)
    o204 else
        ; Unload current tool and load the new one
        M5                              ; 1. Ensure the spindle is off
        G53 Z[#<safe_height>] F1000     ; 2. Move to safe height
        G53 X[#<cur_temp_x>] Y[#<pos_y>] F1200 ; 3. Move to current tool position
        M4 S#<unload_rpm>               ; 4. Start spindle at unloading RPM
        G53 Z[#<collet_height>] F2000   ; 5. Move down to collet height
        M5                              ; 6. Turn off the spindle
        G53 Z[#<safe_height>] F1000     ; 7. Return to safe height
        (Print, Tool unloaded)

        ; Load new tool
        G53 X[#<sel_temp_x>] Y[#<pos_y>] F1200 ; Move to selected tool position
        M3 S#<load_rpm>                 ; Start spindle at loading RPM
        G53 Z[#<collet_height>] F1200   ; Move down to collet height
        M5                              ; Turn off the spindle
        G91 G0 Z30 F1000                ; Retract spindle up by 30 mm relative
        M3 S#<load_rpm>                 ; Start spindle again for second tightening
        G53 Z[#<collet_height>] F2000   ; Move down to collet height again
        M5                              ; Turn off the spindle
        G53 Z[#<safe_height>] F1000     ; Return to safe height
        #<_loaded_tool> = [#<_selected_tool>]

        ; Probing routine
        G53 G0 Z#<safe_height>
        G53 G0 X#<probe_x> Y#<probe_y> F#<travel_feedrate> ; Move to probe point location
        G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> P0       ; Fast probe towards workpiece
        G0 Z3                                              ; Retract to compensate overtravel
        G38.2 G91 Z[-#<retract_height> - 1] F#<slow_rate>  ; Probe slowly for precision
        G53 G0 Z#<safe_height>
        (Print, Tool loaded)
    o204 endif

o203 endif
o202 endif
o100 endif

; --- End Tool Loading Macro ---
