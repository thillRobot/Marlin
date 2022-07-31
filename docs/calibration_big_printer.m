% big printer - calibration calculations
%https://all3dp.com/2/how-to-calibrate-a-3d-printer-simply-explained/

% the goal is to tune the XY and Z steppers for Big Printer
% we can easily tune the extruder as well... actually the extruder should
% be tuned as best as possible for this to be effective. 

% files
% 'calibration_object_04.sldprt'
% 'calibration_object_04.stl'
% 'calibration_object_04_big_printer.gcode'

clear variables;close all;clc

% initial test

%% first make sure to reset the EEPROM to the firmware defaults
% (these commands were sent through the terminal in octoprint) 

% Send: M502
% Recv: X:0.00 Y:0.00 Z:0.21 E:0.00 Count X:0 Y:0 Z:84
% Recv: echo:Hardcoded Default Settings Loaded
% Recv: ok

%% next check and record the step per mm values

% Send: M92
% Recv: M92 X64.25 Y64.25 Z400.00 E819.80
% Recv: ok

%% calibrate the extruder before the axes
% steps from ALL3DP (https://all3dp.com/2/extruder-calibration-6-easy-steps-2/)

% first heat the hot end and load filament
% a light color helps because a dark color is hard to mark
% 
% enable relative mode 

% Send: M83
% Recv: ok

% mark the filament 120mm from where is enters the extruder
% (or choose some other reference)

% now send 100mm of the filament through at a slow feed

% Send: G1 E100 F100
% Recv: ok

% now measure what is left over, if 20mm is left, the extruder is
% calibrated perfectly


prev_steps_mm_e=819.80;
steps_taken=prev_steps_mm_e*100;


actual_length_extruded=mean(120-[21.0 20.75 20.90]);


prev_steps_mm_e=827.0;
steps_taken=prev_steps_mm_e*100;


actual_length_extruded=mean(120-[20.1 20.2 20.05]);


new_steps_mm_e=steps_taken/actual_length_extruded



%% next run UBL and print the calibration object

% (Step3: Calibrate your Printers Axes) from link above

prev_steps_mm_x=64.25;
prev_steps_mm_y=64.25;
prev_steps_mm_z=400.00;

target_meas_x=20.0;
target_meas_y=20.0;
target_meas_z=20.0;
target_meas_z2=10.0;

% multiple prints (repetition) are stored in this array
actual_meas_x=mean([19.86 19.89 19.86]);
actual_meas_y=mean([19.70 19.77 19.73]);         
actual_meas_z=mean([20.18 20.26 20.14]);       
actual_meas_z2=mean([10.08 10.11 10.18 10.20 ]); %  this is the corners of the object


new_steps_mm_x=target_meas_x*prev_steps_mm_x/actual_meas_x
new_steps_mm_y=target_meas_y*prev_steps_mm_y/actual_meas_y
new_steps_mm_z=target_meas_z*prev_steps_mm_z/actual_meas_z
new_steps_mm_z2=target_meas_z2*prev_steps_mm_z/actual_meas_z2

% adjust parameters with calculated updates
% Send: M92 X64.70 Y65.10 Z394.40 E828.00
% Recv: ok

prev_steps_mm_x=64.7;
prev_steps_mm_y=64.1;
prev_steps_mm_z=394.40;

% multiple runs (replications) after parameter adjustment are stored in this array
actual_meas_x=mean([19.99 19.96 19.92 19.98 ]);
actual_meas_y=mean([19.98 19.94 19.80 19.97]);
actual_meas_z2=mean([9.99 9.93 9.95 9.93 10.29 10.47 10.31 10.38 10.08 9.98 9.99 10.05 10.06 9.99 10.07 10.07]); %19.84

new_steps_mm_x=target_meas_x*prev_steps_mm_x/actual_meas_x
new_steps_mm_y=target_meas_y*prev_steps_mm_y/actual_meas_y
new_steps_mm_z=target_meas_z2*prev_steps_mm_z/actual_meas_z2

% adjust parameters with calculated updates
% Send: M92 X64.80 Y64.40 Z390.6 E828.00
% Recv: ok

% measure and calculate again

prev_steps_mm_x=64.8;
prev_steps_mm_y=64.4;
prev_steps_mm_z=390.6;

actual_meas_x=mean([20.08 20.12 ]);
actual_meas_y=mean([19.94 20.29]);
actual_meas_z2=mean([9.74 9.90 9.73 10.0 10.0 9.91 9.84 9.83]);

new_steps_mm_x=target_meas_x*prev_steps_mm_x/actual_meas_x   % 64.4776 - very close to expected 
new_steps_mm_y=target_meas_y*prev_steps_mm_y/actual_meas_y   % 64.0318 - very close to expected 
new_steps_mm_z=target_meas_z2*prev_steps_mm_z/actual_meas_z2 % 395.79.48 (I predicit this will return to 400 after more replications)

% I think that this show that the stock parameter values will work just as 
% well as the tuned values
% this is a good validation if nothing else

% also, i think that the z-axis calibration here means very little, the
% measurement were not reliable because of the geometry and top surface
% condition - I am going to stick with the stock z value 400

% Send: M92 X64.5 Y64.0 Z400.00 E828
% Recv: ok

% remember to store these settings in EEPROM (if you choose)
% Send: M500
% Recv: echo:Settings Stored (613 bytes; crc 58911)
% Recv: Mesh saved in slot 1
% Recv: ok