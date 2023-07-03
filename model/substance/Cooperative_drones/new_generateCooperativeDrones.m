clear
clc
% 以下の論文に基づくモデル化
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き
dir = "model/substance/Cooperative_drones/";
N = 3; % エージェント数

%% symbol定義
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
syms R0 [3 3] real
syms Ri [3 3 N] real

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
[~,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
tmp = mat2cell(ri,4,ones(1,N));
[~,Li] = RodriguesQuaternion(ri);%arrayfun(@(q) RodriguesQuaternion(q{:}),tmp,'UniformOutput',false); % ドローン姿勢回転行列
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
tmp = mat2cell(oi,3,ones(1,N));
Oi = arrayfun(@(o) Skew(o{:}),tmp,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
tmp = mat2cell(ji,3,ones(1,N));
Ji = arrayfun(@(j) diag(j{:}),tmp,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; %
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
 % 13 + 13 * N states
u = reshape([fi;Mi],4*N,1);
%% 
% (1)
tmp = arrayfun(@(i) Skew(wi(:,i))*qi(:,i),1:N,'UniformOutput',false);
dqi = vertcat(tmp{:});
% (2)
dr0 = L0'*o0/2;
tmp = arrayfun(@(i) Li(:,:,i)'*oi(:,i)/2,1:N,'UniformOutput',false);
dri = vertcat(tmp{:});
%%
Mq = m0*eye(3) + qi*diag(mi)*qi';
ui = arrayfun(@(i) -fi(i)*Ri(:,:,i)*e3,1:N,'UniformOutput',false);
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
% eq6 = A6*[ddx0;do0] + B6 == 0
B6 = subs(eq6,[ddx0;do0],[0;0;0;0;0;0]);
tmp=arrayfun(@(eq) fliplr(coeffs(eq,[ddx0;do0])),eq6-B6,'UniformOutput',false);
A6 = vertcat(tmp{:});
% eq7 = A7*[ddx0;do0] + B7 == 0
B7 = subs(eq7,[ddx0;do0],[0;0;0;0;0;0]);
tmp=arrayfun(@(eq) fliplr(coeffs(eq,[ddx0;do0])),eq7-B7,'UniformOutput',false);
A7 = vertcat(tmp{:});
Addx0do0 = [A6;A7];
%%
matlabFunction(Addx0do0,"File",dir+"Addx0do0_"+N,"Vars",{x R0 u physicalParam},'outputs',{'A'})
syms iA [6 6] 
matlabFunction(-iA*[B6;B7],"File",dir+"ddx0do0_"+N,"Vars",{x R0 Ri u physicalParam iA},'outputs',{'dX'})
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

% %dX = [dx0;dr0;ddx0;do0;dqi;dwi;dri;doi];
matlabFunction([dx0;dr0;ddX;dqi;vertcat(rhs8{:});dri;doi],"File",dir+"tmp_cable_suspended_rigid_body_with_"+N+"_drones","Vars",{x R0 Ri u physicalParam ddX},'outputs',{'dX'});
%% gen cable_suspended_rigid_body_with_N_drones
fname = "cable_suspended_rigid_body_with_" + N + "_drones";
str = "function dX = "+fname+"(x,u,P)\n"+...
"R0 = RodriguesQuaternion(x(4:7));\n"+...
"Ri = RodriguesQuaternion(reshape(x("+(13+6*N+1)+":"+(13+6*N+4*N)+"),4,[]));\n"+...
"ddX = ddx0do0_"+N+"(x,R0,Ri,u,P,inv(Addx0do0_"+N+"(x,R0,u,P)));\n" + ...
  "dX = tmp_cable_suspended_rigid_body_with_"+N+"_drones(x,R0,Ri,u,P,ddX);\nend\n" + ...
  "%%%% 状態：\n%% 牽引物: 位置，姿勢角，速度，角速度，\n%% リンク: 角度，角速度\n" + ...
"%% ドローン:姿勢角，角速度\n%% x = [p0 Q0 v0 O0 qi wi Qi Oi]\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str);
fclose(fileID);

%% euler angle model : roll-pitch-yaw(ZYX) euler angle 
fname = "eul_cable_suspended_rigid_body_with_" + N + "_drones";
str = "function dx = "+fname+"(x,u,P)\n"+...
  "eui = reshape(x("+(12+6*N+1)+":"+(12+6*N+3*N)+"),3,[]);\n"+...
  "r0 = Eul2Quat(x(4:6));\n ri = Eul2Quat(eui);\n"+...
"R0 = RodriguesQuaternion(r0);\n"+...
"Ri = RodriguesQuaternion(ri);\n"+...
"X = [x(1:3);r0;x(7:"+(12+6*N)+");reshape(ri,[],1);x("+(12+6*N+3*N+1)+":end)];\n"+...
"ddX = ddx0do0_"+N+"(X,R0,Ri,u,P,inv(Addx0do0_"+N+"(X,R0,u,P)));\n" + ...
  "dX = tmp_cable_suspended_rigid_body_with_"+N+"_drones(X,R0,Ri,u,P,ddX);\n" + ...
"deu0 = pinv(dQdEu(x(4:6)))*dX(4:7); dP = dQdEu(eui); dq = reshape(dX("+(13+6*N+1)+":"+(13+6*N+4*N)+"),4,[]);\n" +...
"deui = zeros(3,"+N+");\n for i = 1:"+N+"\n deui(:,i)=pinv(dP(:,:,i))*dq(:,i);\n"+...
"dx = [dX(1:3);deu0;dX(8:"+(13+6*N)+");reshape(deui,[],1);dX("+(13+6*N+4*N+1)+":end)];\nend\n"+...
  "%%%% 状態：\n%% 牽引物: 位置，姿勢角，速度，角速度，\n%% リンク: 角度，角速度\n"+...
"%% ドローン:姿勢角，角速度\n%% x = [p0 Q0 v0 O0 qi wi Qi Oi]\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str);
fclose(fileID);
%% zup euler angle model
fname = "zup_eul_cable_suspended_rigid_body_with_" + N + "_drones";
str = "function dx = "+fname+"(x,u,P)\n"+...
  "eui = reshape(x("+(12+6*N+1)+":"+(12+6*N+3*N)+"),3,[]);\n"+...
  "r0 = [1;1;-1;-1].*Eul2Quat(x(4:6));\n ri = [1;1;-1;-1].*Eul2Quat(eui);\n"+...
"R0 = RodriguesQuaternion(r0);\n"+...
"Ri = RodriguesQuaternion(ri);\n"+...
"rp = [1 -1 -1]'; \nRzup = [rp; rp; rp; rp; repmat(rp, 4*"+N+",1)];\n"+...
"X = [rp.*x(1:3);r0;repmat(rp, 2+2*"+N+",1).*x(7:"+(12+6*N)+");reshape(ri,[],1);repmat(rp, "+N+",1).*x("+(12+6*N+3*N+1)+":end)];\n"+...
"ddX = ddx0do0_"+N+"(X,R0,Ri,u,P,inv(Addx0do0_"+N+"(X,R0,u,P)));\n" + ...
"dX = tmp_cable_suspended_rigid_body_with_"+N+"_drones(X,R0,Ri,u,P,ddX);\n" + ...
"deu0 = pinv(dQdEu(x(4:6)))*dX(4:7);\ndP = dQdEu(eui);\ndq = reshape(dX("+(13+6*N+1)+":"+(13+6*N+4*N)+"),4,[]);\n" +...
"deui = zeros(3,"+N+");\nfor i = 1:"+N+"\n  deui(:,i)=pinv(dP(:,:,i))*dq(:,i);\nend\n"+...
"dx = Rzup.*[dX(1:3);deu0;dX(8:"+(13+6*N)+");reshape(deui,[],1);dX("+(13+6*N+4*N+1)+":end)];\nend\n"+...
  "%%%% 状態：\n%% 牽引物: 位置，姿勢角，速度，角速度，\n%% リンク: 角度，角速度\n"+...
"%% ドローン:姿勢角，角速度\n%% x = [p0 Q0 v0 O0 qi wi Qi Oi]\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str);
fclose(fileID);


