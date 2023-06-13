classdef DENSITY_MAP% < ENV_CLASS
    % 環境設定
    % 用語
    % map ：実スケールのマップ
    % grid : 実スケールマップにグリッドを切ったもの
    %
    % Properties
    % q % 重要点の位置
    %         Vertices % 領域を規定するpolygon の頂点
    %         discrete = 1 % 離散環境フラグ ：とりあえず離散だけで進める．
    %         d % grid間距離
    %         map_min % polygonを内包する長方形閉包の最小値座標
    %         map_max % polygonを内包する長方形閉包の最大値座標
    %         xq % x 方向の各gridに対応した実座標： n x 1
    %         yq % y 方向の各gridに対応した実座標： n x 1
    %         phi % phi(i) : (xq(i), yq(i)) の位置での重要度の値．n x 1  : = reshape(grid_density,[n 1]);
    %         grid_density % 各grid 点でのdensity 値 grid_density(i,j) : 実座標のd (i, j) の位置にあるセルの重要度
    %         grid_row % grid の行数 : min:d:max
    %         grid_col % grid の列数 : min:d:max
    %         grid_n % grid 数 row x col
    properties
        id
        q % 重要点の位置
        Vertices % 領域を規定するpolygon の頂点
        discrete = 1 % 離散環境フラグ ：とりあえず離散だけで進める．
        d % grid間距離
        map_min % polygonを内包する長方形閉包の最小値座標
        map_max % polygonを内包する長方形閉包の最大値座標
        xq % x 方向の各gridに対応した実座標： n x 1
        yq % y 方向の各gridに対応した実座標： n x 1
        phi % phi(i) : (xq(i), yq(i)) の位置での重要度の値．n x 1  : = reshape(grid_density,[n 1]);
        grid_density % 各grid 点でのdensity 値 grid_density(i,j) : 実座標のd (i, j) の位置にあるセルの重要度
        grid_row % grid の行数 : min:d:max
        grid_col % grid の列数 : min:d:max
        grid_n % grid 数 row x col
        density_sigma
        param % dummy
    end
    methods
        function obj = DENSITY_MAP(param)
            obj.d = param.d;
            obj.q = param.q;
            obj.Vertices= param.Vertices;    
            if isfield(param,'sigma')
                obj.density_sigma=param.sigma;
            else
                obj.density_sigma=0.04;
            end
            [obj.grid_density,obj.map_max,obj.map_min,obj.xq,obj.yq]=gen_map(param.Vertices,param.d,param.q,obj.density_sigma);
            obj.discrete=1;
            obj.grid_row=length(obj.map_min(1):obj.d:obj.map_max(1));
            obj.grid_col=length(obj.map_min(2):obj.d:obj.map_max(2));
            obj.grid_n = obj.grid_row*obj.grid_col;%length(obj.row)*length(obj.col);
        end
        function [] = show(obj,varargin)
            %s=surf(1:obj.grid_row,1:obj.grid_col,obj.grid_density);
            %s.VerticesColor = 'none';
            %pcolor(obj.xq,obj.yq,obj.grid_density);
            ax = varargin{1};
            contourf(ax,obj.xq,obj.yq,obj.grid_density);
            %            surf(obj.xq,obj.yq,obj.grid_density);
            obj.show_setting(ax);
        end
        function [] = show_setting(obj,ax)
            daspect(ax,[1 1 1])
            xlabel(ax,'x [m]');
            ylabel(ax,'y [m]');
            xlim(ax,[obj.map_min(1) obj.map_max(1)]);
            ylim(ax,[obj.map_min(2) obj.map_max(2)]);
            view(ax,0, 90);
            cmap=[[1 1 1];parula];
            colormap(ax,cmap)
            colorbar(ax)
            grid(ax,"on");
        end
    end
end

