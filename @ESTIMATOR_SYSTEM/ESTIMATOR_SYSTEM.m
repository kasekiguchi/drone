classdef ESTIMATOR_SYSTEM < matlab.System
  % untitled Add summary here
  %
  % This template includes the minimum set of functions required
  % to define a System object.

  % Public, tunable properties
  properties (DiscreteState)
  end
properties(Access=public)
  type
end
  properties (Access = private)
    % state : estimated state
    JacobianF
    JacobianH
    Q
    R
    dt
    B
    n = 12;
    sensor % function to get sensor value
    sensor_param
    output_func % function of state
    output_param
  end
  % Pre-computed constants or internal states
  properties (Access = private)
    param% =  [ 0.5000    0.1600    0.1600    0.0800    0.0800    0.0600    0.0600    0.0600    9.8100    0.0301    0.0301    0.0301    0.0301    0.0000    0.0000    0.0000    0.0000    0.0392];
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    t0
    result% = struct("state",zeros(12,1),"P",eye(12),"G",zeros(12,6));%struct("p",zeros(3,1),"v",zeros(3,1),"q",zeros(3,1),"w",zeros(3,1)));
    state
  end
  methods
    function obj = ESTIMATOR_SYSTEM(varargin)
      setProperties(obj,nargin,varargin{:})
    end
  end
  methods (Access = protected)

    function setupImpl(obj,dt,state,P,eparam)
      %obj.n = eparam.n;
      %obj.n = 12;
      obj.B = eparam.B;
      obj.Q = eparam.Q;
      obj.R = eparam.R;
      if isfield(eparam,'dt')
        obj.dt = eparam.dt;
      else
        obj.dt = dt;
      end
      obj.param = P;
      obj.Q = eparam.Q;
      obj.R = eparam.R;
      obj.state = state;
      obj.result = eparam.result;
      % obj.result.state = state;
      % obj.result.P = eye(obj.n);
      obj.type = eparam.type;
    end
    function result = stepImpl(obj,time,y,u)
      arguments
        obj
        time (1,1) {mustBeNumeric}
        y (6,1) {mustBeNumeric}
        u (4,1) {mustBeNumeric}
      end
      % Implement algorithm. Calculate y as a function of input u and
      % internal states.
      %obj.cha = varargin{2};
      % if obj.cha=='f'&& ~isempty(obj.t0)    %flightからreferenceの時間を開始
      %      t = time-obj.t0; % 目標重心位置（絶対座標）
      % else
      %      obj.t0=time;
      %      t = obj.t0;
      % end
      %t = time-obj.t0;
      % if ~isempty(obj.timer)
      %   dt = toc(obj.timer);
      %   if dt > obj.dt
      %     dt = obj.dt;
      %   end
      % else
      % end
      %if time ~= 0
      %  y = obj.sensor(obj.self,obj.sensor_param); % sensor output
        % x = obj.result.state.get(); % estimated state at previous step
        % obj.model.do(varargin{:}); % update state
      [~,X] = ode15s(@(t,x) roll_pitch_yaw_thrust_torque_physical_parameter_model(x,u,obj.param),[0:obj.dt/100:obj.dt],obj.state);
      xh_pre = X(end,:)';
        C = [eye(6),zeros(6)];
        yh = C*xh_pre; % output estimation
        A = eye(obj.n)+Jacobian_euler(obj.state,obj.param)*obj.dt; % Euler approximation
        P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % Predicted covariance
        G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
        P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
        tmpvalue = xh_pre + G*(y-yh);	% Update state estimate
        %tmpvalue = obj.model.projection(tmpvalue);
        obj.result.state = tmpvalue;
        obj.state = tmpvalue;
        obj.result.P = P;
       result=obj.result;
    end
  
  function resetImpl(obj)   
    % Initialize / reset internal properties
  end
  function num = getNumInputsImpl(~)
      num = 4;
  end
end
end
