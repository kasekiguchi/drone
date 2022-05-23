classdef Drone < ABSTRACT_SYSTEM
    % Drone class
    properties %(Access = private)
        %id = 0;
        fig
    end
    methods
        function obj = Drone(args)
            arguments
                args
            end
                obj=obj@ABSTRACT_SYSTEM(args);
            if contains(args.type,"EXP")
                obj.plant = DRONE_EXP_MODEL(args);
            end
            % ドローン用のクラス
            % フレームとしての機能はABSTRACT_SYSTEMに記載
            % ドローン独自の部分はmodel,controllerクラスなどを参照
            %% 描画用ドローンの図
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
