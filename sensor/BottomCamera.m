classdef BottomCamera < SENSOR_CLASS
    % simulation用クラス：状態をそのまま返す
    properties
        name = "BottomCamera";
        interface = @(x) x;
        result
        self
        param
    end
    methods
        function obj = BottomCamera(self,param)
            obj.self=self;
            obj.param=param;
        end
        function result = do(obj,FireMap)
            % 【入力】Target ：観測対象のModel_objのリスト
            tyome(:,:) = FireMap{1,1}.env.firemap.param.MapX <= round(obj.self.state.p(1)) + obj.param{1,1}.Range(1,2) &...
                         FireMap{1,1}.env.firemap.param.MapX >= round(obj.self.state.p(1)) + obj.param{1,1}.Range(1,1) &...
                         FireMap{1,1}.env.firemap.param.MapY <= round(obj.self.state.p(2)) + obj.param{1,1}.Range(2,2) &...
                         FireMap{1,1}.env.firemap.param.MapY >= round(obj.self.state.p(2)) + obj.param{1,1}.Range(2,1);

            tyometyometyome2=FireMap{1,1}.env.firemap.param.Color_Map.*tyome(:,:);
            tyometyometyome2(:,sum(tyometyometyome2)==0)=[];
            tyometyometyome2(sum(tyometyometyome2,2)==0,:)=[];
%             
            [sizey,sizex]=size(tyometyometyome2);
            
            if rem(find(tyome,1),(obj.self.env.firemap.param.Ny+2))~=0
                xs=fix(find(tyome,1)/(obj.self.env.firemap.param.Ny+2))+1;
            else
                xs=fix(find(tyome,1)/(obj.self.env.firemap.param.Ny+2));
            end
            xe=xs+sizex-1;
            ys=find(tyome,1)-(obj.self.env.firemap.param.Ny+2)*(xs-1);
            ye=ys+sizey-1;
            
            result.Map_agent = FireMap{1,1}.env.firemap.param.Map(ys:ye,xs:xe);
            result.Color_Map_agent = FireMap{1,1}.env.firemap.param.Color_Map(ys:ye,xs:xe);
            obj.result.Map_agent = FireMap{1,1}.env.firemap.param.Map(ys:ye,xs:xe);
            obj.result.Color_Map_agent = FireMap{1,1}.env.firemap.param.Color_Map(ys:ye,xs:xe);
        end
        function show(obj)
            if ~isempty(obj.result)
            figure(2)
            target=figure(2);
            [sizex,sizey] = size(obj.result.Color_Map_agent);
            hoge=obj.result.Color_Map_agent;
            hoge(:,end+1)=zeros(sizey,1);
            hoge(1:6,end)=[0;1;2;3;4;5];
            [X,Y]=meshgrid(1:sizex+1,1:sizey);
            mymap=[0.5 0.5 0.5;0 1 0;1 1 0;1 0 0;0.5 0.5 0.5;0.5 0.5 0.5]; %[Black;Green;Yellow;Red;Black;Black]
            cmin=0;
            cmax=5;
            caxis([cmin cmax]);
            pcolor(X,Y,hoge);
            colormap(target,mymap);
            obj.show_setting(sizex,sizey);
            else
                disp("do measure first.");
            end
        end
        function [] = show_setting(obj,sizex,sizey)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('\it x \rm [m]');
            ylabel('\it y \rm [m]');
            xlim([1 sizex]);
            ylim([1 sizey]);
            view(0, 90);
        end
    end
end
