% -------------------------------------------------------------------------
%Author Sota Wada; Date 2021_10_19
% -------------------------------------------------------------------------
function [x,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_Trackobjective(obj,x0,param)
assert(isa(x0,'double'));assert(all(size(x0)==	[8,param.H+1]));
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
assert(isa(param.T,'double'));assert(all(size(param.T)==	[param.H,param.H]));
assert(isa(param.Xr,'double'));assert(all(size(param.Xr)==	[4,param.H+1]));
assert(isa(param.dis,'double'));assert(all(size(param.dis)>=	[1,1]));assert(all(size(param.dis)<=	[1,629]));
assert(isa(param.alpha,'double'));assert(all(size(param.alpha)>=[1,1]));assert(all(size(param.alpha)<=	[1,629]));
assert(isa(param.phi,'double'));assert(all(size(param.phi)>=	[1,1]));assert(all(size(param.phi)<=	[1,629]));
assert(isa(param.X0,'double'));assert(all(size(param.X0)==	[4,1]));
assert(isa(param.model_param,'struct'));
assert(isa(param.model_param.K,'double'));assert(all(size(param.model_param.K)==	[2,2]));
    options = optimoptions('fmincon',...
        'MaxIterations',                 1000000000,...
        'MaxFunctionEvaluations',        1000000000,...
        'ConstraintTolerance',           1e-09,...
        'OptimalityTolerance',           1e-06,...
        'StepTolerance',                 1e-09,...
        'SpecifyObjectiveGradient',      false,...
        'SpecifyConstraintGradient',     false,...
        'Algorithm',                     'sqp');
    % 最大反復回数, 評価関数の最大値, 制約の許容誤差, 最適性の許容誤差, ステップサイズの下限, 評価関数の勾配設定, 制約条件の勾配設定, SQPアルゴリズムの指定
    evalfunc = @(x)TrackobjectiveMEX(x,param);
    nonlcon  = @(x)constraintsMEX(x,param);
    [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(evalfunc,x0,[],[],[],[],[],[],nonlcon,options);
end