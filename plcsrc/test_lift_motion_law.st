(*
 *
 * File: test_lift_motion_law.st
 *
 * IEC 61131-3 Structured Text (ST) code generated for subsystem "test_lift_motion_law/Lift Logic Control"
 *
 * Model name                      : test_lift_motion_law
 * Model version                   : 1.47
 * Model creator                   : manue
 * Model last modified by          : manue
 * Model last modified on          : Fri Jan 20 13:19:40 2023
 * Model sample time               : 0s
 * Subsystem name                  : test_lift_motion_law/Lift Logic Control
 * Subsystem sample time           : 0.001s
 * Simulink PLC Coder version      : 3.5 (R2021b) 14-May-2021
 * ST code generated on            : Fri Jan 20 13:23:39 2023
 *
 * Target IDE selection            : Generic
 * Test Bench included             : No
 *
 *)
FUNCTION_BLOCK Lift
VAR_INPUT
    ssMethodType: SINT;
    switch_h: LREAL;
    lower_proximity_switches: LREAL;
    upper_proximity_switches: LREAL;
    destination_floor: LREAL;
END_VAR
VAR_OUTPUT
    velocity: LREAL;
    setpoint_acc: LREAL;
    idle: BOOL;
END_VAR
VAR
    vel: LREAL;
    direction_internal: LREAL;
    state: LREAL;
    acc: LREAL;
    cruise_velocity_internal: LREAL;
    Memory_PreviousInput: BOOL;
    pos: LREAL;
    req_floor_not_empty: BOOL;
    start_floor: LREAL;
    req_floor: LREAL;
    state_f: LREAL;
    b_time: LREAL;
END_VAR
VAR_TEMP
    destination_floor_0: LREAL;
    deceleration_distance: LREAL;
    jerk: DINT;
    rtb_switch_activated: BOOL;
    rtb_switch_distance: LREAL;
    temp1: BOOL;
    temp2: BOOL;
