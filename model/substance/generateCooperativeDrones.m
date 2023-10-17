clear
clc
% 以下の論文に基づくモデル化
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き

%% symbol定義
N = 3; % エージェント数
% 牽引物に関する変数定義 %%%%%%%%%%%%%%%%%%%%
syms x0 [3 1] real % 位置
syms dx0 [3 1] real
syms ddx0 [3 1] real
syms r0 [4 1] real % 姿勢角（オイラーパラメータ）
syms o0 [3 1] real % 角速度
syms do0 [3 1] real
syms qi [N 3] real % リンクのドローンから見た方向ベクトル：論文中qi
qi = qi';
syms wi [N 3] real % リンクの角速度
wi = wi';
syms dwi [N 3] real
dwi = dwi';

% ドローンに関する変数定義 %%%%%%%%%%%%%%%%%%
syms ri [N 4] real % 姿勢角（オイラーパラメータ）
ri = ri';
syms oi [N 3] real % 角速度
oi = oi';
syms fi [1 N] real % 推力入力
syms Mi [N 3] real % モーメント入力
Mi = Mi';
%% 牽引物の物理パラメータ %%%%%%%%%%%%%%%%%%%
syms g real % 重力加速度
syms m0 real % 質量
syms j0 [3 1] real % 慣性モーメント
syms rho [N 3] real % 牽引物座標系でのリンク接続位置：第i列がi番目のドローンとの接続位置
rho = rho';
syms li [1 N] real % リンク長
% ドローンの物理パラメータ %%%%%%%%%%%%%%%%%%%
syms mi [1 N] real % 質量
syms ji [N 3] real % 慣性モーメント
ji = ji';
physicalParam = [g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)];
%%
[R0,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
tmp = mat2cell(ri,4,ones(1,N));
[Ri,Li] = arrayfun(@(q) RodriguesQuaternion(q{:}),tmp,'UniformOutput',false); % ドローン姿勢回転行列
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
tmp = mat2cell(oi,3,ones(1,N));
Oi = arrayfun(@(o) Skew(o{:}),tmp,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
tmp = mat2cell(ji,3,ones(1,N));
Ji = arrayfun(@(j) diag(j{:}),tmp,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; % 鉛直下向き
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
u = reshape([fi;Mi],4*N,1);
%% 
% (1)
tmp = arrayfun(@(i) Skew(wi(:,i))*qi(:,i),1:N,'UniformOutput',false);
dqi = vertcat(tmp{:});
% (2)
dr0 = L0'*o0/2;
tmp = arrayfun(@(i) Li{i}'*oi(:,i)/2,1:N,'UniformOutput',false);
dri = vertcat(tmp{:});
%%
Mq = m0*eye(3) + qi*diag(mi)*qi';
ui = arrayfun(@(i) -fi(i)*Ri{i}*e3,1:N,'UniformOutput',false);
ul = arrayfun(@(i) qi(:,i)*qi(:,i)'*ui{i},1:N,'UniformOutput',false); % (10)
up = arrayfun(@(i) (eye(3) - qi(:,i)*qi(:,i)')*ui{i},1:N,'UniformOutput',false); % (11)
%% (6) 
mqiqiR0 = arrayfun(@(i) mi(i)*qi(:,i)*qi(:,i)'*R0,1:N,'UniformOutput',false);
tmp = arrayfun(@(i) mqiqiR0{i}*Rho{i},1:N,'UniformOutput',false);
mqiqiR0rhoidO0 = [tmp{:}]*repmat(do0,N,1);
tmp = arrayfun(@(i) mqiqiR0{i}*O0^2*rho(:,i),1:N,'UniformOutput',false);
mqiqiR0O02rho = [tmp{:}]*ones(N,1);
rhs6 = ([ul{:}])*ones(N,1)-qi*(mi.*li.*sum(wi.^2,1))'-mqiqiR0O02rho;
eq6 = Mq*(ddx0 - g*e3) - mqiqiR0rhoidO0 -rhs6;
%% (7)
lhs71 = J0*do0;
tmp = arrayfun(@(i) mi(i)*Rho{i}*R0'*qi(:,i)*qi(:,i)'*R0*Rho{i},1:N,'UniformOutput',false);
lhs72 = [tmp{:}]*repmat(do0,N,1);
tmp = arrayfun(@(i) mi(i)*Rho{i}*R0'*qi(:,i)*qi(:,i)',1:N,'UniformOutput',false);
lhs73 = [tmp{:}]*repmat((ddx0-g*e3),N,1);
lhs74 = O0*J0*o0;
tmp = arrayfun(@(i) Rho{i}*R0',1:N,'UniformOutput',false);
rhs71 = [tmp{:}]*vertcat(ul{:});
tmp = arrayfun(@(i) Rho{i}*R0'*mi(i)*li(i)*sum(wi(:,i).^2),1:N,'UniformOutput',false);
rhs72 = [tmp{:}]*reshape(qi,[3*N,1]);
tmp = arrayfun(@(i) Rho{i}*R0'*mi(i)*qi(:,i)*qi(:,i)'*R0*O0^2,1:N,'UniformOutput',false);
rhs73 = [tmp{:}]*reshape(rho,[3*N,1]);
rhs7 = rhs71 - rhs72 - rhs73;
eq7 = lhs71 - lhs72 + lhs73 + lhs74 - (rhs7);
%% solve (6), (7) derive ddx0, do0
% eq6 = A6*[ddx0;do0] + B6
B6 = subs(eq6,[ddx0;do0],[0;0;0;0;0;0]);
tmp=arrayfun(@(eq) fliplr(coeffs(eq,[ddx0;do0])),eq6-B6,'UniformOutput',false);
A6 = vertcat(tmp{:});
% eq7 = A7*[ddx0;do0] + B7
B7 = subs(eq7,[ddx0;do0],[0;0;0;0;0;0]);
tmp=arrayfun(@(eq) fliplr(coeffs(eq,[ddx0;do0])),eq7-B7,'UniformOutput',false);
A7 = vertcat(tmp{:});
Addx0do0 = [A6;A7];
matlabFunction(Addx0do0,"File","Addx0do0_"+string(N),"Vars",{x u physicalParam},'outputs',{'A'})
syms iA [6 6] 
matlabFunction(-iA*[B6;B7],"File","ddx0do0_"+string(N),"Vars",{x u physicalParam iA},'outputs',{'dX'});
%% (8)
syms ddX [6 1]  % ddX = [ddx0;do0]
rhs81 = ddX(1:3)-g*e3; % 3x1
tmp = arrayfun(@(i) R0*Rho{i}*ddX(4:6),1:N,'UniformOutput',false);
rhs82 = tmp;
rhs83 = arrayfun(@(i) R0*O0^2*rho(:,i),1:N,'UniformOutput',false);
rhs8 =  arrayfun(@(i) li(i)\Qi{i}*(rhs81-rhs82{i}+rhs83{i})-(mi(i)*li(i))\Qi{i}*up{i},1:N,'UniformOutput',false);
%% (9)
tmp = arrayfun(@(i) Ji{i}\(-Oi{i}*Ji{i}*oi(:,i)+Mi(:,i)),1:N,'UniformOutput',false);
doi = vertcat(tmp{:});

%% 

%dX = [dx0;dr0;ddx0;do0;dqi;dwi;dri;doi];
matlabFunction([dx0;dr0;ddX;dqi;vertcat(rhs8{:});dri;doi],"File","tmp_cable_suspended_rigid_body_with_"+string(N)+"_drones","Vars",{x u physicalParam ddX},'outputs',{'dX'});



%%
syms q1 [3,1] real; syms q2 [3,1] real; syms q3 [3,1] real; syms q4 [3,1] real %リンクの方向ベクトル
syms ol0 [3,1] real; %ペイロードの角速度
syms ol1 [3,1] real;syms ol2 [3,1] real;syms ol3 [3,1] real;syms ol4 [3,1] real; %機体の角速度
syms os1 [3,1] real;syms os2 [3,1] real;syms os3 [3,1] real;syms os4 [3,1] real; %リンクの角速度
syms M1 [3,1] real;syms M2 [3,1] real;syms M3 [3,1] real;syms M4 [3,1] real %3*1 モーメント入力
syms R0 [3,3] real; %ペイロードを軸にした回転行列
syms R1 [3,3] real; syms R2 [3,3] real; syms R3 [3,3] real; syms R4 [3,3] real; %機体回転行列
syms f1 real; syms f2 real; syms f3 real; syms f4 real; %機体推力
syms qt0 [4,1] real; syms qt1 [4,1] real; syms qt2 [4,1] real; syms qt3 [4,1] real; syms qt4 [4,1] real; %クォータニオン(姿勢)

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

syms ro1 [3,1] real;
syms ro2 [3,1] real;
syms ro3 [3,1] real;
syms ro4 [3,1] real;

% ro1 = [0.05; 0.05; 0.05];
% ro2 = [-0.05; 0.05; 0.05];
% ro3 = [-0.05; -0.05; 0.05];
% ro4 = [0.05; -0.05; 0.05]; %ペイロードの重心とリングが接地している点までの長さ

syms m0 real;
syms m1 real;
syms m2 real;
syms m3 real;
syms m4 real;

% m0 = 0.1;
% m1 = 0.2;
% m2 = 0.2;
% m3 = 0.2;
% m4 = 0.2;

ge3 = [0;0;9.81]; 

% syms J0 [3,3] real; syms J1 [3,3] real; syms J2 [3,3] real; syms J3 [3,3] real; syms J4 [3,3] real; 
jx = 0.005;
jy = 0.005;
jz = 0.005;
J0=diag([0.01, 0.01, 0.01]);
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
% enq1 = ddx0 == A*dol0 + P1;
% enq2 = B*dol0 == -C*ddx0 + P2;

% ddx0 = A*dol0 + P1;
%%
A0=[1,1,1;1,1,1;1,1,1];
B0=[1,1,1;1,1,1;1,1,1];
C0=[1,1,1;1,1,1;1,1,1];
P10=[1;2;2];
P20=[1;2;1];

%%
ddx0 = simplifyFraction((A*C+B)\(B*P1 + A*P2));
o0 = simplifyFraction((A*C+B)\(-C*P1+P2));
% dol0_2 = simplify(B\(-C*ddx0 + P2));
% ddx0_2 = simplifyFraction(A*dol0 + P1);
dos1 = q1hat*(ddx0-ge3-Rb0*ro1hat*o0+Rb0*ol0hat^2*ro1)/l1 - q1hat*u1p/(m1*l1);
dos2 = q2hat*(ddx0-ge3-Rb0*ro2hat*o0+Rb0*ol0hat^2*ro2)/l2 - q2hat*u2p/(m2*l2);
dos3 = q3hat*(ddx0-ge3-Rb0*ro3hat*o0+Rb0*ol0hat^2*ro3)/l3 - q3hat*u3p/(m3*l3);
dos4 = q4hat*(ddx0-ge3-Rb0*ro4hat*o0+Rb0*ol0hat^2*ro4)/l4 - q3hat*u4p/(m4*l4);

GGGG=1

AA = mq\(m1*(q1*q1')*Rb0*ro1hat +m2*(q2*q2')*Rb0*ro2hat +m3*(q3*q3')*Rb0*ro3hat +m4*(q4*q4')*Rb0*ro4hat);
BB = J0 - m1*ro1hat*Rb0'*(q1*q1')*Rb0*ro1hat - m2*ro2hat*Rb0'*(q2*q2')*Rb0*ro2hat - m3*ro3hat*Rb0'*(q3*q3')*Rb0*ro3hat - m4*ro4hat*Rb0'*(q4*q4')*Rb0*ro4hat;
CC = m1*ro1hat*Rb0'*(q1*q1') +m2*ro2hat*Rb0'*(q2*q2') +m3*ro3hat*Rb0'*(q3*q3') +m4*ro4hat*Rb0'*(q4*q4');
P1_new = mq\((u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+(u4p-m4*l4*norm(os4)^2*q4-m1*(q4*q4')*Rb0*ol0hat^2*ro4))+ge3;
P2_new = ((m1*ro1hat*Rb0*(q1*q1'))+(m2*ro2hat*Rb0*(q2*q2'))+(m3*ro3hat*Rb0*(q3*q3'))+(m4*ro4hat*Rb0*(q4*q4')))*ge3-ol0hat*J0*ol0+ro1hat*Rb0'*(u1p-m1*l1*norm(os1)^2*q1-m1*(q1*q1')*Rb0*ol0hat^2*ro1)+ro2hat*Rb0'*(u2p-m2*l2*norm(os2)^2*q2-m2*(q2*q2')*Rb0*ol0hat^2*ro2)+ro3hat*Rb0'*(u3p-m3*l3*norm(os3)^2*q3-m3*(q3*q3')*Rb0*ol0hat^2*ro3)+ro4hat*Rb0'*(u4p-m4*l4*norm(os4)^2*q4-m4*(q4*q4')*Rb0*ol0hat^2*ro4); 
% S = subs(dos1,[A,B,C],[AA,BB,CC]);

