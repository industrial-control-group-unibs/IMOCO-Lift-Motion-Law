(*
 *
 * File: test_lift_motion_law.st
 *
 * IEC 61131-3 Structured Text (ST) code generated for subsystem "test_lift_motion_law/Subsystem/MATLAB Function"
 *
 * Model name                      : test_lift_motion_law
 * Model version                   : 1.3
 * Model creator                   : manue
 * Model last modified by          : manue
 * Model last modified on          : Tue Jan 17 14:26:57 2023
 * Model sample time               : 0s
 * Subsystem name                  : test_lift_motion_law/Subsystem/MATLAB Function
 * Subsystem sample time           : 0.001s
 * Simulink PLC Coder version      : 3.5 (R2021b) 14-May-2021
 * ST code generated on            : Tue Jan 17 14:28:01 2023
 *
 * Target IDE selection            : Generic
 * Test Bench included             : No
 *
 *)
FUNCTION_BLOCK MATLAB0
VAR_INPUT
    ssMethodType: SINT;
    MaxJerk: LREAL;
    MaxAcc: LREAL;
    CruiseVel: LREAL;
    Ts: LREAL;
    switch_distance: LREAL;
    switch_activated: BOOL;
END_VAR
VAR_OUTPUT
    setpoint_vel: LREAL;
    setpoint_acc: LREAL;
END_VAR
VAR
    state: LREAL;
    pos: LREAL;
    vel: LREAL;
    acc: LREAL;
END_VAR
VAR_TEMP
    deceleration_distance: LREAL;
    jerk: LREAL;
    tmp: LREAL;
    temp1: BOOL;
    temp2: BOOL;
