function [switch_activated,switch_distance,cruise_velocity,direction]=LiftLogic(floor_switches,lower_proximity_switches,upper_proximity_switches,destination_floor,floor_height,num_floors,cabin_height,proximity_distance)

persistent req_floor state start_floor

if isempty(req_floor)
    if floor_switches>0 % lift is parked in one floor at the beginning
        state=0;
        start_floor=floor_height;
    else % abnormal behaviour lift in not parked in one floor at the beginning
        req_floor=nan;
        start_floor=-1;
    end
end


if state

