classdef RANGE_COVERAGE_SIM < SENSOR_CLASS
    %RANGE_COVERAGE_SIM このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサを積んでいる機体のhandle object
        r % センサの半径
    end
    properties (SetAccess = private) % constructしたら変えない値
        d = 5; % センサの測定距離
    end
    
    methods
        function obj = RANGE_COVERAGE_SIM(self,param)
            obj.self = self;
            obj.d = param.d;
        end
        
        function result = do(obj,varargin)
            % result=rcoverage_3D.do(varargin) : obj.r 内のdensity mapを返す．
            % result.state : State_obj,  p : position
            % 【入力】varargin = {{Env}}      agent : センサーを積んでいる機体obj,    Env：観測対象のEnv_obj
            Env = varargin{1}{1};
            time = varargin{1}{2};
            state = obj.self.plant.state; % 真値
            sensor = obj.self.sensor.rpos.result; % rposセンサの値を貰う用
            param = obj.self.reference.covering_3D.param;
            id = obj.self.sensor.motive.rigid_num;
            env = Env.Vertices;
            if isfield(sensor,'neighbor')
                neighbor = sensor.neighbor; % 通信領域内の他機体位置　グローバル座標
            elseif isfield(sensor,'rigid')
                neighbor = [sensor.rigid(1:size(sensor.rigid,2) ~= obj.id).p];
            end

            %% センシング領域を定義
            obj.r = 0.5:0.1:2;
            [X,Y,Z] = cylinder(obj.r,100);
            Z = Z * obj.d;
            sensor_range = {X,Y,Z};

            %% 重み分布
            % 対象領域の重要度を計算
            if ~isempty(neighbor) && id == 1
                Ps = [state.p';neighbor(:,1)';neighbor(:,2)';param.Vertices];
            elseif ~isempty(neighbor) && id == 2
                Ps = [neighbor(:,1)';state.p';neighbor(:,2)';param.Vertices];
            elseif ~isempty(neighbor) && id == 3
                Ps = [neighbor(:,1)';neighbor(:,2)';state.p';param.Vertices];
            else
                Ps = [state.p';param.Vertices];
            end
            [v,c] = voronoin(Ps); % 3次元ボロノイ分割

            %% 共通設定２：3次元ボロノイセルの重み確定
            [k{id},~] = convhull(v(c{id},1),v(c{id},2),v(c{id},3),'Simplify',true); % エージェント周りのボロノイ空間
            TR = triangulation(k{id},v(c{id},1),v(c{id},2),v(c{id},3)); % 三角形分割
            F = faceNormal(TR); % 三角形分割した面に対する法線ベクトル
            Ptri = incenter(TR); % 三角形分割した面の内心

            % 領域質量
            zo = find(max(sum(Ptri.*F,2) - (F*param.bx') < 0,[],1) == 0);
            phi_d = normpdf(vecnorm(param.q.*[cos(time.t),sin(time.t),abs(sin(time.t))] - param.bx(zo,:),2,2),0,0.6); % 重み位置と領域内ボクセルとの距離の正規分布関数
            weight_bx = param.bx(zo,:).*phi_d; % 重み付きボクセル
            dmass = sum(weight_bx,1); % 各方向の重みを合算
            mass = sum(phi_d,"all"); % 全部の重みを合算

            % 領域重心
            result.cent = dmass / mass; % 重心

            obj.result = result;
        end

        function show(obj,verargin)
        end
    end
end

