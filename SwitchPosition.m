function [floor_switches,lower_proximity_switches,upper_proximity_switches]=SwitchPosition(pos,floor_height,num_floors,cabin_height,proximity_distance)

floor_switches=-1;
lower_proximity_switches=-1;
upper_proximity_switches=-1;
for floor_index=0:num_floors-1

    % floor switch
    switch_pos=floor_index*floor_height;
    if (pos>=switch_pos && pos<=(switch_pos+cabin_height))
        floor_switches=floor_index;
    end

    % lower proximity switch
    switch_pos=floor_index*floor_height-proximity_distance;
    if (pos>=switch_pos && pos<=(switch_pos+cabin_height))
        lower_proximity_switches=floor_index;
    end
    
    % upper proximity switch
    switch_pos=floor_index*floor_height+proximity_distance;
    if (pos>=switch_pos && pos<=(switch_pos+cabin_height))
        upper_proximity_switches=floor_index;
    end
end