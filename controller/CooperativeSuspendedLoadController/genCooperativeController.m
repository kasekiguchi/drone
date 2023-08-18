% generate controller for cooperative suspended load system
clear
clc
% 以下の論文に基づくコントローラ
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き zup : 鉛直上向き
%%
dir = "controller/CooperativeSuspendedLoadController/";
%% symbol定義
N = 3; % エージェント数
% 牽引物に関する変数定義 %%%%%%%%%%%%%%%%%%%%
syms x0 [3 1] real % 位置
syms dx0 [3 1] real
syms ddx0 [3 1] real
syms r0 [4 1] real % 姿勢角（オイラーパラメータ）
syms R0 [3 3] real
syms o0 [3 1] real % 角速度
syms qi [3 N] real % リンクのドローンから見た方向ベクトル：論文中qi
syms wi [3 N] real % リンクの角速度

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

Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度

%% 参照軌道 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms x0d [3 1] real
syms dx0d [3 1] real
syms ddx0d [3 1] real
syms dddx0d [3 1] real
syms o0d [3 1] real % 角速度
syms do0d [3 1] real 
syms R0d [3 3] real
X = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)]; % 9*(N+1)
Xd = [x0d;dx0d;ddx0d;dddx0d;o0d;do0d]; % R0d は除いている

%%
syms Pdagger [3*N 6] real % = P'*inv(P*P')
syms qid [3 N] real
syms mui [3 N] real
syms Fd [3 1] real
syms Md [3 1] real
%% gains
syms kqi kwi real
syms kx0 [1 3] real
syms kdx0 [1 3] real
syms kr0 ko0 real
syms kri koi epsilon real
Gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon];
%% (20)-(22)
ex0 = x0 - x0d;
dex0 = dx0 -dx0d;
eR0 = Vee(R0d'*R0 - R0'*R0d)/2;
eo0 = o0 - R0'*R0d*o0d;
%% (23),(24)

