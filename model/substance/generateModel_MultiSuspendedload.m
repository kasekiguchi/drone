clear
clc;
%4機を想定 状態機体番号_x,y,z
%状態:位置x，速度dx，加速度ddx，リンク角速度os，ペイロード機体角速度ol，姿勢角(クォータニオン)Rq，ペイロード上のリンクの接続位置ro
syms x0_1 x0_2 x0_3 dx0_1 dx0_2 dx0_3 ddx0_1 ddx0_2 ddx0_3 os0_1 os0_2 os0_3 ol0_1 ol0_2 ol0_3 dol0_1 dol0_2 dol0_3 Rq0_0 Rq0_1 Rq0_2 Rq0_3 real
syms q1_1 q1_2 q1_3 dq1_1 dq1_2 dq1_3 os1_1 os1_2 os1_3 ol1_1 ol1_2 ol1_3 dos1_1 dos1_2 dos1_3 dol1_1 dol1_2 dol1_3 Rq1_0 Rq1_1 Rq1_2 Rq1_3 ro1_1 ro1_2 ro1_3 real
syms q2_1 q2_2 q2_3 dq2_1 dq2_2 dq2_3 os2_1 os2_2 os2_3 ol2_1 ol2_2 ol2_3 dos2_1 dos2_2 dos2_3 dol2_1 dol2_2 dol2_3 Rq2_0 Rq2_1 Rq2_2 Rq2_3 ro2_1 ro2_2 ro2_3 real
syms q3_1 q3_2 q3_3 dq3_1 dq3_2 dq3_3 os3_1 os3_2 os3_3 ol3_1 ol3_2 ol3_3 dos3_1 dos3_2 dos3_3 dol3_1 dol3_2 dol3_3 Rq3_0 Rq3_1 Rq3_2 Rq3_3 ro3_1 ro3_2 ro3_3 real
syms q4_1 q4_2 q4_3 dq4_1 dq4_2 dq4_3 os4_1 os4_2 os4_3 ol4_1 ol4_2 ol4_3 dos4_1 dos4_2 dos4_3 dol4_1 dol4_2 dol4_3 Rq4_0 Rq4_1 Rq4_2 Rq4_3 ro4_1 ro4_2 ro4_3 real
syms m0 m1 m2 m3 m4 j0_x j0_y j0_z j1_x j1_y j1_z j2_x j2_y j2_z j3_x j3_y j3_z j4_x j4_y j4_z real
syms l1 l2 l3 l4 real
syms f1 f2 f3 f4 real
syms M1_1 M1_2 M1_3 M2_1 M2_2 M2_3 M3_1 M3_2 M3_3 M4_1 M4_2 M4_3
syms e1 e2 e3 real

g=9.81;
e0_3=[0;0;e3];
j0 = diag([j0_x,j0_x,j0_x]);
j1 = diag([j1_x,j1_x,j1_x]);
j2 = diag([j2_x,j2_x,j2_x]);
j3 = diag([j3_x,j3_x,j3_x]);
j4 = diag([j4_x,j4_x,j4_x]);

ol0 = [ol0_1; ol0_2; ol0_3];
ol1 = [ol1_1; ol1_2; ol1_3];
ol2 = [ol2_1; ol2_2; ol2_3];
ol3 = [ol3_1; ol3_2; ol3_3];
ol4 = [ol4_1; ol4_2; ol4_3];

dol0 =[dol0_1; dol0_2; dol0_3];
dol1 =[dol1_1; dol1_2; dol1_3];
dol2 =[dol2_1; dol2_2; dol2_3];
dol3 =[dol3_1; dol3_2; dol3_3];
dol4 =[dol4_1; dol4_2; dol4_3];

%歪対象行列化
olh0 = [0,-ol0_3,ol0_2;
        ol0_3,0,-ol0_1;
        -ol0_2,ol0_1,0];
olh1 = [0,-ol1_3,ol1_2;
        ol1_3,0,-ol1_1;
        -ol1_2,ol1_1,0];
olh2 = [0,-ol2_3,ol2_2;
        ol2_3,0,-ol2_1;
        -ol2_2,ol2_1,0];
olh3 = [0,-ol3_3,ol3_2;
        ol3_3,0,-ol3_1;
        -ol3_2,ol3_1,0];
olh4 = [0,-ol4_3,ol4_2;
        ol4_3,0,-ol4_1;
        -ol4_2,ol4_1,0];

os1 = [os1_1; os1_2; os1_3];
os2 = [os2_1; os2_2; os2_3];
os3 = [os3_1; os3_2; os3_3];
os4 = [os4_1; os4_2; os4_3];

