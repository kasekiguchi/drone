classdef (Abstract) SENSOR_CLASS < handle & matlab.mixin.SetGet & dynamicprops
    % sensor 情報生成用スーパークラス
    % Subclass should define concrete method "measure"
    % subclassではmarkerという言葉は使わずfeatureで統一する．
    properties (Abstract)
        %name % 例：RPLIDAR S1 % でもいらないかも．
        result % sensor output
        self % system obj
    end
%     properties (Abstract)
%         interface % Interface class instance
%     end
    methods (Abstract)
        show(obj)
        result=do(obj) %
    end
%     methods (Static)
%         function sensor_obj = sensor_selector(type,param)
%             % 複数センサーがある場合に利用する関数
%             %  sensor_obj=SENSOR_CLASS.sensor_selector(type,param);
%             %  type : "LiDAR_sim", "RangePos_sim"などの配列
%             %  param : 
%             for i = 1: lenthg(type)
%                 switch type(i)
%                     case "LiDAR_sim"
%                         sensor_obj = LiDAR_sim(param);
%                     case "LiDAR_exp"
%                     case "Prime"
%                     case "Position"
%                     case "none_sense"
%                     otherwise
%                         disp("Unknown sensor! Let's implement it.");
%                 end
%             end
%         end
%     end
end
