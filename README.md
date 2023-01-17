# Jerk-limited Motion Law for Lifts

Available profiles

- Single speed profile: Jerk limited, single cruise velocity

![single speed profile](https://github.com/industrial-control-group-unibs/IMOCO-Lift-Motion-Law/blob/main/docs/Motion%20law%20-%20Single%20speed.png)

States:
```m
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
```

Transitions:

```m
if (state==1 && acc>=MaxAcc) % max acceleration reached
    state=2;
    acc=min(acc,MaxAcc);
elseif ((state==2 || state==1) && vel>=limit_velocity) % limit velocity reached (cruise velocity will be reached soon)
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
```
## Ack

This work was partially supported by IMOCO4.E project (H2020-ECSEL, European Commission – G.A.101007311).
