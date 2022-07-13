function [cineq, ceq] = constraintsOM(obj,x, params)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(params.state_size, 4*params.H);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:end, :);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
%TEMP_predictX = cell2mat(arrayfun(@(N) ode45(@(t,x) params.model(x,U(:,N),params.model_param),[params.dt*(N-2) params.dt*(N-1)],X(:,N-1)),2:params.Num,'UniformOutput',false));
%PredictX = cell2mat(arrayfun(@(L) TEMP_predictX(L).y(:,end),1:params.H,'UniformOutput',false));
PredictX = cell2mat(arrayfun(@(L) X(:,L) +obj.param.dt*obj.self.model.method(X(:,L),U(:,L),params.model_param) , 1:params.H , 'UniformOutput' , false));
ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  -  PredictX(:,L-1), 2:params.Num, 'UniformOutput', false))];
%-- 予測入力が入力の上下限制約に従うことを設定
%     cineq(:, 1: params.H)	        = cell2mat(arrayfun(@(L) params.U(:, 1) - U(:, L), 1:params.H, 'UniformOutput', false));
%     cineq(:, params.H+1: 2*params.H)= cell2mat(arrayfun(@(L) U(:, L) - params.U(:, 2), 1:params.H, 'UniformOutput', false));
%     %-- 予測入力間での変化量が変化量制約以下となることを設定
%     cineq(:, 2*params.H+1: 3*params.H) = [cell2mat(arrayfun(@(L) -params.S - (U(:, L) - U(:, L-1)) , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
%     cineq(:, 3*params.H+1: 4*params.H) = [cell2mat(arrayfun(@(L) (U(:, L) - U(:, L-1)) - params.S  , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
end