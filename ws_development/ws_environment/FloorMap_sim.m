classdef FloorMap_sim < ENV_CLASS
    %make room
    properties
        name % 萓具シ喘ldg1
        id
        param
    end
    methods
        function obj = FloorMap_sim(~,param)
            obj.param=param;
            % 縺薙?ョ繧ッ繝ゥ繧ケ縺ョ繧、繝ウ繧ケ繧ソ繝ウ繧ケ繧剃ス懈??
            obj.name = param.name;
%             if ~strcmp(obj.name,"none")
%                 %obj.Vertex=obj.param.Vertex;
%                 if isfield(obj.param,'sigma')
%                     density_sigma=obj.param.sigma;
%                 else
%                     density_sigma=0.04;
%                     obj.param.sigma=0.04;
%                 end
%                 %[obj.grid_density,obj.map_max,obj.map_min,obj.xq,obj.yq,obj.phi]=gen_map(Vertex,d,density_pos,density_sigma);
%                 [obj.param.grid_density,obj.param.map_max,obj.param.map_min,obj.param.xq,obj.param.yq]=gen_map(obj.param.Vertices,obj.param.d,obj.param.q,density_sigma);
%                 %obj.d=obj.param.d;
%                 obj.param.discrete=1;
%                 obj.param.grid_row=length(obj.param.map_min(1):obj.param.d:obj.param.map_max(1));
%                 obj.param.grid_col=length(obj.param.map_min(2):obj.param.d:obj.param.map_max(2));
%                 obj.param.grid_n = obj.param.grid_row*obj.param.grid_col;%length(obj.row)*length(obj.col);
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

