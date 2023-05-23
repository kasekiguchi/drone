classdef ENV_CLASS_3D < handle & matlab.mixin.SetGet
    % 環境設定
    properties
        name % 例：bldg1
        id % 例：
        node % 行がnode id ，列が各nodeの座標
        surface % 各行が一つの面を表す．列が面を構成するnode id 列
        param % parameters
        graph
        ns = 1; % number of surface cell
    end
    methods
        function obj = ENV_CLASS_3D(name,id,node,surface)
            % このクラスのインスタンスを作成
            obj.name = name;
            obj.id = id;
            obj.node=node;
            obj.surface=surface;
            NodeX = obj.node(:,1);
            NodeY = obj.node(:,2);
            NodeZ = obj.node(:,3);
            NodeTable = table(string(1:length(node))',NodeX,NodeY,NodeZ,'VariableNames',{'Name','X','Y','Z'});
            if class(surface)=='cell'
                obj.ns = length(surface);
                nE=0;
                for i =1:obj.ns
                    nE = nE+prod(size(surface{i}));
                end
                Edges=zeros(nE,2);
                nE=0;
                for i = 1:obj.ns
                    Si = surface{i};
                    for j = 1:size(Si,2)-1
                        Edges(nE+size(Si,1)*(j-1)+1:nE+size(Si,1)*j,:)=Si(:,j:j+1);
                    end
                    Edges(nE+size(Si,1)*j+1:nE+size(Si,1)*(j+1),:)=[Si(:,j+1) Si(:,1)];
                    nE=nE+size(Si,1)*(j+1);
                end
            else
                Edges=zeros(size(surface,1)*size(surface,2),2);
                for i = 1:size(surface,2)-1
                    Edges(size(surface,1)*(i-1)+1:size(surface,1)*i,:)=surface(:,i:i+1);
                end
                Edges(size(surface,1)*i+1:size(surface,1)*(i+1),:)=[surface(:,i+1) surface(:,1)];
            end
            EdgeTable = table(Edges,'VariableNames',{'EndNodes'});
            obj.graph=graph(EdgeTable,NodeTable);
            if ismultigraph(obj.graph)
                obj.graph = simplify(obj.graph);
            end
        end
        function [] = draw(obj)
            NodeX = obj.node(:,1);
            NodeY = obj.node(:,2);
            NodeZ = obj.node(:,3);
            for i=1:obj.ns
                SurfaceX=NodeX(obj.surface{i}');
                SurfaceY=NodeY(obj.surface{i}');
                SurfaceZ=NodeZ(obj.surface{i}');
                rng(i);
                fill3(SurfaceX,SurfaceY,SurfaceZ,rand*ones(size(SurfaceX)),'FaceAlpha',.3,'EdgeAlpha',1);%,'FaceColor','b'
                hold on;
            end
            daspect([1 1 1]);
            grid on;
        end
        function [] = draw_full(obj)
            obj.draw()
            plot(obj.graph,'XData',obj.node(:,1),'YData',obj.node(:,2),'ZData',obj.node(:,3))
        end
    end
end

