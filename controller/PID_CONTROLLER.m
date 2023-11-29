classdef PID_CONTROLLER < handle

properties
    self
    result
    e
    ed
    ei = 0;
    Kp
    Ki
    Kd
    dt
    gen_e
    gen_ed
    gen_ei
end

methods

    function obj = PID_CONTROLLER(self, param)
      %arguments
       % self
        % param.Kp
        % param.gen_e
        % param.Ki = 0;
        % param.Kd = 0;
        % param.gen_ed = @(x,y) 0;
        % param.gen_ei = @(x,y,z) 0;
      %end
        obj.self = self;
        obj.Kp = param.Kp;
        obj.Ki = param.Ki;
        obj.Kd = param.Kd;
        obj.dt = param.dt;
        %obj.ei = zeros(size(var,1),1);
        obj.gen_e = param.gen_e;
        obj.gen_ed = param.gen_ed;
        obj.gen_ei = param.gen_ei;
    end

    function u = do(obj, varargin)
        % u = do(obj,param,~)
        % param (optional) :
        if length(varargin)>6,        param = struct(varargin{7});else param = [];end

        if ~isempty(param)
            if isfield(param, 'Kp'); obj.Kp = param.Kp; end
            if isfield(param, 'Ki'); obj.Ki = param.Ki; end
            if isfield(param, 'Kd'); obj.Kd = param.Kd; end
            if isfield(param, 'dt'); obj.dt = param.dt; end
        end

        obj.e = obj.gen_e(obj.self.estimator.result.state,obj.self.reference.result.state);
        obj.ed = obj.gen_ed(obj.self.estimator.result.state,obj.self.reference.result.state);
        obj.ei = obj.gen_ei(obj.ei,obj.self.estimator.result.state,obj.self.reference.result.state);

        obj.result.input = -obj.Kp * obj.e - obj.Kd * obj.ed - obj.Ki*obj.ei;
        u = obj.result;
    end

    function show(obj)
        obj.result;
    end

end

end
