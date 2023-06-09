clear
clc
%%
%dos1,2,3,4のqiがqihatに変更
%ro追加 omegahat^2(oh02)を変更
syms v0 [3 1] real;
syms ddx0 [3 1] real ; syms dol0 [3 1] real;
syms A [3,3] real; syms B [3,3] real; syms C [3,3] real
syms P1 [3,1] real; syms P2 [3,1] real

syms m0 real; syms m1 real; syms m2 real; syms m3 real; syms m4 real;
syms q1 [3,1] real; syms q2 [3,1] real; syms q3 [3,1] real; syms q4 [3,1] real %リンクの方向ベクトル
syms ol0 [3,1] real; %ペイロードの角速度
syms ol1 [3,1] real;syms ol2 [3,1] real;syms ol3 [3,1] real;syms ol4 [3,1] real; %機体の角速度
syms os1 [3,1] real;syms os2 [3,1] real;syms os3 [3,1] real;syms os4 [3,1] real; %リンクの角速度

syms M1 [3,1] real;syms M2 [3,1] real;syms M3 [3,1] real;syms M4 [3,1] real %3*1 モーメント入力
syms R0 [3,3] real; %ペイロードを軸にした回転行列
syms R1 [3,3] real; syms R2 [3,3] real; syms R3 [3,3] real; syms R4 [3,3] real; %機体回転行列
syms f1 real; syms f2 real; syms f3 real; syms f4 real; %機体推力
syms qt0 [4,1] real; syms qt1 [4,1] real; syms qt2 [4,1] real; syms qt3 [4,1] real; syms qt4 [4,1] real; %クォータニオン(姿勢)

e3 = [0,0,1]';

[Rb0,L0] = RodriguesQuaternion(qt0);   % Rotation matrix
[Rb1,L1] = RodriguesQuaternion(qt1);   % Rotation matrix
[Rb2,L2] = RodriguesQuaternion(qt2);   % Rotation matrix
[Rb3,L3] = RodriguesQuaternion(qt3);   % Rotation matrix
[Rb4,L4] = RodriguesQuaternion(qt4);   % Rotation matrix

dqt0 = L0'*ol0/2; %ペイロードの姿勢
dqt1 = L1'*ol1/2;
dqt2 = L2'*ol2/2;
dqt3 = L3'*ol3/2;
dqt4 = L4'*ol4/2; %ドローンの姿勢


% ro1 = [0.05; 0.05; 0.05];
% ro2 = [-0.05; 0.05; 0.05];
% ro3 = [-0.05; -0.05; 0.05];
% ro4 = [0.05; -0.05; 0.05]; %ペイロードの重心とリングが接地している点までの長さ


ro1 = [1; 1;-1];
ro2 = [1;-1;-1];
ro3 = [-1;-1;-1];
ro4 = [-1;1;-1]; %ペイロードの重心とリングが接地している点までの長さ


% m0 = 100;
% m1 = 2;
% m2 = 2;
% m3 = 2;
% m4 = 2;

ge3 = [0;0;9.81]; 

% syms J0 [3,3] real; syms J1 [3,3] real; syms J2 [3,3] real; syms J3 [3,3] real; syms J4 [3,3] real; 
jx = 0.005;
jy = 0.005;
jz = 0.005;
J0=diag([0.1, 0.1, 0.1]);
J1=diag([jx,jy,jz]);
J2=diag([jx,jy,jz]);
J3=diag([jx,jy,jz]);
J4=diag([jx,jy,jz]);

% syms l1 real; syms l2 real; syms l3 real; syms l4 real;
l1 = 0.5;
l2 = 0.5;
l3 = 0.5;
l4 = 0.5; %リンクの長さ

syms u1 [3,1] real; syms u2 [3,1] real; syms u3 [3,1] real; syms u4 [3,1] real; %入力
u1 = -f1 * Rb1 * e3; u2 = -f2 * Rb2 * e3; u3 = -f3 * Rb3 * e3; u4 = -f4 * Rb4 * e3;
u1p = (q1*q1')*u1; u2p = (q2*q2')*u2; u3p = (q3*q3')*u3; u4p = (q4*q4')*u4;
u1v = (eye(3)-(q1*q1'))*u1; u2v = (eye(3)-(q2*q2'))*u2; u3v = (eye(3)-(q3*q3'))*u3; u4v = (eye(3)-(q4*q4'))*u4;