END_VAR
CASE ssMethodType OF
    0: 
        (* SystemInitialize for Atomic SubSystem: '<Root>/Lift Logic Control' *)
        (* InitializeConditions for Memory: '<S1>/Memory' *)
        Memory_PreviousInput := FALSE;
        (* SystemInitialize for Atomic SubSystem: '<S1>/LiftLogic' *)
        (* SystemInitialize for MATLAB Function: '<S3>/MATLAB Function1' *)
        req_floor_not_empty := FALSE;
        (* End of SystemInitialize for SubSystem: '<S1>/LiftLogic' *)
        
        (* SystemInitialize for Atomic SubSystem: '<S1>/MotionProfileGenerator' *)
        (* SystemInitialize for MATLAB Function: '<S4>/MATLAB Function' *)
        (* '<S6>:1:5' state=1; *)
        state := 1.0;
        (* '<S6>:1:6' vel=0; *)
        vel := 0.0;
        (* '<S6>:1:7' acc=0; *)
        acc := 0.0;
        (* '<S6>:1:8' pos=0; *)
        pos := 0.0;
        (* End of SystemInitialize for SubSystem: '<S1>/MotionProfileGenerator' *)
        (* End of SystemInitialize for SubSystem: '<Root>/Lift Logic Control' *)
    1: 
        (* Outputs for Atomic SubSystem: '<Root>/Lift Logic Control' *)
        (* Outputs for Atomic SubSystem: '<S1>/LiftLogic' *)
        (* MATLAB Function: '<S3>/MATLAB Function1' incorporates:
         *  Constant: '<S3>/Constant10'
         *  Constant: '<S3>/Constant11'
         *  Constant: '<S3>/Constant12'
         *  Constant: '<S3>/Constant13'
         *  Constant: '<S3>/Constant5'
         *  Constant: '<S3>/Constant6'
         *  Constant: '<S3>/Constant7'
         *  Memory: '<S1>/Memory' *)
        destination_floor_0 := destination_floor;
        (* MATLAB Function 'Lift Logic Control/LiftLogic/MATLAB Function1': '<S5>:1' *)
        (* '<S5>:1:18' if isempty(req_floor) *)
        IF  NOT req_floor_not_empty THEN 
            (* '<S5>:1:19' if floor_switches>=0 *)
            IF switch_h >= 0.0 THEN 
                (* lift is parked in one floor at the beginning *)
                (* '<S5>:1:20' start_floor=floor_height; *)
                start_floor := 3.0;
            ELSE 
                (* '<S5>:1:21' else *)
                (* abnormal behaviour lift in not parked in one floor at the beginning, go to the last floor *)
                (* '<S5>:1:22' start_floor=-1; *)
                start_floor := -1.0;
                (* '<S5>:1:23' destination_floor=num_floors; *)
                destination_floor_0 := 20.0;
            END_IF;
            (* '<S5>:1:25' req_floor=start_floor; *)
            req_floor := start_floor;
            req_floor_not_empty := TRUE;
            (* '<S5>:1:26' state=0; *)
            state_f := 0.0;
            (* '<S5>:1:27' time=0; *)
            b_time := 0.0;
            (* '<S5>:1:28' cruise_velocity_internal=0; *)
            cruise_velocity_internal := 0.0;
            (* '<S5>:1:29' direction_internal=0; *)
            direction_internal := 0.0;
        END_IF;
        (* '<S5>:1:32' switch_activated=false; *)
        rtb_switch_activated := FALSE;
        (* '<S5>:1:33' switch_distance=0; *)
        rtb_switch_distance := 0.0;
        (* '<S5>:1:34' idle=false; *)
        (* state: *)
        (* 0 IDLE *)
        (* 1 LIFT IS MOVING *)
        (* 2 waiting open door *)
        (* ACTIONS *)
        (* '<S5>:1:42' if state==1 *)
        IF state_f = 1.0 THEN 
            (* '<S5>:1:43' if motion_profile==1 *)
            (* single speed *)
            (* '<S5>:1:44' if (direction_internal>0) *)
            IF direction_internal > 0.0 THEN 
                (* '<S5>:1:45' switch_activated=floor_switches==(req_floor); *)
                rtb_switch_activated := switch_h = req_floor;
                (* the top of the cabin reach the floor switch *)
                (* '<S5>:1:46' switch_distance=cabin_height; *)
                rtb_switch_distance := 2.8;
            ELSE 
                (* '<S5>:1:47' else *)
                (* '<S5>:1:48' switch_activated=floor_switches==(req_floor+1); *)
                rtb_switch_activated := (req_floor + 1.0) = switch_h;
                (* the bottom of the cabin reach the upper floor switch *)
                (* '<S5>:1:49' switch_distance=floor_height; *)
                rtb_switch_distance := 3.0;
            END_IF;
        ELSIF state_f = 2.0 THEN 
            (* '<S5>:1:54' elseif state==2 *)
            (* '<S5>:1:55' time=time+Ts; *)
            b_time := b_time + 0.001;
        END_IF;
        (* TRANSITIONS *)
        (* '<S5>:1:60' if (state==0 && (destination_floor~=start_floor)) *)
        IF (state_f = 0.0) AND (destination_floor_0 <> start_floor) THEN 
            (* '<S5>:1:61' if ( (destination_floor>num_floors) || (destination_floor<0) ) *)
            IF (destination_floor_0 <= 20.0) AND (destination_floor_0 >= 0.0) THEN 
                (* '<S5>:1:63' else *)
                (* '<S5>:1:64' state=1; *)
                state_f := 1.0;
                (* '<S5>:1:65' req_floor=destination_floor; *)
                req_floor := destination_floor_0;
                (* '<S5>:1:67' if motion_profile==1 *)
                (* single speed *)
                (* '<S5>:1:68' if abs(req_floor-start_floor)==1 *)
                IF ABS(req_floor - start_floor) = 1.0 THEN 
                    (* '<S5>:1:69' cruise_velocity_internal=min_speed; *)
                    cruise_velocity_internal := 0.2;
                ELSE 
                    (* '<S5>:1:70' else *)
                    (* '<S5>:1:71' cruise_velocity_internal=max_speed; *)
                    cruise_velocity_internal := 2.0;
                END_IF;
                (* '<S5>:1:73' if (req_floor>start_floor) *)
                IF req_floor > start_floor THEN 
                    (* '<S5>:1:74' direction_internal=1; *)
                    direction_internal := 1.0;
                ELSE 
                    (* '<S5>:1:75' else *)
                    (* '<S5>:1:76' direction_internal=-1; *)
                    direction_internal := -1.0;
                END_IF;
            END_IF;
        ELSIF (state_f = 1.0) AND Memory_PreviousInput THEN 
            (* '<S5>:1:83' elseif (state==1 && motion_law_idle) *)
            (* '<S5>:1:84' state=2; *)
            state_f := 2.0;
            (* '<S5>:1:85' time=0; *)
            b_time := 0.0;
            (* '<S5>:1:86' start_floor=req_floor; *)
            start_floor := req_floor;
        ELSIF (state_f = 2.0) AND (b_time > 4.0) THEN 
            (* '<S5>:1:87' elseif (state==2 && time>waiting_time) *)
            (* '<S5>:1:88' state=0; *)
            state_f := 0.0;
        END_IF;
        (* '<S5>:1:92' cruise_velocity=cruise_velocity_internal; *)
        (* '<S5>:1:93' direction=direction_internal; *)
        (* '<S5>:1:94' idle=state==0; *)
        idle := state_f = 0.0;
        (* Outputs for Atomic SubSystem: '<S1>/MotionProfileGenerator' *)
        (* MATLAB Function: '<S4>/MATLAB Function' incorporates:
         *  Constant: '<S4>/Constant1'
         *  Constant: '<S4>/Constant3'
         *  Constant: '<S4>/Constant4'
         *  MATLAB Function: '<S3>/MATLAB Function1'
         *  RelationalOperator: '<S2>/Compare' *)
        (* MATLAB Function 'Lift Logic Control/MotionProfileGenerator/MATLAB Function': '<S6>:1' *)
        (* '<S6>:1:4' if isempty(state) *)
        (* compute deceleration distance:  *)
        (* case 1: the maximum acceleration is reached *)
        (* case 2: the maximum acceleration is not reached *)
        (* '<S6>:1:14' if (CruiseVel^(1/2)*MaxJerk^(1/2)>MaxAcc) *)
        IF (SQRT(cruise_velocity_internal) * 2.8284271247461903) > 2.0 THEN 
            (* case 1 *)
            (* '<S6>:1:15' deceleration_distance=(CruiseVel*(MaxAcc^2 + CruiseVel*MaxJerk))/(2*MaxAcc*MaxJerk); *)
            deceleration_distance := (((cruise_velocity_internal * 8.0) + 4.0) * cruise_velocity_internal) / 32.0;
        ELSE 
            (* '<S6>:1:16' else *)
            (* case 2 *)
            (* '<S6>:1:17' deceleration_distance =CruiseVel^(3/2)/MaxJerk^(1/2); *)
            deceleration_distance := EXPT(cruise_velocity_internal, 1.5) / 2.8284271247461903;
        END_IF;
        (* End of Outputs for SubSystem: '<S1>/LiftLogic' *)
        (* '<S6>:1:20' if (state==1) *)
        IF state = 1.0 THEN 
            (* increase acceleration *)
            (* '<S6>:1:21' jerk=MaxJerk; *)
            jerk := 8;
        ELSIF state = 2.0 THEN 
            (* '<S6>:1:22' elseif (state==2) *)
            (* max acceleration *)
            (* '<S6>:1:23' jerk=0; *)
            jerk := 0;
        ELSIF state = 3.0 THEN 
            (* '<S6>:1:24' elseif (state==3) *)
            (* decrease acceleration *)
            (* '<S6>:1:25' jerk=-MaxJerk; *)
            jerk := -8;
        ELSIF state = 4.0 THEN 
            (* '<S6>:1:26' elseif (state==4) *)
            (* keep cruise velocity *)
            (* '<S6>:1:27' jerk=0; *)
            jerk := 0;
        ELSIF state = 5.0 THEN 
            (* '<S6>:1:28' elseif (state==5) *)
            (* kep cruise velocity, switch has been triggered *)
            (* '<S6>:1:29' jerk=0; *)
            jerk := 0;
        ELSIF state = 6.0 THEN 
            (* '<S6>:1:30' elseif (state==6) *)
            (* decrease acceleration (to slow down speed) *)
            (* '<S6>:1:31' jerk=-MaxJerk; *)
            jerk := -8;
        ELSIF state = 7.0 THEN 
            (* '<S6>:1:32' elseif (state==7) *)
            (* max negative acceleration (to slow down speed) *)
            (* '<S6>:1:33' jerk=0; *)
            jerk := 0;
        ELSIF state = 8.0 THEN 
            (* '<S6>:1:34' elseif (state==8) *)
            (* increase acceleration (to return to null acceleration) *)
            (* '<S6>:1:35' jerk=MaxJerk; *)
            jerk := 8;
        ELSE 
            (* '<S6>:1:36' else *)
            (* steaty-state case *)
            (* '<S6>:1:37' jerk=0; *)
            jerk := 0;
            (* '<S6>:1:38' vel=0; *)
            vel := 0.0;
            (* '<S6>:1:39' acc=0; *)
            acc := 0.0;
        END_IF;
        (* '<S6>:1:43' pos=pos+vel*Ts+0.5*acc*Ts^2+1.0/6.0*jerk*Ts^3; *)
        pos := (((vel * 0.001) + pos) + ((0.5 * acc) * 1.0E-6)) + ((0.16666666666666666 * DINT_TO_LREAL(jerk)) * 1.0E-9);
        (* traveled distance *)
        (* '<S6>:1:44' vel=vel+acc*Ts+0.5*Ts*Ts*jerk; *)
        vel := ((acc * 0.001) + vel) + (5.0E-7 * DINT_TO_LREAL(jerk));
        (* velocity *)
        (* '<S6>:1:45' acc=acc+Ts*jerk; *)
        acc := (0.001 * DINT_TO_LREAL(jerk)) + acc;
        (* acceleration *)
        (* '<S6>:1:47' limit_velocity=CruiseVel-acc^2/(2*MaxJerk); *)
        (* velocity limit to start removing accelaration to reach cruise velocity *)
        (* '<S6>:1:48' limit_velocity_final=acc^2/(2*MaxJerk); *)
        (* velocity limit to start removing accelaration to reach null velocity *)
        (* state machine transition  *)
        (* '<S6>:1:51' if (state==0 && new_request) *)
        IF (state = 0.0) AND idle THEN 
            (* '<S6>:1:52' state=1; *)
            state := 1.0;
        ELSIF (state = 1.0) AND (acc >= 2.0) THEN 
            (* '<S6>:1:53' elseif (state==1 && acc>=MaxAcc) *)
            (* max acceleration reached *)
            (* '<S6>:1:54' state=2; *)
            state := 2.0;
            (* '<S6>:1:55' acc=min(acc,MaxAcc); *)
            acc := MIN(acc, 2.0);
        ELSE 
            temp1 := FALSE;
            temp2 := FALSE;
            IF (state = 2.0) OR (state = 1.0) THEN 
                IF vel >= (cruise_velocity_internal - ((acc * acc) / 16.0)) THEN 
                    (* '<S6>:1:56' elseif ((state==2 || state==1) && vel>=limit_velocity) *)
                    (* limit velocity reached  (cruise velocity will be reached soon) *)
                    (* '<S6>:1:57' state=3; *)
                    state := 3.0;
                ELSE 
                    temp2 := TRUE;
                END_IF;
            ELSE 
                temp2 := TRUE;
            END_IF;
            IF temp2 THEN 
                IF (state = 3.0) AND (acc <= 0.0) THEN 
                    (* '<S6>:1:58' elseif (state==3 && acc<=0) *)
                    (* null acceleration reached *)
                    (* '<S6>:1:59' state=4; *)
                    state := 4.0;
                    (* '<S6>:1:60' acc=0; *)
                    acc := 0.0;
                ELSIF (state = 4.0) AND rtb_switch_activated THEN 
                    (* '<S6>:1:61' elseif (state==4 && switch_activated) *)
                    (* switch has been triggered *)
                    (* '<S6>:1:62' state=5; *)
                    state := 5.0;
                    (* '<S6>:1:63' pos=0; *)
                    pos := 0.0;
                ELSIF (state = 5.0) AND (pos >= (rtb_switch_distance - deceleration_distance)) THEN 
                    (* '<S6>:1:64' elseif (state==5 && pos>=(switch_distance-deceleration_distance)) *)
                    (* time to slow down *)
                    (* '<S6>:1:65' state=6; *)
                    state := 6.0;
                ELSIF (state = 6.0) AND (acc <= -2.0) THEN 
                    (* '<S6>:1:66' elseif (state==6 && acc<=-MaxAcc) *)
                    (* negative max acceleration reached *)
                    (* '<S6>:1:67' state=7; *)
                    state := 7.0;
                    (* '<S6>:1:68' acc=max(acc,-MaxAcc); *)
                    acc := MAX(acc, -2.0);
                ELSIF (state = 7.0) OR (state = 6.0) THEN 
                    IF vel <= ((acc * acc) / 16.0) THEN 
                        (* '<S6>:1:69' elseif ((state==7 || state==6) && vel<=limit_velocity_final) *)
                        (* limit acceleration to stop motion is reached *)
                        (* '<S6>:1:70' state=8; *)
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
                    (* '<S6>:1:71' elseif (state==8 && vel<=0) *)
                    (* steady state reached *)
                    (* '<S6>:1:72' state=0; *)
                    state := 0.0;
                    (* '<S6>:1:73' vel=0; *)
                    vel := 0.0;
                    (* '<S6>:1:74' acc=0; *)
                    acc := 0.0;
                END_IF;
            END_IF;
        END_IF;
        (* Update for Memory: '<S1>/Memory' incorporates:
         *  MATLAB Function: '<S4>/MATLAB Function' *)
        (* '<S6>:1:77' idle=state==0; *)
        (* '<S6>:1:78' setpoint_vel=vel; *)
        (* '<S6>:1:79' setpoint_acc=acc; *)
        Memory_PreviousInput := state = 0.0;
        (* Outputs for Atomic SubSystem: '<S1>/LiftLogic' *)
        (* Outport: '<Root>/velocity' incorporates:
         *  MATLAB Function: '<S3>/MATLAB Function1'
         *  MATLAB Function: '<S4>/MATLAB Function'
         *  Product: '<S4>/Product' *)
        velocity := direction_internal * vel;
        (* End of Outputs for SubSystem: '<S1>/LiftLogic' *)
        
        (* Outport: '<Root>/setpoint_acc' incorporates:
         *  MATLAB Function: '<S4>/MATLAB Function' *)
        setpoint_acc := acc;
        (* End of Outputs for SubSystem: '<S1>/MotionProfileGenerator' *)
        (* End of Outputs for SubSystem: '<Root>/Lift Logic Control' *)
END_CASE;
END_FUNCTION_BLOCK
