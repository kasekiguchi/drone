% -------------------------------------------------------------------------
%Author Sota Wada; Date 2021_10_21
% -------------------------------------------------------------------------
function [x,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_ObFimAndFimobjective(obj,x0,param,NoiseR,SensorRange,RangeGain)
% assert(isa(x0,'double'));assert(all(size(x0)==	[8,4]));
% assert(isa(param,'struct'));
% assert(isa(param.H,'double'));assert(all(size(param.H)==	[1,1]));
% assert(isa(param.dt,'double'));assert(all(size(param.dt)==	[1,1]));
% assert(isa(param.input_size,'double'));assert(all(size(param.input_size)==	[1,1]));
% assert(isa(param.state_size,'double'));assert(all(size(param.state_size)==	[1,1]));
% assert(isa(param.total_size,'double'));assert(all(size(param.total_size)==	[1,1]));
% assert(isa(param.Num,'double'));assert(all(size(param.Num)==	[1,1]));
% assert(isa(param.Q,'double'));assert(all(size(param.Q)==	[4,4]));
% assert(isa(param.R,'double'));assert(all(size(param.R)==	[2,2]));
% assert(isa(param.Qf,'double'));assert(all(size(param.Qf)==	[4,4]));
% assert(isa(param.T,'double'));assert(all(size(param.T)==	[3,3]));
% assert(isa(param.S,'double'));assert(all(size(param.S)==	[1,2]));
% assert(isa(param.Xr,'double'));assert(all(size(param.Xr)==	[4,4]));
% assert(isa(param.dis,'double'));assert(all(size(param.dis)>=	[1,1]));assert(all(size(param.dis)<=	[1,629]));
% assert(isa(param.alpha,'double'));assert(all(size(param.alpha)>=[1,1]));assert(all(size(param.alpha)<=	[1,629]));
% assert(isa(param.phi,'double'));assert(all(size(param.phi)>=	[1,1]));assert(all(size(param.phi)<=	[1,629]));
% assert(isa(param.X0,'double'));assert(all(size(param.X0)==	[4,1]));
% assert(isa(param.U0,'double'));assert(all(size(param.U0)==	[2,1]));
% assert(isa(param.model_param,'struct'));
% assert(isa(param.model_param.K,'double'));assert(all(size(param.model_param.K)==	[2,2]));
% assert(isa(NoiseR,'double'));assert(all(size(NoiseR)==	[1,1]));
% assert(isa(SensorRange,'double'));assert(all(size(SensorRange)==	[1,1]));
% assert(isa(RangeGain,'double'));assert(all(size(RangeGain)==	[1,1]));
    options = optimoptions('fmincon',...
        'MaxIterations',                 100000,...
        'MaxFunctionEvaluations',        100000,...
        'ConstraintTolerance',           1e-09,...
        'OptimalityTolerance',           1e-06,...
        'StepTolerance',                 1e-09,...
        'SpecifyObjectiveGradient',      false,...
        'SpecifyConstraintGradient',     false,...
        'Algorithm',                     'sqp');
    % 最大反復回数, 評価関数の最大値, 制約の許容誤差, 最適性の許容誤差, ステップサイズの下限, 評価関数の勾配設定, 制約条件の勾配設定, SQPアルゴリズムの指定
    evalfunc = @(x)FimobjectiveMEX(x,param,NoiseR,SensorRange,RangeGain);
    nonlcon  = @(x)constraintsMEX(x,param);
    [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(evalfunc,x0,[],[],[],[],[],[],nonlcon,options);
end
function [eval] = FimobjectiveMEX(x, params,NoiseR,SensorRange,RangeGain)%way
%  global nextwaypoint 
%  nextwaypoint = 1;
%  ref = [-2,-2;23,-2;23,23;-2,23];
%  
%  if 
% モデル予測制御の評価値を計算するプログラム
%---MPCで用いる予測状態 Xと予測入力 Uを設定---%
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
S = x(params.total_size+1:end,:);
%---状態及び入力に対する目標状態や目標入力との誤差を計算---%
tildeX = X - params.Xr;
tildeU = U;
%
evFim = zeros(1,params.H);

% evFim = zeros(2,2*params.H);
for j = 1:params.H
    t1 = params.phi;
    t2 = params.alpha;
    [~,tth]=min(abs(t1-t2),[],2);
    
    H = (params.dis(:) - X(1,j).*cos(params.alpha(:)) - X(2,j).*sin(params.alpha(:)))./cos(params.phi(tth)' - params.alpha(:) + X(3,j));%observation
%     RangeLogic = H<SensorRange;
    RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;%センサレンジの考慮 zeta
    Fim = RangeLogic(1) * FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),U(1,j),params.dt, params.dis(1), params.alpha(1), params.phi(1));
    obFim = RangeLogic(1) * FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(1), params.alpha(1), params.phi(1));
    for i = 2:length(params.dis)
        Fim = Fim + RangeLogic(i) * FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),U(1,j),params.dt, params.dis(i), params.alpha(i), params.phi(i));
        obFim = obFim + RangeLogic(i) * FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(i), params.alpha(i), params.phi(i));
    end