END_VAR
CASE ssMethodType OF
    0: 
        (* SystemInitialize for MATLAB Function: '<Root>/MATLAB Function' *)
        (* '<S1>:1:5' state=1; *)
        state := 1.0;
        (* '<S1>:1:6' vel=0; *)
        vel := 0.0;
        (* '<S1>:1:7' acc=0; *)
        acc := 0.0;
        (* '<S1>:1:8' pos=0; *)
        pos := 0.0;
    1: 
        (* MATLAB Function: '<Root>/MATLAB Function' *)
        (* MATLAB Function 'MATLAB Function': '<S1>:1' *)
        (* '<S1>:1:4' if isempty(state) *)
        (* compute deceleration distance:  *)
        (* case 1: the maximum acceleration is reached *)
        (* case 2: the maximum acceleration is not reached *)
        (* '<S1>:1:14' if (CruiseVel^(1/2)*MaxJerk^(1/2)>MaxAcc) *)
        tmp := SQRT(MaxJerk);
        IF (SQRT(CruiseVel) * tmp) > MaxAcc THEN 
            (* case 1 *)
            (* '<S1>:1:15' deceleration_distance=(CruiseVel*(MaxAcc^2 + CruiseVel*MaxJerk))/(2*MaxAcc*MaxJerk); *)
            deceleration_distance := (((MaxAcc * MaxAcc) + (CruiseVel * MaxJerk)) * CruiseVel) / ((2.0 * MaxAcc) * MaxJerk);
        ELSE 
            (* '<S1>:1:16' else *)
            (* case 2 *)
            (* '<S1>:1:17' deceleration_distance =CruiseVel^(3/2)/MaxJerk^(1/2); *)
            deceleration_distance := EXPT(CruiseVel, 1.5) / tmp;
        END_IF;
        (* '<S1>:1:20' if (state==1) *)
        IF state = 1.0 THEN 
            (* increase acceleration *)
            (* '<S1>:1:21' jerk=MaxJerk; *)
            jerk := MaxJerk;
        ELSIF state = 2.0 THEN 
            (* '<S1>:1:22' elseif (state==2) *)
            (* max acceleration *)
            (* '<S1>:1:23' jerk=0; *)
            jerk := 0.0;
        ELSIF state = 3.0 THEN 
            (* '<S1>:1:24' elseif (state==3) *)
            (* decrease acceleration *)
            (* '<S1>:1:25' jerk=-MaxJerk; *)
            jerk :=  -MaxJerk;
        ELSIF state = 4.0 THEN 
            (* '<S1>:1:26' elseif (state==4) *)
            (* keep cruise velocity *)
            (* '<S1>:1:27' jerk=0; *)
            jerk := 0.0;
        ELSIF state = 5.0 THEN 
            (* '<S1>:1:28' elseif (state==5) *)
            (* kep cruise velocity, switch has been triggered *)
            (* '<S1>:1:29' jerk=0; *)
            jerk := 0.0;
        ELSIF state = 6.0 THEN 
            (* '<S1>:1:30' elseif (state==6) *)
            (* decrease acceleration (to slow down speed) *)
            (* '<S1>:1:31' jerk=-MaxJerk; *)
            jerk :=  -MaxJerk;
        ELSIF state = 7.0 THEN 
            (* '<S1>:1:32' elseif (state==7) *)
            (* max negative acceleration (to slow down speed) *)
            (* '<S1>:1:33' jerk=0; *)
            jerk := 0.0;
        ELSIF state = 8.0 THEN 
            (* '<S1>:1:34' elseif (state==8) *)
            (* increase acceleration (to return to null acceleration) *)
            (* '<S1>:1:35' jerk=MaxJerk; *)
            jerk := MaxJerk;
        ELSE 
            (* '<S1>:1:36' else *)
            (* steaty-state case *)
            (* '<S1>:1:37' jerk=0; *)
            jerk := 0.0;
            (* '<S1>:1:38' vel=0; *)
            vel := 0.0;
            (* '<S1>:1:39' acc=0; *)
            acc := 0.0;
        END_IF;
        (* '<S1>:1:43' pos=pos+vel*Ts+0.5*acc*Ts^2+1.0/6.0*jerk*Ts^3; *)
        pos := (((vel * Ts) + pos) + ((0.5 * acc) * (Ts * Ts))) + ((0.16666666666666666 * jerk) * EXPT(Ts, 3.0));
        (* traveled distance *)
        (* '<S1>:1:44' vel=vel+acc*Ts+0.5*Ts*Ts*jerk; *)
        vel := (((0.5 * Ts) * Ts) * jerk) + ((acc * Ts) + vel);
        (* velocity *)
        (* '<S1>:1:45' acc=acc+Ts*jerk; *)
        acc := (Ts * jerk) + acc;
        (* acceleration *)
        (* '<S1>:1:47' limit_velocity=CruiseVel-acc^2/(2*MaxJerk); *)
        (* velocity limit to start removing accelaration to reach cruise velocity *)
        (* '<S1>:1:48' limit_velocity_final=acc^2/(2*MaxJerk); *)
        (* velocity limit to start removing accelaration to reach null velocity *)
        (* state machine transition  *)
        (* '<S1>:1:51' if (state==1 && acc>=MaxAcc) *)
        IF (state = 1.0) AND (acc >= MaxAcc) THEN 
            (* max acceleration reached *)
            (* '<S1>:1:52' state=2; *)
            state := 2.0;
            (* '<S1>:1:53' acc=min(acc,MaxAcc); *)
            acc := MIN(acc, MaxAcc);
        ELSE 
            temp1 := FALSE;
            temp2 := FALSE;
            IF (state = 2.0) OR (state = 1.0) THEN 
                IF vel >= (CruiseVel - ((acc * acc) / (2.0 * MaxJerk))) THEN 
                    (* '<S1>:1:54' elseif ((state==2 || state==1) && vel>=limit_velocity) *)
                    (* limit velocity reached *)
                    (* '<S1>:1:55' state=3; *)
                    state := 3.0;
                ELSE 
                    temp2 := TRUE;
                END_IF;
            ELSE 
                temp2 := TRUE;
            END_IF;
            IF temp2 THEN 
                IF (state = 3.0) AND (acc <= 0.0) THEN 
                    (* '<S1>:1:56' elseif (state==3 && acc<=0) *)
                    (* null acceleration reached *)
                    (* '<S1>:1:57' state=4; *)
                    state := 4.0;
                    (* '<S1>:1:58' acc=0; *)
                    acc := 0.0;
                ELSIF (state = 4.0) AND switch_activated THEN 
                    (* '<S1>:1:59' elseif (state==4 && switch_activated) *)
                    (* switch has been triggered *)
                    (* '<S1>:1:60' state=5; *)
                    state := 5.0;
                    (* '<S1>:1:61' pos=0; *)
                    pos := 0.0;
                ELSIF (state = 5.0) AND (pos >= (switch_distance - deceleration_distance)) THEN 
                    (* '<S1>:1:62' elseif (state==5 && pos>=(switch_distance-deceleration_distance)) *)
                    (* time to slow down *)
                    (* '<S1>:1:63' state=6; *)
                    state := 6.0;
                ELSIF (state = 6.0) AND (acc <= ( -MaxAcc)) THEN 
                    (* '<S1>:1:64' elseif (state==6 && acc<=-MaxAcc) *)
                    (* negative max acceleration reached *)
                    (* '<S1>:1:65' state=7; *)
                    state := 7.0;
                    (* '<S1>:1:66' acc=max(acc,-MaxAcc); *)
                    acc := MAX(acc,  -MaxAcc);
                ELSIF (state = 7.0) OR (state = 6.0) THEN 
                    IF vel <= ((acc * acc) / (2.0 * MaxJerk)) THEN 
                        (* '<S1>:1:67' elseif ((state==7 || state==6) && vel<=limit_velocity_final) *)
                        (* limit acceleration to stop motion is reached *)
                        (* '<S1>:1:68' state=8; *)
                        state := 8.0;
                    ELSE 
                        temp1 := TRUE;
                    END_IF;
                ELSE 
                    temp1 := TRUE;
                END_IF;
            END_IF;
            IF temp1 THEN 
                IF (state = 8.0) AND (vel <= 0.0) THEN 
                    (* '<S1>:1:69' elseif (state==8 && vel<=0) *)
                    (* steady state reached *)
                    (* '<S1>:1:70' state=0; *)
                    state := 0.0;
                    (* '<S1>:1:71' vel=0; *)
                    vel := 0.0;
                    (* '<S1>:1:72' acc=0; *)
                    acc := 0.0;
                END_IF;
            END_IF;
        END_IF;
        (* Outport: '<Root>/setpoint_vel' incorporates:
         *  MATLAB Function: '<Root>/MATLAB Function' *)
        (* '<S1>:1:76' setpoint_vel=vel; *)
        (* '<S1>:1:77' setpoint_acc=acc; *)
        setpoint_vel := vel;
        (* Outport: '<Root>/setpoint_acc' incorporates:
         *  MATLAB Function: '<Root>/MATLAB Function' *)
        setpoint_acc := acc;
END_CASE;
END_FUNCTION_BLOCK
