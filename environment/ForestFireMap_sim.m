classdef ForestFireMap_sim < ENV_CLASS 
    % 環境設定
    % 用語
    % Map ：(N+2)×(N+2)の離散マップ
    %
    % Properties
    % param : a structure consists of following field
    %         v1
    %         v2
    %         w %Humidity（High value:Hard to burning / Low value:easy to burning）
    %         d %Forest divercity（High value:Burning rapidly / Low value:Burning Slowly）
    %         N %Space is divided N * N cells
    %         Threshold %[T1 T2 T3 T4] 
    %         (T1<=v<T2)Not burning
    %         (T2<=v<T3)burning 
    %         (T3<=v<T4)burning wildly
    %         (v=T4)burn out 
    %         Map %全体のマップ情報
    %         Map_Agent %各エージェントが持つマップ
    %         Color_Map %描画用のカラーマップ
    %         Color_Map_Agent %各エージェントが持つ描画用のカラーマップ
properties
        name % 例：bldg1
        id % 例：
        param
%         result
    end
    methods
        function obj = ForestFireMap_sim(~,param)
            obj.param=param;
            % このクラスのインスタンスを作成
            obj.name = param.name;
            obj.id = obj.param.id;
            obj.param.Nx=(numel(obj.param.map_min(1):obj.param.D:obj.param.map_max(1)));
            obj.param.Ny=(numel(obj.param.map_min(2):obj.param.D:obj.param.map_max(2)));
            [obj.param.MapX,obj.param.MapY]=meshgrid(obj.param.map_min(1)-obj.param.D:+obj.param.D:obj.param.map_max(1)+obj.param.D,...
                                                     obj.param.map_max(2)+obj.param.D:-obj.param.D:obj.param.map_min(2)-obj.param.D);
            if obj.id == 0

                v=obj.param.v1+(obj.param.v2-obj.param.v1)*rand(obj.param.Ny+2,obj.param.Nx+2);

                obj.param.Map=v;
                obj.param.Map(49:51,49:51)=30;
                obj.param.Map(1,:)=0;
                obj.param.Map(obj.param.Ny+2,:)=0;
                obj.param.Map(:,1)=0;
                obj.param.Map(:,obj.param.Nx+2)=0;

                hogehoge=obj.param.Map==0;
                map=obj.param.Map - obj.param.Map.*hogehoge;
                hoge1=map>=obj.param.Threshold(4);
                hoge2=map>=obj.param.Threshold(3);
                hoge3=map>=obj.param.Threshold(2);
                hoge4=map>=obj.param.Threshold(1);
                hoge5= map>=0 & map<obj.param.Threshold(1);
                obj.param.Color_Map=hoge1+hoge2+hoge3+hoge4+5*hoge5;
            else
                obj.param.Map_agent=zeros(obj.param.Ny+2,obj.param.Nx+2);
                obj.param.Color_Map_agent=zeros(obj.param.Ny+2,obj.param.Nx+2);
            end
        end

        function result = do(obj,varargin)
            if isempty(varargin) %グローバルマップの更新
            %Wheb v >= threshold(2), v increace constantly.  
            hoge=obj.param.Map>=obj.param.Threshold(2);
            obj.param.Map=obj.param.Map+ hoge.*rand(obj.param.Ny+2,obj.param.Nx+2);

            %When v >= threshold(4), v = 0.
            hogehoge=obj.param.Map>=obj.param.Threshold(4);
            obj.param.Map=obj.param.Map - obj.param.Map.*hogehoge;

            %calculate average of neighbor cells (around 8 cells) 
            Map_1 = circshift(obj.param.Map,[0 obj.param.Nx+1]);
            Map_2 = circshift(obj.param.Map,[obj.param.Ny+1 0]);
            Map_3 = circshift(obj.param.Map,[0 1]);
            Map_4 = circshift(obj.param.Map,[1 0]);
            Map_5 = circshift(obj.param.Map,[1 obj.param.Nx+1]);
            Map_6 = circshift(obj.param.Map,[obj.param.Ny+1 1]);
            Map_7 = circshift(obj.param.Map,[1 1]);
            Map_8 = circshift(obj.param.Map,[obj.param.Ny+1 obj.param.Nx+1]);    
            nighbor = (Map_1+Map_2+Map_3+Map_4+Map_5+Map_6+Map_7+Map_8)./8;

            E = nighbor - obj.param.Map;

            Tobihi = obj.param.sigma.*randn(obj.param.Ny+2,obj.param.Nx+2)+obj.param.mu;
            hogehogehoge = Tobihi>=1.0000;
            Tobihi = hogehogehoge*obj.param.Threshold(2);

            %Map update
            result.ReMap = obj.param.Map + ((obj.param.d/obj.param.w)*((1+exp(-0.5*(E-15))).^-1)).*rand(obj.param.Ny+2,obj.param.Nx+2) + Tobihi;

            %When v = 0, v doesn't increase.
            hogehoge=obj.param.Map==0;
            result.ReMap=result.ReMap - result.ReMap.*hogehoge;

            hoge1=result.ReMap>=obj.param.Threshold(4);
            hoge2=result.ReMap>=obj.param.Threshold(3);
            hoge3=result.ReMap>=obj.param.Threshold(2);
            hoge4=result.ReMap>=obj.param.Threshold(1);
            hoge5=result.ReMap>=0 & result.ReMap<obj.param.Threshold(1);
            result.ReColor_Map=hoge1+hoge2+hoge3+hoge4+5*hoge5;
            
            obj.param.Map=result.ReMap;
            obj.param.Color_Map=result.ReColor_Map;
            
            else %エージェントが持つローカルマップの更新
                %varargin{1,1}{1,1} マップのセンサ情報
                %varargin{1,2}      状態推定値
                %obj.param          エージェントが持つローカルマップ
                obj.param.Map_agent(obj.param.MapX <= round(varargin{1,2}.state.p(1)) + 10 &...
                                    obj.param.MapX >= round(varargin{1,2}.state.p(1)) - 10 &...
                                    obj.param.MapY <= round(varargin{1,2}.state.p(2)) + 10 &...
                                    obj.param.MapY >= round(varargin{1,2}.state.p(2)) - 10)=varargin{1,1}{1,1}.Map_agent;
                                
                obj.param.Color_Map_agent(obj.param.MapX <= round(varargin{1,2}.state.p(1)) + 10 &...
                                          obj.param.MapX >= round(varargin{1,2}.state.p(1)) - 10 &...
                                          obj.param.MapY <= round(varargin{1,2}.state.p(2)) + 10 &...
                                          obj.param.MapY >= round(varargin{1,2}.state.p(2)) - 10)=varargin{1,1}{1,1}.Color_Map_agent;
                                      
                 result.Map_agent=obj.param.Map_agent;
                 result.Color_Map_agent=obj.param.Color_Map_agent;
            end
        end
        function [] = show(obj)
            figure(2)
            target=figure(2);
            mymap=[0 1 0;1 1 0;1 0 0;0.5 0.5 0.5;0.5 0.5 0.5]; %[Green;Yellow;Red;Black;Black]
            cmin=1;
            cmax=5;
            caxis([cmin cmax]);
            pcolor(obj.param.MapX,obj.param.MapY,obj.param.Color_Map);
            colormap(target,mymap);
            obj.show_setting();
        end
        function [] = show_setting(obj)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('\it x \rm [m]');
            ylabel('\it y \rm [m]');
            xlim([obj.param.map_min(1) obj.param.map_max(2)]);
            ylim([obj.param.map_min(2) obj.param.map_max(2)]);
            view(0, 90);
        end
    end
end
