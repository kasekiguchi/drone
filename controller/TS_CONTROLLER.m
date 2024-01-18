classdef TS_CONTROLLER < handle
    % Adaptive PID controller
    properties
        self
        result
        z
        v
        vr
        w
        mu
        theta
        f1
        f2
        strans
        rtrans
    end

    methods
        function obj = TS_CONTROLLER(self,param)
            obj.self = self;
            param = param.param;
            obj.strans = param.strans;
            obj.rtrans = param.rtrans;
            obj.f1 = param.f1;
            obj.f2 = param.f2;
            obj.vr = param.vr;
        end

        function u = do(obj,varargin)
            [p,q,~,~]=obj.strans(obj.self.estimator.result.state);       % （グローバル座標）推定状態 (state object)
            [rp,~,~,~]=obj.rtrans(obj.self.reference.result.state);   % （ボディ座標）目標状態 (state object)
            
            xe = rp(1)-p(1);
            ye = rp(2)-p(2);
            obj.z = norm([xe, ye]);
            obj.theta = atan2(ye, xe) - q;

            if obj.theta < 0; f1 = obj.f1;
            else f1 = -obj.f1; end
            
            obj.mu = -f1*obj.z -obj.f2*-sin(obj.theta);
            obj.w = obj.vr * ( obj.mu / cos(obj.theta) );

            if obj.w> pi()/3;obj.w= pi()/3;end
            if obj.w<-pi()/3;obj.w=-pi()/3;end

            if obj.z < 0.1
                obj.v = 0;
            elseif obj.theta>pi/2 || obj.theta<-pi/2
                obj.v = -obj.vr;
            else
                obj.v = obj.vr;
            end
            
            obj.result.input = [obj.v; obj.w];
            obj.self.input_transform.result = obj.result.input;
            u = obj.result;

        end
        function show(obj)
            obj.result;
        end
    end
end

