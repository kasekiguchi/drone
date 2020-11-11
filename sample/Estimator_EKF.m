function Estimator_EKF(agent,output,var)
% output ：出力のリスト　例 ["p","q"]

%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
% すべての機体で同一設定
Estimator.name="ekf";
Estimator.type="EKF";
dt = agent(1).model.dt;
n = agent(1).model.dim(1);% 状態数
if isfield(agent(1).sensor,'imu')
    output = ["w","a"];
end
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    syms dummy1 dummy2 
    col = agent.model.state.num_list;
    k=1;
    EKF_param.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    %EKF_param.Q = 100* diag([0.5;0.5;0.5;0.9;0.9;1.8;0.5;0.5;0.5;0.9;0.9;1.8]);%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    EKF_param.Q = diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
%    EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5]/100;[6.716E-5; 7.058E-5; 7.058E-5]/1000]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）    
    EKF_param.R = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
%EKF_param.R = diag([[6.716E-5;6.716E-5;6.716E-5;6.716E-5]/1000;[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
    %EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5]/100;[6.716E-5; 7.058E-5; 7.058E-5]/1000;[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
%    EKF_param.R = 10^-5*diag(ones(sum(agent(1).sensor.result.state.num_list),1));
    %%
    EKF_param.B = eye(n); % システムノイズが加わるチャンネル
    EKF_param.P = eye(n); % 初期共分散行列
    EKF_param.list=output;
    Estimator.param=EKF_param;
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end

function mat = zeroone(row,col,idx)
if idx == 0
    mat = zeros(row,col);
elseif row== col
    mat = eye(row);
else
    error("ACSL : invalid size");
end
end

