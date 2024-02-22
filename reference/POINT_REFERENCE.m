classdef POINT_REFERENCE < handle
    properties
        param
        self
        result

        pointflag = 1
        point

    end
    
    methods
        function obj = POINT_REFERENCE(self,sample_param)
            % 参照
            obj.self = self;
            obj.result.state = state_copy(obj.self.estimator.model.state);
            obj.param = sample_param;
            obj.result.state.set_state(obj.param.point(1));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}            
            pe = obj.self.estimator.result.state.p - obj.param.point(obj.pointflag).p;
            qe = obj.self.estimator.result.state.q - obj.param.point(obj.pointflag).q;
            if vnorm(pe - qe) < obj.param.threshold && obj.pointflag < obj.param.num
                obj.pointflag = obj.pointflag + 1;%フラグ更新
                if obj.pointflag <= obj.param.num
                    obj.result.state.set_state(obj.param.point(obj.pointflag));
                    disp("flag passed")
                end            
            end
            result=obj.result;
        end
        function show(obj,param)            
        end

    end
end
