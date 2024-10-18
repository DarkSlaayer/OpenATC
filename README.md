OpenATC is an open source Automatic Tool Changer system for FluidNC.
It currently supports magazine style tool changers like RapidChange ATC and TLO Probing. 
This is ALPHA software and comes with no guarantees.

This is very early stages and the macros are very messy things will change often.

THIS IS NOT PERSISTANT IT WILL NOT SAVE WHAT TOOLS YOU HAVE INSTALLED AFTER RESTART
DUE TO A BUG? I HAVE THE TOOL NUMBER SET TO 0 AFTER HOMING AFTER STARTING YOUR CNC ONLY HOME IT ONCE.

How to install. Theres also an example config.yaml 

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
