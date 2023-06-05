classdef LANDING_REFERENCE < REFERENCE_CLASS
  properties
    param
    self
    vd = 0.2;
  end

  methods
    function obj = LANDING_REFERENCE(self,varargin)
      % generate landing reference w.r.t. position
      obj.self = self;
      obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[3,3,3]));
      obj.dt = varargin{1}{1}.dt;
    end
    function  result= do(obj,varargin)
      % [Input] time,cha,logger,env
      if isempty( obj.result.state.xd) % first take
        obj.result.state.xd = obj.self.estimator.result.state.p;
      end
      obj.result.state.xd = obj.gen_ref_for_landing(obj.self.estimator.result.state.p);
      obj.result.state.p = obj.result.state.xd;
      obj.result.state.v = [0;0;0];
      result = obj.result;

    end
    function show(obj,param)

    end
    function Xd = gen_ref_for_landing(obj,p)
      % calc reference position for landing
      % [Inputs] 
      % p : current position
      %
      % [Output]
      % Xd : reference of p in R^3

      %% Variable set
      dz = obj.vd * obj.dt; % ref vel * sampling
      %% Set Xd
      Xd = obj.result.state.xd(1:3);
      if Xd(3) > 0 || p(3) - obj.Xd(3) <0.5 % stop descending if xd(3) is far from p(3)
          Xd(3,1)   = Xd(3,1) - dz; % descending with constant rate
      end

    end

  end
end
