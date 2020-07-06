classdef WiFi_sim < SENSOR_CLASS
    % �����؁FWiFi�ʐM��simulation�p�N���X
    %   espr = WiFi()
    properties
        name = "ESPr";
        output
        targets_id
        msg
    end
    methods
        function obj = WiFi_sim(varargin)
            %  ���̃N���X�̃C���X�^���X���쐬
            obj.targets_id = varargin; % �ʐM�ɕK�v��
        end
        
        function output = measure(obj,Plants,msg)
            % output=espr.measure(Model)
            output.neighbor(1:length(obj.targets_id)) = Neighbor_gen();
            for i = 1:length(obj.targets_id)
                TargetPlant=Plants.id(obj.targets_id(i));
                output.neighbor(i).info=TargetPlant.espr.get(msg);
            end
        end
    end
end

