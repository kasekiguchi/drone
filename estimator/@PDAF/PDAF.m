classdef PDAF < handle
% Extended Kalman filter
% obj = EKF(model,param)
%   model : EKFを実装する制御対象の制御モデル
%   param : required field : Q,R,B,JacobianH
%  JacobianH(x,p) : 出力方程式の拡張線形化した関数のhandle
  properties
    result
        % state : estimated state
    JacobianF
    JacobianH
    Q
    R
    dt
    B
    n
    sensor % function to get sensor value
    sensor_param
    output_func % function of state
    output_param
    sensor_length
    threshold
    PD
    PG
    L
    self
    model
    m
    timer= [];
    beta
end

methods
    function obj = PDAF(self,param)
        obj.self= self;
        obj.model = param.model;
        ELfile=strcat("Jacobian_",obj.model.name);
        if ~exist(ELfile,"file")
            obj.JacobianF=ExtendedLinearization(ELfile,obj.model);
        else
            obj.JacobianF=str2func(ELfile);
        end
        obj.result.state= state_copy(obj.model.state);
        obj.sensor = param.sensor_func; % output function handle : function of obj.self
        obj.sensor_param = param.sensor_param;
        obj.output_func = param.output_func;
        obj.output_param = param.output_param;
        obj.JacobianH = param.JacobianH;
        obj.n = length(obj.model.state.get());
        obj.Q = param.Q;% 分散
        obj.R = param.R;% 分散
        obj.dt = obj.model.dt; % 刻み
        obj.B = param.B;
        obj.result.P = param.P;
        obj.result.G = zeros(obj.n,size(obj.R,2));
        obj.result.A = zeros(obj.n,size(obj.R,2));
        obj.result.C = zeros(obj.n,size(obj.R,2));
        obj.result.param = zeros(1,18);
        obj.threshold = param.threshold;
        obj.sensor_length = param.sensor_length;
        obj.PD = param.PD;
        obj.PG = param.PG;
        obj.L = zeros(length(obj.sensor_length)+1,1);
        obj.m = zeros(length(obj.sensor_length)+1,1);
        obj.beta = zeros(length(obj.sensor_length)+1,1);
    end
    
    function [result]=do(obj,varargin)
      if ~isempty(obj.timer)
        dt = toc(obj.timer);
        if dt > obj.dt
          dt = obj.dt;
        end
      else
        dt = obj.dt;
      end
      if varargin{1}.t ~= 0
        % 事前予測
        x = obj.result.state.get(); % estimated state at previous step
        obj.model.do(varargin{:}); % update state
        xh_pre = obj.model.state.get(); % Pre-estimation
        yh = obj.output_func(xh_pre,obj.output_param); % output estimation
        y = obj.sensor(obj.self,obj.sensor_param); % sensor output
        p = obj.self.parameter.get(); 
        A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
        C = obj.JacobianH(x,p);
        P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';  
        % 外れ値判定
        nu = y - yh;
        S = C*P_pre*C' + obj.R;
        c = pi^(length(y)/2)/gamma(1+(length(y))/2);
        Vr = c * obj.threshold^(length(y)/2)*sqrt(S);
        obj.m(1) = sqrt(nu'*inv(S)*nu);
        count = 1;
        for j = 1:length(obj.sensor_length)
            span = [count count+obj.sensor_length(j)-1];
            obj.m(j+1) = sqrt(nu(span)'*inv(S(span,span))*nu(span));
            count = + obj.sensor_length(j);
        end
        gating_num = min(find(obj.m<obj.threshold));
        if  isempty(gating_num)
            tmpvalue = xh_pre;	% Update state estimate
            tmpvalue = obj.model.projection(tmpvalue);
            obj.result.state.set_state(tmpvalue);
            obj.model.state.set_state(tmpvalue);
            obj.result.G = zeros;
            obj.result.P = P_pre;
            obj.result.A = A;
            obj.result.C = C;
            obj.result.param = p;
        else
        lambda = length(nu(gating_num))/(c*obj.threshold(1)^(length(y)/2));
        obj.L(1) = (obj.PD/lambda)*(exp(-0.5 * nu'*inv(S)*nu))/(sqrt((2*pi)^(length(nu))*det(S)));
        count = 1;
        for j=1:length(obj.sensor_length)
            span = [count count+obj.sensor_length(j)-1];
            obj.L(j+1) = (obj.PD/lambda)*(exp(-0.5 * nu(span)'*inv(S(span,span))*nu(span)))/(sqrt((2*pi)^(length(nu(span)))*det(S(span,span))));
            count = + obj.sensor_length(j);
        end
        obj.beta(1) = obj.L(1) / (1 - obj.PD*obj.PG + sum(obj.L(2:end)));
        count = 1;
        inov = zeros(length(nu),1);
        for j=1:length(obj.sensor_length)
            span = [count count+obj.sensor_length(j)-1];
            obj.beta(j+1) = obj.L(j+1) / (1 - obj.PD*obj.PG + sum(obj.L(2:end)));
            inov(span) = obj.beta(j+1)*nu(span);
            count = + obj.sensor_length(j);
        end
        % fltering
        G = (P_pre*C')/(C*P_pre*C'+obj.R);% kalmangain
        P = P_pre + (1-obj.beta(gating_num))*G*S*G';	% Update covariance
        tmpvalue = xh_pre + G*inov;	% Update state estimate
        tmpvalue = obj.model.projection(tmpvalue);
        obj.result.state.set_state(tmpvalue);
        obj.model.state.set_state(tmpvalue);
        obj.result.G = G;
        obj.result.P = P;
        obj.result.A = A;
        obj.result.C = C;
        obj.result.param = p;
        end
      end
        result=obj.result;
        obj.timer = tic;
    end
end
end

