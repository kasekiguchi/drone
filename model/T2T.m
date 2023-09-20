function U = T2T(T1,T2,T3,T4)
%T2T
%    U = T2T(T1,T2,T3,T4)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    18-Jul-2023 18:30:57

t2 = T1./4.0;
t3 = T2.*(2.5e+1./8.0);
t4 = T3.*(2.5e+1./8.0);
t7 = T4.*8.305647840531561;
t5 = -t3;
t6 = -t4;
t8 = -t7;
U = [t2+t4+t5+t7,t2+t5+t6+t8,t2+t3+t4+t8,t2+t3+t6+t7];