%     Fim = (1/(2*NoiseR+diag([1,1])))*Fim;
    Fim = (Fim+1e-2*eye(2))/(2*NoiseR);%観測値差分のFisher情報行列計算
    %obFim = (1/(NoiseR))*([obFim + [1e-2,1e-2,1e-2;1e-2,1e-2,1e-2;1e-2,1e-2,1e-2]]);%観測値のFisher情報行列
    obFim = (1/(NoiseR))*(obFim + 1e-2*eye(3));%観測値のFisher情報行列
    InvFim = [Fim(2,2) -Fim(1,2); -Fim(2,1), Fim(1,1)]/(det(Fim));%逆行列の計算
%     InvFim = inv(Fim);
    InvobFim = inv(obFim);
    evFim(1,j) = trace(InvobFim)*trace(InvFim);%評価値計算
   % evFim(1,j) = det(InvobFim'*InvobFim)*det(InvFim'*InvFim);
end
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
stageevFim = evFim* params.T * evFim';
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + sum(stageevFim) + terminalState;
end
function APP = FIM_ObserbSubAOmegaRungeKutta(x,y,theta,v,omega,a,t,d1,alpha1,phi1)
%FIM_OBSERBSUBAOMEGARUNGEKUTTA
%    APP = FIM_OBSERBSUBAOMEGARUNGEKUTTA(X,Y,THETA,V,OMEGA,A,T,D1,ALPHA1,PHI1)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    13-Dec-2021 19:35:13

t2 = cos(alpha1);
t3 = sin(alpha1);
t4 = cos(theta);
t5 = sin(theta);
t6 = a+v;
t7 = omega.*t;
t8 = omega+theta;
t13 = -alpha1;
t14 = -d1;
t15 = a./2.0;
t16 = omega./2.0;
t9 = cos(t8);
t10 = t4.*v;
t11 = sin(t8);
t12 = t5.*v;
t17 = t15+v;
t18 = t16+theta;
t23 = phi1+t7+t13+theta;
t19 = cos(t18);
t20 = sin(t18);
t21 = t6.*t9;
t22 = t6.*t11;
t26 = cos(t23);
t27 = sin(t23);
t24 = t19.*4.0;
t25 = t20.*4.0;
t28 = 1.0./t26;
t30 = t17.*t20.*2.0;
t34 = t17.*t19.*2.0;
t29 = t28.^2;
t31 = t17.*t25;
t32 = t4+t9+t24;
t33 = t5+t11+t25;
t35 = t17.*t24;
t38 = t21+t34;
t39 = t22+t30;
t36 = (t.*t3.*t33)./6.0;
t37 = (t.*t2.*t32)./6.0;
t40 = t10+t21+t35;
t41 = t12+t22+t31;
t42 = (t.*t3.*t38)./6.0;
t43 = (t.*t2.*t39)./6.0;
t44 = -t43;
t45 = (t.*t40)./6.0;
t46 = (t.*t41)./6.0;
t51 = t36+t37;
t47 = t46+y;
t48 = t45+x;
t52 = t42+t44;
t49 = t2.*t48;
t50 = t3.*t47;
t53 = t28.*t52;
t54 = t14+t49+t50;
t55 = t.*t27.*t29.*t54;
t56 = t53+t55;
t57 = t28.*t51.*t56;
APP = [t29.*t51.^2,t57;t57,t56.^2];
end
function PVT = FIMVT_ObserbSubAOmegaRungeKutta(x,y,theta,v,omega,a,t,d1,alpha1,phi1)
%FIMVT_OBSERBSUBAOMEGARUNGEKUTTA
%    PVT = FIMVT_OBSERBSUBAOMEGARUNGEKUTTA(X,Y,THETA,V,OMEGA,A,T,D1,ALPHA1,PHI1)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    20-Dec-2021 13:57:42

