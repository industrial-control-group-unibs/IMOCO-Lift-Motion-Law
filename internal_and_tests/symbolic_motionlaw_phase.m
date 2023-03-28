clear all;close all;clc;

if 0
%% reach max vel
syms MaxAcc InitialVel InitialAcc FinalVel Vel MaxJerk time distance t tend positive;
syms Acc
syms t1 t2 positive


Jerk=-MaxJerk;

acc=InitialAcc+int(Jerk,t,0,t);
vel=InitialVel+int(acc,t,0,t);

eq=subs([vel;acc],t,tend);

solve(eq==[FinalVel;0],[tend,InitialVel])
end

if 1

    %% reach max vel
syms MaxAcc InitialVel InitialAcc FinalVel Vel MaxJerk time distance t tend positive;
syms Acc
syms t1 t2 positive


Jerk=-MaxJerk;

acc=InitialAcc+int(Jerk,t,0,t);
vel=InitialVel+int(acc,t,0,t);

eq=subs([vel;acc],t,tend);

solve(eq==[FinalVel;0],[tend,InitialVel])
end

