classdef ceiling_PtoP
    properties
        param
        flight_phase = 's';
        flag = 's';
        self
        base_time
        base_state
    end
    
    methods
        function obj = ceiling_ProP(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v"],'num_list',[3]));
        end
        function  result= do(obj,Param,result)
            if isempty( obj.base_state )
                obj.base_state =obj.self.estimator.result.state.p;
            end
            cha = get(Param{1}, 'currentcharacter');
            if strcmp(cha,'f') % flight phase

                obj.result.state.p = obj.base_state;
            end
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end


