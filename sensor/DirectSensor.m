classdef DirectSensor < SENSOR_CLASS
    % simulation�p�N���X�F��Ԃ����̂܂ܕԂ�
    properties
        name = "DirectSensor";
        interface = @(x) x;
        result
        self
    end
    methods
        function obj = DirectSensor(self,~)
            obj.self=self;
            obj.result.state = state_copy(self.state);
        end
        
        function result = do(obj,~)
            % �y���́zTarget �F�ϑ��Ώۂ�Model_obj�̃��X�g
            obj.result.state.set_state(obj.self.state.get());
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
