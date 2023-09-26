function [c, ceq] = constraints(Obj, x)
    % モデル予測制御の制約条件を計算するプログラム
    c  = zeros(12, Obj.H);
    ceq_ode = zeros(12, Obj.H);

    %-- MPCで用いる予測状態 Xと予測入力 Uを設定
    X = x(1:12, :);          % 12 * Params.H
    U = x(13:16, :);   % 4 * Params.H

    % U(16, :) = zeros(1, obj.H);
    %- ダイナミクス拘束
    %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
    %-- 連続の式をダイナミクス拘束に使う
    % tmp = obj.current_state;
    for L = 2:Obj.H
        xx = X(:, L-1);
        xu = U(:, L-1);
        tmp = xx + Obj.dt * Obj.modelf(xx, xu, Obj.modelp);
        % tmp = obj.current_state + obj.dt * obj.modelf(xx, xu, obj.modelp);
        ceq_ode(:, L) = X(:, L) - tmp; 
        % 
        % [~,tmpx]=ode15s(@(t,X) obj.modelf(xx, xu, obj.modelp), [0 0.025],obj.current_state);
        % ceq_ode(:, L) = X(:, L) - tmpx(end, :)';
    end
    ceq = [X(:, 1) - Obj.current_state, ceq_ode];
    c = [U(1,:)-Obj.input_max; -U(1,:)+Obj.input_min; -(U(2:4,:)+Obj.torque_TH); U(2:4,:)-Obj.torque_TH; -X(3,:)]; 
    % 0<推力<10, -2<torque<2, z>0
end