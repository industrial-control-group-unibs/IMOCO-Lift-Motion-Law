clear all;close all;clc;

syms MaxAcc InitialVel FinalVel Vel MaxJerk time distance positive;
syms Acc
syms t1 t2 positive

t3=t1;



if 0 %Acc

jerk_t1=MaxJerk;
acc_t1=int(jerk_t1,time,0,time);
vel_t1=int(acc_t1,time,0,time);
pos_t1=int(vel_t1,time,0,time);

acc_end_of_t1=subs(acc_t1,time,t1);
vel_end_of_t1=subs(vel_t1,time,t1);
pos_end_of_t1=subs(pos_t1,time,t1);


jerk_t2=0;
acc_t2=acc_end_of_t1+int(jerk_t2,time,t1,time);
vel_t2=vel_end_of_t1+int(acc_t2,time,t1,time);
pos_t2=pos_end_of_t1+int(vel_t2,time,t1,time);


acc_end_of_t2=subs(acc_t2,time,t1+t2);
vel_end_of_t2=subs(vel_t2,time,t1+t2);
pos_end_of_t2=subs(pos_t2,time,t1+t2);

jerk_t3=-MaxJerk;
acc_t3=acc_end_of_t2+int(jerk_t3,time,t1+t2,time);
vel_t3=vel_end_of_t2+int(acc_t3,time,t1+t2,time);
pos_t3=pos_end_of_t2+int(vel_t3,time,t1+t2,time);

acc_end_of_t3=subs(acc_t3,time,t1+t2+t3);
vel_end_of_t3=subs(vel_t3,time,t1+t2+t3);
vel_end_of_t3=simplify(vel_end_of_t3);
pos_end_of_t3=subs(pos_t3,time,t1+t2+t3);

eq(1,1)= vel_end_of_t3==FinalVel;
eq(2,1)=acc_end_of_t2==Acc;
%% case 1 Acc==MaxAcc
eq_case1=[eq;Acc==MaxAcc];
sol_case=solve(eq_case1,[t1,t2,Acc]);

sol{1}=simplify([sol_case.t1;sol_case.t2;sol_case.Acc]);
% case 2 Acc <MaxAcc
eq_case2=subs(eq,t2,0);
sol_case=solve(eq_case2,[t1,Acc]);

sol{2}=simplify([sol_case.t1;0;sol_case.Acc]);

acc_distance=simplify(pos_end_of_t3);

else
%% Deceleration


jerk_t1=-MaxJerk;
acc_t1=int(jerk_t1,time,0,time);
vel_t1=InitialVel+int(acc_t1,time,0,time);
pos_t1=int(vel_t1,time,0,time);

acc_end_of_t1=subs(acc_t1,time,t1);
vel_end_of_t1=subs(vel_t1,time,t1);
pos_end_of_t1=subs(pos_t1,time,t1);


jerk_t2=0;
acc_t2=acc_end_of_t1+int(jerk_t2,time,t1,time);
vel_t2=vel_end_of_t1+int(acc_t2,time,t1,time);
pos_t2=pos_end_of_t1+int(vel_t2,time,t1,time);


acc_end_of_t2=subs(acc_t2,time,t1+t2);
vel_end_of_t2=subs(vel_t2,time,t1+t2);
pos_end_of_t2=subs(pos_t2,time,t1+t2);

jerk_t3=MaxJerk;
acc_t3=acc_end_of_t2+int(jerk_t3,time,t1+t2,time);
vel_t3=vel_end_of_t2+int(acc_t3,time,t1+t2,time);
pos_t3=pos_end_of_t2+int(vel_t3,time,t1+t2,time);

acc_end_of_t3=subs(acc_t3,time,t1+t2+t3);
vel_end_of_t3=subs(vel_t3,time,t1+t2+t3);
vel_end_of_t3=simplify(vel_end_of_t3);
pos_end_of_t3=subs(pos_t3,time,t1+t2+t3);

eq(1,1)= vel_end_of_t3==0;
eq(2,1)=acc_end_of_t2==Acc;
%% case 1 Acc==MaxAcc
eq_case1=[eq;Acc==-MaxAcc];
sol_case=solve(eq_case1,[t1,t2,Acc]);

sol{1}=simplify([sol_case.t1;sol_case.t2;sol_case.Acc]);
% case 2 Acc <MaxAcc
eq_case2=subs(eq,t2,0);
sol_case=solve(eq_case2,[t1,Acc]);

sol{2}=simplify([sol_case.t1;0;sol_case.Acc]);



dec_distance=simplify(pos_end_of_t3);


dec_distance_case1=simplify(subs(dec_distance,[t1;t2;Acc],sol{1}))

dec_distance_case2=simplify(subs(dec_distance,[t1;t2;Acc],sol{2}))
end