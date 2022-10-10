function cZ3 = Z3(in1,in2,in3,in4)
%Z3
%    cZ3 = Z3(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.2.
%    10-Oct-2022 18:57:34

V1 = in3(:,1);
Xd2 = in2(:,2);
dp2 = in1(9,:);
gravity = in4(:,9);
o1 = in1(11,:);
o2 = in1(12,:);
o3 = in1(13,:);
p2 = in1(6,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
t2 = V1+gravity;
t3 = q0.^2;
t4 = q1.^2;
t5 = q2.^2;
t6 = q3.^2;
t7 = q0.*q1.*2.0;
t8 = q2.*q3.*2.0;
t9 = -t8;
t10 = -t4;
t11 = -t5;
t12 = t7+t9;
t13 = t3+t6+t10+t11;
t14 = 1.0./t13;
t15 = t14.^2;
cZ3 = [-Xd2+p2;dp2;-t2.*t12.*t14;-(q0.*t2.*t14.*2.0+q1.*t2.*t12.*t15.*2.0).*((o1.*q0)./2.0-(o2.*q3)./2.0+(o3.*q2)./2.0)+(q1.*t2.*t14.*2.0-q0.*t2.*t12.*t15.*2.0).*((o1.*q1)./2.0+(o2.*q2)./2.0+(o3.*q3)./2.0)+(q2.*t2.*t14.*2.0+q3.*t2.*t12.*t15.*2.0).*(o1.*q2.*(-1.0./2.0)+(o2.*q1)./2.0+(o3.*q0)./2.0)+(q3.*t2.*t14.*2.0-q2.*t2.*t12.*t15.*2.0).*((o2.*q0)./2.0+(o1.*q3)./2.0-(o3.*q1)./2.0)];