Fd0 = m0*(-kx0*ex0- kdx0*dex0 + ddx0d + g*e3);
Md0 = -kr0*eR0 - ko0*eo0 + Skew(R0'*R0d*o0d)*J0*R0'*R0d*o0d + J0*R0'*R0d*do0d;
matlabFunction([R0'*Fd0;Md0],"file",dir+"CSLC_"+N+"_R0TFdMd.m","vars",{X,Xd,R0,R0d,physicalParam,Gains},...
  "Comments","[R0'*Fd;Md] for (26)")
%%
%dwi = cross(qi,ai)./li - cross(qi,uip1)./(mi.*li);
 syms dqid [3 N] real
 syms ddqid [3 N] real
for i = 1:N
%dqid(:,i) = 0*(-R0d*Skew(o0d)*(-R0d'*qid(:,i))); % 3xN % 要検討　：近似微分？
wid(:,i) = cross(qid(:,i),dqid(:,i)); % 3xN
%ddqid(:,i) = 0*(R0d*(Skew(do0d) + Skew(o0d)^2)*(-R0d'*qid(:,i))); % 要検討　：近似微分？
dwid(:,i) = cross(qid(:,i),ddqid(:,i));
eqi(:,i) = cross(qid(:,i),qi(:,i)); % 3xN
ewi(:,i) = wi(:,i) + Qi{i}^2*wid(:,i);
end
%% ui
for i = 1:N
  RhoR0Tmu(:,i) = Rho{i}*R0'*mui(:,i);
end
for i = 1:N
  dqi(:,i) = cross(wi(:,i),qi(:,i));
  ai(:,i) = sum(mui,2)/m0 + R0*O0^2*rho(:,i) + R0*Rho{i}*inv(J0)*(O0*J0*o0-sum(RhoR0Tmu,2)); % (19) 3xN
  uip1(:,i) = mui(:,i) + mi(i)*li(i)*(wi(:,i)'*wi(:,i))*qi(:,i) + mi(i)*qi(:,i)*qi(:,i)'*ai(:,i);% ui parallel 3xN
  uip2(:,i) = mi(i)*li(i)*Qi{i}*(-kqi*eqi(:,i) -kwi*ewi(:,i) -(qi(:,i)'*wid(:,i))*dqi(:,i) - Qi{i}^2*dwid(:,i)) - mi(i)*Qi{i}^2*ai(:,i); % ui perp
end
ui = uip1 + uip2; % 3xN
matlabFunction(ui, ai(:,i),O0*J0*o0,-sum(RhoR0Tmu,2),"file",dir + "CSLC_"+N+"_ui.m","vars",{X Xd R0 R0d physicalParam Gains Pdagger mui qid dqid ddqid})

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
db3 = zeros(size(b3));
for i = 1:N
b3ddx0d(:,i) = cross(b3(:,i),ddx0d);
db2(:,i) = (b3ddx0d(:,i)-ci(i)*b2(:,i))/si(i);
db1(:,i) = -cross(b3(:,i),db2(:,i));
ddb3(:,i) = db3(:,i);
ddb2(:,i) = (cross(b3(:,i),dddx0d)+(b2(:,i)-ci(i)*b3ddx0d(:,i))/si(i) - ci(i)*db2(:,i))/si(i);
ddb1(:,i) = -cross(b3(:,i),ddb2(:,i));
Ric{i} = [b1(:,i) b2(:,i) b3(:,i)];% 3x3xN
dRic{i} = [db1(:,i) db2(:,i) db3(:,i)];% 3x3xN
ddRic{i} = [ddb1(:,i),ddb2(:,i),ddb3(:,i)];% 3x3xN
oic(:,i) = Vee(Ric{i}'*dRic{i});% 3xN = Vee(hoic)
doic(:,i) = Vee(Ric{i}'*ddRic{i} - (Ric{i}'*dRic{i})^2);%+ (dRic{i}'*dRic{i}));% 3xN
end
for i = 1:N
  eri(:,i) = Vee(Ric{i}'*Ri(:,:,i)-Ri(:,:,i)'*Ric{i})/2;
  eoi(:,i) = oi(:,i) - Ri(:,:,i)'*Ric{i}*oic(:,i);% 3xN
end
%%
for i = 1:N
fi(i) = ui(:,i)'*Ri(:,:,i)*e3;
Mi(:,i) = - kri*eri(:,i)/(epsilon^2) - koi*eoi(:,i)/epsilon + Oi(:,i)*Ji{i}*oi(:,i) - Ji{i}*(Oi{i}*Ri(:,:,i)'*Ric{i}*oic(:,i)-Ri(:,:,i)*Ric{i}*doic(:,i));% 3xN
end
matlabFunction(reshape([fi;Mi],[],1),"file",dir+"CSLC_"+N+"_Uvec.m","Vars",{X,Xd,physicalParam,Gains,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci})
%%
% X,Xd,R0,R0d,physicalParam,Gains
fname = "CooperativeSuspendedLoadController_" + N;
str = "function U = "+fname+"(x,qi,R0,Ri,R0d,xd,K,P,Pdagger)\n"+...
  " %% x : state\n %% qi : subpart of x 3xN\n %% xd : reference 18x1 : =[x0d;dx0d;ddx0d;dddx0d;o0d;do0d] \n"+...
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
"b1 = xd(4:6) + 0.1*cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],1:"+N+",'UniformOutput',false)); %% Caution : problem if dx0d = - 10*xi.\n"+...
"b1 = b1./vecnorm(b1,2,1);\n"+...
"b2 = cross(b3, b1); %% 3xN\n"+...
"si = vecnorm(b2,2,1);\n"+...
"ci = sum(b3.* b1,1);\n"+...
"b2 = b2 ./ si;\n"+...
"b1 = cross(b2, b3);\n"+...
"U= CSLC_"+N+"_Uvec(x,xd,P,K,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci);\nend\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str)
fclose(fileID);