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
%syms r0 [4 1] real % 姿勢角（オイラーパラメータ）
syms R0 [3 3] real
R0 = R0';
syms o0 [3 1] real % 角速度
%syms do0 [3 1] real
syms qi [N 3] real % リンクのドローンから見た方向ベクトル：論文中qi
qi = qi';
syms wi [N 3] real % リンクの角速度
wi = wi';
syms dwi [N 3] real
dwi = dwi';

% ドローンに関する変数定義 %%%%%%%%%%%%%%%%%%
%syms ri [N 4] real % 姿勢角（オイラーパラメータ）
%ri = ri';
syms Ri [N 3] real
Ri = Ri';
syms oi [N 3] real % 角速度
oi = oi';
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
%[R0,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
%tmp = mat2cell(ri,4,ones(1,N));
%[Ri,Li] = arrayfun(@(q) RodriguesQuaternion(q{:}),tmp,'UniformOutput',false); % ドローン姿勢回転行列
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
x_no_q = [x0;dx0;o0;reshape([qi,wi],6*N,1);reshape(oi,3*N,1)]; % 9*(N+1)
%% 参照軌道 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms x0d [3 1] real
syms dx0d [3 1] real
syms ddx0d [3 1] real
syms dddx0d [3 1] real
%syms r0d [4 1] real % 姿勢角（オイラーパラメータ）
syms o0d [3 1] real % 角速度
syms do0d [3 1] real 
syms R0d [3 3] real
R0d = R0d';
%R0d = RodriguesQuaternion(r0d); % 牽引物回転行列
%%
syms Pdagger [3*N 6] real % = P'*inv(P*P')
syms qid [3 N] real
syms mui [3 N] real
%syms Ai [3 N] real
syms Fd [3 1] real
syms Md [3 1] real
%% gains
syms kqi kwi real
syms kx0 kdx0 kr0 ko0 real
syms kri koi e real
gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi e]';
%% for zup
syms Gains [size(gains)] real
syms X [9*(N+1) 1] real
syms Xd [3*6 1] real
rp = [1 -1 -1]; rq = [1 1 -1 -1];
Rzup = [rp, rp, rp, repmat(rp, 1,N), repmat(rp, 1,N), repmat(rp, 1,N)]';
rX = Rzup.*X;
rXd = [rp rp rp rp rp rp]'.*Xd;

