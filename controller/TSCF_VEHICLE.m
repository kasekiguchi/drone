classdef TSCF_VEHICLE < CONTROLLER_CLASS
    % 車両の時間軸状態制御形での制御
    properties
        self
        result
        param
        parameter_name = [];
    end
    
    methods
        function obj = TSCF_VEHICLE(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
        end
        
        function result=do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = model.state.get(); % = [p;q];
            xd = ref.state.get();
            F1 = Param.F1;
            F2 = Param.F2;
            
            obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4)];
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

