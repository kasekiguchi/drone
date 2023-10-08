classdef CBFMPC < handle
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
    AE
    BE
    QE
    RE
    gen_Lgh
  end

  methods
    function obj = CBFMPC(model,x0,u0,Td,H)
      obj.Td = Td;

      obj.n = size(x0,1);
      obj.m = size(u0,1);

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

      obj.AE = blkdiag(repmat(Model.A,H,1));
      obj.BE = blkdiag(repmat(Model.B,H,1));
      obj.FE = lqrd(obj.AE,obj.BE,diag([Q,Qf]),R,obj.Td);

      obj.qpproblem.H = 2*diag(obj.Weight.QR);
      obj.gen_f = @(xr) -2*obj.Weight.QR.*xr;
      obj.gen_Lgh = @(x) -2*x(obj.n/2:obj/2:end);
      obj.h = @(x) 1-sum(x(obj.n/2:obj/2:end).^2);
      obj.J = @(x) -0.01*obj.h(x);
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

      Lgh = obj.gen_Lgh(x);
      un = -obj.F*(x-varr);
      tmp = Lgh*un-obj.J(x);
      if tmp < 0
        uk = -(tmp)*Lgh'/sum(Lgh.^2);
      else
        uk = 0;
      end
      if isfield(state,"xo")
        xo = state.xo;
      end
      var = un + uk;
      obj.var = var;
    end    

  end
end