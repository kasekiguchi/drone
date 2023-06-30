% generate controller for cooperative suspended load system
clear
clc
% 以下の論文に基づくコントローラ
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き zup : 鉛直上向き
dir = "controller/CooperativeSuspendedLoad/";
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
e3 = [0;0;1]; %
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
%% 参照軌道 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms x0d [3 1] real
syms dx0d [3 1] real
syms ddx0d [3 1] real
syms dddx0d [3 1] real
syms r0d [4 1] real % 姿勢角（オイラーパラメータ）
syms o0d [3 1] real % 角速度
syms do0d [3 1] real 
%% (20)-(22)
ex0 = x0 - x0d;
dex0 = dx0 -dx0d;
R0dTR0 = quat_times_vec(r0d.*[1;-1;-1;-1],R0);
R0TR0d = R0dTR0';
eR0 = Vee(R0dTR0 - R0TR0d)/2;
eo0 = o0 - R0dTR0'*o0d;
%% (23),(24)
syms kx0 kdx0 kR0 ko0 real
Fd = m0*(-kx0*ex0- kdx0*dex0 + ddx0d - g*e3);
Md = -kR0*eR0 - ko0*eo0 + Skew(R0TR0d*o0d)*J0*R0TR0d*o0d + J0*R0TR0d*do0d;
P =[repmat(eye(3),1,N); horzcat(Rho{:})];
syms Pdagger [3*N 6] real % = P'*inv(P*P')
muid = reshape(kron(eye(N),R0)*Pdagger*[R0'*Fd;Md],3,N); % 3xN
mui = sum(muid.*qi,1).*qi;% 3xN
qid = -muid./sqrt(sum(muid.*muid,1)); % 3xN
%%
%dwi = cross(qi,ai)./li - cross(qi,uip1)./(mi.*li);
wid = cross(qid,dqid);
q2i = % =Skew(qi)^2
eqi = cross(qid,qi);
ewi = wi + cellmatfun(@(Qi,i,wi) Qi^2*wi,Qi,"mat",wid);

%% ui
%ai = sum(mui)/m0 + R0*O0^2*rho + R0*Rho*J0\(O0*J0*o0-Rho*R0'*mui) % (19)
ai = ddx0 - g*e3 + R0*O0^2*rho - R0'*Rho*do0; % (15)
uip1 = mui + mi.*li.*lwi2.*qi + mi.*sum(ai.*qi,1).*qi;% ui parallel
uip2 = mi.*li.*qi.*(-kq.*eqi -kw.*ewi -sum(qi.*wid,1).*dqi - q2i.*dwd) - mi.*q2i.*ai; % ui perp
ui = uip1 + uip2;

%%
%clc
%syms ui [3 N] real
b3 = -ui./sqrt(sum(ui.*ui,1));% 3xN
b1 = dx0d + 0.1*quat_times_vec(ri,[1;0;0]); % Caution : problem if dx0d = - 10*xi.
b1 = b1./sqrt(sum(b1.*b1,1));
b2 = cross(b3, b1);%3xN
si = sqrt(sum(b2.*b2,1));

ci = b3' * b1;
si2 = si.^2;
b2 = b2 ./ si;
b1 = cross(b2, b3);
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
hoic = matrix_prod_3x3to9x1(RicT,dRic); % 9xN = Ric'*dRic
oic=mtake(hoic,[6,7,2]);% 3xN = Skew(hoic)
doic = mtake(matrix_prod_3x3to9x1(RicT,ddRic) - matrix_prod_3x3to9x1(hoic,hoic),[6,7,2]);% 3xN
quatRiT = ri.*[1;-1;-1;-1];% = R2q(Ri');
RiTRic = [quat_times_vec(quatRiT,Ric(1:3,:));quat_times_vec(quatRiT,Ric(4:6,:));quat_times_vec(quatRiT,Ric(7:9,:))]; %9xN
%RiTRic=arrayfun(@(i) quat_times_vec(ri(:,i).*[1;-1;-1;-1],Ric{i}),1:N,'UniformOutput',false);
%eri = Vee(RiTRic'-RiTRic)/2;
eri = mtake(matrix_transpose_3x3to9x1(RiTRic)-RiTRic,[6,7,2])/2;% 3xN
%RiTRicoic = cellmatfun(@(R,i) R*oic(:,i),RiTRic,"mat");
RiTRicoicd = matrix_prod_3x3to9x1(RiTRic,[oic;doic;zeros(size(oic))]);% 1:3 = RiTRic*oic, 4:6 = RiTRic*doic
eoi = oi - RiTRicoicd(1:3,:);% 3xN
%%
syms kr ko e real
fi = -sum(ui.*quat_times_vec(ri,e3),1);
Mi = - kr.*eri/(e^2) - ko.*eoi/2 + cross(oi,ji.*oi) - ji.*(cross(oi,RiTRicoicd(1:3,:))-RiTRicoicd(4:6,:));% 3xN

%%
syms X [13*(N+1) 1] real
syms Xd [3*4+4+6 1] real
matlabFunction(subs(reshape([fi;Mi],[],1),[x;x0d;dx0d;ddx0d;dddx0d;r0d;o0d;do0d],[X;Xd]),"file",dir+"Uvec_CSLC_"+N+".m","Vars",{X,Xd,physicalParam,[kr;ko;e]});