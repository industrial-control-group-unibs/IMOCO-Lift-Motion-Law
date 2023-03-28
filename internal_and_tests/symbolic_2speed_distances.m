clear all;

syms Jerk1 Jerk3 vel_init acc_init vel_final max_acc positive

if 1
%case 1: reach -max_acc, t2>0
syms t2 t

t1=((-max_acc)-acc_init)/(-Jerk1);
t3=(max_acc-0)/Jerk3;

jerk1=-Jerk1;
acc1=int(jerk1,t)+acc_init;
vel1=int(acc1,t)+vel_init;
pos1=int(vel1,t);

acc1f=subs(acc1,t,t1);
vel1f=subs(vel1,t,t1);
pos1f=subs(pos1,t,t1);

jerk2=0;
acc2=int(jerk2,t)+acc1f;
vel2=int(acc2,t)+vel1f;
pos2=int(vel2,t)+pos1f;

acc2f=subs(acc2,t,t2);
vel2f=subs(vel2,t,t2);
pos2f=subs(pos2,t,t2);

jerk3=Jerk3;
acc3=int(jerk3,t)+acc2f;
vel3=int(acc3,t)+vel2f;
pos3=int(vel3,t)+pos2f;


acc3f=subs(acc3,t,t3);
vel3f=subs(vel3,t,t3);
pos3f=subs(pos3,t,t3);

t2sol=solve(simplify(vel3f)==vel_final,t2)



else
%case 2: reach max acc t2=0
syms t1 t3 t positive
t3=solve(acc_init-Jerk1*t1+Jerk3*t3==0,t3);
t2=0;

jerk1=-Jerk1;
acc1=int(jerk1,t)+acc_init;
vel1=int(acc1,t)+vel_init;
pos1=int(vel1,t);

acc1f=subs(acc1,t,t1);
vel1f=subs(vel1,t,t1);
pos1f=subs(pos1,t,t1);

jerk2=0;
acc2=int(jerk2,t)+acc1f;
vel2=int(acc2,t)+vel1f;
pos2=int(vel2,t)+pos1f;

acc2f=subs(acc2,t,t2);
vel2f=subs(vel2,t,t2);
pos2f=subs(pos2,t,t2);

jerk3=Jerk3;
acc3=int(jerk3,t)+acc2f;
vel3=int(acc3,t)+vel2f;
pos3=int(vel3,t)+pos2f;


acc3f=subs(acc3,t,t3);
vel3f=subs(vel3,t,t3);
pos3f=subs(pos3,t,t3);

t1sol=solve(simplify(vel3f)==vel_final,t1)
end