q1hat = [0, -q1(3,1), q1(2,1);
        q1(3,1), 0, -q1(1,1);
        -q1(2,1), q1(1,1), 0];
q2hat = [0, -q2(3,1), q2(2,1);
        q2(3,1), 0, -q2(1,1);
        -q2(2,1), q2(1,1), 0];
q3hat = [0, -q3(3,1), q3(2,1);
        q3(3,1), 0, -q3(1,1);
        -q3(2,1), q3(1,1), 0];
q4hat = [0, -q4(3,1), q4(2,1);
        q4(3,1), 0, -q4(1,1);
        -q4(2,1), q4(1,1), 0];

ro1hat = [0, -ro1(3,1), ro1(2,1);
        ro1(3,1), 0, -ro1(1,1);
        -ro1(2,1), ro1(1,1), 0];
ro2hat = [0, -ro2(3,1), ro2(2,1);
        ro2(3,1), 0, -ro2(1,1);
        -ro2(2,1), ro2(1,1), 0];
ro3hat = [0, -ro3(3,1), ro3(2,1);
        ro3(3,1), 0, -ro3(1,1);
        -ro3(2,1), ro3(1,1), 0];
ro4hat = [0, -ro4(3,1), ro4(2,1);
        ro4(3,1), 0, -ro4(1,1);
        -ro4(2,1), ro4(1,1), 0];

ol0hat = [0, -ol0(3,1), ol0(2,1);
        ol0(3,1), 0, -ol0(1,1);
        -ol0(2,1), ol0(1,1), 0];

ol1hat = [0, -ol1(3,1), ol1(2,1);
        ol1(3,1), 0, -ol1(1,1);
        -ol1(2,1), ol1(1,1), 0];

ol2hat = [0, -ol2(3,1), ol2(2,1);
        ol2(3,1), 0, -ol2(1,1);
        -ol2(2,1), ol2(1,1), 0];

ol3hat = [0, -ol3(3,1), ol3(2,1);
        ol3(3,1), 0, -ol3(1,1);
        -ol3(2,1), ol3(1,1), 0];

ol4hat = [0, -ol4(3,1), ol4(2,1);
        ol4(3,1), 0, -ol4(1,1);
        -ol4(2,1), ol4(1,1), 0];

os1hat = [0, -os1(3,1), os1(2,1);
        os1(3,1), 0, -os1(1,1);
        -os1(2,1), os1(1,1), 0];

os2hat = [0, -os2(3,1), os2(2,1);
        os2(3,1), 0, -os2(1,1);
        -os2(2,1), os2(1,1), 0];

os3hat = [0, -os3(3,1), os3(2,1);
        os3(3,1), 0, -os3(1,1);
        -os3(2,1), os3(1,1), 0];

os4hat = [0, -os4(3,1), os4(2,1);
        os4(3,1), 0, -os4(1,1);
        -os4(2,1), os4(1,1), 0];

mq = m0*eye(3) + m1*(q1*q1') + m2*(q2*q2') + m3*(q3*q3') + m4*(q4*q4');


%%
ddx0 = simplifyFraction((A*C+B)\(B*P1 + A*P2));
dol0 = simplifyFraction((A*C+B)\(-C*P1+P2));
% dol0_2 = simplify(B\(-C*ddx0 + P2));
% ddx0_2 = simplifyFraction(A*dol0 + P1);
% dos1 = q1hat*(ddx0-ge3-Rb0*ro1hat*dol0+Rb0*ol0hat^2*ro1)/l1 - q1hat*u1p/(m1*l1);
% dos2 = q2hat*(ddx0-ge3-Rb0*ro2hat*dol0+Rb0*ol0hat^2*ro2)/l2 - q2hat*u2p/(m2*l2);
% dos3 = q3hat*(ddx0-ge3-Rb0*ro3hat*dol0+Rb0*ol0hat^2*ro3)/l3 - q3hat*u3p/(m3*l3);
% dos4 = q4hat*(ddx0-ge3-Rb0*ro4hat*dol0+Rb0*ol0hat^2*ro4)/l4 - q3hat*u4p/(m4*l4);

%%
GGGG=1

