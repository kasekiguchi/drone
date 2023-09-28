function dxf = FL(in1,in2)
%FL
%    DXF = FL(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    28-Sep-2023 16:53:38

Length = in2(:,16);
dpl1 = in1(11,:);
dpl2 = in1(12,:);
dpl3 = in1(13,:);
gravity = in2(:,6);
jx = in2(:,3);
jy = in2(:,4);
jz = in2(:,5);
m = in2(:,1);
mL = in2(:,15);
o1 = in1(5,:);
o2 = in1(6,:);
o3 = in1(7,:);
ol1 = in1(17,:);
ol2 = in1(18,:);
ol3 = in1(19,:);
pT1 = in1(14,:);
pT2 = in1(15,:);
pT3 = in1(16,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
t2 = m+mL;
t3 = ol1.*pT2;
t4 = ol2.*pT1;
t5 = ol1.*pT3;
t6 = ol3.*pT1;
t7 = ol2.*pT3;
t8 = ol3.*pT2;
t9 = -t4;
t10 = -t6;
t11 = -t8;
t12 = 1.0./t2;
t13 = t3+t9;
t14 = t5+t10;
t15 = t7+t11;
t16 = t13.^2;
t17 = t14.^2;
t18 = t15.^2;
t19 = t16+t17+t18;
dxf = [o1.*q1.*(-1.0./2.0)-(o2.*q2)./2.0-(o3.*q3)./2.0;(o1.*q0)./2.0-(o2.*q3)./2.0+(o3.*q2)./2.0;(o2.*q0)./2.0+(o1.*q3)./2.0-(o3.*q1)./2.0;o1.*q2.*(-1.0./2.0)+(o2.*q1)./2.0+(o3.*q0)./2.0;(jy.*o2.*o3-jz.*o2.*o3)./jx;-(jx.*o1.*o3-jz.*o1.*o3)./jy;(jx.*o1.*o2-jy.*o1.*o2)./jz;dpl1;dpl2;dpl3;-Length.*m.*pT1.*t12.*t19;-Length.*m.*pT2.*t12.*t19;-gravity-Length.*m.*pT3.*t12.*t19;t15;-t5+t6;t13;0.0;0.0;0.0];
