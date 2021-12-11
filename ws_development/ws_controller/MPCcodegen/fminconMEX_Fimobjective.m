% -------------------------------------------------------------------------
%Author Sota Wada; Date 2021_10_21
% -------------------------------------------------------------------------
function [x,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_Fimobjective(x0,param,NoiseR,SensorRange,RangeGain)
assert(isa(x0,'double'));assert(all(size(x0)==	[8,11]));
assert(isa(param,'struct'));
assert(isa(param.H,'double'));assert(all(size(param.H)==	[1,1]));
assert(isa(param.dt,'double'));assert(all(size(param.dt)==	[1,1]));
assert(isa(param.input_size,'double'));assert(all(size(param.input_size)==	[1,1]));
assert(isa(param.state_size,'double'));assert(all(size(param.state_size)==	[1,1]));
assert(isa(param.total_size,'double'));assert(all(size(param.total_size)==	[1,1]));
assert(isa(param.Num,'double'));assert(all(size(param.Num)==	[1,1]));
assert(isa(param.Q,'double'));assert(all(size(param.Q)==	[4,4]));
assert(isa(param.R,'double'));assert(all(size(param.R)==	[2,2]));
assert(isa(param.Qf,'double'));assert(all(size(param.Qf)==	[4,4]));
assert(isa(param.T,'double'));assert(all(size(param.T)==	[10,10]));
assert(isa(param.S,'double'));assert(all(size(param.S)==	[1,2]));
assert(isa(param.WoS,'double'));assert(all(size(param.WoS)==	[2,2]));
assert(isa(param.Evfim,'double'));assert(all(size(param.Evfim) == [1,10]));
assert(isa(param.Xr,'double'));assert(all(size(param.Xr)==	[4,11]));
assert(isa(param.dis,'double'));assert(all(size(param.dis)>=	[1,1]));assert(all(size(param.dis)<=	[1,629]));
assert(isa(param.alpha,'double'));assert(all(size(param.alpha)>=[1,1]));assert(all(size(param.alpha)<=	[1,629]));
assert(isa(param.phi,'double'));assert(all(size(param.phi)>=	[1,1]));assert(all(size(param.phi)<=	[1,629]));
assert(isa(param.X0,'double'));assert(all(size(param.X0)==	[4,1]));
assert(isa(param.U0,'double'));assert(all(size(param.U0)==	[2,1]));
assert(isa(param.model_param,'struct'));
assert(isa(param.model_param.K,'double'));assert(all(size(param.model_param.K)==	[1,1]));
assert(isa(NoiseR,'double'));assert(all(size(NoiseR)==	[1,1]));
assert(isa(SensorRange,'double'));assert(all(size(SensorRange)==	[1,1]));
assert(isa(RangeGain,'double'));assert(all(size(RangeGain)==	[1,1]));
    options = optimoptions('fmincon',...
        'MaxIterations',                 1000000000,...
        'MaxFunctionEvaluations',        1000000000,...
        'ConstraintTolerance',           1e-06,...
        'OptimalityTolerance',           1e-06,...
        'StepTolerance',                 1e-09,...
        'SpecifyObjectiveGradient',      false,...
        'SpecifyConstraintGradient',     false,...
        'Algorithm',                     'sqp');
    % 最大反復回数, 評価関数の最大値, 制約の許容誤差, 最適性の許容誤差, ステップサイズの下限, 評価関数の勾配設定, 制約条件の勾配設定, SQPアルゴリズムの指定
    evalfunc = @(x)FimobjectiveMEX(x,param,NoiseR,SensorRange,RangeGain);
    nonlcon  = @(x)constraintsMEX(x,param,NoiseR,SensorRange,RangeGain);
    [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(evalfunc,x0,[],[],[],[],[],[],nonlcon,options);
end
function [eval] = FimobjectiveMEX(x, params,NoiseR,SensorRange,RangeGain)
% モデル予測制御の評価値を計算するプログラム
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
S = x(params.total_size+1:end,:);
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
tildeU = U;
%
evFim = zeros(1,params.H);
% evFim = zeros(2,2*params.H);
for j = 1:params.H
    H = (params.dis(:) - X(1,j).*cos(params.alpha(:)) - X(2,j).*sin(params.alpha(:)))./cos(params.phi(:) - params.alpha(:) + X(3,j));%observation
%     RangeLogic = H<SensorRange;
    RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;
    tmpFim = FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j), params.dt, params.dis(:), params.alpha(:), params.phi(:));
    Fim = RangeLogic(1) .* tmpFim(1:2,:);
    for i = 2:length(tmpFim)/2
        Fim = Fim + RangeLogic(i) .* tmpFim(2*i-1:2*i,:);
    end
    Fim = (1/(2*NoiseR))*Fim;
    InvFim = inv(Fim);
        evFim(1,j) = trace(InvFim);
    %     evFim(1,j) = real(max(eig(InvFim)));
