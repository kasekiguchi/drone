classdef FloorMap_sim < ENV_CLASS
    %make room
    properties
        name % 
        id
        param
    end
    methods
        function obj = FloorMap_sim(~,param)
            obj.param=param;
            % 
            obj.name = param.name;
%             end
        end
        function [] = show(obj,varargin)
            %s=surf(1:obj.grid_row,1:obj.grid_col,obj.grid_density);
            %s.VertexColor = 'none';
            %pcolor(obj.param.xq,obj.param.yq,obj.param.grid_density);
            contourf(obj.param.xq,obj.param.yq,obj.param.grid_density);
            %            surf(obj.param.xq,obj.param.yq,obj.param.grid_density);
            obj.show_setting();
        end
        function [] = show_setting(obj)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('x [m]');
            ylabel('y [m]');
            xlim([obj.param.map_min(1) obj.param.map_max(1)]);
            ylim([obj.param.map_min(2) obj.param.map_max(2)]);
            view(0, 90);
            cmap=[[1 1 1];parula];
            colormap(cmap)
            colorbar
            %caxis([-50 255])
            grid on;
        end
    end
end

