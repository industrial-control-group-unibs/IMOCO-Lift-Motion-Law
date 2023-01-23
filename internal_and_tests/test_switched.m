clear all;close all;clc;


floor_height=3;
num_floors=20;
BuildingHeight=num_floors*floor_height;
cabin_height=2.7;
proximity_distance=0.5;


pos=linspace(0,BuildingHeight,1e3);

for ip=1:length(pos)
    [floor_switches(ip,1),lower_proximity_switches(ip,1),upper_proximity_switches(ip,1)]=SwitchPosition(pos(ip),floor_height,num_floors,cabin_height,proximity_distance);
end

plot(pos,floor_switches,pos,lower_proximity_switches,pos,upper_proximity_switches)