function cZep2 = Zep2(in1,in2,in3)
%Zep2
%    cZep2 = Zep2(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2024/01/16 14:46:07

T1 = in1(14,:);
Xd1 = in2(:,1);
dT1 = in1(15,:);
dXd1 = in2(:,5);
ddXd1 = in2(:,9);
dddXd1 = in2(:,13);
dp1 = in1(8,:);
m = in3(:,1);
o1 = in1(11,:);
o2 = in1(12,:);
o3 = in1(13,:);
p1 = in1(5,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
t2 = q0.*q2.*2.0;
t3 = q1.*q3.*2.0;
t4 = 1.0./m;
t5 = t2+t3;
cZep2 = [-Xd1+p1;-dXd1+dp1;-ddXd1+T1.*t4.*t5;-dddXd1+dT1.*t4.*t5+T1.*q0.*t4.*((o2.*q0)./2.0+(o1.*q3)./2.0-(o3.*q1)./2.0).*2.0+T1.*q1.*t4.*(o1.*q2.*(-1.0./2.0)+(o2.*q1)./2.0+(o3.*q0)./2.0).*2.0-T1.*q2.*t4.*((o1.*q1)./2.0+(o2.*q2)./2.0+(o3.*q3)./2.0).*2.0+T1.*q3.*t4.*((o1.*q0)./2.0-(o2.*q3)./2.0+(o3.*q2)./2.0).*2.0];
end