dos1 =[dos1_1; dos1_2; dos1_3];
dos2 =[dos2_1; dos2_2; dos2_3];
dos3 =[dos3_1; dos3_2; dos3_3];
dos4 =[dos4_1; dos4_2; dos4_3];

osh1 = [0,-os1_3,os1_2;
        os1_3,0,-os1_1;
        -os1_2,os1_1,0];

osh2 = [0,-os2_3,os2_2;
        os2_3,0,-os2_1;
        -os2_2,os2_1,0];

osh3 = [0,-os3_3,os3_2;
        os3_3,0,-os3_1;
        -os3_2,os3_1,0];

osh4 = [0,-os4_3,os4_2;
        os4_3,0,-os4_1;
        -os4_2,os4_1,0];

Rq0 = [Rq0_0; Rq0_1; Rq0_2; Rq0_3];
Rq1 = [Rq1_0; Rq1_1; Rq1_2; Rq1_3];
Rq2 = [Rq2_0; Rq2_1; Rq2_2; Rq2_3];
Rq3 = [Rq3_0; Rq3_1; Rq3_2; Rq3_3];
Rq4 = [Rq4_0; Rq4_1; Rq4_2; Rq4_3];

R0 = RodriguesQuaternion(Rq0);
R1 = RodriguesQuaternion(Rq1);
R2 = RodriguesQuaternion(Rq2);
R3 = RodriguesQuaternion(Rq3);
R4 = RodriguesQuaternion(Rq4);

dR0 = R0 *olh0;
dR1 = R1 *olh1;
dR2 = R2 *olh2;
dR3 = R3 *olh3;
dR4 = R4 *olh4;

ro1 = [ro1_1; ro1_2; ro1_3];
ro2 = [ro2_1; ro2_2; ro2_3];
ro3 = [ro3_1; ro3_2; ro3_3];
ro4 = [ro4_1; ro4_2; ro4_3];

roh1 = [0,-ro1_3,ro1_2;
        ro1_3,0,-ro1_1;
        -ro1_2,ro1_1,0];

roh2 = [0,-ro2_3,ro2_2;
        ro2_3,0,-ro2_1;
        -ro2_2,ro2_1,0];

roh3 = [0,-ro3_3,ro3_2;
        ro3_3,0,-ro3_1;
        -ro3_2,ro3_1,0];

roh4 = [0,-ro4_3,ro4_2;
        ro4_3,0,-ro4_1;
        -ro4_2,ro4_1,0];

q1 = [q1_1; q1_2; q1_3];
q2 = [q2_1; q2_2; q2_3];
q3 = [q3_1; q3_2; q3_3];
q4 = [q4_1; q4_2; q4_3];

qh1 = [0,-q1_3,q1_2;
       q1_3,0,-q1_1;
       -q1_2,q1_1,0];

qh2 = [0,-q2_3,q2_2;
       q2_3,0,-q2_1;
       -q2_2,q2_1,0];

qh3 = [0,-q3_3,q3_2;
       q3_3,0,-q3_1;
       -q3_2,q3_1,0];

qh4 = [0,-q4_3,q4_2;
       q4_3,0,-q4_1;
       -q4_2,q4_1,0];

dq1 = cross(os1,q1);
dq2 = cross(os2,q2);
dq3 = cross(os3,q3);
dq4 = cross(os4,q4);

x0 = [x0_1; x0_2; x0_3];
x1 = x0 + R0*ro1 - l1*q1;
x2 = x0 + R0*ro2 - l2*q2;
x3 = x0 + R0*ro3 - l3*q3;
x4 = x0 + R0*ro4 - l4*q4;

ddx0 =[ddx0_1;ddx0_2;ddx0_3];

u1 = -f1*R1*e0_3; ull1 = q1*q1'*u1;
u2 = -f2*R2*e0_3; ull2 = q2*q2'*u2;
u3 = -f3*R3*e0_3; ull3 = q3*q3'*u3;
u4 = -f4*R4*e0_3; ull4 = q4*q4'*u4;

M1 = [M1_1;M1_2;M1_3];
M2 = [M2_1;M2_2;M2_3];
M3 = [M3_1;M3_2;M3_3];
M4 = [M4_1;M4_2;M4_3];


