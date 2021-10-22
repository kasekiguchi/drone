% -------------------------------------------------------------------------
%Author Sota Wada; Date 2021_10_21
% -------------------------------------------------------------------------
function [x,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_Fimobjective(x0,param,NoiseR)
assert(isa(x0,'double'));assert(all(size(x0)==	[7,11]));
assert(isa(param,'struct'));
assert(isa(param.H,'double'));assert(all(size(param.H)==	[1,1]));
assert(isa(param.dt,'double'));assert(all(size(param.dt)==	[1,1]));
assert(isa(param.input_size,'double'));assert(all(size(param.input_size)==	[1,1]));
assert(isa(param.state_size,'double'));assert(all(size(param.state_size)==	[1,1]));
assert(isa(param.total_size,'double'));assert(all(size(param.total_size)==	[1,1]));
assert(isa(param.Num,'double'));assert(all(size(param.Num)==	[1,1]));
assert(isa(param.Q,'double'));assert(all(size(param.Q)==	[5,5]));
assert(isa(param.R,'double'));assert(all(size(param.R)==	[2,2]));
assert(isa(param.Qf,'double'));assert(all(size(param.Qf)==	[5,5]));
assert(isa(param.T,'double'));assert(all(size(param.T)==	[10,10]));
assert(isa(param.Xr,'double'));assert(all(size(param.Xr)==	[5,11]));
assert(isa(param.dis,'double'));assert(all(size(param.dis)>=	[1,1]));assert(all(size(param.dis)<=	[1,629]));
assert(isa(param.alpha,'double'));assert(all(size(param.alpha)>=[1,1]));assert(all(size(param.alpha)<=	[1,629]));
assert(isa(param.phi,'double'));assert(all(size(param.phi)>=	[1,1]));assert(all(size(param.phi)<=	[1,629]));
assert(isa(param.X0,'double'));assert(all(size(param.X0)==	[5,1]));
assert(isa(param.model_param,'struct'));
assert(isa(param.model_param.K,'double'));assert(all(size(param.model_param.K)==	[1,1]));
assert(isa(NoiseR,'double'));assert(all(size(NoiseR)==	[1,1]));
    options = optimoptions('fmincon',...
        'MaxIterations',                 100000,...
        'MaxFunctionEvaluations',        1000000000,...
        'ConstraintTolerance',           1e-06,...
        'OptimalityTolerance',           1e-06,...
        'StepTolerance',                 1e-09,...
        'SpecifyObjectiveGradient',      false,...
        'SpecifyConstraintGradient',     false,...
        'Algorithm',                     'sqp');
    % 最大反復回数, 評価関数の最大値, 制約の許容誤差, 最適性の許容誤差, ステップサイズの下限, 評価関数の勾配設定, 制約条件の勾配設定, SQPアルゴリズムの指定
    evalfunc = @(x)FimobjectiveMEX(x,param,NoiseR);
    nonlcon  = @(x)constraintsMEX(x,param);
    [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(evalfunc,x0,[],[],[],[],[],[],nonlcon,options);
end
function [eval] = FimobjectiveMEX(x, params,NoiseR)
% モデル予測制御の評価値を計算するプログラム
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:end, :);
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
tildeU = U;
%
evFim = zeros(1,params.H);
for j = 1:params.H
%     arrayfun(@(L) FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j), X(5,j), params.dt, params.dis(L), params.alpha(L), params.phi(L)),1:length(params.dis));
    Fim = FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j), X(5,j), params.dt, params.dis(1), params.alpha(1), params.phi(1));
%     arrayfun(@(N) FIM_ObserbSub(X(1,1), X(2,1), X(3,1), X(4,1), X(5,1), params.t, params.dis(N), params.alpha(N), params.phi(N)),1:length(params.dis),'UniformOutput',false);
    for i = 2:length(params.dis)
        Fim = Fim + FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j), X(5,j), params.dt, params.dis(i), params.alpha(i), params.phi(i) );
    end
    Fim = (1/(2*NoiseR))*Fim;
    InvFim = inv(Fim);
    evFim(1,j) = real(max(eig(InvFim)));
end
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
% stageevFim = arrayfun(@(L) evFim(:,L)' * params.Th * evFim(:,L), 1:params.H);
stageevFim = evFim* params.T * evFim';
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + sum(stageevFim) + terminalState;
end
function PP = FIM_ObserbSub(x,y,theta,v,omega,t,d1,alpha1,phi1)
%FIM_OBSERBSUB
%    PP = FIM_OBSERBSUB(X,Y,THETA,V,OMEGA,T,D1,ALPHA1,PHI1)

%    This function was generated by the Symbolic Math Toolbox version 8.6.
%    22-Jul-2021 16:27:23
%   This function was overwritten by Sota Wada on 2021_10_21 and the reshape function was removed.

t2 = cos(alpha1);
t3 = sin(alpha1);
t4 = cos(theta);
t5 = sin(theta);
t6 = omega.*t;
t7 = -alpha1;
t8 = -d1;
t9 = t.*t4.*v;
t10 = t.*t5.*v;
t11 = t.*t2.*t4;
t12 = t.*t3.*t5;
t17 = phi1+t6+t7+theta;
t13 = t10+y;
t14 = t9+x;
t18 = cos(t17);
t19 = sin(t17);
t20 = t11+t12;
t15 = t2.*t14;
t16 = t3.*t13;
t21 = 1.0./t18.^3;
t22 = t8+t15+t16;
t23 = t.*t19.*t20.*t21.*t22;
PP = [1.0./t18.^2.*t20.^2,t23;t23,t.^2.*1.0./t18.^4.*t19.^2.*t22.^2];
end
function [cineq, ceq] = constraintsMEX(x, params)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(params.state_size, 4*params.H);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:end, :);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
PredictX = zeros(5,params.H);
for L = 1:params.H
    PredictX(:,L) = X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param);
end
% PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false));
tmpceq = zeros(5,params.H);
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
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));x(5);u(1);u(2)];
end