classdef MPC < handle
  properties
    problem % problem setting
    H % horizon
    Td % prediction step size
    var % optimization variable's optimized value
    X
    U
    gen_beq
    n
    m
    Weight
    qpproblem
    gen_f
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
      Qf = ones(obj.n,1);      % weight for terminal cost
      Q = repmat([100;100;ones(obj.n/2-2,1);100;ones(obj.n/2-1,1)],obj.H-1,1);
      R = repmat([1;1],obj.H,1);
      obj.Weight.QR = [Q;Qf;R];
      obj.Weight.Qapf = 1;               % weight for obstacle avoidance

      Model = model.gen_ss(obj.Td);   % prediction model : discrete-time state space model

      obj.X = ones(1,obj.H).*x0;
      obj.U = ones(1,obj.H).*u0; % initialize optimization variables
      obj.var = [repmat(x0,H,1);repmat(u0,H,1)];
      AX = eye(obj.n*(obj.H))-[zeros(obj.n,obj.n*(obj.H));kron(eye(obj.H-1),Model.A),zeros(obj.n*(obj.H-1),obj.n)];
      AU = -kron(eye(obj.H),Model.B);
      obj.problem.Aeq = [AX,AU];
      obj.gen_beq = @(x0) [Model.A*x0;zeros(obj.n*(obj.H-1),1)];

      obj.qpproblem.solver = 'quadprog';
      obj.qpproblem.options = optimoptions('quadprog','Display','none');
      %options;              % ソルバー

      obj.qpproblem.H = 2*diag(obj.Weight.QR);
      obj.gen_f = @(xr) -2*obj.Weight.QR.*xr;
      obj.qpproblem.Aeq = [AX,AU];
      obj.qpproblem.A = [];
      obj.qpproblem.B = [];
      
    end
    function [var,fval,exitflag,output,lambda] = do(obj,varargin)
      %[var,fval, exitflag, output, lambda, grad, hessian]
      % (obj,x,varr,xo)    
      % [Input]
      % 1 : time
      % 2 : key board input
      % 3 : logger
      % 4 : env
      % 5 : agent
      % 6 : id
      state = varargin{5}.estimator.result.state;
      x = state.p;
      varr = varargin{5}.reference.result.state.xd;
      if isfield(state,"xo")
        xo = state.xo;
      end
      % sqp 
      obj.problem.beq = obj.gen_beq(x);
      obj.problem.x0 = [obj.var(obj.n+1:obj.n*obj.H,1);obj.var(obj.n*(obj.H-1)+1:end,1)];
      % obj.problem.x0 = [repmat(x,obj.H,1);zeros(obj.m*obj.H,1)];
      obj.problem.objective = @(x) obj.Objective(x, obj.Weight,varr,xo);              % objective function
      [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(obj.problem);
      % 
      % qp
      % obj.qpproblem.beq = obj.gen_beq(x);
      % obj.qpproblem.f = obj.gen_f(varr);
      % obj.qpproblem.x0 = [obj.var(obj.n+1:obj.n*obj.H,1);obj.var(obj.n*(obj.H-1)+1:end,1)];
      % [var,fval,exitflag,output,lambda] = quadprog(obj.qpproblem);
      
      obj.var = var;
    end    
    function eval = Objective(obj,x,Weight,varr,xo)
      % [Input]
      % x : [x[k+1];x[k+2];...;x[k+H+1];u[k];u[k+1];...;u[k+H]];
      % Weight : structure of QR and Qo
      % varr : reference for x
      % xo : measured obstacle position
      % [Output]
      % eval : objective function's value
      arguments
        obj
        x
        Weight
        varr
        xo = []
      end

      %-- state and input error
      var = x - varr;
      %-- obstacle avoidance : artificial potential 
      dxo = [x(1:obj.n:obj.n*obj.H)';x(1+obj.n/2:obj.n:obj.n*obj.H)'] - xo;
      if isempty(xo)
        APF = 0;
      else
        APF = sum(Weight.Qapf./sum(dxo.^2));
      end
      eval = sum(var.^2.*Weight.QR) + APF;
    end

  end
end