classdef LOGGER < handle
  %UNTITLED13 このクラスの概要をここに記述
  %   詳細説明をここに記述

  properties
    data
    dataNum
  end
 
  methods
    function obj = LOGGER(mpc,x,u,kmax)
      obj.dataNum = 2*(mpc.n+mpc.m) + 1;
      obj.data.state      = zeros(kmax, obj.dataNum);
      obj.data.state(1,:) = ([x',u',x',u',0]);
    end

    function log(obj,idx,t,state,var,fval,exitflag,output,lambda,grad,hessian)
      obj.data.t(idx) = t;
      obj.data.state(idx,:) = [state,fval];
      % state = [current time, x, u, xr, ur, fval]
      obj.data.exitflag(idx)= exitflag;   % 
      obj.data.output(idx)  = output;     % 
      obj.data.lambda(idx)  = lambda;     % 
      obj.data.grad(idx)	  = {grad};     % 
      obj.data.hessian(idx) = {hessian};  % 
      obj.data.var(idx)     = {var};      % 
    end
  end
end