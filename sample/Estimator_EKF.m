function Estimator = Estimator_EKF(agent,dt,model,output,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズ
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments
        agent
        dt
        model
        output = ["p","q"]
        opts.B = []
        opts.P = []
        opts.Q = []                                      % システムノイズ．状態の並び順に合わせて値を設定
        opts.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3)]); % 観測ノイズ．観測値の並び順に合わせて値を設定
    end
    Estimator.model = model;
    p               = length(model.state.get(output));   % number of output
    dt              = Estimator.model.dt;
    n               = Estimator.model.dim(1);% 状態数
    % 出力方程式の拡張線形化行列(JacobianH)の生成
    % output で登録された出力
    if class(output)=="function_handle"
        Estimator.JacobianH = output;
    else
        syms dummy1 dummy2
        tmp                 = arrayfun(@(i) strcmp(Estimator.model.state.list,output(i)),1:length(output),'UniformOutput',false);
        col                 = Estimator.model.state.num_list;
        Estimator.JacobianH = matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    end
    
    Estimator.sensor_func   = @(self,param) self.sensor.result.state.get(param);    % function to get sensor value: sometimes some conversion will be done
    Estimator.sensor_param  = ["p","q"];                                            % parameter for sensor_func
    Estimator.output_func   = @(state,param) param*state;                           % output function
    Estimator.output_param  = Estimator.JacobianH(0,0);                             % parameter for output_func

    % P, Q, R, B生成(単機機体モデル用)
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
    Estimator.R = opts.R;
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

% modelによってEKFのパラメータを調整
modelName = Estimator.model.name;
switch modelName
    case "load"
        Estimator.sensor_param = ["p", "q", "pL", "pT"]; % parameter for sensor_func
        %6288で飛んだ。7278でmass足したら飛ばない。EKFにも質量足すことで解決するかを確認する必要がある。ダメなら戻して小さく変更。
        Estimator.Q = blkdiag(eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-1); % システムノイズ（Modelクラス由来）-2次回-6とか下げてみる
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)]);
        Estimator.R = blkdiag(eye(3)*1e-10, eye(3)*1e-8,eye(3)*1e-8,eye(3)*1e-8);%-8ここはあげたほうが良いかも観測ノイズ
        % Estimator.Q = blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8); % システムノイズ（Modelクラス由来）
        % % Estimator.Q = blkdiag(eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-5); % システムノイズ（Modelクラス由来）
        % Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]);
        disp(modelName)
    case "Load_mL_HL"
        Estimator.sensor_param = ["p", "q", "pL", "pT"]; % parameter for sensor_func
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)],0);% 単位の次元を状態に合わせる(x=at^2/2, v = atの関係)例：加速度入力の時に一時刻先の速度の状態を計算する
        % 観測の分散=0.001
        % Estimator.Q = blkdiag(eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,0);     % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        % Estimator.R = blkdiag(eye(3)*1e-3, eye(3)*1e-3,eye(3)*1e-3,eye(3)*1e-3);  %観測ノイズ
        % 観測の分散=1e-8                
        % Estimator.Q = blkdiag(eye(3)*1E0,eye(3)*1E0,eye(3)*1E0,eye(3)*1E0,0);       % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        % Estimator.R = blkdiag(eye(3)*1e-8, eye(3)*1e-8,eye(3)*1e-8,eye(3)*1e-8);    %観測ノイズ
        % % exp標準偏差=1e-6    
        Estimator.Q = blkdiag(eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,0);       % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        Estimator.R = blkdiag(eye(3)*1e-6, eye(3)*1e-6,eye(3)*1e-6,eye(3)*1e-6);    %観測ノイズ
        %offline推定
        % Estimator.Q = blkdiag(eye(3)*0.5*1E2,eye(3)*0.5*1E2,eye(3)*0.5*1E2,eye(3)*0.5*1E2,0);   % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        % Estimator.R = blkdiag(eye(3)*1e-2, eye(3)*1e-2,eye(3)*1e-2,eye(3)*1e-2);                % 観測ノイズ
        disp(modelName)
    case "Load_mL_dstxy_HL"
        Estimator.sensor_param = ["p", "q", "pL", "pT"]; % parameter for sensor_func
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)],0,0,0);% 単位の次元を状態に合わせる，
        % 観測の分散=1e-8    
        % Estimator.Q = blkdiag(eye(3)*1E0,eye(3)*1E0,eye(3)*1E0,eye(3)*1E0,0,0,0);   % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        % Estimator.R = blkdiag(eye(3)*1e-8, eye(3)*1e-8,eye(3)*1e-8,eye(3)*1e-8);    %観測ノイズ
        % % exp標準偏差=1e-6    
        Estimator.Q = blkdiag(eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,eye(3)*1E1,0,0,0);       % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
        Estimator.R = blkdiag(eye(3)*1e-6, eye(3)*1e-6,eye(3)*1e-6,eye(3)*1e-6);    %観測ノイズ
        disp(modelName)
    case "Expand"
        % Estimator.Q = blkdiag(eye(3)*1E-3, eye(3)*1E-3,eye(2)*1E-3); % システムノイズ（Modelクラス由来）
        % Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],dt^2*eye(2));
        % Estimator.Q = blkdiag(2*eye(3)*1E-3, 2*eye(3)*1E-3,eye(2)*1E-3); % システムノイズ（Modelクラス由来）
        % Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],dt*eye(2)*0);%拡大のノイズなしの場合で実験
        Estimator.Q = blkdiag(2*eye(3)*1E-1, 2*eye(3)*1E-1,eye(2)*1E-1); % システムノイズ（Modelクラス由来）%controller change
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],dt*eye(2)*0);%拡大のノイズなしの場合で実験
        % Estimator.Q = blkdiag(eye(3)*1E-3, eye(3)*1E-3); % システムノイズ（Modelクラス由来）
        % Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6);zeros(2,6)]);%拡大のノイズなしの場合で実験
        disp(modelName)
    case "cable_suspended_rigid_body"
      N = length(Estimator.model.state.Oi)/3;
        Estimator.Q = blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3*N)*1E-3,eye(3*N)*1E-8); % システムノイズ（Modelクラス由来）
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(6*N);dt*eye(6*N)]);
        %Estimator.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3), 1e-8*ones(1,3*N), 1e-8*ones(1,3*N)]);
        Estimator.R = 1e-5*eye(p);
        disp(modelName)
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
