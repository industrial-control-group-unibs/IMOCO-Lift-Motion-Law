function [setpoint_vel,setpoint_acc,setpoint_jerk,idle,state_out]=WegMotionLaw(...
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
Ts ...
    )

persistent state vel acc SlowSpeedSwitch_internal HighSpeedSwitch_internal
if isempty(state)
    state=0;
    vel=0;
    acc=0;
    SlowSpeedSwitch_internal=false;
    HighSpeedSwitch_internal=false;
    %pos=0;
end


if (state==1)
    jerk=AccelInitialJerk*PercentAccFactor;
elseif (state==2)
    jerk=0;
elseif (state==3)
    jerk=-AccelEndJerk*PercentAccFactor;
elseif (state==4)
    jerk=0;
elseif (state==5)
    jerk=-DecelInitialJerk*PercentAccFactor;
elseif (state==6)
    jerk=0;
elseif (state==7)
    jerk=DecelEndJerk*PercentAccFactor;
elseif (state==8)
    jerk=0;
elseif (state==9)
    jerk=-DecelInitialJerk*PercentAccFactor;
elseif (state==10)
    jerk=0;
elseif (state==11)
    jerk=DecelEndJerk*PercentAccFactor;
else % steaty-state case
    jerk=0;
    vel=0;
    acc=0;
end

if (state<=2)
    MaxJerk=AccelEndJerk*PercentAccFactor;
    MaxAcc=Acceleration*PercentAccFactor;
    CruiseVel=HighSpeed;
elseif (state<=7)
    MaxJerk=DecelEndJerk*PercentAccFactor;
    MaxAcc=Deceleration*PercentAccFactor;
    CruiseVel=LowSpeed;
else
    MaxJerk=DecelEndJerk*PercentAccFactor;
    MaxAcc=StopDeceleration*PercentAccFactor;
    CruiseVel=LowSpeed;
end

SlowSpeedSwitch_internal=SlowSpeedSwitch_internal || SlowSpeedSwitch ;
HighSpeedSwitch_internal=HighSpeedSwitch_internal || HighSpeedSwitch ;

%pos=pos+vel*Ts+0.5*acc*Ts^2+1.0/6.0*jerk*Ts^3; % traveled distance
vel=vel+acc*Ts+0.5*Ts*Ts*jerk; % velocity
acc=acc+Ts*jerk; % acceleration

limit_velocity=CruiseVel-acc^2/(2*MaxJerk); % velocity limit to start removing accelaration to reach cruise velocity
limit_velocity_profile2=CruiseVel+acc^2/(2*MaxJerk); % velocity limit to start removing accelaration to reach low velocity
limit_velocity_final=acc^2/(2*MaxJerk); % velocity limit to start removing accelaration to reach null velocity

%% state machine transition 
if (state==0 && StartMovement)
    state=1;
elseif (state==1 && acc>=MaxAcc) % max acceleration reached
    state=2;
    acc=min(acc,MaxAcc);
elseif ((state==2 || state==1) && vel>=limit_velocity) % limit velocity reached  (cruise velocity will be reached soon)
    state=3;
elseif (state==3 && acc<=0) % null acceleration reached
    state=4;
    acc=0;
    vel=HighSpeed;

%elseif (state==4 && HighSpeedSwitch) % switch has been triggered
elseif ( (state>0 && state<5) && HighSpeedSwitch_internal) % switch has been triggered
    state=5;
    HighSpeedSwitch_internal=false;
elseif (state==5 && acc<=-MaxAcc)
    state=6;
    acc=-MaxAcc;
elseif ((state==5 || state==6)  && vel<=limit_velocity_profile2)
    state=7;
elseif (state==7 && acc >= 0 )
    state=8;
    vel=LowSpeed;
    acc=0;
%elseif (state==8 && SlowSpeedSwitch)
%elseif ( (state>0 && state<9) && SlowSpeedSwitch)
elseif ((abs(vel-LowSpeed)<StopDeceleration*Ts && state<9) && SlowSpeedSwitch_internal)
    state=9;
    SlowSpeedSwitch_internal=false;
elseif (state==9 && acc<=-MaxAcc)
    state=10;
    acc=-MaxAcc;
elseif ((state==9 || state==10)  && vel<=limit_velocity_final)
    state=11;
elseif (state==11 && acc>=0)
    state=0;
    acc=0;
    vel=0;
end
  
    
    
idle=state==0;
setpoint_vel=vel;
setpoint_acc=acc;
setpoint_jerk=jerk;
state_out=state;