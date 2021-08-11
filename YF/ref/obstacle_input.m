classdef obstacle_input < REFERENCE_CLASS
    %EXAMPLE_WAYPOINT このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        param
        xd
        areas
        coef
        ret
        num_slope
        random
        self
        BV
        separateu
    end
    
    methods
        function obj = obstacle_input(varargin)
                        obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));

        end
        
        function result= do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = Param{4};
            state =  Param{1}.state;
            %             agent_v = Param{1}.state.v;
            N = Param{3};
            gather = zeros(2,length(N));%引力
            pre_info = Param{5}.save.agent;
            count = Param{5}.main_roop_count;
            %歩行速度ゲイン
            v_k = 1.0;
            dt = Param{5}.dt;
           
            agent_input = [0;0];
            obj.self.input = agent_input;
            obj.result.state.u = [agent_input];
            result = obj.result;
            
        end
        function show(obj,param)
            %             draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
        function make_map(flag,obj,other_state,num)
            grid_x =-1:0.5:20;
            grid_y =  -2:0.5:15;
            [GX,GY] = meshgrid(grid_x,grid_y);%%χ
            [sizeX,~]=size(GX);
            [~,sizeY]=size(GY);
            map = zeros(sizeX,sizeY);
            Vp = zeros(1,obj.num_slope);
            N = length(other_state);
            if flag%マップ保存用
                for k=1:sizeX
                    for j=1:sizeY
                        xm = GX(k,j);
                        ym = GY(k,j);
                        Vp = zeros(1,obj.num_slope);
                        aaa=0;
                        for i=1:N
                            if i~=num
                                aaa =aaa +1/norm([xm;ym]-other_state{i}(1:2));
                            end
                        end
                        for i = 1:obj.num_slope
                            Vp(i) = 0.05*Cov_slope(xm,ym,obj.coef{i}(1),obj.coef{i}(2),obj.coef{i}(3),obj.areas{i}(1,1),obj.areas{i}(3,1),obj.areas{i}(1,2),obj.areas{i}(3,2));
                        end
                        
                        min_Vp = min(Vp);
                        if min_Vp >15
                            min_Vp =15;
                        end
                        map(k,j) = min_Vp;
                    end
                end
%                                         figure;  surf(GX,GY,map,'EdgeColor','none');
                mapmax =max(max(map));
                obj.result.map = map./mapmax;
                if num==1
%                     figure
%                     hold on
%                     contour(GX,GY,obj.result.map)
% %                     scatter(node.point(1,:),node.point(2,:))
%                     hold off
                end
            end
        end
    end
end

