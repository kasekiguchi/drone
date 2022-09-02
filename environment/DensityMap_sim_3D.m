classdef DensityMap_sim_3D
    % 環境設定
    % 用語
    % map ：実スケールのマップ
    % grid : 実スケールマップにグリッドを切ったもの
    
    
    properties
        id
        q % 重要点の位置
        Vertices % 領域を規定する範囲の頂点
        discrete = 1 % 離散環境フラグ
        d % grid間距離
        map_min_x % polygonを内包する立方閉包のx方向の最小値座標
        map_max_x % polygonを内包する立方閉包のx方向の最大値座標
        map_min_y % polygonを内包する立方閉包のy方向の最小値座標
        map_max_y % polygonを内包する立方閉包のy方向の最大値座標
        map_min_z % polygonを内包する立方閉包のz方向の最小値座標
        map_max_z % polygonを内包する立方閉包のz方向の最大値座標
        xq % x方向の各gridに対応した実座標：n × 1
        yq % y方向の各gridに対応した実座標：n × 1
        zq % z方向の各gridに対応した実座標：n × 1
        phi % phi(i) : (xq(i), yq(i), zq(i)) の位置での重要度の値．n x 1  : = reshape(grid_density,[n 1]);
        grid_density % 各grid点でのdensity値 grid_density(i,j,k) : 実座標のd(i,j,k) の位置にあるセルの重要度
        grid_x % gridのx方向数：min:d:max
        grid_y % gridのy方向数：min:d:max
        grid_z % gridのz方向数：min:d:max
        grid_n % grid総数：x × y × z
        density_sigma 
    end
    
    methods
        function obj = DensityMap_sim_3D(param)
            obj.d = param.d;
            obj.q = param.q;
            obj.Vertices = param.Vertices;
            if isfield(param,'sigma')
                obj.density_sigma = param.sigma;
            else
                obj.density_sigma = 0.05;
            end
            [obj.grid_density,obj.map_max,obj.map_min,obj.xq,obj.yq]=gen_map_3D(param.Vertices,param.d,param.q,obj.density_sigma);
            obj.discrete=1;
            obj.grid_row=length(obj.map_min(1):obj.d:obj.map_max(1));
            obj.grid_col=length(obj.map_min(2):obj.d:obj.map_max(2));
            obj.grid_n = obj.grid_row*obj.grid_col;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            outputArg = obj.Property1 + inputArg;
        end
    end
end