%     evFim(:,2*j-1:2*j) = InvFim' * params.T * InvFim;
end
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
stageSlack = arrayfun(@(L) S(:,L)' * params.WoS * S(:,L), 1:params.Num);
% stageevFim = arrayfun(@(L) evFim(:,L)' * params.Th * evFim(:,L), 1:params.H);
% stageevFim = arrayfun(@(L) evFim(:,2*L-1:2*L)* params.T * evFim(:,2*L-1:2*L)' ,1:params.H);
stageevFim = evFim* params.T * evFim';
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + sum(stageSlack) + sum(stageevFim) + terminalState;
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
function [cineq, ceq] = constraintsMEX(x, params,NoiseR,SensorRange,RangeGain)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(7, params.Num);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
S = x(params.total_size+1:end,:);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
PredictX = zeros(4,params.H);
for L = 1:params.H
    PredictX(:,L) = X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param);
end
% PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false));
tmpceq = zeros(params.state_size,params.H);
for L = 2:params.Num
    tmpceq(1:params.state_size,L-1) = X(:, L)  -  PredictX(:,L-1);
end
ceq = [X(:, 1) - params.X0, tmpceq];%初期時刻を現在状態に固定，モデルに従う制約
evFim = zeros(1,params.H);
% evFim = zeros(2,2*params.H);
for j = 1:params.H
    H = (params.dis(:) - X(1,j).*cos(params.alpha(:)) - X(2,j).*sin(params.alpha(:)))./cos(params.phi(:) - params.alpha(:) + X(3,j));%observation
    %     RangeLogic = H<SensorRange;
    RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;
    tmpFim = FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j), params.dt, params.dis(:), params.alpha(:), params.phi(:));
    Fim = RangeLogic(1) .* tmpFim(1:2,:);
    for i = 2:length(tmpFim)/2
        Fim = Fim + RangeLogic(i) .* tmpFim(2*i-1:2*i,:);
    end
    Fim = (1/(2*NoiseR))*Fim;
    InvFim = inv(Fim);
    evFim(1,j) = trace(InvFim);
    %     evFim(1,j) = real(max(eig(InvFim)));
    %     evFim(:,2*j-1:2*j) = InvFim' * params.T * InvFim;
end
%     %-- 予測入力間での変化量が変化量制約以下となることを設定
cineq(1,:) = [-params.S(1)-S(1,1)-(U(1,1) - params.U0(1)),arrayfun(@(L) - params.S(1) -S(1,L) - (U(1,L) - U(1,L-1)),2:params.Num)];%速度入力の変化量制約下限
cineq(2,:) = [-params.S(2)-S(2,1)-(U(2,1) - params.U0(2)),arrayfun(@(L) - params.S(2) -S(2,L) - (U(2,L) - U(2,L-1)),2:params.Num)];%角速度の変化量制約　下限
cineq(3,:) = [-params.S(1)-S(1,1)+(U(1,1) - params.U0(1)),arrayfun(@(L) - params.S(1) -S(1,L) + (U(1,L) - U(1,L-1)),2:params.Num)];%速度入力の変化量上限
cineq(4,:) = [-params.S(2)-S(2,1)+(U(2,1) - params.U0(2)),arrayfun(@(L) - params.S(2) -S(2,L) + (U(2,L) - U(2,L-1)),2:params.Num)];%角速度入力の変化量上限
cineq(5,:) = arrayfun(@(L) -S(1,L),1:params.Num);
cineq(6,:) = arrayfun(@(L) -S(2,L),1:params.Num);
cineq(7,:) = [0,arrayfun(@(L) -params.Evfim(1,L) + evFim(1,L),1:params.H)];
end
% function dX = Model(x,u,param)
%     u(1) = param.K * u(1);
%     dX = [x(4)*cos(x(3));x(4)*sin(x(3));x(5);u(1);u(2)];
% end
function dX = Model(x,u,param)
    u(1) = param.K * u(1);
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end