t2 = cos(alpha1);
t3 = sin(alpha1);
t4 = cos(theta);
t5 = sin(theta);
t6 = a+v;
t7 = omega.*t;
t8 = omega+theta;
t15 = -alpha1;
t16 = -d1;
t17 = a./2.0;
t18 = omega./2.0;
t9 = t2.*x;
t10 = cos(t8);
t11 = t3.*y;
t12 = t4.*v;
t13 = sin(t8);
t14 = t5.*v;
t19 = phi1+t15+theta;
t20 = t17+v;
t21 = t18+theta;
t22 = cos(t21);
t23 = sin(t21);
t24 = t6.*t10;
t25 = t6.*t13;
t26 = cos(t19);
t27 = sin(t19);
t28 = t7+t19;
t34 = t9+t11+t16;
t29 = t22.*4.0;
t30 = t23.*4.0;
t31 = cos(t28);
t32 = sin(t28);
t33 = 1.0./t26.^2;
t35 = 1.0./t31;
t37 = t20.*t30;
t38 = t4+t10+t29;
t39 = t5+t13+t30;
t40 = t20.*t29;
t45 = t27.*t33.*t34;
t36 = t35.^2;
t41 = (t.*t3.*t39)./6.0;
t42 = (t.*t2.*t38)./6.0;
t43 = t12+t24+t40;
t44 = t14+t25+t37;
t46 = (t.*t43)./6.0;
t47 = (t.*t44)./6.0;
t52 = t.*t3.*t43.*(-1.0./6.0);
t55 = t41+t42;
t48 = t2.*t47;
t49 = t47+y;
t50 = t3.*t46;
t51 = t46+x;
t53 = t2.*t51;
t54 = t3.*t49;
t56 = t48+t52;
t57 = t16+t53+t54;
t58 = t35.*t56;
t59 = t32.*t36.*t57;
t60 = -t59;
t61 = t45+t58+t60;
t62 = t35.*t55.*t61;
t63 = -t62;
PVT = [t36.*t55.^2,t63;t63,t61.^2];
end
function PP = FIM_Observe(x,y,theta,d,alpha,phi)
%FIM_OBSERVE
%    PP = FIM_OBSERVE(X,Y,THETA,D,ALPHA,PHI)

%    This function was generated by the Symbolic Math Toolbox version 8.6.
%    16-Nov-2021 18:17:45

t2 = cos(alpha);
t3 = sin(alpha);
t6 = -alpha;
t7 = -d;
t4 = t2.*x;
t5 = t3.*y;
t8 = phi+t6+theta;
t9 = cos(t8);
t10 = sin(t8);
t13 = t4+t5+t7;
t11 = 1.0./t9.^2;
t12 = 1.0./t9.^3;
t14 = t2.*t3.*t11;
t15 = t2.*t10.*t12.*t13;
t16 = t3.*t10.*t12.*t13;
PP = [t2.^2.*t11,t14,t15;t14,t3.^2.*t11,t16;t15,t16,t10.^2.*t11.^2.*t13.^2];
end
function [cineq, ceq] = constraintsMEX(x, params)
% モデル予測制御の制約条件を計算するプログラム
%constraints only model
cineq  = zeros(4, params.Num);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
%S = x(params.total_size+1:end,:);
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
PredictX = zeros(4,params.H);
for L = 1:params.H
    tmp = ode45(@(t,x) Model(x,U(:,L),params.model_param),[0 params.dt*params.step],X(:,L));
    PredictX(:,L) = tmp.y(:,end);
    %     PredictX(:,L) = X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param);
end
% PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false));
tmpceq = zeros(params.state_size,params.H);
for L = 2:params.Num
    tmpceq(1:params.state_size,L-1) = X(:, L)  -  PredictX(:,L-1);
end
ceq = [X(:, 1) - params.X0, tmpceq];%初期時刻を現在状態に固定，モデルに従う制約
%---入力の情怪訝制約を設定---%
cineq(1,:) = arrayfun(@(L) -params.S(1)+U(1,L),1:params.Num);%速度入力の上限
cineq(2,:) = arrayfun(@(L) -params.S(2)+U(2,L),1:params.Num);%角速度の上限
cineq(3,:) = arrayfun(@(L) -params.S(1)-U(1,L),1:params.Num);%速度入力の下限
cineq(4,:) = arrayfun(@(L) -params.S(2)-U(2,L),1:params.Num);%角速度の下限
end
function dX = Model(x,u,param)
    u = param.K * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1) - param.D*x(4)];
end