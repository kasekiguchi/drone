classdef TAKEOFF_REFERENCE < handle
  properties
    param
    self
    base_time
    base_state
    ts
    te = 5;
    zd = 1; % goal altitude
    result
    th_offset
    th_offset0 = 200;
  end

  methods
    function obj = TAKEOFF_REFERENCE(self,varargin)
      % generate takeoff reference w.r.t. position and velocity
      obj.self = self;
      obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
    end
    function  result= do(obj,varargin)
      % [Input] time,cha,logger,env
      if isempty( obj.base_state ) % first take
        obj.base_time=varargin{1}.t;
        obj.base_state = obj.self.estimator.result.state.p;
        obj.result.state.xd = [obj.base_state;zeros(17,1)];
        obj.th_offset = obj.self.input_transform.param.th_offset;
      end
      obj.result.state.xd = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
      obj.result.state.p = obj.result.state.xd(1:3,1);
      obj.result.state.v = obj.result.state.xd(5:7,1);
      obj.self.input_transform.param.th_offset = obj.th_offset0 + (obj.th_offset-obj.th_offset0)*min(obj.te,varargin{1}.t-obj.base_time)/obj.te;
      result = obj.result;
    end
    function Xd = gen_ref_for_take_off(obj,t)
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
      d = obj.zd-obj.base_state(3); % goal altitude : relative value
      te = obj.te; % terminal time to reach zd
      %% Set Xd
      if t<=te
        tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
        dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
        ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
        d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
        d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
      elseif t> te
        tra=d;
        dtra = 0;
        ddtra = 0;
        d3tra = 0;
        d4tra = 0;
      end
      Xd(1:3,1) = obj.base_state(1:3);
      Xd(3,1) = tra + Xd(3,1);
      Xd(7,1) = dtra;
      Xd(11,1) = ddtra;
      Xd(15,1) = d3tra;
      Xd(19,1) = d4tra;
    end

  end
end
