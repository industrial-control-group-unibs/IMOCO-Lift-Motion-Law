clear all;close all;clc

num_floors=5;
sensor_height=0.1;
lower_floor_sensor_positions=3*(0:num_floors-1)'-0.5;
upper_floor_sensor_positions=3*(0:num_floors-1)'+0.5;
lower_proximity_sensor_positions=3*(0:num_floors-1)'-0.1;
upper_proximity_sensor_positions=3*(0:num_floors-1)'+0.1;


switches_position=[lower_floor_sensor_positions lower_proximity_sensor_positions upper_proximity_sensor_positions upper_floor_sensor_positions  ];
Ts=1e-3;

t=(0:Ts:40)';
position=num_floors*3*t/t(end);

simOut=sim('test_SwitchSensor.slx',[0 t(end)],'',[t position]);

time=simOut.tout;
switches=simOut.yout.signals(1).values;
pos=simOut.yout.signals(2).values;
plot(time,pos)
hold on

for idx=1:size(switches,2)
tmp=nan(length(time),1);
tmp(switches(:,idx)>=0)=switches_position(switches(switches(:,idx)>=0,idx),idx);
plot(time,tmp,'o')
end
hold off

legend({'cabin position' 'lower floor sensor positions' 'lower proximity sensor positions' 'upper proximity sensor positions' 'upper floor sensor positions'})