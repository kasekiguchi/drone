function Estimator = Estimator_PDAF(agent,dt,model,output,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments
        agent
        dt
        model
        output = ["p","q"]
        opts.output_func = [];
        opts.B = []
        opts.P = []
        opts.Q = []
        opts.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3)]);
    end
    Estimator.model = model;
    n = Estimator.model.dim(1);% 状態数
    if class(output)=="function_handle"
            Estimator.JacobianH = output;
        else
            p = length(model.state.get(output));
            tmp=arrayfun(@(i) strcmp(Estimator.model.state.list,output(i)),1:length(output),'UniformOutput',false);
            syms dummy1 dummy2
            col = Estimator.model.state.num_list;
            Estimator.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    end   
    Estimator.sensor_func = @(self,param) [self.sensor.result.state.get('p');self.sensor.result.state.getq('3');self.sensor.lidar.result.length(1);self.sensor.lidar.result.length(3)]; % function to get sensor value: sometimes some conversion will be done
    Estimator.sensor_param = ["p","q"]; % parameter for sensor_func
    Estimator.sensor_length = [6;2];                                       % Nmber of sensor to fusion
    Estimator.threshold   =   200000;                                            % threshold (All, Sensor, Sensor1, 2...)
    Estimator.PD          = 0.9;                                             % Target probability
    Estimator.PG          = 0.9;                                             % Gate probability
    Estimator.R = opts.R;
    if isempty(opts.output_func)
        Estimator.output_func = @(state,param) param*state; % output function
        Estimator.output_param = Estimator.JacobianH(0,0); % parameter for output_func
    else
        Estimator.output_func = opts.output_func; % output function
        Estimator.output_param = []; % parameter for output_func
    end
 % P, Q, R, B生成
    if isempty(opts.P) % 初期共分散行列
        Estimator.P = eye(n);
    else
        Estimator.P = opts.P;
    end
    if isempty(opts.Q)
        Estimator.Q = 1E-3*diag([1E3,1E3,1E3,1E5,1E5,1E5]);%eye(6)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    else
        Estimator.Q = opts.Q;
    end
    if isempty(opts.B)
        if Estimator.model.state.type == 3 % 姿勢がオイラー角の場合
        %Estimator.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
            Estimator.B = [eye(6)*0.01;eye(6)*0.1]; % システムノイズが加わるチャンネル
        elseif  Estimator.model.state.type == 4 % 姿勢がオイラーパラメータの場合
            Estimator.B = [eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
        end
    else
        Estimator.B = opts.B;
    end
    Estimator.list=output;
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

