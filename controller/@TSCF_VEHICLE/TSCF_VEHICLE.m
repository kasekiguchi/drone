classdef TSCF_VEHICLE < handle
% 車両の時間軸状態制御形での制御
properties
    self
    result
    F1
    F2
    eps = 0.001;
end

methods

    function obj = TSCF_VEHICLE(self, param)
        obj.self = self;
        obj.F1 = param.F1;
        obj.F2 = param.F2;
        obj.result.input = zeros(6, 1);
    end

    function result = do(obj, param, ~)
        % param (optional) : {dt}

        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        p = model.state.p(1:2);
        th = model.state.q(3);
        r = ref.state.p(1:2);

        if isprop(ref.state, 'q')
            thr = ref.state.q(3);
        else
            thr = 0;
        end

        if isprop(ref.state, 'v')
            Vr = vecnorm(ref.state.v(1:2));
        else
            Vr = 0;
        end

        if isprop(ref.state, 'dth')
            dthr = vecnorm(ref.state.dth);
        else
            dthr = 0;
        end

        e = [cos(th); sin(th)];
        ep = [-sin(th); cos(th)];
        dp = r - p;
        V = obj.result.input(1);
        dth = obj.result.input(6);
        u1 = obj.input_vel(p, th, r, thr, V, Vr, obj.F1, obj.F2, param{1}); % 2 x 1
        u2 = obj.input_delta(p, Vr, th, dth, r, thr, dthr, obj.F1, obj.F2);
        %obj.result.input = [u1*e;0;0;0;u2];
        obj.result.input = [u1(1); 0; 0; 0; 0; u2];
        obj.self.input = obj.result.input;
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
