classdef Drone < ABSTRACT_SYSTEM
    % Drone class
    properties %(Access = private)
        %id = 0;
        fig
    end
    methods
        function obj = Drone(varargin)
            obj=obj@ABSTRACT_SYSTEM({varargin});
            % このクラスのインスタンスを作成
            %   詳細説明をここに記述
                        %% ドローンのフレーム
            % propeller
            [px,py,pz]=cylinder(0.06); % 半径0.2の円柱
            prop = patch('XData',px(1,:)','YData',py(1,:)','ZData',pz(1,:)'); %  半径0.2の円柱
            l1=length(prop.Vertices(:,1)); % 円柱の頂点の数
            L = 0.1;% motor 間の距離/2
            H = 0.5;
            p1 = L*[1 1 H];
            p2 = L*[-1 1 H];
            p3 = L*[-1 -1 H];
            p4 = L*[1 -1 H];
            Prop.Vertices = [prop.Vertices+p1;[0 0 0];prop.Vertices+p2;[0 0 0];prop.Vertices+p3;[0 0 0];prop.Vertices+p4];
            Prop.Faces=[prop.Faces;prop.Faces+l1+1;prop.Faces+2*(l1+1);prop.Faces+3*(l1+1)];
            Prop.FaceVertexCData=ones(length(Prop.Faces(:,1)),1);
            
            % body
            pvnum = 0;%length(Frame.Vertices(:,1));
            Frame.Vertices = [p1;p1.*[1 1 0];p3.*[1 1 0];p3;0 0 0;p2;p2.*[1 1 0];p4.*[1 1 0];p4];
            pfnum = 0;%length(Frame.Faces(1,:));
            Frame.Faces = [pvnum+[1 2 3 4 NaN(1,pfnum-4)];pvnum+5+[1 2 3 4 NaN(1,pfnum-4)]];
            Frame.FaceVertexCData=zeros(length(Frame.Vertices),1);
            obj.fig = [Prop;Frame];

        end
    end
    methods
        function show(obj)
            %rad = norm(rot);
            %dir = rot/rad;
            if isprop(obj.state,'q')
                pp =patch(obj.fig(1),'FaceAlpha',0.3);
                pf =patch(obj.fig(2),'EdgeColor','flat','FaceColor','none','LineWidth',0.2);
                
                pobj=[pp;pf];
                for i = 1:length(pobj)
                    pobj(i).Vertices = (obj.state.getq('rotmat')*pobj(i).Vertices')'+obj.state.p';
                end
                %rotate(obj,dir,180*rad/pi,orig+trans);
            end
        end
    end
end
