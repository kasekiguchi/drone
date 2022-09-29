function Estimator = Estimator_EKF_PE2(agent,output,var)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    Estimator.name="ekf_pe2";
    Estimator.type="EKF_PE2";
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    syms dummy1 dummy2
    col = agent.model.state.num_list;
    EKF_param.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    EKF_param.R = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
    EKF_param.Q = blkdiag(eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-5,eye(2)*1E-15); % システムノイズ（Modelクラス由来）
    EKF_param.B = [[blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)]);zeros(2,12)],[zeros(9,2);1E4*eye(2);zeros(10,2);1E-4*eye(2);0,0;1E-12*eye(2)]];
    EKF_param.P = eye(n); % 初期共分散行列

    tmp=arrayfun(@(i) strcmp(["p","q","v","w","pL","vL","pT","wL"],output(i)),1:length(output),'UniformOutput',false);
    col = [3 3 3 3 3 3 3 3];
    EKF_param.JacobianHt= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    EKF_param.Rt = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
    EKF_param.Qt = blkdiag(eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-5); % システムノイズ（Modelクラス由来）
    EKF_param.Bt = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)]);
    EKF_param.Pt = eye(24); % 初期共分散行列
    EKF_param.list=output;
    Estimator.param=EKF_param;
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

