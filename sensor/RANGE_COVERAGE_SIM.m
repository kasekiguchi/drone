classdef RANGE_COVERAGE_SIM < SENSOR_CLASS
    %RANGE_COVERAGE_SIM このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサを積んでいる機体のhandle object
        r % センサの半径
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
            state = obj.self.plant.state; % 真値
            env = Env.Vertices;

            %% センシング領域を定義
            obj.r = 0.5:0.1:2;
            [X,Y,Z] = cylinder(obj.r,100);
            Z = Z * obj.d;
            surf(X,Y,Z)
        end
    end
end

