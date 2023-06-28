close all hidden;
clear all;
clc;
%% 

loadfilename{1} = 'EstimationResult_12state_6_26_circle=circle_estimation=circle.mat' ;%mainで書き込んだファイルの名前に逐次変更する
loadfilename{2} = 'EstimationResult_12state_6_26_circle=flight_estimation=circle.mat';

WhichRef = 1; % どのファイルをリファレンスに使うか
stepN = 49;

HowmanyFile = size(loadfilename,2);
for i = 1:HowmanyFile
    file{i} = load(loadfilename{i});
    file{i}.name = loadfilename{i};
    % file{i}.markerSty = ':o';
    file{i}.markerSty = '';
    file{i}.lgdname.p = {append('$data',num2str(i),'_x$'),append('$data',num2str(i),'_y$'),append('$data',num2str(i),'_z$')};
    file{i}.lgdname.q = {append('$data',num2str(i),'_{roll}$'),append('$data',num2str(i),'_{pitch}$'),append('$data',num2str(i),'_{yaw}$')};
    file{i}.lgdname.v = {append('$data',num2str(i),'_{vx}$'),append('$data',num2str(i),'_{vy}$'),append('$data',num2str(i),'_{vz}$')};
    file{i}.lgdname.w = {append('$data',num2str(i),'_{w1}$'),append('$data',num2str(i),'_{w2}$'),append('$data',num2str(i),'_{w3}$')};
    
    if isfield(file{i}.simResult,'initTindex')
    
    else
        file{i}.simResult.initTindex = 1;
    end

    if i == 1
        indexcheck = file{i}.simResult.initTindex
    elseif indexcheck ~= file{i}.simResult.initTindex
            disp('Caution!! 読み込んだファイルの初期状態が異なっています!!')
            dammy = input('Enterで無視して続行します');
    end
end

dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
tlength = file{1}.simResult.initTindex:file{1}.simResult.initTindex+stepN-1;

%% RMSE計算
clc
%位置のRMSE
xt = file{WhichRef}.simResult.reference.est.p(tlength,1)';
yt = file{2}.simResult.reference.est.p(tlength,2)';
zt = file{WhichRef}.simResult.reference.est.p(tlength,3)';
xr1 = file{1}.simResult.state.p(1,1:stepN);
xr2 = file{2}.simResult.state.p(1,1:stepN);
yr1 = file{1}.simResult.state.p(2,1:stepN);
yr2 = file{2}.simResult.state.p(2,1:stepN);
zr1 = file{1}.simResult.state.p(3,1:stepN);
zr2 = file{2}.simResult.state.p(3,1:stepN);

x_case1 = sqrt((sum(xr1-xt).^2)/size(xt,2));
x_case2 = sqrt((sum(xr2-xt).^2)/size(xt,2));
y_case1 = sqrt((sum(yr1-yt).^2)/size(xt,2));
y_case2 = sqrt((sum(yr2-yt).^2)/size(xt,2));
z_case1 = sqrt((sum(zr1-zt).^2)/size(xt,2));
z_case2 = sqrt((sum(zr2-zt).^2)/size(xt,2));

disp(['x_case1: ' num2str(x_case1) ' x_case2: ' num2str(x_case2) ' y_case1: ' num2str(y_case1) ...
    ' y_case2: ' num2str(y_case2) ' z_case1: ' num2str(z_case1) ' z_case2: ' num2str(z_case2)])

%姿勢角のRMSE
phi_t = file{WhichRef}.simResult.reference.est.q(tlength,1)';
sita_t = file{WhichRef}.simResult.reference.est.q(tlength,2)';
psi_t = file{WhichRef}.simResult.reference.est.q(tlength,3)';
phi_r1 = file{1}.simResult.state.q(1,1:stepN);
phi_r2 = file{2}.simResult.state.q(1,1:stepN);
sita_r1 = file{1}.simResult.state.q(2,1:stepN);
sita_r2 = file{2}.simResult.state.q(2,1:stepN);
psi_r1 = file{1}.simResult.state.q(3,1:stepN);
psi_r2 = file{2}.simResult.state.q(3,1:stepN);

