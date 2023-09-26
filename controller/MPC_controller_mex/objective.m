function [eval] = objective(Obj,x)   % obj.~とする
    X = x(1:12,:);
    U = x(13:16,:);
    tildeX = X - Obj.state(1:12,:);
    tildeUpre = U - Obj.input;
    tildeUref = U - Obj.state(13:16,:);

    stageState = tildeX(:,end-1)' * Obj.Q    * tildeX(:,end-1);
    stageInputPre  = tildeUpre(:,end-1)' * Obj.RP * tildeUpre(:,end-1);
    stageInputRef  = tildeUref(:,end-1)' * Obj.R  * tildeUref(:,end-1);
    terminalState = tildeX(:,end)' * Obj.Qf * tildeX(:,end);

    eval = stageState + stageInputPre + stageInputRef + terminalState;
    
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
    % Xp = x(1:3, :);
    % Xq = x(4:6, :);
    % Xv = x(7:9, :);  
    % Xw = x(10:12, :);
    % U = x(13:16, :);
    
    % tildeXp = Xp - obj.state(1:3, :);  % 位置
    % tildeXq = Xq - obj.state(4:6, :);
    % tildeXv = Xv - obj.state(7:9, :);  % 速度
    % tildeXw = Xw - obj.state(10:12,:);
    % tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    % tildeUpre = U - obj.input.v;
    % tildeUref = U - obj.state(13:16,:);

    % stageStateP =    sum(tildeXp(:,end-1)' * obj.param.P   .* tildeXp(:,end-1)',2);
    % stageStateV =    sum(tildeXv(:,end-1)' * obj.param.V   .* tildeXv(:,end-1)',2);
    % stageStateQW =   sum(tildeXqw(:,end-1)' * obj.param.QW .* tildeXqw(:,end-1)',2);
    % stageInputPre  = sum(tildeUpre(:,end-1)' * obj.param.RP.* tildeUpre(:,end-1)',2);
    % stageInputRef  = sum(tildeUref(:,end-1)' * obj.param.R .* tildeUref(:,end-1)',2);

    %-- 評価値計算
    % eval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
    %     + terminalState;
end