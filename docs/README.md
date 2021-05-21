# Marlin
This is a custom configured version of the Marlin2 firmware for the Velleman KD8200(this might be wrong num) 'Big-Printer'.

## MakerGear M2 - Customized 
- Hotend - E3D v6 with titanium heat break
- Extruder - Custom build from $10 amazon special and geared stepper
- Bed - Heated bed for MakerGear M2 with picture frame glass
- Adhesion - Painters Tape / Polyamide Tape / Build Surface

## Installing/Updating Firmware on the Marlin M2-TWH Printer

### Install Arduino IDE 
The Arduino version must be >= 1.8.8 based on the instructions on the [Marlin Github](https://github.com/thillRobot/marlin_m2/tree/master/Marlin-2.0.m2)

Version 1.8.10 in my `Dropbox/threedee_printing` directory as an executable

The `U8glib` arduino library is needed. This can be installed through the arudino IDE by clicking `Sketch>Include Library>Manage Libraries`


## Replacing Nozzle on Marlin M2-TWH Printer

Follow the assembly instructions for assembling the E3D V6 Hotend [here](https://e3d-online.dozuki.com/Guide/V6+Assembly/6). Read the instructions, but you are looking for the *hot tightening* procedure.

The *hot tightening* procedure requires the nozzle to be set to 285 which is outside of the normal/safe range of temps for the hotend. The max nozzle temp must be temporarily set to 285 for the mozzle to be replaced. Make sure to reset the limit to a safe xyz after installing a nozzle.

**Note:** A steel adjustable wrench will change the temperature of the hotend very quickly and often trigger reset if you are not quick.

## PID Tuning for Hotend
## G-Code - this orginally came from the marlin website [here](https://marlinfw.org/docs/features/unified_bed_leveling.html#unified-bed-leveling)
## Start Code - Initialize UBL - Generates and Saves New Mesh
```
M502          ; Reset settings to configuration defaults...
;M500         ; ...and Save to EEPROM. Use this on a new install.  
M501          ; Read back in the saved EEPROM.

M190 S65      ; Not required, but having the printer at temperature helps accuracy
M104 S210     ; Not required, but having the printer at temperature helps accuracy

G28           ; Home XYZ.
G29 P1        ; Do automated probing of the bed. ; 
;G29 P2 B T  ; Manual probing of locations. USUALLY NOT NEEDED! 
G29 P3 T      ; Repeat until all mesh points are filled in.

G29 T         ; View the Z compensation values.
G29 S1        ; Save UBL mesh points to EEPROM.
G29 F 10.0    ; Set Fade Height for correction at 10.0 mm.
G29 A         ; Activate the UBL System.
M500          ; Save current setup. WARNING - UBL will be active at power up, before any G28.
```
## Start Code - Print UBL - Tilts Previously Saved Mesh
```
G28 ; home all axes
G1 Z5 F5000 ; lift nozzle

G29 L1        ; Load the mesh stored in slot 1 (from G29 S1)
G29 J         ; No size specified on the J option tells G29 to probe the specified 3 points and tilt the mesh according to what it finds.

```
## End Code - Home and Cooldown
```
M104 S0 ; turn off temperature
M190 S0; turn off bed
G28 X0  ; home X axis
M84     ; disable motors
```

## Measuring and defining the extruder steps per millimeter
 // twh 04/26/2020
 // complete the '100 mm' extruder test. (https://all3dp.com/2/extruder-calibration-6-easy-steps-2/)
 // * you must heat the nozzle of course
 // 1) Mark 120mm from the entrance to extruder
 // 2) send commands M83 (relative extruder mode) 
 // 3) send command G1 E100 F100 (extrude 100mm of filament)
 // 4) after motion stops measure distance from mark to entrance. If you are perfect it will be 120-100=20. If not record this number. 26mm
 // 5) send M503 this is what I got 'echo:  M851 X34.00 Y5.00 Z8.00' // i calibrated and got 851 before moving to marlin2
 // 6) 120 – [length from extruder to mark] = [actual length extruded], 120-26=94
 // 7)[steps/mm value] x 100 = [steps taken], 500*100=50000
 // 8)[steps taken] / [actual length extruded] = [accurate steps/mm value], 50000/94 =531.9 // this number works very good, almost exactly 20mm left!


i


## Things to do:

- [ ] work on this repo, good documentation will improve printing success
- [ ] learn how to save prusaslicer settings for export, the printer settings specifically
- [x] convert this repo to a fork of Marlin2, learn about forking(in process)
- [ ] update 'big-printer' firmware and move from old repo to new branch 'big-2.0.x' or similar of this repo 
	-> 2.0.x does not compile for BOARD_EINSY_RAMBO, error "init is not a member U8glib"
- [x] copy and test settings from configurtion.h and configuration_adv.h for bug-printer (EISNYRAMBO)
- [ ] install and configure second titan aero extruder hotend combo for dual extrusion 
