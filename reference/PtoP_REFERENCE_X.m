classdef LANDING_REFERENCE_X < handle
%試作途中なので注意
  properties
    param
    self
    vd = 0.5;
    dt
    result
    base_state
    base_time
    te = 10
    th_offset
    th_offset0 = 200;
  end

  methods
    function obj = LANDING_REFERENCE_X(self,varargin)
      % generate landing reference w.r.t. position
      obj.self = self;
      obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
      obj.dt = varargin{1};
      obj.vd = varargin{2};
    end
    function result = do(obj,varargin)
      % [Input] time,cha,logger,env
      if isempty(obj.result.state.xd) % first take
        obj.base_time = varargin{1}.t;
        obj.base_state = [obj.self.estimator.result.state.p(1); obj.result.state.p(2:3)]; % x : current position, y,z : reference using at flight phase
        obj.result.state.xd = [obj.base_state; zeros(17,1)];
        obj.th_offset = obj.self.input_transform.param.th_offset;
      end
      obj.result.state.xd = obj.gen_ref_for_landing(varargin{1}.t - obj.base_time);
      obj.result.state.p = obj.result.state.xd(1:3,1);
      obj.result.state.v = obj.result.state.xd(5:7,1);
      obj.self.input_transform.param.th_offset = obj.th_offset - (obj.th_offset - obj.th_offset0) * min(obj.te, varargin{1}.t - obj.base_time) / obj.te;
      result = obj.result;
    end
    function Xd = gen_ref_for_landing(obj,t)
      %% Setting
      % calc reference position and its higher time derivatives
      % reference designed as a 9-degree polynomial function of time
      % [Inputs]
      % t : current time
      %
      % [Output]
      % Xd : reference [[p;yd], [p^(1);0], [p^(2);0], [p^(3);0], [p^(4);0]] as column vector
      %    : Xd in R^20
      %    : yd is a yaw angle reference

      %% Variable set
      Xd  = zeros( 20, 1);
      %% Set Xd
      if t <= obj.te
        Xd_x = curve_interpolation_9order(t, obj.te, obj.base_state(1), 0, 0, 0);
      elseif t > obj.te
        Xd_x = zeros(1, 5);
      end
      Xd(1,1) = Xd_x(1);
      Xd(5,1) = Xd_x(2);
      Xd(9,1) = Xd_x(3);
      Xd(13,1) = Xd_x(4);
      Xd(17,1) = Xd_x(5);
    end
  end
end