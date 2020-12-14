classdef WiFi_sim < SENSOR_CLASS
    % 未検証：WiFi通信のsimulation用クラス
    %   espr = WiFi()
    properties
        name = "ESPr";
        output
        targets_id
        msg
    end
    methods
        function obj = WiFi_sim(varargin)
            %  このクラスのインスタンスを作成
            obj.targets_id = varargin; % 通信に必要な
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

