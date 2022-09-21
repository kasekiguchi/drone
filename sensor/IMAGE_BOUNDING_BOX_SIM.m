classdef IMAGE_BOUNDING_BOX_SIM < SENSOR_CLASS
    %IMAGE_BOUNDING_BOX_SIM このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサを積んでいる機体のhandle object
    end
    properties (SetAccess = private) % constructしたら変えない値
        d = 5; % センサの測定距離
    end
    
    methods
        function obj = IMAGE_BOUNDING_BOX_SIM(self,param)
            obj.self = self;
            obj.d = param.d;
        end
        
        function result = do(obj,param)
            % result=rcoverage_3D.do(varargin) : obj.r 内のdensity mapを返す．
            % result.state : State_obj,  p : position   q : quaternion
            state = obj.self.plant.state; % 真値
            t = param{1}.t;
            result.env = polyshape(2*[-1 -1 1 1],2*[1 -1 -1 1]);
            
            result.polyin = polyshape([0 0 1 1],[1 0 0 1]);
            result.polyout = translate(result.polyin,obj.d*[cos(t),sin(t)]);
            result.poly = intersect(result.env,result.polyout);

            obj.result = result;
        end

        function show(obj,~)
            axis equal
            xlim([-3,3]);
            ylim([-3,3]);
            hold on
            plot(obj.result.env,'FaceColor','none')
            plot(obj.result.polyin)
            plot(obj.result.poly)
        end
    end
end

