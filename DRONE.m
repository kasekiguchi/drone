classdef DRONE < ABSTRACT_SYSTEM
    % Drone class
    properties %(Access = private)
        %id = 0;
        fig
    end
    methods
        function obj = DRONE(varargin)
            obj=obj@ABSTRACT_SYSTEM({varargin});
            % このクラスのインスタンスを作成
            %   詳細説明をここに記述
                        %% ドローンのフレーム
            obj.fig = load('plot/frame/drone_frame_01_05.mat').fig;
        end
    end
    methods
        function show(obj)
            %rad = norm(rot);
            %dir = rot/rad;
            if isprop(obj.state,'q')
                pp =patch(obj.fig(1),'FaceAlpha',0.3);
                pf =patch(obj.fig(2),'EdgeColor','flat','FaceColor','none','LineWidth',0.2);
                
                pobj=[pp;pf];
                for i = 1:length(pobj)
                    pobj(i).Vertices = (obj.state.getq('rotmat')*pobj(i).Vertices')'+obj.state.p';
                end
            end
        end
    end
end