AA = mq\(m1*(q1*q1')*Rb0*ro1hat +m2*(q2*q2')*Rb0*ro2hat +m3*(q3*q3')*Rb0*ro3hat +m4*(q4*q4')*Rb0*ro4hat);
BB = J0 - m1*ro1hat*Rb0'*(q1*q1')*Rb0*ro1hat - m2*ro2hat*Rb0'*(q2*q2')*Rb0*ro2hat - m3*ro3hat*Rb0'*(q3*q3')*Rb0*ro3hat - m4*ro4hat*Rb0'*(q4*q4')*Rb0*ro4hat;
CC = m1*ro1hat*Rb0'*(q1*q1') +m2*ro2hat*Rb0'*(q2*q2') +m3*ro3hat*Rb0'*(q3*q3') +m4*ro4hat*Rb0'*(q4*q4');
P1_new = mq\((u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+(u4p-m4*l4*norm(os4)^2*q4-m1*(q4*q4')*Rb0*ol0hat^2*ro4))+ge3;
P2_new = ((m1*ro1hat*Rb0*(q1*q1'))+(m2*ro2hat*Rb0*(q2*q2'))+(m3*ro3hat*Rb0*(q3*q3'))+(m4*ro4hat*Rb0*(q4*q4')))*ge3-ol0hat*J0*ol0+ro1hat*Rb0'*(u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+ro2hat*Rb0'*(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+ro3hat*Rb0'*(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+ro4hat*Rb0'*(u4p-m4*l4*norm(os4)^2*q4-m4*(q4*q4')*Rb0*ol0hat^2*ro4); 
% S = subs(dos1,[A,B,C],[AA,BB,CC]);


%%



GGGG2=1
ddx0_new = subs(ddx0,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
% ddx0_new2 = simplifyFraction(((mq\(m1*(q1*q1')*Rb0*ro1hat +m2*(q2*q2')*Rb0*ro2hat +m3*(q3*q3')*Rb0*ro3hat +m4*(q4*q4')*Rb0*ro4hat))*(m1*ro1hat*Rb0'*(q1*q1') +m2*ro2hat*Rb0'*(q2*q2') +m3*ro3hat*Rb0'*(q3*q3') +m4*ro4hat*Rb0'*(q4*q4'))+(J0 - m1*ro1hat*Rb0'*(q1*q1')*Rb0*ro1hat - m2*ro2hat*Rb0'*(q2*q2')*Rb0*ro2hat - m3*ro3hat*Rb0'*(q3*q3')*Rb0*ro3hat - m4*ro4hat*Rb0'*(q4*q4')*Rb0*ro4hat))\((J0 - m1*ro1hat*Rb0'*(q1*q1')*Rb0*ro1hat - m2*ro2hat*Rb0'*(q2*q2')*Rb0*ro2hat - m3*ro3hat*Rb0'*(q3*q3')*Rb0*ro3hat - m4*ro4hat*Rb0'*(q4*q4')*Rb0*ro4hat)*(mq\((u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+(u4p-m4*l4*norm(os4)^2*q4-m1*(q4*q4')*Rb0*ol0hat^2*ro4))+ge3) + (mq\(m1*(q1*q1')*Rb0*ro1hat +m2*(q2*q2')*Rb0*ro2hat +m3*(q3*q3')*Rb0*ro3hat +m4*(q4*q4')*Rb0*ro4hat))*(((m1*ro1hat*Rb0*(q1*q1'))+(m2*ro2hat*Rb0*(q2*q2'))+(m3*ro3hat*Rb0*(q3*q3'))+(m4*ro4hat*Rb0*(q4*q4')))*ge3-ol0hat*J0*ol0+ro1hat*Rb0'*(u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+ro2hat*Rb0'*(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+ro3hat*Rb0'*(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+ro4hat*Rb0'*(u4p-m4*l4*norm(os4)^2*q4-m4*(q4*q4')*Rb0*ol0hat^2*ro4))));
dol0_new = subs(dol0,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);

dos1 = q1hat*(ddx0_new-ge3-Rb0*ro1hat*dol0_new+Rb0*ol0hat^2*ro1)/l1 - q1hat*u1p/(m1*l1);
dos2 = q2hat*(ddx0_new-ge3-Rb0*ro2hat*dol0_new+Rb0*ol0hat^2*ro2)/l2 - q2hat*u2p/(m2*l2);
dos3 = q3hat*(ddx0_new-ge3-Rb0*ro3hat*dol0_new+Rb0*ol0hat^2*ro3)/l3 - q3hat*u3p/(m3*l3);
dos4 = q4hat*(ddx0_new-ge3-Rb0*ro4hat*dol0_new+Rb0*ol0hat^2*ro4)/l4 - q3hat*u4p/(m4*l4);

GGGG3=1
dos1_new = subs(dos1,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
dos2_new = subs(dos2,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
GGGG4=1
dos3_new = subs(dos3,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
dos4_new = subs(dos4,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
dol1 = J1\(M1-cross(ol1,J1*ol1));
dol2 = J2\(M2-cross(ol2,J2*ol2));
dol3 = J3\(M3-cross(ol3,J3*ol3));
dol4 = J4\(M4-cross(ol4,J4*ol4));

dq1 = os1hat*q1;
dq2 = os2hat*q2;
dq3 = os3hat*q3;
dq4 = os4hat*q4;

dR0 = R0*ol0hat;
dR1 = R1*ol1hat;
dR2 = R2*ol2hat;
dR3 = R3*ol3hat;
dR4 = R4*ol4hat;

%%
% Usage: dx=f+g*u
% x = [ol0;ol1;ol2;ol3;ol4;os1;os2;os3;os4;q1;q2;q3;q4]; %lomega,somega,link
% Quat = [qt0;qt1;qt2;qt3;qt4];
% f = [v0;ddx0_new;dol0_new;dos1_new;dos2_new;dos3_new;dos4_new;dq1;dq2;dq3;dq4;dol1;dol2;dol3;dol4];
% dQuat = [dqt0;dqt1;dqt2;dqt3;dqt4];
% u = [u1;u2;u3;u4;M1;M2;M3;M4];
% 
% f = [v0,dqt0,ddx0_new,dol0_new,dq1,dq2,dq3,dq4,dos1_new,dos2_new,dos3_new,dos4_new,dqt1,dqt2,dqt3,dqt4,dol1,dol2,dol3,dol4];
% u = [u1,u2,u3,u4,M1,M2,M3,M4];

% matlabFunction(f,'file','malti_drone_suspended_load_FL','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});
% subs(f,u,[0,0,0,0,0,0,0,0])

%%
% f_data = [dos1_new];
% % u_data = [M1;M2;M3;M4];
% u_data = [u1;u2;u3;u4];
% fx = subs(f_data,u_data,zeros(size(u_data)));
% gx = [subs(f_data,u_data,[1;zeros(11,1)])-fx,subs(f_data,u_data,[zeros(1,1);1;zeros(10,1)])-fx,subs(f_data,u_data,[zeros(2,1);1;zeros(9,1)])-fx,subs(f_data,u_data,[zeros(3,1);1;zeros(8,1)])-fx,subs(f_data,u_data,[zeros(4,1);1;zeros(7,1)])-fx,subs(f_data,u_data,[zeros(5,1);1;zeros(6,1)])-fx,subs(f_data,u_data,[zeros(6,1);1;zeros(5,1)])-fx,subs(f_data,u_data,[zeros(7,1);1;zeros(4,1)])-fx,subs(f_data,u_data,[zeros(8,1);1;zeros(3,1)])-fx,subs(f_data,u_data,[zeros(9,1);1;zeros(2,1)])-fx,subs(f_data,u_data,[zeros(10,1);1;zeros(1,1)])-fx,subs(f_data,u_data,[zeros(11,1);1])-fx];
% simplifyFraction(f_data - (fx + gx*u_data));

% f_data = [ddx0_new;dol0_new;dos1_new;dos2_new;dos3_new;dos4_new];
% u_data = [u1;u2;u3;u4];
% % fx = subs(f_data,u_data,zeros(size(u_data)));
% fx = subs(ddx0_new,u_data,zeros(size(u_data)));
% AAAAA=1
% % gx = [subs(f_data,u_data,[1;zeros(11,1)])-fx,subs(f_data,u_data,[zeros(1,1);1;zeros(10,1)])-fx,subs(f_data,u_data,[zeros(2,1);1;zeros(9,1)])-fx,subs(f_data,u_data,[zeros(3,1);1;zeros(8,1)])-fx,subs(f_data,u_data,[zeros(4,1);1;zeros(7,1)])-fx,subs(f_data,u_data,[zeros(5,1);1;zeros(6,1)])-fx,subs(f_data,u_data,[zeros(6,1);1;zeros(5,1)])-fx,subs(f_data,u_data,[zeros(7,1);1;zeros(4,1)])-fx,subs(f_data,u_data,[zeros(8,1);1;zeros(3,1)])-fx,subs(f_data,u_data,[zeros(9,1);1;zeros(2,1)])-fx,subs(f_data,u_data,[zeros(10,1);1;zeros(1,1)])-fx,subs(f_data,u_data,[zeros(11,1);1])-fx];
% gx = [subs(ddx0_new,u_data,[1;zeros(11,1)])-fx,subs(ddx0_new,u_data,[zeros(1,1);1;zeros(10,1)])-fx,subs(ddx0_new,u_data,[zeros(2,1);1;zeros(9,1)])-fx,subs(ddx0_new,u_data,[zeros(3,1);1;zeros(8,1)])-fx,subs(ddx0_new,u_data,[zeros(4,1);1;zeros(7,1)])-fx,subs(ddx0_new,u_data,[zeros(5,1);1;zeros(6,1)])-fx,subs(ddx0_new,u_data,[zeros(6,1);1;zeros(5,1)])-fx,subs(ddx0_new,u_data,[zeros(7,1);1;zeros(4,1)])-fx,subs(ddx0_new,u_data,[zeros(8,1);1;zeros(3,1)])-fx,subs(ddx0_new,u_data,[zeros(9,1);1;zeros(2,1)])-fx,subs(ddx0_new,u_data,[zeros(10,1);1;zeros(1,1)])-fx,subs(ddx0_new,u_data,[zeros(11,1);1])-fx];
% % subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl
% % simplifyFraction(f_data - (fx + gx*u_data));
%%
% f_data2 = ddx0_new;
% fx2 = subs(f_data2,u_data,zeros(size(u_data)));
% gx2 = [subs(f_data2,u_data,[1;zeros(11,1)])-fx2,subs(f_data2,u_data,[zeros(1,1);1;zeros(10,1)])-fx2,subs(f_data2,u_data,[zeros(2,1);1;zeros(9,1)])-fx2,subs(f_data2,u_data,[zeros(3,1);1;zeros(8,1)])-fx2,subs(f_data2,u_data,[zeros(4,1);1;zeros(7,1)])-fx2,subs(f_data2,u_data,[zeros(5,1);1;zeros(6,1)])-fx2,subs(f_data2,u_data,[zeros(6,1);1;zeros(5,1)])-fx2,subs(f_data2,u_data,[zeros(7,1);1;zeros(4,1)])-fx2,subs(f_data2,u_data,[zeros(8,1);1;zeros(3,1)])-fx2,subs(f_data2,u_data,[zeros(9,1);1;zeros(2,1)])-fx2,subs(f_data2,u_data,[zeros(10,1);1;zeros(1,1)])-fx2,subs(f_data2,u_data,[zeros(11,1);1])-fx2];

%%
% kakunin2 = f_data2 - (fx2 + gx2*u_data);
%%
% kakunin = simplify(f_data - (fx + gx*u_data));

%%
% subs(ddx0_new,dol0,[0,0,0])
% subs(ddx0_new,data,dataset)
P = [m0,m1,m2,m3,m4]';
data = [q1;q2;q3;q4;ol0;ol1;ol2;ol3;ol4;os1;os2;os3;os4;f1;f2;f3;f4;M1;M2;M3;M4;qt0;qt1;qt2;qt3;qt4;P];
% q_dataset=[[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)]];
% q_dataset=[[0;1/sqrt(2);1/sqrt(2)];[0;1/sqrt(2);1/sqrt(2)];[0;1/sqrt(2);1/sqrt(2)];[0;1/sqrt(2);1/sqrt(2
q_dataset1=[0;-1;1];
q_dataset2=[0;-1;1];
q_dataset3=[0;-1;1];
q_dataset4=[0;-1;1];
q_dataset=[q_dataset1/vecnorm(q_dataset1);q_dataset2/vecnorm(q_dataset2);q_dataset3/vecnorm(q_dataset3);q_dataset4/vecnorm(q_dataset4)];

ol0_dataset=[0;0;0];
ol_dataset=[[0;0;0];[0;0;0];[0;0;0];[0;0;0]];
os_dataset=[[0;0;0];[0;0;0];[0;0;0];[0;0;0]];
u_dataset = [[0;0;1];[0;0;1];[0;0;1];[0;0;1]];
f_dataset=[1;1;1;1];
M_dataset = [[0;0;0];[0;0;0];[0;0;0];[0;0;0]];

qt0_dataset=[1;0;0;0];
qt1_dataset=[1;0;0;0];
qt2_dataset=[1;0;0;0];
qt3_dataset=[1;0;0;0];
qt4_dataset=[1;0;0;0];

m0_dataset = 1;
m1_dataset = 2;
m2_dataset = 2;
m3_dataset = 2;
m4_dataset = 2;
P_dataset = [m0_dataset,m1_dataset,m2_dataset,m3_dataset,m4_dataset]';

dataset = [q_dataset;ol0_dataset;ol_dataset;os_dataset;f_dataset;M_dataset;qt0_dataset;qt1_dataset;qt2_dataset;qt3_dataset;qt4_dataset;P_dataset];
% dataset2 = [q_dataset;ol0_dataset;ol_dataset;os_dataset;u_dataset;qt0_dataset;P1dataset;P2dataset];

% ddx0_new2 = subs(ddx0_new,[P1,P2],[P1_new,P2_new]);
%%
% matlabFunction(f,'file','FL','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
% [subs(ddx0_new,data,dataset);
% subs(dol0_new,data,dataset);
% subs(dos1_new,data,dataset);
% subs(dos2_new,data,dataset);
% subs(dos3_new,data,dataset);
% subs(dos4_new,data,dataset)]
v0= [0;0;0];

AA2 = subs(AA,data,dataset);
BB2 = subs(BB,data,dataset);
CC2 = subs(CC,data,dataset);
P1_new2 = subs(P1_new,data,dataset);
P2_new2 = subs(P2_new,data,dataset);

ddx0_out = simplifyFraction((AA2*CC2+BB2)\(BB2*P1_new2 + AA2*P2_new2));
dol0_out = simplifyFraction((AA2*CC2+BB2)\(-CC2*P1_new2+P2_new2));
dos1_out = subs((q1hat*(ddx0_out-ge3-Rb0*ro1hat*dol0_out+Rb0*ol0hat^2*ro1)/l1 - q1hat*u1p/(m1*l1)),data,dataset);
dos2_out = subs((q2hat*(ddx0_out-ge3-Rb0*ro2hat*dol0_out+Rb0*ol0hat^2*ro2)/l2 - q2hat*u2p/(m2*l2)),data,dataset);
dos3_out = subs((q3hat*(ddx0_out-ge3-Rb0*ro3hat*dol0_out+Rb0*ol0hat^2*ro3)/l3 - q3hat*u3p/(m3*l3)),data,dataset);
dos4_out = subs((q4hat*(ddx0_out-ge3-Rb0*ro4hat*dol0_out+Rb0*ol0hat^2*ro4)/l4 - q3hat*u4p/(m4*l4)),data,dataset);

dq1_out = subs(os1hat*q1,data,dataset);
dq2_out = subs(os2hat*q2,data,dataset);
dq3_out = subs(os3hat*q3,data,dataset);
dq4_out = subs(os4hat*q4,data,dataset);


% dR0_out = subs(R0*ol0hat,data,dataset);
% dR1_out = subs(R1*ol1hat,data,dataset);
% dR2_out = subs(R2*ol2hat,data,dataset);
% dR3_out = subs(R3*ol3hat,data,dataset);
% dR4_out = subs(R4*ol4hat,data,dataset);

dqt0_out = subs(L0'*ol0/2,data,dataset); %ペイロードの姿勢
dqt1_out = subs(L1'*ol1/2,data,dataset); %ドローンの姿勢
dqt2_out = subs(L2'*ol2/2,data,dataset);
dqt3_out = subs(L3'*ol3/2,data,dataset);
dqt4_out = subs(L4'*ol4/2,data,dataset);

dol1 = subs(J1\(M1-cross(ol1,J1*ol1)),data,dataset);
dol2 = subs(J2\(M2-cross(ol2,J2*ol2)),data,dataset);
dol3 = subs(J3\(M3-cross(ol3,J3*ol3)),data,dataset);
dol4 = subs(J4\(M4-cross(ol4,J4*ol4)),data,dataset);

out = [v0;dqt0_out;ddx0_out;dol0_out;dq1_out;dq2_out;dq3_out;dq4_out;dos1_out;dos2_out;dos3_out;dos4_out;dqt1_out;dqt2_out;dqt3_out;dqt4_out;dol1;dol2;dol3;dol4]
out_2 = reshape(double(out),[5,13])'
%[ 3*1;dr0 4*1;ddx0 3*1;do0 3*1;dqi 3*N;dwi 3*N;dri 4*N;doi 3*N]

% ddx0_out2 = ddx0_out'
% dol0_out2 = dol0_out'
% dos1_out2 = dos1_out'
% dos2_out2 = dos2_out'
% dos3_out2 = dos3_out'
% dos4_out2 = dos4_out'