classdef IMAGE_BOUNDING_BOX_SIM < SENSOR_CLASS
    %IMAGE_BOUNDING_BOX_SIM このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサを積んでいる機体のhandle object
        time
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
            obj.time = t;
            result.env = polyshape(2*[-1 -1 1 1],2*[1 -1 -1 1]);
            
            result.polyin = polyshape([0 0 1 1],[1 0 0 1]);
            result.polyout = translate(result.polyin,obj.d*[cos(t),sin(t)]);
            result.poly = intersect(result.env,result.polyout);

            obj.result = result;
        end

        function show(obj,~)
            hold on
            daspect([1 1 1]);
            ax = gca;
            ax.Box = 'on';
            ax.GridColor = 'k';
            ax.GridAlpha = 0.4;
            xlim([-3,3]);
            ylim([-3,3]);
            xlabel('Position {\it x} [m]');
            ylabel('Position {\it y} [m]');

            plot(obj.result.env,'FaceColor','none')
            plot(obj.result.polyin)
            plot(obj.result.poly)
        end

        function movie(obj,logger)
            cd('Data');
            figure(2)
            t = 1;
            v = VideoWriter('bounding_movie','MPEG-4');
            v.Quality = 100;
            open(v);
            while t<numel(logger.Data.t)
                clf(figure(2))
                disp('.');

                hold on
                daspect([1 1 1]);
                ax = gca;
                ax.Box = 'on';
                ax.GridColor = 'k';
                ax.GridAlpha = 0.4;
                xlim([-3,3]);
                ylim([-3,3]);
                xlabel('Position {\it x} [m]');
                ylabel('Position {\it y} [m]');

                plot(logger.Data.agent(1).sensor.result{t}.env,'FaceColor','none')
                plot(logger.Data.agent(1).sensor.result{t}.polyin)
                plot(logger.Data.agent(1).sensor.result{t}.poly)
                hold off
                t = t + 1;
                frame = getframe(figure(2));
                writeVideo(v,frame);
            end
            close(v);
        end
    end
end

