classdef slope_input < REFERENCE_CLASS
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
        function obj = slope_input(varargin)
            refP = varargin{2}{1};
            select_probability = varargin{2}{2};
            obj.param = {[refP],[select_probability]};
            obj.xd = human_plobable_refarence(refP,select_probability);%基底の目標位置からランダムに選択
            %             numberofagent = varargin{2}{3};
            %             if numberofagent==1
            % obj.xd = [9;-2];
            %             elseif numberofagent==3
            %                 obj.xd = [0.5;9];
            %             elseif numberofagent==2
            %                 obj.xd = [0.5;0];
            %             else
            %                 obj.xd = [0.5;1];
            %             end
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
            obj.areas = varargin{2}{4}.vertices;%歩行環境をセルで格納
            [Pw,Coef] = create_slope_potential(obj.areas,obj.xd');
            obj.coef = Coef;%各領域の傾きを算出
            obj.ret = Pw;
            obj.num_slope = length(obj.areas);
            obj.random = randn;
        end
        
        function result= do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = Param{4};
            state =  Param{1}.state;
            %             agent_v = Param{1}.state.v;
            TheNumber = cell2mat(Param{3});
            N = TheNumber(1);
            Nh = TheNumber(2);
            Nob = TheNumber(3);
            count = Param{5}.main_roop_count;
            dt = Param{5}.dt;
            xxd = cell(1,Nh);
            OtherAgentState = cell(1,Nh);
            parfor i=1:Nh
                xxd{i} = Param{6}(i).reference.slope.xd;
                OtherAgentState{1,i}=[Param{6}(i).plant.state.p;Param{6}(i).plant.state.v;Param{6}(i).plant.state.a];
            end
            ObstacleState = cell(1,Nob);
            parfor i = 1:Nob
                ObstacleState{i} = [Param{6}(i+Nh).plant.state.p];
            end
            %通路の最大最小
            env = Param{2}.huma_load.param;
            %%%%%%ここまでで初期化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            result = arrayfun(@(i) Cov_distance(state.p(1:2),OtherAgentState{i}(1:2),1),1:Nh);%Calclate distance between human and other one.
            tmp = struct2cell(result);
            %人本体間の距離計算
            disi2j = cell2mat(tmp);
            
            %% 障害物と人の距離
            result = arrayfun(@(i) Cov_distance(state.p(1:2),ObstacleState{i}(1:2),1),1:Nob);%Calclate distance between obstacle and other one.
            tmp = struct2cell(result);
            %人本体間の距離計算
            disi2ob = cell2mat(tmp);
            %% 最小射影法
            %%%%%%%  Start to algorithm %%%%%%%%%%%%
            x = state.p(1);
            y = state.p(2);
            %%ここが重すぎ,最小射影の計算
            env.coeficient = obj.coef;
            id = minimum_slope(env,x,y,obj);
            u = -1*[Cov_diffx_slope(x,y,obj.coef{id}(1),obj.coef{id}(2),obj.coef{id}(3),obj.ret{id}(1,1),obj.ret{id}(3,1),obj.ret{id}(1,2),obj.ret{id}(3,2));...
                Cov_diffy_slope(x,y,obj.coef{id}(1),obj.coef{id}(2),obj.coef{id}(3),obj.ret{id}(1,1),obj.ret{id}(3,1),obj.ret{id}(1,2),obj.ret{id}(3,2))];
            %slopeの微分値を入力として算出
            input = u;
            
            % 自分と他者の距離計算
            result = arrayfun(@(i) Cov_distance(OtherAgentState{i}(1:2),state.p(1:2),1),1:Nh);
            tmp = struct2cell(result);
            dis = cell2mat(tmp);
            %視野角を算出
            ViewLength = 10;
            ViewWidthTheta = 100;
            AvoidWidthTheta = 10;
            [Avoid_range,~,LViewRange,ViewRange] = Cov_view_range(state.p,state.v,AvoidWidthTheta,env,ViewLength,num,OtherAgentState,ViewWidthTheta);
                        %障害物用の視野角を算出
            ViewLength = 10;
            ViewWidthTheta = 10;
            AvoidWidthTheta = 10;
            [~,~,LObViewRange,ObViewRange] = Cov_view_range(state.p,state.v,AvoidWidthTheta,env,ViewLength,num,ObstacleState,ViewWidthTheta);
            LViewRange = intersect(LViewRange,LObViewRange);
            in_flontAvoid = zeros(1,Nh);
            in_flontViewRange = zeros(1,Nh);
            parfor i= 1:Nh
                %前にいて特定の距離以内の個体をカウント
                if isinterior(Avoid_range,OtherAgentState{i}(1),OtherAgentState{i}(2))&&i~=num
                    in_flontAvoid(i) = isinterior(Avoid_range,OtherAgentState{i}(1),OtherAgentState{i}(2));
                end
                if isinterior(ViewRange,OtherAgentState{i}(1),OtherAgentState{i}(2))&&i~=num
                    in_flontViewRange(i) = isinterior(ViewRange,OtherAgentState{i}(1),OtherAgentState{i}(2));
                end
            end
            in_flontObject = zeros(1,Nob);
            parfor i= 1:Nob
                %前にいて特定の距離以内の障害物をカウント
                if isinterior(ObViewRange,ObstacleState{i}(1),ObstacleState{i}(2))
                    in_flontObject(i) = isinterior(ObViewRange,ObstacleState{i}(1),ObstacleState{i}(2));
                end
            end
            if area(LViewRange)==0
                density = 10;
            else
                density = sum(in_flontViewRange,2)/area(LViewRange);
            end
            if density >5
                v_k = 0.1;
            else
                v_k = 0.0013*density^3+0.025*density^2-0.3143*density+0.9;
            end
            %             v_k=0.5;
            %相対速度の計算
            Rerativevi2vj = cell2mat(arrayfun(@(i) OtherAgentState{i}(3:4)-state.v(1:2),1:Nh,'uniformoutput',false));
            tmppp = cell2mat(arrayfun(@(i) disi2j(2:3,:,i),1:Nh,'uniformoutput',false));
            Vdotdis = dot(Rerativevi2vj,tmppp);
            FT_Avoid = zeros(1,Nh);
            parfor i=1:Nh
                %視野角内か自分と同じ方向に動いていないものをカウント
                if in_flontAvoid(i)==1&&num~=i&&Vdotdis(i)>0
                    FT_Avoid(i) = 1;
                else
                    FT_Avoid(i) = 0;
                end
            end
            %相対速度，前にいるかつ自分より遅い判定，個体間距離の合算
            RerativeFT_AvoidDis = [Rerativevi2vj;FT_Avoid;reshape(dis,[3,Nh])];
            DisMinAgentRerative = [num;inf;inf];
            for i=1:Nh
                %視野角内かつ相対速度が自分より遅いものを選別
                if (RerativeFT_AvoidDis(3,i)==1&&i~=num)&&DisMinAgentRerative(2,1)>RerativeFT_AvoidDis(2,1)
                    DisMinAgentRerative = [i;RerativeFT_AvoidDis(1:2,i)];
                else
                    DisMinAgentRerative = [num;inf;inf];
                end
            end
            %注視点の距離を変化させるための関数
            VP = 1.;
            %一点注視店の初期化，とりあえず自己位置に作成．
            viewpoint = cell(1,Nh);
            F = zeros(3,Nh);
            %注視点の初期化．自己位置を代入している．
            ref_point = arrayfun(@(i) eye(length(OtherAgentState{i}))*OtherAgentState{i},1:Nh,'uniformoutput',false);
            if count~=1
                ObstacleAvoidPotential = cell2mat(arrayfun(@(i) [Cov_diffx_Agent2ObstaclePotential(state.p(1),state.p(2),ObstacleState{i}(1),ObstacleState{i}(2));Cov_diffy_Agent2ObstaclePotential(state.p(1),state.p(2),ObstacleState{i}(1),ObstacleState{i}(2))],1:Nob,'UniformOutput',false));
                parfor i=1:Nh
                    %遠心力の計算
                    if i~=num
                        F(:,i) = cross([0;0;1],[dis(2,:,i);dis(3,:,i);0]);
                        F(:,i) = F(:,i)/norm(F(:,i));
                    end
                    if i==num
                        %i番目の個体の仮注視点をV_kｍ前に作成．
                        viewpoint{i} = OtherAgentState{i}(1:2)+v_k*eye(2)*[input/norm(input)];
                        ref_point{i} = viewpoint{i}(1:2);
                    else
                        %その他個体の注視点を作成
                        viewpoint{i} = OtherAgentState{i}(1:2)+VP*eye(2)*OtherAgentState{i}(3:4)/norm(OtherAgentState{i}(3:4));
                        ref_point{i} = viewpoint{i}(1:2);
                    end
                end
                %障害物中心でかかる遠心力
                parfor i=1:Nob
                    %遠心力の計算
                        obF(:,i) = cross([0;0;1],[disi2ob(2,:,i);disi2ob(3,:,i);0]);
                        obF(:,i) = obF(:,i)/norm(obF(:,i));
                 end
                %注視点の間の距離を算出
                result = arrayfun(@(i) Cov_distance(viewpoint{num}(1:2),viewpoint{i}(1:2),1),1:Nh);%Calclate distance between human and other one.
                tmp = struct2cell(result);
                disVi2V = cell2mat(tmp);
                %注視点とその他個体の距離を算出
                result = arrayfun(@(i) Cov_distance(viewpoint{num}(1:2),OtherAgentState{i}(1:2),1),1:Nh);%Calclate distance between human and other one.
                tmp = struct2cell(result);
                disVi2other = cell2mat(tmp);
                %i番目の注視点と注視点の反力ポテンシャル
                ithViewPoint_separate_ViewPoint = cell2mat(arrayfun(@(i) [disVi2V(2:3,:,i)]/(sqrt(disVi2V(2,:,i)^2+disVi2V(3,:,i)^2)^3),1:Nh,'UniformOutput',false));
                %i番目の注視点とその他個体の反力ポテンシャル
                ithViewPoint_separate_OtherAgent = cell2mat(arrayfun(@(i) [disVi2other(2:3,:,i)]/(sqrt(disVi2other(2,:,i)^2+disVi2other(3,:,i)^2)^3),1:Nh,'UniformOutput',false));
                %i番目の個体とその他個体の反力ポテンシャル
                agent_separate = cell2mat(arrayfun(@(i) [Cov_diffx_Agent2AgentPotential(state.p(1),state.p(2),OtherAgentState{i}(1),OtherAgentState{i}(2));Cov_diffy_Agent2AgentPotential(state.p(1),state.p(2),OtherAgentState{i}(1),OtherAgentState{i}(2))],1:Nh,'UniformOutput',false));
            else
                agent_separate = zeros(2,Nh);
                ObstacleAvoidPotential = zeros(2,Nob);
                ithViewPoint_separate_ViewPoint = zeros(2,Nh);
                ithViewPoint_separate_OtherAgent = zeros(2,Nh);
            end
            %上で計算した入力たちを視野角に入ってるかi=numか，iの法が遅い場合には回避行動を0
            AvoidRerativeAgentdistance = [];
            ViewRerativeAgentdistance = [];
            parfor i = 1:Nh
                if in_flontAvoid(i)==0||num==i||Vdotdis(i)<=0
                    F(:,i) = zeros(3,1);
                end
                if in_flontViewRange(i)==0||num==i||Vdotdis(i)<=0
                    ithViewPoint_separate_ViewPoint(:,i) = zeros(2,1);
                    ithViewPoint_separate_OtherAgent(:,i) = zeros(2,1);
                end
                if in_flontViewRange(i)==0||num==i
                    agent_separate(:,i) = zeros(2,1);
                end
                RerativeVerocityDot = dot(OtherAgentState{i}(3:4),state.v(1:2));
                %回避希望領域内に入っている対向者の数を把握
                if in_flontAvoid(i)==1&&RerativeVerocityDot<0&&num~=i
                    AvoidRerativeAgentdistance = [AvoidRerativeAgentdistance,Cov_distance(viewpoint{num}(1:2),OtherAgentState{i}(1:2),2)];
                end
                %視野領域内の対向車を把握
                if in_flontViewRange(i)==1&&RerativeVerocityDot<0&&num~=i
                    ViewRerativeAgentdistance = [ViewRerativeAgentdistance,Cov_distance(viewpoint{num}(1:2),OtherAgentState{i}(1:2),2)];
                end
            end
            parfor i=1:Nob
                %遠心力の計算
                if in_flontObject(i)==0
                    obF(:,i) = zeros(3,1);
                    ObstacleAvoidPotential = zeros(2,1);
                end
            end
            if ~isempty(AvoidRerativeAgentdistance)
                k2 = 0.1;
            else
                k2 = 0;%*sign(obj.random);%交通ルール
            end
            if ~isempty(ViewRerativeAgentdistance)
                k3 = 0.3;
                k1 = 0.5;%注視転換
            else
                k3=0;
                k1 =0;%注視転換
            end
            %最終的に本体にかかる入力
            if count ==1
                walk = input;
                a= [0;0];
                b = a;
                c=a;
            else
                %これ以前では環境による注視点を算出ここで，人などの外的要因を基にした注視点を算出
                MaxLabela = Cov_MaxLabel(ithViewPoint_separate_ViewPoint,2);
                a = k1*((ithViewPoint_separate_ViewPoint(:,MaxLabela)));
                MaxLabelc = Cov_MaxLabel(F,2);
                b = k2*(F(1:2,MaxLabelc));
%                 b = k2*sum(F(1:2,:),2);
                if norm(b)>300
                    b = b/norm(b)*300;
                end
                MaxLabelc = Cov_MaxLabel(ithViewPoint_separate_OtherAgent,2);
                c = k3*(ithViewPoint_separate_OtherAgent(:,MaxLabelc));
                if norm(c)>300
                    c = c/norm(c)*300;
                end
                ppp = -0.2*ObstacleAvoidPotential+0.01*obF(1:2,:);
                MaxLabelc = Cov_MaxLabel(ppp,2);
                d = 1*(ppp(:,MaxLabelc));
%                 MaxLabelc = Cov_MaxLabel(ObstacleAvoidPotential,2);
%                 d = -1*(ObstacleAvoidPotential(:,MaxLabelc));
                
                [~,Directionu] = max(abs(u)) ;
                if Directionu ==2
                    ref_input = [a(1);0]+[b(1);0]+[c(1);0]+[d(1);0]+10*u;
                elseif Directionu == 1
                    ref_input = [0;a(2)]+[0;b(2)]+[0;c(2)]+[0;d(2)]+10*u;
                else
                    ref_input = a+b+c+10*u;
                end
                viewpoint{num} = viewpoint{num}+0.1*eye(2)*[ref_input];
                ref_point{num} = viewpoint{num}(1:2);
                walk = (ref_point{num}(1:2) - state.p(1:2))/norm(ref_point{num}(1:2) - state.p(1:2),2);
            end
            %目標速度へと向かうような加速度入力
            if norm(walk)~=0
                acceleration = (walk/norm(walk)*v_k - OtherAgentState{num}(3:4))/dt;
            else
                acceleration = zeros(2,1);
            end
            MaxLabel = Cov_MaxLabel(agent_separate,2);
            if abs(agent_separate(1,MaxLabel))>=10
                mp = sign(agent_separate(1,MaxLabel));
                agent_separate(1,MaxLabel) = mp*10;
            end
            if abs(agent_separate(2,MaxLabel))>=10
                mp = sign(agent_separate(2,MaxLabel));
                agent_separate(2,MaxLabel) = mp*10;
            end
            agent_input = 0.5*walk+1*acceleration+agent_separate(:,MaxLabel);
            obj.result.ref_point = ref_point{num};
            %%
            %             make_map(0,obj,other_state,num)
            %%
            if isnan(agent_input)
                disp('a');
            end
            agent_input = [0;0;agent_input;0;0];
            obj.self.input = agent_input;
            obj.result.state.u = [agent_input];
            obj.result.separateu = [a;b;c];
            obj.result.rerativepotential = [ ];
            obj.result.View_range = LViewRange;
            obj.result.View_range = ObViewRange;
            obj.result.OPV = v_k;
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
            Nh = length(other_state);
            if flag%マップ保存用
                for k=1:sizeX
                    for j=1:sizeY
                        xm = GX(k,j);
                        ym = GY(k,j);
                        Vp = zeros(1,obj.num_slope);
                        aaa=0;
                        for i=1:Nh
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

