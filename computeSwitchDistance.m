function [t1,t2,t3,distance]=computeSwitchDistance(Jerk1,Jerk3,acc_init,vel_init,vel_final,max_acc)

t2=-(vel_final - vel_init + (acc_init + max_acc)^2/(2*Jerk1) + max_acc^2/(2*Jerk3) - (acc_init*(acc_init + max_acc))/Jerk1)/max_acc;
if (t2>=0)
    t1=(acc_init + max_acc)/Jerk1;
    t3=max_acc/Jerk3;
    distance=(t2*(2*vel_init - max_acc*t2))/2 - (acc_init + max_acc)^3/(6*Jerk1^2) + (vel_init*(acc_init + max_acc))/Jerk1 - (max_acc*((2*max_acc^2)/Jerk3 + 6*t2*max_acc - 6*vel_init))/(6*Jerk3) + (t2*(acc_init^2 - max_acc^2))/(2*Jerk1) + (acc_init*(acc_init + max_acc)^2)/(2*Jerk1^2) + (max_acc*(3*acc_init^2 - 3*max_acc^2))/(6*Jerk1*Jerk3);
else
    t2=0;
    t1=(Jerk1*acc_init + Jerk3*acc_init + Jerk3^(1/2)*((Jerk1 + Jerk3)*(acc_init^2 + 2*Jerk1*vel_init - 2*Jerk1*vel_final))^(1/2))/(Jerk1^2 + Jerk3*Jerk1);
    t3= -(acc_init - Jerk1*t1)/Jerk3;
    distance=t1*vel_init - (acc_init - Jerk1*t1)^3/(6*Jerk3^2) - (Jerk1*t1^3)/6 + (acc_init*t1^2)/2 - ((acc_init - Jerk1*t1)*(vel_init + acc_init*t1 - (Jerk1*t1^2)/2))/Jerk3 + ((acc_init/2 - (Jerk1*t1)/2)*(acc_init - Jerk1*t1)^2)/Jerk3^2;
end