%% (20)-(22)
ex0 = x0 - x0d;
dex0 = dx0 -dx0d;
R0dTR0 = R0d'*R0;
R0TR0d = R0dTR0';
eR0 = Vee(R0dTR0 - R0TR0d)/2;
eo0 = o0 - R0dTR0'*o0d;
%% (23),(24)
clc
Fd0 = m0*(-kx0*ex0- kdx0*dex0 + ddx0d - g*e3);
Md0 = -kr0*eR0 - ko0*eo0 + Skew(R0TR0d*o0d)*J0*R0TR0d*o0d + J0*R0TR0d*do0d;
matlabFunction(subs(subs([R0'*Fd0;Md0],[R0,R0d],diag([1 -1 -1])*[R0,R0d]),[x_no_q;x0d;dx0d;ddx0d;dddx0d;o0d;do0d;gains],[rX;rXd;Gains]),"file",dir+"CSLC_"+N+"_R0TFdMd.m","vars",{X,Xd,R0,R0d,physicalParam,Gains},...
  "Comments","[R0'*Fd;Md] for (26)")
%P =[repmat(eye(3),1,N); horzcat(Rho{:})];
%%
%muid = reshape(kron(eye(N),R0)*Pdagger*[R0'*Fd;Md],3,N); % 3xN
%mui = sum(muid.*qi,1).*qi;% 3xN
%qid = -muid./sqrt(sum(muid.*muid,1)); % 3xN
%%
%dwi = cross(qi,ai)./li - cross(qi,uip1)./(mi.*li);
e = -R0d'*qid;
dqid = -R0d*Skew(o0d)*e; % 3xN
wid = cross(qid,dqid); % 3xN
ddqid = R0d*(Skew(do0d) + Skew(o0d)^2)*e;
dwid = cross(qid,ddqid);
eqi = cross(qid,qi); % 3xN
ewi = wi + cellmatfun(@(Qi,i) Qi^2*wid(:,i),Qi,"mat");
%% ui
%ai = ddx0 - g*e3 + R0*O0^2*rho - R0'*cellmatfun(@(R,i) R*do0,Rho,"mat"); % (15) 3xN
R0Rho = cellmatfun(@(Rho,i) R0*Rho,Rho,"struct");
RhoR0Tmu = cellmatfun(@(R0Rho,i) -R0Rho'*mui(:,i),R0Rho,"mat");
ai3 = cellmatfun(@(M,i) M*inv(J0)*(O0*J0*o0-sum(RhoR0Tmu,2)),R0Rho,"mat");% 3xN
ai = sum(mui,2)/m0 + R0*O0^2*rho + ai3; % (19) 3xN
% uip1 = mui + mi.*li.*sum(wi.*wi,1).*qi;% ui parallel 3xN
% uip2 = mi.*li.*qi.*(-kqi.*eqi -kwi.*ewi -sum(qi.*wid,1).*cross(wi,qi) - cellmatfun(@(Qi,i) Qi^2*dwid(:,i),Qi,"mat")); % ui perp
% ui = uip1 + uip2 + mi.*ai; % 3xN
ui3 = sum(wi.*wi,1).*qi + cross(qi,wid) - kqi*(qid - sum(qi.*qid,1).*qi)...
  -kwi*cross(qi,wi-wid) - sum(qi.*wid,1).*(wi-sum(qi.*wi,1).*qi);
ui = mui + mi.*ai + mi.*li.*ui3;
matlabFunction(subs(subs(ui,[R0,R0d],diag([1 -1 -1])*[R0,R0d]),[x_no_q;x0d;dx0d;ddx0d;dddx0d;o0d;do0d;gains],[rX;rXd;Gains]),"file",dir + "CSLC_"+N+"_ui.m","vars",{X Xd R0 R0d physicalParam Gains Pdagger mui qid})

%%
clc
clear ui
syms ui [3 N] real
syms Ri [3 3 N] real
syms b1 [3 N] real
syms b2 [3 N] real
syms b3 [3 N] real
syms si [1 N] real
syms ci [1 N] real
%%
load("tmp.mat");
ddx0d = [0;0;0];
x0d = [0;0;0];
dx0d = [0;0;0];
dddx0d = [0;0;0];
oi = 
%%
b3ddx0d=cross(b3,repmat(ddx0d,1,N));
db3 = zeros(size(b3));
db2 = (b3ddx0d-ci.*b2)./si;
db1 = -cross(b3,db2);
ddb3 = db3;
ddb2 = (cross(b3,repmat(dddx0d,1,N))+(b2-ci.*b3ddx0d)./si - ci.*db2)./si;
ddb1 = -cross(b3,ddb2);
Ric = [b1;b2;b3];% 9xN
dRic = [db1;db2;db3];% 9xN
ddRic = [ddb1;ddb2;ddb3];% 9xN
RicT = matrix_transpose_3x3to9x1(Ric);% 9xN = Ric'
hoic = matrix_prod_3x3to9x1(RicT,dRic); % 9xN = Ric'*dRic in so3
oic=mtake(hoic,[6,7,2]);% 3xN = Vee(hoic)
doic = mtake(matrix_prod_3x3to9x1(RicT,ddRic) - matrix_prod_3x3to9x1(hoic,hoic),[6,7,2]);% 3xN
%%
% quatRiT = ri.*[1;-1;-1;-1];% = R2q(Ri');
% RiTRic = [quat_times_vec(quatRiT,Ric(1:3,:));quat_times_vec(quatRiT,Ric(4:6,:));quat_times_vec(quatRiT,Ric(7:9,:))]; %9xN
Ric3 = reshape(Ric,3,3,[]);
RiTRic=arrayfun(@(i) Ri(:,:,i)'*Ric3(:,:,i),1:N,'UniformOutput',false);
%eri = Vee(RiTRic'-RiTRic)/2;
%eri = mtake(matrix_transpose_3x3to9x1(RiTRic)-RiTRic,[6,7,2])/2;% 3xN
eri = arrayfun(@(i) Vee(RiTRic{i}'-RiTRic{i}),1:N,'UniformOutput',false); % N-cell
eri = horzcat(eri{:}); % 3xN
%RiTRicoic = cellmatfun(@(R,i) R*oic(:,i),RiTRic,"mat");
%RiTRicoicd = matrix_prod_3x3to9x1(RiTRic,[oic;doic;zeros(size(oic))]);% 1:3 = RiTRic*oic, 4:6 = RiTRic*doic
RiTRicoicd = arrayfun(@(i) [RiTRic{i}*oic(:,i);RiTRic{i}*doic(:,i)],1:N,'UniformOutput',false); % 3xN
RiTRicoicd = horzcat(RiTRicoicd{:}); % 6xN
eoi = oi - RiTRicoicd(1:3,:);% 3xN
%%
%fi = -sum(ui.*quat_times_vec(ri,e3),1);
fi = arrayfun(@(i) ui(:,1)'*Ri(:,:,i)*e3,1:N,'UniformOutput',false);
fi = -horzcat(fi{:});
Mi = - kri*eri/(e^2) - koi*eoi/2 + cross(oi,ji.*oi) - ji.*(cross(oi,RiTRicoicd(1:3,:))-RiTRicoicd(4:6,:));% 3xN
%%
matlabFunction(subs(reshape([-fi;Mi.*[1;-1;-1]],[],1),[x_no_q;x0d;dx0d;ddx0d;dddx0d;o0d;do0d;gains],[rX;rXd;Gains]),"file",dir+"CSLC_"+N+"_Uvec.m","Vars",{X,Xd,physicalParam,Gains,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci})
%%
% X,Xd,R0,R0d,physicalParam,Gains
fname = "CooperativeSuspendedLoadController_" + N;
str = "function U = "+fname+"(x_no_q,qi,R0,Ri,R0d,xd,K,P,Pdagger)\n"+...
  " %% x_no_q : state except for q\n %% qi : subpart of x 3xN\n %% xd : reference 18x1 : =[x0d;dx0d;ddx0d;dddx0d;o0d;do0d] \n"+...
" %% R0 : load attitude 3x3\n %% Ri : drone attitude\n %% R0d : reference attitude\n"+...
" %% K : gains = []\n"+...
" %% P : physical parameter\n %% Pdagger = pinv(P) in (26)\n"+...
" %% U : [f1;M1;f2;M2;...] for zup system\n"+...  
"R0TFdMd = CSLC_"+N+"_R0TFdMd(x_no_q,xd,R0,R0d,P,K);\n"+...
"muid = reshape(kron(eye("+N+"),R0)*Pdagger*R0TFdMd,3,"+N+"); %% 3xN\n"+...
"mui = sum(muid.*qi,1).*qi; %% 3xN\n"+...
"qid = -muid./vecnorm(muid,1); %% 3xN\n"+...
"ui = CSLC_"+N+"_ui(x_no_q,xd,R0,R0d,P,K,Pdagger,mui,qid);\n"+...
"b3 = -ui./sqrt(sum(ui.*ui,1)); %% 3xN\n"+...
"b1 = xd(4:6) + 0.1*cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],1:"+N+",'UniformOutput',false)); %% Caution : problem if dx0d = - 10*xi.\n"+...
"b1 = b1./sqrt(sum(b1.*b1,1));\n"+...
"b2 = cross(b3, b1); %% 3xN\n"+...
"si = sqrt(sum(b2.*b2,1));\n"+...
"ci = sum(b3.* b1,1);\n"+...
"b2 = b2 ./ si;\n"+...
"b1 = cross(b2, b3);\n"+...
"U= CSLC_"+N+"_Uvec(x_no_q,xd,P,K,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci);\nend\n";
fileID = fopen(dir + fname+".m",'w');
fprintf(fileID,str);
fclose(fileID);