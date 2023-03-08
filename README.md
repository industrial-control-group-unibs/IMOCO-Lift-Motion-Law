# Jerk-limited Motion Law for Lifts

Available Jerk-limited profiles

- Single speed profile:
The cruise velocity is selected as equal to the maximum velocity if the ride is more than one floor. The cruise velocity is the minimum speed if the ride is one floor. The lift reaches the cruise velocity with a limited jerk and acceleration. When it reaches the floor adjacent to the desired one (that is the adjacent-floor on/off switch is activated), it starts to compute the traveled position. When the traveled position reaches the deceleration distance, the lift begins to slow down and then stops.

![single speed profile](https://github.com/industrial-control-group-unibs/IMOCO-Lift-Motion-Law/blob/main/docs/Motion%20law%20-%20Single%20speed.png)


- Dual speed profile:
The first cruise velocity is selected as equal to the maximum velocity if the ride is more than one floor. The cruise velocity is the minimum speed if the ride is one floor. The lift reaches the first cruise velocity with a limited jerk and acceleration. When it reaches the floor adjacent to the desired one (that is, the adjacent-floor on/off switch is activated), it starts to compute the traveled position. When the traveled position reaches the deceleration distance, the lift starts to slow down to reach the second cruise velocity (always equal to the minimum speed). When it reaches the proximity on/off switch is activated, it starts to compute the traveled position.

![dual speed profile](https://github.com/industrial-control-group-unibs/IMOCO-Lift-Motion-Law/blob/main/docs/Motion%20law%20-%20Dual%20speed.png)
## Ack

This work was partially supported by IMOCO4.E project (H2020-ECSEL, European Commission – G.A.101007311).
