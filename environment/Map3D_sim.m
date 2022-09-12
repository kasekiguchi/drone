classdef Map3D_sim
    %環境設定
    %用語
    % map : 実スケール3Dマップ
    % grid : 実スケールマップにグリッドを切ったもの
    
    properties
        q        % 重要点の位置
        Vertices % 領域の頂点
        d        % grid間距離
        qx       % gridのx方向
        qy       % gridのy方向
        qz       % gridのz方向
        min      % map内立方領域に存在する任意領域の最小値
        max      % map内立方領域に存在する任意領域の最大値
        bx       % 任意領域のボクセル数
        R        % 他機体との通信レンジ
    end
    
    methods
        function obj = Map3D_sim(param)
            obj.d = param.d;
            obj.Vertices = param.Vertices;
            obj.min = param.min;
            obj.max = param.max;
            [obj.qx,obj.qy,obj.qz] = meshgrid(obj.min:obj.d:obj.max,obj.min:obj.d:obj.max,obj.min:obj.d:obj.max);
            obj.bx = [reshape(obj.qx,[numel(obj.qx),1]),reshape(obj.qy,[numel(obj.qx),1]),reshape(obj.qz,[numel(obj.qx),1])];
        end
        
        function show(obj,varargin)
            daspect([1 1 1]);
            ax = gca;
            ax.Box = 'on';
            ax.GridColor = 'k';
            ax.GridAlpha = 0.4;
            xlabel('x [m]','FontSize',pt);
            ylabel('y [m]','FontSize',pt);
            zlabel('z [m]','FontSize',pt);
            xlim([-2,2]);
            ylim([-2,2]);
            zlim([-2,2]);
            grid on;
            plot3(obj.weight(:,1),obj.weight(:,2),obj.weight(:,3),'g.');
        end
    end
end

