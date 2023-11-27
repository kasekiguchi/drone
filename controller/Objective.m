function [eval] = Objective(Param, u) % x : input
%-- 評価計算をする関数
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
%元の非線形等式制約を取り込んだ

%     Z = zeros(Param.state_size+1, Param.H-1);
%     z = [Param.current;1];
    z = quaternions(Param.current);
    Z = zeros(size(z,1),Param.H-1);
    Z(:,1) = Param.A*z + Param.B*u(:,1);
    for i = 2:Param.H-1
        Z(:,i) = Param.A*Z(:,i-1) + Param.B*u(:,i); %z[k+1]=Az[k]+Bu[k],Koopman
    end
    X = [Param.current,Z(1:Param.state_size,:)]; % x[k] = Cz[k]

    tildeXp = X(1:3, :) - Param.ref(1:3, :);  % 位置
    tildeXq = X(4:6, :) - Param.ref(4:6, :);
    tildeXv = X(7:9, :) - Param.ref(7:9, :);  % 速度
    tildeXw = X(10:12, :) - Param.ref(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUref = u(:, :) - Param.ref(13:16,:);
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stagestateP = tildeXp(:, 1:Param.H-1)'*Param.weight.P*tildeXp(:, 1:Param.H-1);
    stagestateV = tildeXv(:, 1:Param.H-1)'*Param.weight.V*tildeXv(:, 1:Param.H-1);
    stagestateQW = tildeXqw(:, 1:Param.H-1)'*Param.weight.QW*tildeXqw(:, 1:Param.H-1);
    stageinputR = tildeUref(:, 1:Param.H-1)'*Param.weight.R*tildeUref(:, 1:Param.H-1);
    
    stagestateP = diag(stagestateP);
    stagestateV = diag(stagestateV);
    stagestateQW = diag(stagestateQW);
    stageinputR = diag(stageinputR);
    
    stagestate = stagestateP' + stagestateV' + stagestateQW' + stageinputR'; %ステージコスト
    
%-- 状態の終端コストを計算
    terminalstate =  tildeXp(:, end)'   * Param.weight.Pf   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * Param.weight.Vf   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * Param.weight.QWf  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stagestate) + terminalstate;
end
