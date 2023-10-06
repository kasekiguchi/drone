classdef MPC < handle
  properties
    problem % problem setting
    H % horizon
    Td % prediction step size
    var % optimization variable's optimized value
    gen_beq
    n
    m
    Weight
  end

  methods
    function obj = MPC(model,x0,u0,Td,H)
      obj.Td = Td;

      obj.n = size(x0,1);
      obj.m = size(u0,1);
      options.Algorithm = 'sqp';
      options.Display = 'none';
      obj.problem.solver = 'fmincon';
      obj.problem.options = options;              % ソルバー

      obj.H = H;
      %obj.Model.Xo = Xo*ones(1, obj.Model.H);       % 障害物の座標をホライゾン分

      % set weight
      obj.Weight.Qf = [1.; 1];      % weight for terminal cost
      obj.Weight.Qapf = 0.4;               % 人工ポテンシャル場法に対する重み
      obj.Weight.Q = [1;100];
      obj.Weight.R = [1;1];
      Model = model.gen_ss(obj.Td);   % prediction model : discrete-time state space model

      obj.var = [ones(1,obj.H+1).*x0,ones(1,obj.H+1).*u0]; % initialize optimization variables

      AX = eye(obj.n*(obj.H+1))-[zeros(obj.n,obj.n*(obj.H+1));kron(eye(obj.H),Model.A),zeros(obj.n*obj.H,obj.n)];
      AU = -kron(eye(obj.H+1),Model.B);
      obj.problem.Aeq = [AX,AU];
      obj.gen_beq = @(x0) [Model.A*x0;zeros(obj.n*obj.H,1)];
    end
    function [var, fval, exitflag, output, lambda, grad, hessian] = do(obj,x,xr,ur)
      varr = [xr,ur];
      % set optimization problem
      obj.problem.beq = obj.gen_beq(x);
      obj.problem.x0		  = [x,obj.var(:,3:obj.H+1),obj.var(:,obj.H+1),obj.var(:,obj.H+2:end)];                         % initial state for optimization
      % obj.problem.x0		  = [repmat(x,1,obj.H+1),ur*0];%ones(1,obj.H+1).*[x;ur*0];
      obj.problem.objective = @(x) obj.Objective(x, obj.Weight,varr);              % objective function
      [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(obj.problem);
      obj.var = var;
    end
    function eval = Objective(obj,x,Weight,xr)
      %-- state and input error
      var = x - xr;
      %-- calc stage cost
      stageCost = sum(var(:,1:obj.H).^2.*Weight.Q,"all")+sum(var(:,obj.H+2:end).^2.*Weight.R,"all");
      %-- calc terminal cost
      terminalCost = sum(var(1:obj.n,end).^2.*Weight.Qf);
      %-- calc objective function value
      eval = stageCost + terminalCost;
    end

  end
end