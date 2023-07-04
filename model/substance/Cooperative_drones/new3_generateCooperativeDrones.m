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
syms qi [3 N] real % リンクのドローンから見た方向ベクトル：論文中qi
syms wi [3 N] real % リンクの角速度
syms R0 [3 3] real
syms Ri [3 3 N] real

% ドローンに関する変数定義 %%%%%%%%%%%%%%%%%%
syms ri [4 N] real % 姿勢角（オイラーパラメータ）
syms oi [3 N] real % 角速度
syms fi [1 N] real % 推力入力
syms Mi [3 N] real % モーメント入力
%% 牽引物の物理パラメータ %%%%%%%%%%%%%%%%%%%
syms g real % 重力加速度
syms m0 real % 質量
syms j0 [3 1] real % 慣性モーメント
syms rho [3 N] real % 牽引物座標系でのリンク接続位置：第i列がi番目のドローンとの接続位置
syms li [1 N] real % リンク長
% ドローンの物理パラメータ %%%%%%%%%%%%%%%%%%%
syms mi [1 N] real % 質量
syms ji [3 N] real % 慣性モーメント
physicalParam = [g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)];
%%
[~,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
[~,Li] = RodriguesQuaternion(ri);
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
Oi = arrayfun(@(i) Skew(oi(:,i)),1:N,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
Ji = arrayfun(@(i) diag(ji(:,i)),1:N,'UniformOutput',false); % ドローン慣性行列
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
dr0 = L0'*o0/2;
for i = 1:N
% (1)
dqi(:,i) = cross(wi(:,i),qi(:,i));
% (2)
dri(:,i) = Li(:,:,i)'*oi(:,i)/2;
ui(:,i) = fi(i)*Ri(:,:,i)*e3;
%ul(:,i) = qi(:,i)*qi(:,i)'*ui(:,i);
%up(:,i) = (eye(3) - qi(:,i)*qi(:,i)')*ui(:,i); % (11)
end
%%
clc
syms ddX0dO0 [6 1] real
ddX0 = ddX0dO0(1:3);
dO0 = ddX0dO0(4:6);
eq22 = zeros(3);
eq23 = zeros(3);
eq32 = zeros(3);
eq33 = zeros(3);
for i = 1:N
  uil(:,i) = qi(:,i)*qi(:,i)'*ui(:,i);
  uip(:,i) = (eye(3) - qi(:,i)*qi(:,i)')*ui(:,i);
  ai(:,i) = ddX0 + g*e3 - R0*Rho{i}*dO0+ R0*O0^2*rho(:,i);
  eq21(:,i) = uil(:,i) - mi(i)*li(i)*(wi(:,i)'*wi(:,i))*qi(:,i) - mi(i)*qi(:,i)*qi(:,i)'*(g*e3+R0*O0^2*rho(:,1));
  eq22 = eq22 + mi(i)*qi(:,i)*qi(:,i)';
  eq23 = eq23 + mi(i)*qi(:,i)*qi(:,i)'*(-R0*Rho{i});
  eq31(:,i) = Rho{i}*R0'*uil(:,i) - Rho{i}*R0'*mi(i)*li(i)*(wi(:,i)'*wi(:,i))*qi(:,i) - Rho{i}*R0'*mi(i)*qi(:,i)*qi(:,i)'*(g*e3+R0*O0^2*rho(:,1)) ;
  eq32 = eq32 + Rho{i}*R0'*mi(i)*qi(:,i)*qi(:,i)';
  eq33 = eq33 + Rho{i}*R0'*mi(i)*qi(:,i)*qi(:,i)'*(-R0*Rho{i}); 
end
A = [m0*eye(3) + eq22, eq23; eq32,J0 + eq33];
B = [ -m0*g*e3 + sum(eq21,2);- O0*J0*o0 + sum(eq31,2)];
%%
dqi = reshape(dqi,[],1);
dri = reshape(dri,[],1);
%% A* [ddx0;do0] = B
syms iA [6 6] real
matlabFunction(A,"File",dir+"Addx0do0_"+N,"Vars",{x R0 u physicalParam},'outputs',{'A'})
matlabFunction(iA*B,"File",dir+"ddx0do0_"+N,"Vars",{x R0 Ri u physicalParam iA},'outputs',{'dX'})
%%
syms ddqi [3 1] real
syms a [3 1] real
syms b [3 1] real
syms c [3 1] real
syms d [3 1] real
%% (8) (9)
for i = 1:N
  dwi(:,i) = -Skew(qi(:,i))*(qi(:,i)'*Skew(wi(:,i))^2*qi(:,i))*qi(:,i) + Skew(qi(:,i))*Qi{i}^2*(ui(:,i)-mi(i)*ai(:,i))/(mi(i)*li(i));% dwi = Skew(qi)*ddqi
  doi(:,i) = Ji{i}\(-Oi{i}*Ji{i}*oi(:,i)+Mi(:,i));
end

%% 
% %dX = [dx0;dr0;ddx0;do0;dqi;dwi;dri;doi];
matlabFunction([dx0;dr0;ddX0dO0;dqi;reshape(dwi,[],1);dri;reshape(doi,[],1)],"File",dir+"tmp_cable_suspended_rigid_body_with_"+N+"_drones","Vars",{x R0 Ri u physicalParam ddX0dO0},'outputs',{'dX'})
%% gen cable_suspended_rigid_body_with_N_drones
fname = "zup_cable_suspended_rigid_body_with_" + N + "_drones";
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
%% zup model
fname = "zup_cable_suspended_rigid_body_with_" + N + "_drones";
str = "function dx = "+fname+"(x,u,P)\n"+...
"r0 = [1;1;-1;-1].*x(4:7);\n ri = [1;1;-1;-1].*reshape(x("+(13+6*N+1)+":"+(13+10*N)+"),4,[]);\n"+...
"R0 = RodriguesQuaternion(r0);\n"+...
"Ri = RodriguesQuaternion(ri);\n"+...
"rp = [1 -1 -1]'; rq = [1;1;-1;-1];\nRzup = [rp; rq; rp; rp; repmat(rp, 2*"+N+",1); repmat(rq, "+N+",1); repmat(rp, "+N+",1)];\n"+...
"X = Rzup.*x;\n"+...
"ddX = ddx0do0_"+N+"(X,R0,Ri,u,P,inv(Addx0do0_"+N+"(X,R0,u,P)));\n" + ...
"dX = tmp_cable_suspended_rigid_body_with_"+N+"_drones(X,R0,Ri,u,P,ddX);\n" + ...
"dx = Rzup.*dX;\nend\n"+...
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


