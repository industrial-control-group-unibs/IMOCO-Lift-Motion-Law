clear all;close all;clc;



floor_height=3;
num_floors=20;
BuildingHeight=num_floors*floor_height;
cabin_height=3;



MaxVel=2;
%Vmin=0.2;
MaxAcc=2;
MaxJerk=8;
CruiseVel=2;
vlim=MaxAcc^2/MaxJerk;
switch_distance=1;

final_p=BuildingHeight;

Ts=1e-3;

t=(0:Ts:(5))';

p=0;


if (CruiseVel^(1/2)*MaxJerk^(1/2)>MaxAcc)
    dec_distance_case=(CruiseVel*(MaxAcc^2 + CruiseVel*MaxJerk))/(2*MaxAcc*MaxJerk);
else
    dec_distance_case =CruiseVel^(3/2)/MaxJerk^(1/2);
end

for idx=1:length(t)
    pos(idx,1)=p;

    stop(idx,1)=pos(idx,1)>(final_p-switch_distance);
    [setpoint_vel(idx,1),setpoint_acc(idx,1)]=MotionLaw(MaxJerk,MaxAcc,CruiseVel,Ts,switch_distance,stop(idx,1));
    p=p+setpoint_vel(idx,1)*Ts+0.5*setpoint_acc(idx,1)*Ts^2;
end
plot(t,setpoint_vel,t,setpoint_acc,t,stop,'--k',t,pos)

grid on
xlabel('Time [s]')
legend({'Velocity','Acceleration','Switch signal','Position'})