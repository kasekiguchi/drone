function cZ4 = Z4(in1,in2,in3,in4)
%Z4
%    cZ4 = Z4(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.2.
%    10-Oct-2022 18:57:35

Xd4 = in2(:,4);
o1 = in1(11,:);
o2 = in1(12,:);
o3 = in1(13,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
t2 = q0.^2;
t3 = q1.^2;
t4 = q2.^2;
t5 = q3.^2;
t6 = q0.*q3.*2.0;
t7 = q1.*q2.*2.0;
t8 = -t4;
t9 = -t5;
t10 = t6+t7;
t11 = t10.^2;
t12 = t2+t3+t8+t9;
t13 = t12.^2;
t14 = 1.0./t12;
t15 = 1.0./t13;
t16 = t11+t13;
t17 = 1.0./t16;
cZ4 = [-Xd4+atan2(q0.*q3.*2.0+q1.*q2.*2.0,t12);t13.*t17.*(q0.*t14.*2.0+q3.*t10.*t15.*2.0).*(o1.*q2.*(-1.0./2.0)+(o2.*q1)./2.0+(o3.*q0)./2.0)+t13.*t17.*(q1.*t14.*2.0+q2.*t10.*t15.*2.0).*((o2.*q0)./2.0+(o1.*q3)./2.0-(o3.*q1)./2.0)+t13.*t17.*(q2.*t14.*2.0-q1.*t10.*t15.*2.0).*((o1.*q0)./2.0-(o2.*q3)./2.0+(o3.*q2)./2.0)-t13.*t17.*(q3.*t14.*2.0-q0.*t10.*t15.*2.0).*((o1.*q1)./2.0+(o2.*q2)./2.0+(o3.*q3)./2.0)];
