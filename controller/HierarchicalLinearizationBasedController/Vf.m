function V1 = Vf(in1,in2,in3,in4)
%Vf
%    V1 = Vf(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.2.
%    10-Oct-2022 18:57:35

Xd3 = in2(:,3);
dp3 = in1(10,:);
f11 = in4(:,1);
f12 = in4(:,2);
p3 = in1(7,:);
t2 = f11.*f12;
t3 = f12.^2;
t4 = -p3;
t5 = -t3;
t6 = Xd3+t4;
t7 = f11+t5;
t8 = f12.*t7;
t9 = t2+t8;
V1 = [-dp3.*f12+f11.*t6,-dp3.*t7-t2.*t6,dp3.*t9-f11.*t6.*t7,dp3.*(f11.*t7-f12.*t9)+f11.*t6.*t9];
