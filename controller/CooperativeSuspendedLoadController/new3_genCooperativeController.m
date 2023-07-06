% generate controller for cooperative suspended load system
clear
clc
% 以下の論文に基づくコントローラ
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き
%%
dir = "controller/CooperativeSuspendedLoadController/";
%% symbol定義
N = 4; % エージェント数
% 牽引物に関する変数定義 %%%%%%%%%%%%%%%%%%%%
syms x0 [3 1] real % 位置
syms dx0 [3 1] real
%syms ddx0 [3 1] real
syms r0 [4 1] real % 姿勢角（オイラーパラメータ）
syms R0 [3 3] real
syms o0 [3 1] real % 角速度
syms qi [3 N] real % リンクのドローンから見た方向ベクトル：論文中qi
syms wi [3 N] real % リンクの角速度
%syms dwi [3 N] real

% ドローンに関する変数定義 %%%%%%%%%%%%%%%%%%
syms ri [4 N] real % 姿勢角（オイラーパラメータ）
syms Ri [3 3 N] real
syms oi [3 N] real % 角速度
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
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
Oi = arrayfun(@(i) Skew(oi(:,i)),1:N,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
Ji = arrayfun(@(i) diag(ji(:,i)),1:N,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; %
G = g*e3;
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)]; % 9*(N+1)
%% 参照軌道 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms x0d [3 1] real
syms dx0d [3 1] real
syms ddx0d [3 1] real
syms dddx0d [3 1] real
%syms r0d [4 1] real % 姿勢角（オイラーパラメータ）
syms o0d [3 1] real % 角速度
syms do0d [3 1] real 
syms R0d [3 3] real
Xd = [x0d;dx0d;ddx0d;dddx0d;o0d;do0d];

