OpenATC is an open source Automatic Tool Changer system for FluidNC.
It currently supports magazine style tool changers like RapidChange ATC and TLO Probing. 
This is ALPHA software and comes with no guarantees.

This is very early stages and the macros are very messy things will change often.

THIS IS NOT PERSISTANT IT WILL NOT SAVE WHAT TOOLS YOU HAVE INSTALLED AFTER RESTART
DUE TO A BUG? I HAVE THE TOOL NUMBER SET TO 0 AFTER HOMING AFTER STARTING YOUR CNC ONLY HOME IT ONCE.

How to install. Theres also an example config.yaml 

```
#<pos_x> = -280.6 ;first spot in mag x
#<pos_y> = -729.5 ;first spot in mag y
#<collet_height> = -124.5 ;where spindle meets collet
#<safe_height> = -20.0 ;safe travel height
#<load_rpm> = 1600.0 ;your load rpm
#<unload_rpm> = 1800.0 ;your unload rpm

;Probe vars

#<fast_rate>=500    ; Fast probing speed
#<slow_rate>=25   ; Slow probing speed
#<probe_dist>=100   ; Maximum distance to probe
#<safe_height>=-20 ; Safe Z height to travel and return to after probing
#<retract_height>=10 ; Height to retract after probing the first time
#<probe_x>=-24.3 ;probe x location
#<probe_y>=-784.6 ;probe y location

#<travel_feedrate>=4000 ; Feedrate for X and Y travel
```

Upload the OpenATC.g file to your ESP32 not your SD Card.

Your FluidNC config.yaml requires the items below
```
macros:
  startup_line0:
  startup_line1:
  macro0:
  macro1: 
  after_homing: #<_loaded_Tool>=0 
```
and under your spindle put
```
  M6_macro: $LocalFS/Run=OpenATC.g
```

  as an example
```
H100:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 1200=5% 6000=25% 24000=100%
  M6_macro: $LocalFS/Run=OpenATC.g
```
  
  NOT RESPONSIBLE FOR ANY DAMAGE DONE TO YOUR CNC THIS IS ALPHA SOFTWARE DONT TOUCH ANYTHING IF YOU DONT KNOW WHAT YOU ARE DOING BECAUSE I DONT KNOW WHAT IM DOING EITHER SO I CANT GUARANTEE ANYTHING!
