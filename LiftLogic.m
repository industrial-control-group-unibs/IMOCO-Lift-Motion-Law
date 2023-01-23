function [switch_activated,switch_distance,cruise_velocity,direction,idle]=LiftLogic(floor_switches,...
    lower_proximity_switches,...
    upper_proximity_switches,...
    destination_floor,...
    motion_law_idle,...
    floor_height,...
    num_floors,...
    cabin_height,...
    proximity_distance,...
    motion_profile,...
    waiting_time,...
    min_speed,...
    max_speed,...
    Ts)

persistent req_floor state start_floor time cruise_velocity_internal direction_internal

if isempty(req_floor)
    if floor_switches>=0 % lift is parked in one floor at the beginning
        start_floor=floor_height;
        req_floor=start_floor;
    else % abnormal behaviour lift in not parked in one floor at the beginning, go to the last floor
        start_floor=-1;
        destination_floor=num_floors;
    end
    req_floor=start_floor;
    state=0;
    time=0;
    cruise_velocity_internal=0;
    direction_internal=0;
end

switch_activated=false;
switch_distance=0;
% state:
% 0 IDLE
% 1 LIFT IS MOVING
% 2 waiting open door

% ACTIONS
if state==1
    if motion_profile==1 % single speed
        if (direction_internal>0)
            switch_activated=floor_switches==(req_floor); % the top of the cabin reach the floor switch
            switch_distance=cabin_height;
        else
            switch_activated=floor_switches==(req_floor+1); % the bottom of the cabin reach the upper floor switch
            switch_distance=floor_height;
        end
    else % two speed profile
        %not implemented yet
    end
elseif state==2
    time=time+Ts;
end


% TRANSITIONS
if (state==0 && (destination_floor~=start_floor))
    if ( (destination_floor>num_floors) || (destination_floor<0) )
        % you should not go here!
    else
        state=1;
        req_floor=destination_floor;

        if motion_profile==1 % single speed
            if abs(req_floor-start_floor)==1
                cruise_velocity_internal=min_speed;
            else
                cruise_velocity_internal=max_speed;
            end
            if (req_floor>start_floor)
                direction_internal=1;
            else
                direction_internal=-1;
            end
        else % two speed profile
            %not implemented yet
        end
    end

elseif (state==1 && motion_law_idle)
    state=2;
    time=0;
    start_floor=req_floor;
elseif (state==2 && time>waiting_time)
    state=0;
end


cruise_velocity=cruise_velocity_internal;
direction=direction_internal;
idle=state==0;

