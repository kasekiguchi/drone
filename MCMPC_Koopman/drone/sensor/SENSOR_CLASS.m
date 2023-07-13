classdef (Abstract) SENSOR_CLASS < handle & matlab.mixin.SetGet & dynamicprops
    % sensor 情報生成用スーパークラス
    % Subclass should define concrete method "measure"
    % subclassではmarkerという言葉は使わずfeatureで統一する．
    properties (Abstract)
        result % sensor output
        self % system obj
    end
    methods (Abstract)
        show(obj)
        result=do(obj) %
    end
end
