classdef POINT_REFERENCE < handle
    properties
        param
        self
        result
    end
    
    methods
        function obj = POINT_REFERENCE(self,sample_param)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","q"],'num_list',[3,3]));
            % obj.result.state = STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[9,3,3,3]));
            
            % obj.param = varargin;
            obj.param = sample_param;

            % obj.result.state.p = obj.param{1};
            % obj.result.state.q = obj.param{2};
            obj.result.state.p = obj.param.point_1.p;
            obj.result.state.q = obj.param.point_1.q;
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            if abs(obj.self.estimator.result.state.p(1) - obj.param.point_1.p(1)) < 0.15
                obj.result.state.p = obj.param.point_2.p;
                obj.result.state.q = obj.param.point_2.q;
            end
                
                
            % obj.result.state.p = obj.param{1};
            % obj.result.state.q = obj.param{2};
            % % obj.result.state.v = obj.param{3};
            % % obj.result.state.xd = vertcat(obj.param{:});

            result=obj.result;
        end
        function kabe = kaihi(obj)
            pc = obj.self.sensor.result.pc;
            roi
            
        end
        function show(obj,param)
            
        end
    end
end
