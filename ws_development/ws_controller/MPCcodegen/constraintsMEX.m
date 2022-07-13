function [cineq, ceq] = constraintsMEX(x, params)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(6, params.Num);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
S = x(params.total_size+1:end,:);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
PredictX = zeros(4,params.H);
for L = 1:params.H
    %     PredictX(:,L) = X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param);
    tmp = ode45(@(t,x) Model(x,U(:,L),params.model_param),[0 params.dt],X(:,L));
    PredictX(:,L) = tmp.y(:,end);
end
% PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false));
tmpceq = zeros(4,params.H);
for L = 2:params.Num
    tmpceq(:,L-1) = X(:, L)  -  PredictX(:,L-1);
end
ceq = [X(:, 1) - params.X0, tmpceq];
%---入力の情怪訝制約を設定---%
% cineq(1,:) = arrayfun(@(L) -params.S(1)+U(1,L),1:params.Num);%速度入力の上限
% cineq(2,:) = arrayfun(@(L) -params.S(2)+U(2,L),1:params.Num);%角速度の上限
% cineq(3,:) = arrayfun(@(L) -params.S(1)-U(1,L),1:params.Num);%速度入力の下限
% cineq(4,:) = arrayfun(@(L) -params.S(2)-U(2,L),1:params.Num);%角速度の下限

cineq(5,:) = arrayfun(@(L) -S(1,L),1:params.Num);
cineq(6,:) = arrayfun(@(L) -S(2,L),1:params.Num);
end
function dX = Model(x,u,param)
    u = param.K * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end