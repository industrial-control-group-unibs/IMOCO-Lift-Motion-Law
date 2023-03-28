clear all;close all;clc;



floor_height=3;
num_floors=20;
BuildingHeight=num_floors*floor_height;
gearbox=1;
max_load=800;
Rp=0.5;

HighSpeed = 1.0;
LowSpeed = 0.07;
PercentAccFactor = 1.0;

AccelInitialJerk = 0.2;
Acceleration = 0.6;
AccelEndJerk = 0.6;
DecelInitialJerk = 0.6;
Deceleration = 0.31;
DecelEndJerk = 0.5;
StopDeceleration = 0.3;

sensor_height=0.1;
waiting_time_open_door=2;    % Time to open the doors
waiting_time_close_door=2;   % Time to close the doors
waiting_time_close_brake=1;  % Time to close the brake
waiting_time_open_brake=1;   % Time to open the brake
waiting_time_steady_state=1; % Time to reach zero velocity


[t1a,t2a,t3a,deceleration_distance]=computeSwitchDistance(DecelInitialJerk*PercentAccFactor,DecelEndJerk*PercentAccFactor,0,HighSpeed,LowSpeed,Deceleration*PercentAccFactor);
[t1b,t2b,t3b,proximity_deceleration_distance]  =computeSwitchDistance(DecelInitialJerk*PercentAccFactor,DecelEndJerk*PercentAccFactor,0,LowSpeed,0,StopDeceleration*PercentAccFactor);

lower_floor_sensor_positions=3*(0:num_floors-1)'-proximity_deceleration_distance-deceleration_distance;
upper_floor_sensor_positions=3*(0:num_floors-1)'+proximity_deceleration_distance+deceleration_distance;
lower_proximity_sensor_positions=3*(0:num_floors-1)'-proximity_deceleration_distance-.1;
upper_proximity_sensor_positions=3*(0:num_floors-1)'+proximity_deceleration_distance+.1;


destination_floor=0;
p=0;

Ts=1e-3;

t=(0:Ts:(1000))';


motion_law_idle=0;
