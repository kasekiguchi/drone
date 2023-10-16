function dx = euler_parameter_thrust_torque_physical_parameter_expand_model(in1,in2,in3)
%EULER_PARAMETER_THRUST_TORQUE_PHYSICAL_PARAMETER_EXPAND_MODEL
%    DX = EULER_PARAMETER_THRUST_TORQUE_PHYSICAL_PARAMETER_EXPAND_MODEL(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/06/15 12:16:44

Tr = in1(14,:);
dTr = in1(15,:);
dp1 = in1(8,:);
dp2 = in1(9,:);
dp3 = in1(10,:);
gravity = in3(:,9);
jx = in3(:,6);
jy = in3(:,7);
jz = in3(:,8);
m = in3(:,1);
o1 = in1(11,:);
o2 = in1(12,:);
o3 = in1(13,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
u1 = in2(1,:);
u2 = in2(2,:);
u3 = in2(3,:);
u4 = in2(4,:);
t2 = 1.0./jx;
t3 = 1.0./jy;
t4 = 1.0./jz;
t5 = 1.0./m;
dx = [o1.*q1.*(-1.0./2.0)-(o2.*q2)./2.0-(o3.*q3)./2.0;(o1.*q0)./2.0-(o2.*q3)./2.0+(o3.*q2)./2.0;(o2.*q0)./2.0+(o1.*q3)./2.0-(o3.*q1)./2.0;o1.*q2.*(-1.0./2.0)+(o2.*q1)./2.0+(o3.*q0)./2.0;dp1;dp2;dp3;Tr.*t5.*(q0.*q2.*2.0+q1.*q3.*2.0);-Tr.*t5.*(q0.*q1.*2.0-q2.*q3.*2.0);-gravity+Tr.*t5.*(q0.^2-q1.^2-q2.^2+q3.^2);t2.*u2+t2.*(jy.*o2.*o3-jz.*o2.*o3);t3.*u3-t3.*(jx.*o1.*o3-jz.*o1.*o3);t4.*u4+t4.*(jx.*o1.*o2-jy.*o1.*o2);dTr;u1];
end
