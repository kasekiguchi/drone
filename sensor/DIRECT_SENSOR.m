classdef DIRECT_SENSOR < handle
% simulation用クラス：状態をそのまま返す
properties
    name = "direct";
    interface = @(x) x;
    result
    self
    noise
end

methods

    function obj = DIRECT_SENSOR(self, noise)

        arguments
            self
            noise = 0;
        end

        obj.self = self;
        obj.result.state = state_copy(self.plant.state);
        %            obj.result.state = state_copy(self.model.state);
        obj.noise = noise;
    end

    function result = do(obj, varargin)
        % 【入力】Target ：観測対象のModel_objのリスト
        tmp = obj.self.plant.state.get();
        obj.result.state.set_state(tmp + obj.noise * randn(size(tmp)));
        result = obj.result;
    end

    function show(obj, varargin)

        if ~isempty(obj.result)
            obj.result
        else
            disp("do measure first.");
        end

    end

end

end
