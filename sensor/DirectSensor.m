classdef DirectSensor < SENSOR_CLASS
    % simulation用クラス：状態をそのまま返す
    properties
        name = "DirectSensor";
        interface = @(x) x;
        result
        self
        noise
    end
    methods
        function obj = DirectSensor(self,noise)
            arguments
                self
                noise = 0;
            end
            obj.self=self;
%            obj.result.state = state_copy(self.plant.state);
            obj.result.state = state_copy(self.model.state);
            obj.noise = noise;
        end
        
        function result = do(obj,~)
            % 【入力】Target ：観測対象のModel_objのリスト
%            obj.result.state.set_state(obj.self.plant.state.get());
            tmp=obj.self.model.state.get();
            obj.result.state.set_state(tmp+obj.noise*randn(size(tmp)));
            result=obj.result;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                obj.result
            else
                disp("do measure first.");
            end
        end
    end
end