Mq = m0 * diag([1,1,1]) + m1*q1*q1' + m2*q2*q2'+ m3*q3*q3'+ m4*q4*q4';
% Mq*(ddx0 - g*e0_3) -m1*q1*q1'*R0*ro1h*dol0 -m2*q2*q2'*R0*ro2h*dol0 -m3*q3*q3'*R0*ro3h*dol0 -m4*q4*q4'*R0*ro4h*dol0 ==;
% ddx0 = inv(Mq)*(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3);
% - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0
% - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0
% - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0
% (j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+m1*roh*R0'*q1*q1'*ddx0 - m1*roh1*R0'*q1*q1'*g*e0_3+olh0*J0*ol0 ==roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1) 
% solve(ddx0 == inv(Mq)*(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3) ,dol0,'ReturnConditions',true)
% solve(ddx0 == inv(Mq)*(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3) ,(j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+m1*roh1*R0'*q1*q1'*ddx0 - m1*roh1*R0'*q1*q1'*g*e0_3+olh0*j0*ol0 ==roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1),dol0,'ReturnConditions',true)

% ddx0==inv(m1*roh1*R0'*q1*q1')*(m1*roh1*R0'*q1*q1'*g*e0_3+olh0*j0*ol0  -(j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1))
% solve(Mq*ddx0 ==(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3) ,(j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+m1*roh1*R0'*q1*q1'*ddx0 - m1*roh1*R0'*q1*q1'*g*e0_3+olh0*j0*ol0 ==roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1), m1*l1*dos1==m1*qh1*(ddx0-g*e0_3-R0*roh1*dol0+R0*olh1^2*ro1)-qh1*(diag([1,1,1])-q1*q1')*u1 , m2*l2*dos2==m2*qh2*(ddx0-g*e0_3-R0*roh2*dol0+R0*olh2^2*ro2)-qh2*(diag([1,1,1])-q2*q2')*u2 , m3*l3*dos3==m3*qh3*(ddx0-g*e0_3-R0*roh3*dol0+R0*olh3^2*ro3)-qh3*(diag([1,1,1])-q3*q3')*u3 , m4*l4*dos4==m4*qh4*(ddx0-g*e0_3-R0*roh4*dol0+R0*olh4^2*ro4)-qh4*(diag([1,1,1])-q4*q4')*u4,'ReturnConditions',true)
% S = solve([Mq*ddx0 ==(ull1 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 +Mq*g*e0_3) ,(j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+m1*roh1*R0'*q1*q1'*ddx0 - m1*roh1*R0'*q1*q1'*g*e0_3+olh0*j0*ol0 ==roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1), m1*l1*dos1==m1*qh1*(ddx0-g*e0_3-R0*roh1*dol0+R0*olh1^2*ro1)-qh1*(diag([1,1,1])-q1*q1')*u1],[ddx0,dol0,dos1])
% solve(Mq*ddx0 == ull1,ddx0)
% ddx0 = inv(Mq)*(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 - m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3);

% enq1= ddx0 == inv(Mq)*(ull1+ ull2+ ull3+ ull4 - m1*l1*norm(os1)^2*q1 -m1*q1*q1'*R0*olh1^2*ro1 +m1*q1*q1'*R0*roh1*dol0 - m2*l2*norm(os2)^2*q2 -m2*q2*q2'*R0*olh2^2*ro2 +m2*q2*q2'*R0*roh2*dol0 - m3*l3*norm(os3)^2*q3 -m3*q3*q3'*R0*olh3^2*ro3 +m3*q3*q3'*R0*roh3*dol0 - m4*l4*norm(os4)^2*q4 -m4*q4*q4'*R0*olh4^2*ro4 +m4*q4*q4'*R0*roh1*dol0 +Mq*g*e0_3) ;

Mq1 = m0 * diag([1,1,1]) + m1*q1*q1';
ddx0 = inv(Mq1)*Mq1*g*e0_3+m1*q1*q1'*R0*roh1*dol1+ull1-m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh1^2*ro1;


enq2=(j0 - m1*roh1*R0'*q1*q1'*R0*roh1)*dol0+m1*roh1*R0'*q1*q1'*ddx0 - m1*roh1*R0'*q1*q1'*g*e0_3+olh0*j0*ol0 ==roh1*R0'*(q1*q1'*u1 -m1*l1*norm(os1)^2*q1-m1*q1*q1'*R0*olh0^2*ro1);
enqx = simplifyFraction (enq2);
% enq3=m1*l1*dos1==m1*qh1*(ddx0-g*e0_3-R0*roh1*dol0+R0*olh1^2*ro1)-qh1*(diag([1,1,1])-q1*q1')*u1;
enq4=j1*dol1+cross(ol1,j1*ol1)==M1;
S = solve([enqx],[dol0]);