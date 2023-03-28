clear all;close all;

StartMovement = false;
HighSpeedSwitch = false;
    SlowSpeedSwitch = false;
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
    Ts=0.001;


position=0;
floor=6;

[t1a,t2a,t3a,deceleration_distance_1]=computeSwitchDistance(DecelInitialJerk*PercentAccFactor,DecelEndJerk*PercentAccFactor,0,HighSpeed,LowSpeed,Deceleration*PercentAccFactor);
[t1b,t2b,t3b,deceleration_distance]  =computeSwitchDistance(DecelInitialJerk*PercentAccFactor,DecelEndJerk*PercentAccFactor,0,LowSpeed,0,StopDeceleration*PercentAccFactor);
% 
% if (LowSpeed^(1/2)*(DecelEndJerk*PercentAccFactor)^(1/2)>StopDeceleration) % case 1
%     deceleration_distance=(LowSpeed*(StopDeceleration^2 + LowSpeed*DecelEndJerk*PercentAccFactor))/(2*LowSpeed*DecelEndJerk*PercentAccFactor);
% else % case 2
%     deceleration_distance =LowSpeed^(3/2)/(DecelEndJerk*PercentAccFactor)^(1/2);
% end

% if ((HighSpeed-LowSpeed)^(1/2)*(DecelEndJerk*PercentAccFactor)^(1/2)>Deceleration) % case 1
%     deceleration_distance_1=((HighSpeed-LowSpeed)*(Deceleration^2 + (HighSpeed-LowSpeed)*DecelEndJerk*PercentAccFactor))/(2*(HighSpeed-LowSpeed)*DecelEndJerk*PercentAccFactor);
% else % case 2
%     deceleration_distance_1 =(HighSpeed-LowSpeed)^(3/2)/(DecelEndJerk*PercentAccFactor)^(1/2);
% end

LowSpeedSwitchPosition=floor-deceleration_distance;


HighSpeedSwitchPosition=LowSpeedSwitchPosition-deceleration_distance_1;
idx=1;

sensor_dimension=0.1;

flag=false;
while idx<1e5
    StartMovement=(idx==100);
        
    HighSpeedSwitch= (position>HighSpeedSwitchPosition);
    SlowSpeedSwitch= (position>LowSpeedSwitchPosition); 
    [setpoint_vel,setpoint_acc,setpoint_jerk,idle,state(idx,1)]=WegMotionLaw(...
            StartMovement, ...
        HighSpeedSwitch, ...
        SlowSpeedSwitch, ...
        HighSpeed, ...
        LowSpeed, ...
        PercentAccFactor, ...
        AccelInitialJerk, ...
        Acceleration, ...
        AccelEndJerk, ...
        DecelInitialJerk, ...
        Deceleration, ...
        DecelEndJerk, ...
        StopDeceleration, ...
        Ts);

    position=position+setpoint_vel*Ts+0.5*setpoint_acc*Ts^2+1.0/6.0*setpoint_jerk*Ts^3;
    pos(idx,1)=position;
    vel(idx,1)=setpoint_vel;
    acc(idx,1)=setpoint_acc;
    jerk(idx,1)=setpoint_jerk;
    t(idx,1)=(idx-1)*Ts;
    idx=idx+1;
    if idle && flag
        break;
    elseif ~(idle)
        flag=true;
    end
end
fprintf('final position = %f (desired %f)\n',position,floor)
subplot(5,1,1)
plot(t,pos)

subplot(5,1,2)
plot(t,vel)

subplot(5,1,3)
plot(t,acc)

subplot(5,1,4)
plot(t,jerk)

subplot(5,1,5)
plot(t,state)