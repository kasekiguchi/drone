classdef Drone < ABSTRACT_SYSTEM
    % Drone class
    properties (Access = private)
        %id = 0;
    end
    methods
        function obj = Drone(varargin)
            obj=obj@ABSTRACT_SYSTEM({varargin});
            % このクラスのインスタンスを作成
            %   詳細説明をここに記述
        end
    end
    methods
      
    end
end
