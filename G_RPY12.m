function gp = G_RPY12(in1,in2)
%FORM_U
%    GP = FORM_U(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    07-Dec-2023 16:20:03

jx = in2(:,6);
jy = in2(:,7);
jz = in2(:,8);
m = in2(:,1);
pitch = in1(5,:);
roll = in1(4,:);
yaw = in1(6,:);
t2 = 1.0./m;
t3 = pitch./2.0;
t4 = roll./2.0;
t5 = yaw./2.0;
t6 = cos(t3);
t7 = cos(t4);
t8 = cos(t5);
t9 = sin(t3);
t10 = sin(t4);
t11 = sin(t5);
t12 = t6.*t7.*t8;
t13 = t6.*t7.*t11;
t14 = t6.*t8.*t10;
t15 = t7.*t8.*t9;
t16 = t6.*t10.*t11;
t17 = t7.*t9.*t11;
t18 = t8.*t9.*t10;
t19 = t9.*t10.*t11;
t20 = -t17;
t21 = -t18;
t22 = t12+t19;
t23 = t15+t16;
t24 = t13+t21;
t25 = t14+t20;
gp = reshape([0.0,0.0,0.0,0.0,0.0,0.0,t2.*(t22.*t23.*2.0+t24.*t25.*2.0),-t2.*(t22.*t25.*2.0-t23.*t24.*2.0),t2.*(t22.^2-t23.^2+t24.^2-t25.^2),0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0./jx,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0./jy,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0./jz,0.0,0.0,0.0,0.0,0.0,0.0],[18,4]);
