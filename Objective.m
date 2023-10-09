function [eval] = Objective(obj, x) % x : input
%-- 評価計算をする関数
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
%元の非線形等式制約を取り込んだ

    X = zeros(obj.param.state_size+1, obj.param.H-1);
    Xc = [obj.current_state;1];
    X(:,1) = obj.param.A*Xc + obj.param.B*x(:,1);
    for i = 2:obj.param.H-1
        X(:,i) = obj.param.A*X(:,i-1) + obj.param.B*x(:,i); %z[k+1]=Az[k]+Bu[k],Koopman
    end
    Xn = [obj.current_state,X(1:obj.param.state_size,:)]; % x[k] = Cz[k]

    tildeXp = Xn(1:3, :) - obj.state.ref(1:3, :);  % 位置
    tildeXq = Xn(4:6, :) - obj.state.ref(4:6, :);
    tildeXv = Xn(7:9, :) - obj.state.ref(7:9, :);  % 速度
    tildeXw = Xn(10:12, :) - obj.state.ref(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUref = x(:, :) - obj.state.ref(13:16,:);
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP = tildeXp(:, 1:obj.param.H-1)'*obj.param.weight.P*tildeXp(:, 1:obj.param.H-1);
    stageStateV = tildeXv(:, 1:obj.param.H-1)'*obj.param.weight.V*tildeXv(:, 1:obj.param.H-1);
    stageStateQW = tildeXqw(:, 1:obj.param.H-1)'*obj.param.weight.QW*tildeXqw(:, 1:obj.param.H-1);
    stageInputR = tildeUref(:, 1:obj.param.H-1)'*obj.param.weight.R*tildeUref(:, 1:obj.param.H-1);
    
    stageStateP = diag(stageStateP);
    stageStateV = diag(stageStateV);
    stageStateQW = diag(stageStateQW);
    stageInputR = diag(stageInputR);
    
    stageState = stageStateP' + stageStateV' + stageStateQW' + stageInputR'; %ステージコスト
    
%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * obj.param.weight.Pf   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * obj.param.weight.V   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * obj.param.weight.QWf  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end

