classdef (Abstract) SENSOR_CLASS < handle & matlab.mixin.SetGet & dynamicprops
    % sensor ��񐶐��p�X�[�p�[�N���X
    % Subclass should define concrete method "measure"
    % subclass�ł�marker�Ƃ������t�͎g�킸feature�œ��ꂷ��D
    properties (Abstract)
        %name % ��FRPLIDAR S1 % �ł�����Ȃ������D
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
%             % �����Z���T�[������ꍇ�ɗ��p����֐�
%             %  sensor_obj=SENSOR_CLASS.sensor_selector(type,param);
%             %  type : "LiDAR_sim", "RangePos_sim"�Ȃǂ̔z��
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