GGGG2=1
ddx0_new = subs(ddx0,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
dol0_new = subs(o0,[A,B,C,P1,P2],[AA,BB,CC,P1_new,P2_new]);
dos1_new = subs(dos1,[A,B,C],[AA,BB,CC]);
dos2_new = subs(dos2,[A,B,C],[AA,BB,CC]);
dos3_new = subs(dos3,[A,B,C],[AA,BB,CC]);
dos4_new = subs(dos4,[A,B,C],[AA,BB,CC]);
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
x = [q1,q2,q3,q4,ol0,ol1,ol2,ol3,ol4,os1,os2,os3,os4];
Quat = [qt0,qt1,qt2,qt3,qt4];
% f = [v0,ddx0_new,dol0_new,dos1_new,dos2_new,dos3_new,dos4_new,dq1,dq2,dq3,dq4,dol1,dol2,dol3,dol4];
dQuat = [dqt0,dqt1,dqt2,dqt3,dqt4];
f = [v0,dqt0,ddx0_new,dol0_new,dq1,dq2,dq3,dq4,dos1_new,dos2_new,dos3_new,dos4_new,dqt1,dqt2,dqt3,dqt4dol1,dol2,dol3,dol4];
u = [u1,u2,u3,u4,M1,M2,M3,M4];


% matlabFunction(f,'file','malti_drone_suspended_load_FL','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});
% subs(f,u,[0,0,0,0,0,0,0,0])

%%
f_data = [ddx0_new;dol0_new;dos1_new;dos2_new;dos3_new;dos4_new];
u_data = [u1;u2;u3;u4];
% fx = subs(f_data,u_data,zeros(size(u_data)));
fx = subs(ddx0_new,u_data,zeros(size(u_data)));
% gx = [subs(f_data,u_data,[1;zeros(11,1)])-fx,subs(f_data,u_data,[zeros(1,1);1;zeros(10,1)])-fx,subs(f_data,u_data,[zeros(2,1);1;zeros(9,1)])-fx,subs(f_data,u_data,[zeros(3,1);1;zeros(8,1)])-fx,subs(f_data,u_data,[zeros(4,1);1;zeros(7,1)])-fx,subs(f_data,u_data,[zeros(5,1);1;zeros(6,1)])-fx,subs(f_data,u_data,[zeros(6,1);1;zeros(5,1)])-fx,subs(f_data,u_data,[zeros(7,1);1;zeros(4,1)])-fx,subs(f_data,u_data,[zeros(8,1);1;zeros(3,1)])-fx,subs(f_data,u_data,[zeros(9,1);1;zeros(2,1)])-fx,subs(f_data,u_data,[zeros(10,1);1;zeros(1,1)])-fx,subs(f_data,u_data,[zeros(11,1);1])-fx];
gx = [subs(ddx0_new,u_data,[1;zeros(11,1)])-fx,subs(ddx0_new,u_data,[zeros(1,1);1;zeros(10,1)])-fx,subs(ddx0_new,u_data,[zeros(2,1);1;zeros(9,1)])-fx,subs(ddx0_new,u_data,[zeros(3,1);1;zeros(8,1)])-fx,subs(ddx0_new,u_data,[zeros(4,1);1;zeros(7,1)])-fx,subs(ddx0_new,u_data,[zeros(5,1);1;zeros(6,1)])-fx,subs(ddx0_new,u_data,[zeros(6,1);1;zeros(5,1)])-fx,subs(ddx0_new,u_data,[zeros(7,1);1;zeros(4,1)])-fx,subs(ddx0_new,u_data,[zeros(8,1);1;zeros(3,1)])-fx,subs(ddx0_new,u_data,[zeros(9,1);1;zeros(2,1)])-fx,subs(ddx0_new,u_data,[zeros(10,1);1;zeros(1,1)])-fx,subs(ddx0_new,u_data,[zeros(11,1);1])-fx];
subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl
f_data - (fx + gx*u_data)
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
data = [q1;q2;q3;q4;ol0;ol1;ol2;ol3;ol4;os1;os2;os3;os4;u1;u2;u3;u4;qt0];
% q_dataset=[[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)];[1/(3)^(1/2);1/(3)^(1/2);1/(3)^(1/2)]];
q_dataset=[[0;0;1];[0;0;1];[0;0;1];[0;0;1]];
ol0_dataset=[0;0;0];
ol_dataset=[[0;0;0];[0;0;0];[0;0;0];[0;0;0]];
os_dataset=[[0;0;0];[0;0;0];[0;0;0];[0;0;0]];
u_dataset = [[0;0;-3];[0;0;-3];[0;0;-3];[0;0;-3]];

% P1dataset=subs(P1_new,data,dataset);
% P2dataset=subs(P2_new,data,dataset);

% data2 = [q1;q2;q3;q4;ol0;ol1;ol2;ol3;ol4;os1;os2;os3;os4;u1;u2;u3;u4;qt0;P1;P2];

alfa=pi/180*90;
beta=pi/180*0;
gunma=pi/180*60;
R0_matrix = [cos(alfa)*cos(beta)*cos(gunma)-sin(alfa)*sin(gunma),-cos(alfa)*cos(beta)*sin(gunma)-sin(alfa)*cos(gunma),cos(alfa)*sin(beta);
            sin(alfa)*cos(beta)*cos(gunma)-cos(alfa)*sin(gunma),-sin(alfa)*cos(beta)*sin(gunma)-cos(alfa)*sin(gunma),sin(alfa)*sin(gunma);
            -sin(beta)*cos(gunma),sin(beta)*sin(gunma),cos(beta)];

qt0_dataset=[1;0;0;0];


dataset = [q_dataset;ol0_dataset;ol_dataset;os_dataset;u_dataset;qt0_dataset];
% dataset2 = [q_dataset;ol0_dataset;ol_dataset;os_dataset;u_dataset;qt0_dataset;P1dataset;P2dataset];

% ddx0_new2 = subs(ddx0_new,[P1,P2],[P1_new,P2_new]);
%%
% matlabFunction(f,'file','FL','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});

%%
% [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
% reshape([fi;Mi],4*N,1);
x0data = [0;0;0];
r0data = [1;0;0;0];
dx0data = [1;0;0];
o0data = [0;0;0];
% q1 = [0,1/sqrt(2),1/sqrt(2)]'; q2 = [0,1/sqrt(2),1/sqrt(2)]'; q3 = [0,1/sqrt(2),1/sqrt(2)]'; q4 = [0,1/sqrt(2),1/sqrt(2)]';
q1 = [0,-1,1]'; q2 = [0,-1,1]'; q3 = [0,-1,1]'; q4 = [0,-1,1]';
qidata=[q1/vecnorm(q1);q2/vecnorm(q2);q3/vecnorm(q3);q4/vecnorm(q4)];

% qidata = [q1;q2;q3;q4];
w1 = [0,0,0]'; w2 = [0,0,0]'; w3 = [0,0,0]'; w4 = [0,0,0]';
widata = [w1;w2;w3;w4];
% r1 = [0.8776,0.4794,0,0]'; r2 = [1,0,0,0]'; r3 = [1,0,0,0]'; r4 = [0.8776,0.4794,0,0]';
r1 = [1,0,0,0]'; r2 = [1,0,0,0]'; r3 = [1,0,0,0]'; r4 = [1,0,0,0]';
ridata = [r1;r2;r3;r4];
o1 = [0,0,0]'; o2 = [0,0,0]'; o3 = [0,0,0]'; o4 = [0,0,0]'; 
oidata = [o1;o2;o3;o4];
xdata=[x0data;r0data;dx0data;o0data;qidata;widata;ridata;oidata];

fidata = [1,1,1,1];
M1 = [0,0,0]; M2 = [0,0,0]; M3 = [0,0,0]; M4 = [0,0,0];
udata =[fidata(1,1),M1,fidata(1,2),M2,fidata(1,3),M3,fidata(1,4),M4]';

% [g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)]
gdata = 9.81;
m0data = 1;
j0data = [0.1,0.1,0.1];
rho1data = [1,1,-1]; rho2data = [1,-1,-1]; rho3data = [-1,-1,-1]; rho4data = [-1,1,-1];
rhodata = [rho1data,rho2data,rho3data,rho4data];
lidata = [0.5,0.5,0.5,0.5];
midata = [2,2,2,2];
j1data = [0.005,0.005,0.005]; j2data = [0.005,0.005,0.005]; j3data = [0.005,0.005,0.005]; j4data = [0.005,0.005,0.005];
jidata = [j1data,j2data,j3data,j4data];
P = [gdata,m0data,j0data,rhodata,lidata,midata,jidata];

%%
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
% [x01, x02, x03, r01, r02, r03, r04, dx01, dx02, dx03, o01, o02, o03, qi1_1, qi1_2, qi1_3, qi2_1, qi2_2, qi2_3, qi3_1, qi3_2, qi3_3, qi4_1, qi4_2, qi4_3, wi1_1, wi1_2, wi1_3, wi2_1, wi2_2, wi2_3, wi3_1, wi3_2, wi3_3, wi4_1, wi4_2, wi4_3, ri1_1, ri1_2, ri1_3, ri1_4, ri2_1, ri2_2, ri2_3, ri2_4, ri3_1, ri3_2, ri3_3, ri3_4, ri4_1, ri4_2, ri4_3, ri4_4, oi1_1, oi1_2, oi1_3, oi2_1, oi2_2, oi2_3, oi3_1, oi3_2, oi3_3, oi4_1, oi4_2, oi4_3]
% u = [f1 M1 f2 M2 .. f4 M4]
% [fi1, Mi1_1, Mi1_2, Mi1_3, fi2, Mi2_1, Mi2_2, Mi2_3, fi3, Mi3_1, Mi3_2, Mi3_3, fi4, Mi4_1, Mi4_2, Mi4_3]
% P = [g m0 j0 rho li mi ji]
% [g, m0, j01, j02, j03, rho1_1, rho1_2, rho1_3, rho2_1, rho2_2, rho2_3, rho3_1, rho3_2, rho3_3, rho4_1, rho4_2, rho4_3, li1, li2, li3, li4, mi1, mi2, mi3, mi4, ji1_1, ji1_2, ji1_3, ji2_1, ji2_2, ji2_3, ji3_1, ji3_2, ji3_3, ji4_1, ji4_2, ji4_3]

% [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
% x0 = [zeros(3,1);[1;0;0;0];zeros(6,1);repmat([0;0;1],4,1);zeros(12,1);repmat([1;0;0;0],4,1);repmat([0;0;0],4,1)];
% x0 = [zeros(3,1);[1;0;0;0];zeros(3,1);zeros(3,1);repmat([0;0;1],4,1);zeros(12,1);repmat([1;0;0;0],4,1);repmat([0;0;0],4,1)];

% u0 = zeros(4*4,1);
% u0 = [fidata;Midata]
% P = [9.81, 0.1, [0.01, 0.01, 0.01], [1,1,1, 1,-1,1, -1,-1,1, -1,1,1], [0.5 0.5 0.5 0.5], [0.2 0.2 0.2 0.2],0.005*ones(1,12)];
% P = [9.81, 1, [0.01, 0.01, 0.01], [0.2,0.1,-0.1, -0.2,0.1,-0.1, -0.2,-0.1,-0.1, 0.2,-0.1,-0.1], [1 1 1 1], [1 1 1 1],0.005*ones(1,12)]
%%
%             3       7        10       13     25      37      53      65    
%dX = [dx0 3*1;dr0 4*1;ddx0 3*1;do0 3*1;dqi 3*N;dwi 3*N;dri 4*N;doi 3*N]
% iAdata =inv(Addx0do0_4(xdata,udata,P));
% ddx0do0_4(xdata,udata,P,iAdata);
% dxdata = reshape(tmp_cable_suspended_rigid_body_with_4_drones(xdata,udata,P,ddxdata),[13,5])
dxdata = reshape(cable_suspended_rigid_body_with_4_drones(xdata,udata,P),[5,13])'

%%
eul = [pi/4 0 0];
qZYX = eul2quat(eul)