phi_case1 = sqrt((sum(phi_r1-phi_t).^2)/size(xt,2));
phi_case2 = sqrt((sum(phi_r2-phi_t).^2)/size(xt,2));
sita_case1 = sqrt((sum(sita_r1-sita_t).^2)/size(xt,2));
sita_case2 = sqrt((sum(sita_r2-sita_t).^2)/size(xt,2));
psi_case1 = sqrt((sum(psi_r1-psi_t).^2)/size(xt,2));
psi_case2 = sqrt((sum(psi_r2-psi_t).^2)/size(xt,2));

disp(['phi_case1: ' num2str(phi_case1) ' phi_case2: ' num2str(phi_case2) ' sita_case1: ' num2str(sita_case1) ...
    ' sita_case2: ' num2str(sita_case2) ' psi_case1: ' num2str(psi_case1) ' psi_case2: ' num2str(psi_case2)])

%速度のRMSE
vxt = file{WhichRef}.simResult.reference.est.v(tlength,1)';
vyt = file{WhichRef}.simResult.reference.est.v(tlength,2)';
vzt = file{WhichRef}.simResult.reference.est.v(tlength,3)';
vxr1 = file{1}.simResult.state.v(1,1:stepN);
vxr2 = file{2}.simResult.state.v(1,1:stepN);
vyr1 = file{1}.simResult.state.v(2,1:stepN);
vyr2 = file{2}.simResult.state.v(2,1:stepN);
vzr1 = file{1}.simResult.state.v(3,1:stepN);
vzr2 = file{2}.simResult.state.v(3,1:stepN);

vx_case1 = sqrt((sum(vxr1-vxt).^2)/size(xt,2));
vx_case2 = sqrt((sum(vxr2-vxt).^2)/size(xt,2));
vy_case1 = sqrt((sum(vyr1-vyt).^2)/size(xt,2));
vy_case2 = sqrt((sum(vyr2-vyt).^2)/size(xt,2));
vz_case1 = sqrt((sum(vzr1-vzt).^2)/size(xt,2));
vz_case2 = sqrt((sum(vzr2-vzt).^2)/size(xt,2));

disp(['vx_case1: ' num2str(vx_case1) ' vx_case2: ' num2str(vx_case2) ' vy_case1: ' num2str(vy_case1) ...
    ' vy_case2: ' num2str(vy_case2) ' vz_case1: ' num2str(vz_case1) ' vz_case2: ' num2str(vz_case2)])

%角速度のRMSE
wphi_t = file{WhichRef}.simResult.reference.est.w(tlength,1)';
wsita_t = file{WhichRef}.simResult.reference.est.w(tlength,2)';
wpsi_t = file{WhichRef}.simResult.reference.est.w(tlength,3)';
wphi_r1 = file{1}.simResult.state.w(1,1:stepN);
wphi_r2 = file{2}.simResult.state.w(1,1:stepN);
wsita_r1 = file{1}.simResult.state.w(2,1:stepN);
wsita_r2 = file{2}.simResult.state.w(2,1:stepN);
wpsi_r1 = file{1}.simResult.state.w(3,1:stepN);
wpsi_r2 = file{2}.simResult.state.w(3,1:stepN);

wphi_case1 = sqrt((sum(wphi_r1-wphi_t).^2)/size(xt,2));
wphi_case2 = sqrt((sum(wphi_r2-wphi_t).^2)/size(xt,2));
wsita_case1 = sqrt((sum(wsita_r1-wsita_t).^2)/size(xt,2));
wsita_case2 = sqrt((sum(wsita_r2-wsita_t).^2)/size(xt,2));
wpsi_case1 = sqrt((sum(wpsi_r1-wpsi_t).^2)/size(xt,2));
wpsi_case2 = sqrt((sum(wpsi_r2-wpsi_t).^2)/size(xt,2));

disp(['wphi_case1: ' num2str(wphi_case1) ' wphi_case2: ' num2str(wphi_case2) ' wsita_case1: ' num2str(wsita_case1) ...
    ' wsita_case2: ' num2str(wsita_case2) ' wpsi_case1: ' num2str(wpsi_case1) ' wpsi_case2: ' num2str(wpsi_case2)])
