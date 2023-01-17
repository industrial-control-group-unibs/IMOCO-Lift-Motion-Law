function [setpoint_vel,setpoint_acc]=MotionLaw(MaxJerk,MaxAcc,CruiseVel,Ts,switch_distance,switch_activated)

persistent state vel acc pos
if isempty(state)
    state=1;
    vel=0;
    acc=0;
    pos=0;
end

% compute deceleration distance: 
% case 1: the maximum acceleration is reached
% case 2: the maximum acceleration is not reached
if (CruiseVel^(1/2)*MaxJerk^(1/2)>MaxAcc) % case 1
    deceleration_distance=(CruiseVel*(MaxAcc^2 + CruiseVel*MaxJerk))/(2*MaxAcc*MaxJerk);
else % case 2
    deceleration_distance =CruiseVel^(3/2)/MaxJerk^(1/2);
end

if (state==1)  %increase acceleration
    jerk=MaxJerk;
elseif (state==2) % max acceleration
    jerk=0;
elseif (state==3) % decrease acceleration
    jerk=-MaxJerk;
elseif (state==4) % keep cruise velocity
    jerk=0;
elseif (state==5) % kep cruise velocity, switch has been triggered
    jerk=0;
elseif (state==6) % decrease acceleration (to slow down speed)
    jerk=-MaxJerk;
elseif (state==7) % max negative acceleration (to slow down speed)
    jerk=0;
elseif (state==8) % increase acceleration (to return to null acceleration)
    jerk=MaxJerk;
else % steaty-state case
    jerk=0;
    vel=0;
    acc=0;
end


pos=pos+vel*Ts+0.5*acc*Ts^2+1.0/6.0*jerk*Ts^3; % traveled distance
vel=vel+acc*Ts+0.5*Ts*Ts*jerk; % velocity
acc=acc+Ts*jerk; % acceleration

limit_velocity=CruiseVel-acc^2/(2*MaxJerk); % velocity limit to start removing accelaration to reach cruise velocity
limit_velocity_final=acc^2/(2*MaxJerk); % velocity limit to start removing accelaration to reach null velocity

%% state machine transition 
if (state==1 && acc>=MaxAcc) % max acceleration reached
    state=2;
    acc=min(acc,MaxAcc);
elseif ((state==2 || state==1) && vel>=limit_velocity) % limit velocity reached
    state=3;
elseif (state==3 && acc<=0) % null acceleration reached
    state=4;
    acc=0;
elseif (state==4 && switch_activated) % switch has been triggered
    state=5;
    pos=0;
elseif (state==5 && pos>=(switch_distance-deceleration_distance)) % time to slow down
    state=6;
elseif (state==6 && acc<=-MaxAcc) % negative max acceleration reached
    state=7;
    acc=max(acc,-MaxAcc);
elseif ((state==7 || state==6) && vel<=limit_velocity_final) % limit acceleration to stop motion is reached
    state=8;
elseif (state==8 && vel<=0) % steady state reached
    state=0;
    vel=0;
    acc=0;
end


setpoint_vel=vel;
setpoint_acc=acc;