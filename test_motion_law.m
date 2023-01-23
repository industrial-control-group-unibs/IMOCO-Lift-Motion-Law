clear all;close all;clc;



floor_height=3;
num_floors=20;
BuildingHeight=num_floors*floor_height;
cabin_height=2.8;
proximity_distance=1;
gearbox=1;
max_load=800;


MaxVel=2;
MinVel=0.2;
MaxAcc=1;
MaxJerk=1;
CruiseVel=2;
vlim=MaxAcc^2/MaxJerk;
switch_distance=1;
waiting_time=4;
motion_profile=1;

destination_floor=BuildingHeight;
p=0;

Ts=1e-3;

t=(0:Ts:(1000))';


motion_law_idle=0;

for idx=1:length(t)
    pos(idx,1)=p;



    [floor_switches(idx,1),lower_proximity_switches(idx,1),upper_proximity_switches(idx,1)]=SwitchPosition(pos(idx),floor_height,num_floors,cabin_height,proximity_distance);

    [switch_activated(idx,1),switch_distance,cruise_velocity,direction,lift_idle(idx,1)]=LiftLogic(floor_switches(idx,1),...
        lower_proximity_switches(idx,1),...
        upper_proximity_switches(idx,1),...
        destination_floor,...
        motion_law_idle,...
        floor_height,...
        num_floors,...
        cabin_height,...
        proximity_distance,...
        motion_profile,...
        waiting_time,...
        MinVel,...
        MaxVel,...
        Ts);

    [setpoint_vel(idx,1),setpoint_acc(idx,1),motion_law_idle]=MotionLaw(MaxJerk,MaxAcc,CruiseVel,Ts,switch_distance,switch_activated(idx,1),lift_idle(idx,1)~=0);
    setpoint_vel(idx,1)=setpoint_vel(idx,1)*direction;
    setpoint_acc(idx,1)=setpoint_acc(idx,1)*direction;
    p=p+setpoint_vel(idx,1)*Ts+0.5*setpoint_acc(idx,1)*Ts^2;

    if (lift_idle(idx,1))
        destination_floor=randi(num_floors+1)-1;
    end
end

%%
figure(1)
subplot(2,1,1)
plot(t,pos/floor_height,t,switch_activated,'--k')
hold on
plot(t(floor_switches>=0),floor_switches(floor_switches>=0))
hold off

grid on
xlabel('Time [s]')
ylabel('Floor')

subplot(2,1,2)
plot(t,setpoint_vel,t,switch_activated,'--k')

grid on
xlabel('Time [s]')
ylabel('velocity')
