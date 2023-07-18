
   
%-- 配列サイズ
    Params.state_size = 12; %12状態
    Params.input_size = 4;  %4つの入力
    Params.total_size = Params.state_size + Params.input_size;

    x = agent.estimator.result.state.get();

    %Koopman
    load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_6_26_circle.mat','est');
    Params.A = est.A;
    Params.B = est.B;
    Params.C = est.C;
    f = @(x) [x;1];

    xc = f(x); %複素空間へ値を写像
    previous_state  = zeros(Params.state_size + Params.input_size, Params.H);
    xr = zeros(Params.total_size, Params.H);

try
    while round(time.t, 5) <= te
               
        for i = 1:N
            
            x = agent.estimator.result.state.get(); % これ追加10/14　よくなった気がする
            xc = f(x); %複素空間へ値を写像
                   
            x0 = [initial_u1; initial_u2; initial_u3; initial_u4];% 初期値＝入力
            previous_state = repmat([agent.estimator.result.state.get(); x0], 1, Params.H);
             
            % MPC設定(problem)
            problem.x0		  = previous_state;       % 状態，入力を初期値とする      % 現在状態
            problem.objective = @(x) Objective(x,  Params, agent);            % 評価関数
            problem.nonlcon   = @(x) Constraints(x, Params, agent, time);    % 制約条件
            [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem); %最適化計算
            % 制御入力の決定
            previous_state = var   % 初期値の書き換え(最適化計算で求めたホライズン数分の値)
          
            agent.input = var(Params.state_size+1:Params.total_size, 1);    % 2なら飛んだ(ホライズンの一番はじめの入力のみを代入)
    
        end   
    end

catch ME % for error
    
end

%%
function [eval] = Objective(x, params, Agent) % x : p q v w input
%-- 評価計算をする関数
%-- 現在の状態および入力
%     x = repmat(x, 1, params.H);
    Xp = x(1:3, :);
    Xq = x(4:6, :);
    Xv = x(7:9, :);  
    Xw = x(10:12, :);
    U = x(13:16, :);
    
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
    tildeXp = Xp - params.xr(1:3, :);  % 位置
    tildeXq = Xq - params.xr(4:6, :);
    tildeXv = Xv - params.xr(7:9, :);  % 速度
    tildeXw = Xw - params.xr(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUpre = U - Agent.input;
    tildeUref = U - params.xr(13:16,:);
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP  = arrayfun(@(L) tildeXp(:, L)'   * params.Weight.P         * tildeXp(:, L),   1:params.H-1);
    stageStateV  = arrayfun(@(L) tildeXv(:, L)'   * params.Weight.V         * tildeXv(:, L),   1:params.H-1);
    stageStateQW = arrayfun(@(L) tildeXqw(:, L)'  * params.Weight.QW        * tildeXqw(:, L),  1:params.H-1);
    stageInputP  = arrayfun(@(L) tildeUpre(:, L)' * params.Weight.RP        * tildeUpre(:, L), 1:params.H-1);
    stageInputR  = arrayfun(@(L) tildeUref(:, L)' * params.Weight.R         * tildeUref(:, L), 1:params.H-1);
    stageState = stageStateP + stageStateV +  stageStateQW + stageInputP + stageInputR; % ステージコスト
    
%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * params.Weight.P   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.V   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QW  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end
%% 

function [c, ceq] = Constraints(x, params, Agent, ~)
% モデル予測制御の制約条件を計算するプログラム
    c  = zeros(params.state_size, params.H);
    ceq_ode = zeros(params.state_size, params.H);

%-- MPCで用いる予測状態 Xと予測入力 Uを設定
    X = x(1:params.state_size, :);          % 12 * Params.H 
    Xc = [X(1:params.state_size, 1);1];     % 13 * 1(複素空間)
    U = x(params.state_size+1:params.total_size, :);   % 4 * Params.H

%- ダイナミクス拘束
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
%-- 連続の式をダイナミクス拘束に使う
    for L = 2:params.H
        tmpx = params.A * Xc(:,L-1) + params.B * U(:,L-1); %クープマンモデル
        ceq_ode(:, L) = X(:, L) - tmpx(1:params.state_size,1);   % tmpx : 縦ベクトル？ 入力が正しいかを確認
    end
    ceq = [X(:, 1) - params.X0, ceq_ode];
%     c(:, 1) = [];
%     c = X(1,:) - 2;
end
