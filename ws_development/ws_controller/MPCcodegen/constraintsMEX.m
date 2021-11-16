function [cineq, ceq] = constraintsMEX(x, params)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(params.state_size, 4*params.H);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:end, :);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
PredictX = zeros(4,params.H);
for L = 1:params.H
    PredictX(:,L) = X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param);
end
% PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false));
tmpceq = zeros(4,params.H);
for L = 2:params.Num
    tmpceq(:,L-1) = X(:, L)  -  PredictX(:,L-1);
end
ceq = [X(:, 1) - params.X0, tmpceq];
%-- 予測入力が入力の上下限制約に従うことを設定
%     cineq(:, 1: params.H)	        = cell2mat(arrayfun(@(L) params.U(:, 1) - U(:, L), 1:params.H, 'UniformOutput', false));
%     cineq(:, params.H+1: 2*params.H)= cell2mat(arrayfun(@(L) U(:, L) - params.U(:, 2), 1:params.H, 'UniformOutput', false));
%     %-- 予測入力間での変化量が変化量制約以下となることを設定
%     cineq(:, 2*params.H+1: 3*params.H) = [cell2mat(arrayfun(@(L) -params.S - (U(:, L) - U(:, L-1)) , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
%     cineq(:, 3*params.H+1: 4*params.H) = [cell2mat(arrayfun(@(L) (U(:, L) - U(:, L-1)) - params.S  , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
end
function dX = Model(x,u,param)
    u(1) = param.K * u(1);
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end