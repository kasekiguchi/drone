classdef (Abstract) SENSOR_CLASS < handle & matlab.mixin.SetGet & dynamicprops
    % sensor 情報生成用スーパークラス
    properties (Abstract)
        result % sensor output
        self % system obj
    end
    methods (Abstract)
        show(obj)
        result=do(obj) %
    end
end
