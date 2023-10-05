function [c , ceq] = Constraints(x, params)
% モデル予測制御の制約条件を計算するプログラム
    c  = zeros(params.state_size, params.H);
    ceq_ode = zeros(params.state_size, params.H);

%-- MPCで用いる予測状態 Xと予測入力 Uを設定
    X=x(1:params.state_size, 1:params.H);
    Xc = [x(1:params.state_size, 1:params.H);ones(1,params.H)];
    U = x(params.state_size+1:params.total_size, :);   % 4 * Params.H

%- ダイナミクス拘束
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
%-- 連続の式をダイナミクス拘束に使う

    for L = 2:params.H  
        tmpx = params.A * Xc(:,L-1) + params.B * U(:,L-1); %クープマンモデル
        tmpx = params.C * tmpx; 
        ceq_ode(:, L) = X(:, L) - tmpx;   % tmpx : 縦ベクトル？ 入力が正しいかを確認
    end
    ceq = [x(1:params.state_size, 1) - params.X0, ceq_ode];
    
%     c = [norm(x(1:params.state_size, 1) , params.X0) - 1, ceq_ode];
end