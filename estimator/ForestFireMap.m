classdef ForestFireMap < ESTIMATOR_CLASS
    % 環境設定
    % 用語
    %
    % Properties
    % param : a structure consists of following field
    % result: estimation result
properties
%         name % 例：bldg1
%         id % 例：
        param
        result
        self
    end
    methods
        function obj = ForestFireMap(self,param)
            obj.self = self;
            obj.param=param;
            % このクラスのインスタンスを作成
            obj.param{1,1}.Nx=(numel(obj.param{1,1}.map_min(1):obj.param{1,1}.D:obj.param{1,1}.map_max(1)));
            obj.param{1,1}.Ny=(numel(obj.param{1,1}.map_min(2):obj.param{1,1}.D:obj.param{1,1}.map_max(2)));
            [obj.param{1,1}.MapX,obj.param{1,1}.MapY]=meshgrid(obj.param{1,1}.map_min(1)-obj.param{1,1}.D:+obj.param{1,1}.D:obj.param{1,1}.map_max(1)+obj.param{1,1}.D,...
                                                               obj.param{1,1}.map_max(2)+obj.param{1,1}.D:-obj.param{1,1}.D:obj.param{1,1}.map_min(2)-obj.param{1,1}.D);
            obj.param{1,1}.Map_agent=zeros(obj.param{1,1}.Ny+2,obj.param{1,1}.Nx+2);
            obj.param{1,1}.Color_Map_agent=zeros(obj.param{1,1}.Ny+2,obj.param{1,1}.Nx+2);
        end

        function result = do(obj,varargin)
            obj.param{1,1}.Map_agent(obj.param{1,1}.MapX <= round(varargin{1,2}.state.p(1)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(1,2) &...
                                     obj.param{1,1}.MapX >= round(varargin{1,2}.state.p(1)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(1,1) &...
                                     obj.param{1,1}.MapY <= round(varargin{1,2}.state.p(2)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(2,2) &...
                                     obj.param{1,1}.MapY >= round(varargin{1,2}.state.p(2)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(2,1))=varargin{1,1}{1,1}.result.Map_agent;

            obj.param{1,1}.Color_Map_agent(obj.param{1,1}.MapX <= round(varargin{1,2}.state.p(1)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(1,2) &...
                                           obj.param{1,1}.MapX >= round(varargin{1,2}.state.p(1)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(1,1) &...
                                           obj.param{1,1}.MapY <= round(varargin{1,2}.state.p(2)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(2,2) &...
                                           obj.param{1,1}.MapY >= round(varargin{1,2}.state.p(2)) + varargin{1,1}{1,1}.Observation.param{1,1}.Range(2,1))=varargin{1,1}{1,1}.result.Color_Map_agent;
                                      
            result.Map_agent=obj.param{1,1}.Map_agent;
            result.Color_Map_agent=obj.param{1,1}.Color_Map_agent;
        end
        function [] = show(obj,varargin)
            if ~isempty(varargin)
                figure(2)
                target=figure(2);
                mymap=[0.5 0.5 0.5;0 1 0;1 1 0;1 0 0;0.5 0.5 0.5;0.5 0.5 0.5]; %[Black;Green;Yellow;Red;Black;Black]
                cmin=0;
                cmax=5;
                caxis([cmin cmax]);
                obj.param{1,1}.Color_Map_agent(1:6,obj.param{1,1}.Nx+1)=[0;1;2;3;4;5];
                pcolor(obj.param{1,1}.MapX,obj.param{1,1}.MapY,obj.param{1,1}.Color_Map_agent);
                hold on
                plot(varargin{1,1}.estimator.result.state.p(1),varargin{1,1}.estimator.result.state.p(1),'.b','MarkerSize',20)
                hold off
                colormap(target,mymap);
                obj.show_setting();
            else
                disp('do estimate first.')
            end
            
        end
        function [] = show_setting(obj)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('\it x \rm [m]');
            ylabel('\it y \rm [m]');
            xlim([obj.param{1,1}.map_min(1) obj.param{1,1}.map_max(2)]);
            ylim([obj.param{1,1}.map_min(2) obj.param{1,1}.map_max(2)]);
            view(0, 90);
        end
    end
end
