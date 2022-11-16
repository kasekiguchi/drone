classdef RANGE_COVERAGE_BIRD_SIM < SENSOR_CLASS
    %RANGE_COVERAGE_SIM このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサを積んでいる機体のhandle object
        r % センサの半径
        drone
    end
    properties (SetAccess = private) % constructしたら変えない値
        d = 5; % センサの測定距離
    end
    
    methods
        function obj = RANGE_COVERAGE_BIRD_SIM(self,param)
            obj.self = self;
            obj.d = param.d;
            obj.drone = param.drone;
        end
        
        function result = do(obj,Param)
            % result=rcoverage_3D.do(varargin) : obj.r 内のdensity mapを返す．
            % result.state : State_obj,  p : position
            % 【入力】varargin = {{Env}}      agent : センサーを積んでいる機体obj,    Env：観測対象のEnv_obj
            state = obj.self.plant.state; % 真値
            sensor = obj.self.sensor.motive.result.rigid; % センサで取ったドローンの位置
            sensor_drone = obj.drone(1).sensor.motive.motive.result.rigid; % センサで取った鳥の全部の位置

            id = obj.self.sensor.motive.rigid_num;
            N = Param{1};
            Nb = Param{2};

            %% センシング領域を定義
            obj.r = 0.5:0.1:2;
            [X,Y,Z] = cylinder(obj.r,100);
            Z = Z * obj.d;
            sensor_range = {X,Y,Z};
            
            %% 鳥の位置を取得
            for i = 1:N
                result.drone_pos(:,i) = sensor_drone(i).p;
            end
            for j = 1:Nb
                result.bird_pos(:,j) = sensor(j).p;
            end
            obj.result = result;
        end

        function show(obj,verargin)
        end
    end
end