%%
syms Pdagger [3*N 6] real % = P'*inv(P*P')
syms qid [3 N] real
syms mui [3 N] real
syms Fd [3 1] real
syms Md [3 1] real
%% gains
syms kqi kwi real
syms kx0 [3 1] real
syms kdx0 [3 1] real
syms kr0 ko0 real
syms kri koi epsilon real
gains = [kx0' kr0 kdx0' ko0 kqi kwi kri koi epsilon];
%% (20)-(22)
ex0 = x0 - x0d;
dex0 = dx0 - dx0d;
eR0 = Vee(R0d'*R0 - R0'*R0d)/2;
eo0 = o0 - R0'*R0d*o0d;
%% (23),(24)
clc
Fd0 = m0*(-kx0.*ex0- kdx0.*dex0 + ddx0d + G);
Md0 = -kr0*eR0 - ko0*eo0 + Skew(R0'*R0d*o0d)*J0*R0'*R0d*o0d + J0*R0'*R0d*do0d;
matlabFunction([R0'*Fd0;Md0],"file",dir+"CSLC_"+N+"_R0TFdMd.m","vars",{x,Xd,R0,R0d,physicalParam,gains},...
  "Comments","[R0'*Fd;Md] for (26)")
%%
% -qid = R0d*e  ... (1)
% e : constant unit vector that points the drone's position
% time derivative of (1) 
% -dqid = R0d*Skew(o0d)*e, 
% where de/dt = 0 since e is constant vector.
% dqid = R0d*Skew(o0d)*R0d'*qid
% Similarly 
% -ddqid = R0d*Skew(o0d)^2*e + R0d*Skew(do0d)*e
dqid = R0d*Skew(o0d)*(R0d'*qid); % 3xN
wid = cross(qid,dqid); % 3xN
ddqid = R0d*(Skew(do0d) + Skew(o0d)^2)*R0d'*qid;
dwid = cross(qid,ddqid);
eqi = cross(qid,qi); % 3xN
ewi = wi + cellmatfun(@(Qi,i) Qi^2*wid(:,i),Qi,"mat");
%% ui
tmp = 0;
for i = 1:N, tmp = tmp+Rho{i}*R0'*mui(:,i); end
for i = 1:N
  ai(:,i) = sum(mui,2)/m0 + R0*O0^2*rho(:,i)+R0*Rho{i}*inv(J0)*(O0*J0*o0-tmp);
  uil(:,i) = mui(:,i) + mi(i)*li(i)*(wi(:,i)'*wi(:,i))*qi(:,i) + mi(i)*qi(:,i)*qi(:,i)'*ai(:,i);
  uip(:,i) = mi(i)*li(i)*Qi{i}*(-kqi*eqi(:,i)-kwi*ewi(:,i)-(qi(:,i)'*wid(:,i))*cross(wi(:,i),qi(:,i))-Qi{i}^2*dwid(:,i)) - mi(i)*Qi{i}^2*ai(:,i);
  ui(:,i) = uil(:,i) + uip(:,i);
end

matlabFunction(ui,"file",dir + "CSLC_"+N+"_ui.m","vars",{x Xd R0 R0d physicalParam gains Pdagger mui qid})

%%
clc
clear ui
syms ui [3 N] real
syms b1 [3 N] real
syms b2 [3 N] real
syms b3 [3 N] real
syms si [1 N] real
syms ci [1 N] real
%%
clc
b3ddx0d=cross(b3,repmat(ddx0d,1,N));
db3 = zeros(size(b3));
db2 = (b3ddx0d-ci.*b2)./si;
db1 = -cross(b3,db2);
ddb3 = db3;
ddb2 = (cross(b3,repmat(dddx0d,1,N))+(b2-ci.*b3ddx0d)./si - ci.*db2)./si;
ddb1 = -cross(b3,ddb2);
for i = 1:N
  Ric(:,:,i) = [b1(:,i),b2(:,i),b3(:,i)];
  dRic(:,:,i) = [db1(:,i),db2(:,i),db3(:,i)];
  ddRic(:,:,i) = [ddb1(:,i),ddb2(:,i),ddb3(:,i)];
  oic(:,i) = Vee(Ric(:,:,i)'*dRic(:,:,i));
  doic(:,i) = Vee(Ric(:,:,i)'*ddRic(:,:,i)-(Ric(:,:,i)'*dRic(:,:,i))^2);
  eri(:,i) = Vee(Ric(:,:,i)'*Ri(:,:,i)-Ri(:,:,i)'*Ric(:,:,i))/2;
  eoi(:,i) = oi(:,i) - Ri(:,:,i)'*Ric(:,:,i)*oic(:,i);
  fi(:,i) = ui(:,i)'*Ri(:,:,i)*e3;
  Mi(:,i) = - kri*eri(:,i)/(epsilon^2) - koi*eoi(:,i)/epsilon + Oi{i}*Ji{i}*oi(:,i) - Ji{i}*(Oi{i}*Ri(:,:,i)'*Ric(:,:,i)*oic(:,i)-Ri(:,:,i)'*Ric(:,:,i)*doic(:,i));% 3xN
end
matlabFunction(reshape([fi;Mi],[],1),"file",dir+"CSLC_"+N+"_Uvec.m","Vars",{x,Xd,physicalParam,gains,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci})
%%
% X,Xd,R0,R0d,physicalParam,Gains
fname = "CooperativeSuspendedLoadController_" + N;
str = "function U = "+fname+"(x,qi,R0,Ri,R0d,xd,K,P,Pdagger)\n"+...
  " %% x : state \n %% qi : subpart of x 3xN\n %% xd : reference 18x1 : =[x0d;dx0d;ddx0d;dddx0d;o0d;do0d] \n"+...
" %% R0 : load attitude 3x3\n %% Ri : drone attitude\n %% R0d : reference attitude\n"+...
" %% K : gains = []\n"+...
" %% P : physical parameter\n %% Pdagger = pinv(P) in (26)\n"+...
" %% U : [f1;M1;f2;M2;...] for zup system\n"+...  
"R0TFdMd = CSLC_"+N+"_R0TFdMd(x,xd,R0,R0d,P,K);\n"+...
"muid = reshape(kron(eye("+N+"),R0)*Pdagger*R0TFdMd,3,"+N+"); %% 3xN\n"+...
"mui = sum(muid.*qi,1).*qi; %% 3xN\n"+...
"qid = -muid./vecnorm(muid,2,1); %% 3xN\n"+...
"ui = CSLC_"+N+"_ui(x,xd,R0,R0d,P,K,Pdagger,mui,qid);\n"+...
"b3 = ui./vecnorm(ui,2,1); %% 3xN\n"+...
"b1 = xd(4:6) + 1*cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],1:"+N+",'UniformOutput',false)); %% Caution : problem if dx0d = - 10*xi.\n"+...
"b1 = b1./vecnorm(b1,2,1);\n"+...
"b2 = cross(b3, b1); %% 3xN\n"+...
"si = vecnorm(b2,2,1);\n"+...
"ci = sum(b3.* b1,1);\n"+...
"b2 = b2 ./ si;\n"+...
"b1 = cross(b2, b3);\n"+...
"U= CSLC_"+N+"_Uvec(x,xd,P,K,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci);\nend\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str);
fclose(fileID);