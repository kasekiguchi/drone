function cV2 = Vsd(dt,in2,in3,in4,in5,in6,in7,in8)
%Vsd
%    cV2 = Vsd(DT,IN2,IN3,IN4,IN5,IN6,IN7,IN8)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/06/12 13:41:21

V1 = in4(:,1);
Xd1 = in3(:,1);
Xd2 = in3(:,2);
Xd4 = in3(:,4);
dV1 = in4(:,2);
dXd1 = in3(:,5);
dXd2 = in3(:,6);
dXd4 = in3(:,8);
ddXd1 = in3(:,9);
ddXd2 = in3(:,10);
ddXd3 = in3(:,11);
dddXd1 = in3(:,13);
dddXd2 = in3(:,14);
dddXd3 = in3(:,15);
dp1 = in2(8,:);
dp2 = in2(9,:);
f21 = in6(:,1);
f22 = in6(:,2);
f23 = in6(:,3);
f24 = in6(:,4);
f31 = in7(:,1);
f32 = in7(:,2);
f33 = in7(:,3);
f34 = in7(:,4);
f41 = in8(:,1);
f42 = in8(:,2);
gravity = in5(:,9);
o1 = in2(11,:);
o2 = in2(12,:);
o3 = in2(13,:);
p1 = in2(5,:);
p2 = in2(6,:);
q0 = in2(1,:);
q1 = in2(2,:);
q2 = in2(3,:);
q3 = in2(4,:);
t2 = dV1+dddXd3;
t3 = q0.^2;
t4 = q1.^2;
t5 = q2.^2;
t6 = q3.^2;
t7 = q0.*q1.*2.0;
t8 = q0.*q2.*2.0;
t9 = q0.*q3.*2.0;
t10 = q1.*q2.*2.0;
t11 = q1.*q3.*2.0;
t12 = q2.*q3.*2.0;
t13 = V1+ddXd3+gravity;
t18 = (o1.*q0)./2.0;
t19 = (o1.*q1)./2.0;
t20 = (o2.*q0)./2.0;
t21 = (o1.*q2)./2.0;
t22 = (o2.*q1)./2.0;
t23 = (o3.*q0)./2.0;
t24 = (o1.*q3)./2.0;
t25 = (o2.*q2)./2.0;
t26 = (o3.*q1)./2.0;
t27 = (o2.*q3)./2.0;
t28 = (o3.*q2)./2.0;
t29 = (o3.*q3)./2.0;
t14 = -t12;
t15 = -t4;
t16 = -t5;
t17 = -t6;
t30 = -t21;
t31 = -t26;
t32 = -t27;
t33 = t8+t11;
t34 = t9+t10;
t37 = t19+t25+t29;
t35 = t7+t14;
t36 = t34.^2;
t38 = t3+t6+t15+t16;
t39 = t3+t4+t16+t17;
t40 = t22+t23+t30;
t41 = t20+t24+t31;
t42 = t18+t28+t32;
t43 = t39.^2;
t44 = 1.0./t38;
t45 = 1.0./t39;
t46 = t44.^2;
t47 = 1.0./t43;
t48 = q0.*t13.*t44.*2.0;
t49 = q1.*t13.*t44.*2.0;
t50 = q2.*t13.*t44.*2.0;
t51 = q3.*t13.*t44.*2.0;
t52 = t36+t43;
t53 = 1.0./t52;
mt1 = [f23.*(ddXd1-t13.*t33.*t44)+f21.*(Xd1-p1)+f22.*(dXd1-dp1)-f24.*(-dddXd1-t37.*(t50-q0.*t13.*t33.*t46.*2.0)+t41.*(t48+q2.*t13.*t33.*t46.*2.0)+t40.*(t49-q3.*t13.*t33.*t46.*2.0)+t42.*(t51+q1.*t13.*t33.*t46.*2.0)+t2.*t33.*t44),f33.*(ddXd2+t13.*t35.*t44)+f31.*(Xd2-p2)+f32.*(dXd2-dp2)+f34.*(dddXd2-t37.*(t49-q0.*t13.*t35.*t46.*2.0)+t42.*(t48+q1.*t13.*t35.*t46.*2.0)-t40.*(t50+q3.*t13.*t35.*t46.*2.0)-t41.*(t51-q2.*t13.*t35.*t46.*2.0)+t2.*t35.*t44)];
mt2 = [-f42.*(-dXd4-t37.*t43.*t53.*(q3.*t45.*2.0-q0.*t34.*t47.*2.0)+t40.*t43.*t53.*(q0.*t45.*2.0+q3.*t34.*t47.*2.0)+t41.*t43.*t53.*(q1.*t45.*2.0+q2.*t34.*t47.*2.0)+t42.*t43.*t53.*(q2.*t45.*2.0-q1.*t34.*t47.*2.0))+f41.*(Xd4-atan2(q0.*q3.*2.0+q1.*q2.*2.0,t39))];
cV2 = [mt1,mt2];
end
