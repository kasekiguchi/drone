classdef human_input < REFERENCE_CLASS
    %EXAMPLE_WAYPOINT このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        param
        xd
        node_buffa 
    end
    
    methods
        function obj = human_input(varargin)
            refP = varargin{2}{1};
            select_probability = varargin{2}{2};
            id = varargin{2}{3};
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
            obj.xd = human_plobable_refarence(refP,select_probability);%基底の目標位置からランダムに選択
            obj.param = {[refP],[select_probability]};
            obj.node_buffa = caluclate_buffa(varargin{2}{4},obj.xd);
         end
        
        function result= do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = Param{4};
            state =  Param{1}.state;
            %             agent_v = Param{1}.state.v;
            other_state = Param{3};
            N = length(other_state);
            wark_area = Param{2}.huma_load.param.spone_area.Vertices;
            node = Param{2}.huma_load.param.node;
            dim = length(state.p);
            gather = zeros(2,length(other_state));%引力
            pillar =[0;0];
            separate_input = zeros(2,1);
            pre_info = Param{5}.save.agent;
            dt = Param{5}.dt;
            count = Param{5}.main_roop_count;
%             agent_v=cell(N,1);
            buffa_c = obj.node_buffa(1,:);
%             buffa_c2 = Param{9}{num}(2,:);  
            k1 = .3;%%離れる
            k2 = .04;%目標に向かう
            k3 = .1;%寄る
            %歩行速度ゲイン
            v_k = 1.0;
            xxd = cell(1,N);
            for i=1:N
                xxd{i} = Param{6}(i).reference.human.xd;
            end
            %通路の最大最小
%             xmax = max(wark_area(:,1));xmin = min(wark_area(:,1));
%             ymax = max(wark_area(:,2));ymin = min(wark_area(:,2));
%             flont = zeros(1,N);
            env = Param{2}.huma_load.param;
            if count~=1
                for i=1:N
                    pre_input{i} = pre_info{i}.u;
                end
            end

            %%%%%%ここまでで初期化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            result = arrayfun(@(i) Cov_distance(state.p(1:2),other_state{i}(1:2),1),1:N);%Calclate distance between human and other one.
            tmp = struct2cell(result);
            distance = cell2mat(tmp);
            
            %%柱の数をカウントする
            [pillar_num,~]=size(env.pillar_cog);
            [~,num_node] = size(node.point);

                        %% 最小射影法
                                    % Genelate of refalance
            A = [0 0 1 0 0 0;...
                0 0 0 1 0 0;...
                0 0 0 0 1 0;...
                0 0 0 0 0 1;...
                0 0 0 0 0 0;...
                0 0 0 0 0 0];
            
            B = [1 0 1 0 0 0;...
                0 1 0 1 0 0;...
                0 0 1 0 0 0;...
                0 0 0 1 0 0;...
                0 0 0 0 1 0;...
                0 0 0 0 0 1];
            sysd = c2d(ss(A,B,A,0),dt);
                                    %%%%%%%  Start to algorithm %%%%%%%%%%%%
            x = state.p(1);
            y = state.p(2);
            

            %%ここが重すぎ,最小射影の計算

            Vp = minimum_projection(num_node,x,y,node,buffa_c);
            [~,index]= min(Vp);
            %     vx = Cov_diffx_Vp2(x,y,node.point(1,index),node.point(2,index),node.point(3,index), otherP(1,1),otherP(2,1),otherr(1,1),otherr(2,1) , otherP(1,2),otherP(2,2),otherr(1,2),otherr(2,2) , otherP(1,3),otherP(2,3),otherr(1,3),otherr(2,3));
            %     vy = Cov_diffy_Vp2(x,y,node.point(1,index),node.point(2,index),node.point(3,index), otherP(1,1),otherP(2,1),otherr(1,1),otherr(2,1) , otherP(1,2),otherP(2,2),otherr(1,2),otherr(2,2) , otherP(1,3),otherP(2,3),otherr(1,3),otherr(2,3));
            vx = Cov_diffx_Vp(x,y,node.point(1,index),node.point(2,index),node.point(3,index));
            vy = Cov_diffy_Vp(x,y,node.point(1,index),node.point(2,index),node.point(3,index));
            u = -1*[vx;vy];
            input = k2*u;
%             [~,kkkk]=ode45(@(x,t) odefun(0,[state.p(1:2);0;0;0;0],A,B,10*v_k*[input;0;0;0;0],dt),[0 dt],[state.p;0;0;0;0]);
%             tmp_ref{num} = kkkk(end,1:2)';
                % 自分と他者の距離計算
                result = arrayfun(@(i) Cov_distance(other_state{i}(1:2),state.p(1:2),1),1:N);
                tmp = struct2cell(result);
                dis = cell2mat(tmp);
                % Calclate inner product. if vectar state->other state and
                % speed is negative, the other one is front of human
                AA = arrayfun(@(i) dot(input,dis(2:3,:,i)),1:N);
                %前にいるやつの把握
                flont = AA>0;
                %人口密度の計算
                density = 0;
                
                for i= 1:N
                    %前にいて特定の距離以内の個体をカウント
                    if flont(i)==1&&dis(1,:,i)>0&&dis(1,:,i)<=1.25
                        density = density+1;
                    end
                end
%                 if density >1.5
%                     v_k = 1.32*log(9.16/density);
%                 else
%                     v_k = -0.204*density +1.48;
%                 end
                if density >5
                    v_k = 0;
                else
                    v_k = 0.0013*density^3+0.025*density^2-0.3143*density+0.9;
                end
                

                
            %一点注視店の初期化，とりあえず自己位置に作成．
            sysB = eye(6);
            viewpoint = cell(1,N);
            F = zeros(3,N);
            theta = zeros(1,N);
            if count~=1
                for i=1:N
               %遠心力の計算
               theta(i) = atan2(dis(3,:,i),dis(2,:,i))-atan2(input(2),input(1));
               if i~=num
                  if dis(1,:,i)>0&&dis(1,:,i)<=5&&flont(i)==1&&~isequal(xxd{num},xxd{i})&&theta(i)>=0
                     F(:,i) = cross([0;0;1],[dis(2,:,i);dis(3,:,i);0]);
                     F(:,i) = F(:,i)/norm(F(:,i));
                  elseif dis(1,:,i)>0&&dis(1,:,i)<=5&&flont(i)==1&&~isequal(xxd{num},xxd{i})&&theta(i)<0
                     F(:,i) = cross([0;0;1],[dis(2,:,i);dis(3,:,i);0]);
                     F(:,i) = F(:,i)/norm(F(:,i));
                  end
               end
                    [~,y] = ode45(@(t,y) sysd.A*[other_state{i}(1:2);0;0;0;0]+dis(1,:,i)/2*sysB*pre_input{i}(:,end),[0 dt], [other_state{i}(1:2);0;0;0;0]);
                    viewpoint{i} = y(end,:);
                end
%                            figure
% scatter(viewpoint{1}(1,1),viewpoint{i}(1,2))
% hold
% scatter(state.p(1),state.p(2))
% scatter(other_state{2}.p(1),other_state{2}.p(2))
% scatter(viewpoint{2}(1,1),viewpoint{2}(1,2))
            result = arrayfun(@(i) Cov_distance(state.p(1:2),viewpoint{i}(1,1:2)',1),1:N);%Calclate distance between human and other one.
            tmp = struct2cell(result);
            distance = cell2mat(tmp);
            distance_and_labels = cell2mat(arrayfun(@(i) [distance(:,:,i);i],1:N,'uniformoutput',false));
            rerative_agent = zeros(1,N);

            %前にいるかつ目標位置が異なる個体を探し出す
            for i=1:N
               if i~=num
                  if flont(i)==1&&~isequal(xxd{num},xxd{i})
                     rerative_agent(i) = 1;
                  else
                      rerative_agent(i) = 0;
                  end
               end
            end
            %前にいるかつ目標の異なる個体の最小を求める
            tmp = distance_and_labels(:,logical(rerative_agent));
            min_rerative_agent = sortrows(tmp',1)';

            %楕円ポテンシャルの作成
            Elliptical_potential = cell(1,N);
            potential = cell(1,N);
                for i=1:N
                    Elliptical_potential{i} = -Cov_Elliptical_potential(viewpoint{num}(1,1),viewpoint{num}(1,2),viewpoint{i}(1,1)',viewpoint{i}(1,2)',other_state{i}(1),other_state{i}(2));
                    if dis(1,:,i)>0&&dis(1,:,i)<=5&&flont(i)==1&&~isequal(xxd{num},xxd{i})
                    potential{i} = [distance(2,:,i);distance(3,:,i)]/(distance(1,:,i))^6;
                    else
                    potential{i} = [0;0];    
                    end
                end
                Elliptical_potential= sum(cell2mat(Elliptical_potential),2,'omitnan');
%                 Elliptical_potential= sum(cell2mat(potential),2,'omitnan');
            else 
                Elliptical_potential = zeros(2,1);
            end
 
            ref_point = arrayfun(@(i) eye(2)*other_state{i}(1:2),1:N,'uniformoutput',false);
            
            %他者の位置の行列を作成．今は使ってないけど，拡張で利用する予定
%             sss = cell2mat(arrayfun(@(i) other_state{i}.p,1:N,'uniformoutput',false));
%             qs = sss(1,:)~=state.p(1,:)&sss(2,:)~=state.p(2,:);
%             otherP = sss(:,qs);%j番目の人の位置を行列に変更
%             sss = cell2mat(arrayfun(@(i) ref_point{i},1:N,'uniformoutput',false));
%             qs = sss(1,:)~=ref_point{num}(1,:)&sss(2,:)~=ref_point{num}(2,:);
%             otherr = sss(:,qs);%j番目の人の一点注視点を行列に変更
 

            
            Relative_N =1;
               if num==2
                   disp('') 
               end
                %目標位置を種類分け．
                all_xd = cell2mat(xxd);
                unique_xd = unique(all_xd','rows')';
                [~,qq] = size(unique_xd);
                agent_label =zeros(1,N);
                for i=1:qq
                   agent_label=double(arrayfun(@(kk) isequal(all_xd(:,kk),unique_xd(:,i)),1:N)); 
                        some_gole_label_tmp{i} = find(agent_label);


                end
                %ゴールを種類分けして同じやつをラベル分け
                for i=1:qq
                    if find(some_gole_label_tmp{i}==num)
                    some_gole_label = some_gole_label_tmp{i};
                    break;
                    end
                end
                for i=1:N
                    if i~=num&&flont(i)>0&&isequal(xxd{num},xxd{i})
                        %ゴールが同じになるっやつに引力を印加
                        gather(:,i) = -[distance(2:3,:,i)]/norm(distance(2:3,:,i),2);
                    end
                  %動きが単純ならば大丈夫だがよける方向で変になる．ゴール位置で判断にした法がいい．
                    if isequal(xxd{num},xxd{i})==0&&i~=num&&flont(i)>0
                        % 楕円ポテンシャルによる回避
                        separate_input(:,i) = -Cov_Elliptical_potential(ref_point{num}(1),ref_point{num}(2),ref_point{i}(1),ref_point{i}(2),other_state{i}(1),other_state{i}(2));
%                         separate_input(:,i) = [[x-other_state{i}.p(1)]/norm([x;y]-other_state{i}.p)^6;[y-other_state{i}.p(2)]/norm([x;y]-other_state{i}.p)^6];
%                         agent_separate_input(:,i) = Cov_Elliptical_potential(state.p(1),state.p(2),ref_point{i}(1),ref_point{i}(2),other_state{i}.p(1),other_state{i}.p(2));
                        %                         daen(:,i) = Cov_daen(ref_point{num}(1),ref_point{num}(2),ref_point{i}(1),ref_point{i}(2),other_state{i}.p(1),other_state{i}.p(2));
                    end
                end
                pillar_exp = 6;
            parfor j = 1:pillar_num
                pillar =pillar-[[env.pillar_cog(j,:)']-ref_point{num}(1:2)]/norm(env.pillar_cog(j,:)'-ref_point{num}(1:2,:),2)^pillar_exp;
            end
            %%目標位置に向かう用のやつ
%             ggg = sum(separate_input~=0,2);
            %角の部分で遠心力をかける．
%             [n,~]= size(Cpoint);
            %一番近い曲がり角を見つける
%             C_distance = arrayfun(@(i) norm(Cpoint(i,:)'-state.p,2),1:n);
%             [M,I] = min(C_distance) ;
            %目標位置に近いノード店の方向を見つける．
            %壁の向こう側を見ないようにしつつ視野みたい穴物をキメてう
            all_area = polyshape([0 0;0 20;20 20;20 0]);
            wall = subtract(all_area,polyshape(wark_area));
            view_ragne = Cov_view_range(state.p(1:2),u,360,wall);
            inout = arrayfun(@(i) isinterior(view_ragne,node.point(1,i),node.point(2,i)),1:num_node);
            in_num = find(inout==1);

            tmp = buffa_c(in_num);
            norm_num = vertcat(in_num,tmp);
            [~,ind] = min(tmp);
            
            %ノードをもとにゴールの方向を決定
            direction_goal = node.point(1:2,norm_num(1,ind))-state.p(1:2);
%             disp(direction_goal)
                %曲がり角を基準に時計回りとかの力を印加
%             if M<2
%                CFR = cross([0;0;1],[Cpoint(I,:)'-state.p;1]);
%                CFR = CFR/norm(CFR,2);
%                CFL = cross([0;0;-1],[Cpoint(I,:)'-state.p;1]);
%                CFL = CFL/norm(CFL,2);
%                pA = dot(CFR(1:2),burein_u);
%                pB = dot(CFL(1:2),burein_u);
%                SSSS = Cpoint(I,:)'-state.p;
%                flontC = dot(SSSS,direction_goal);
%                if sign(pA)==1&&flontC>0
%                     CF = CFR;
%                elseif sign(pB) ==1&&flontC>0
%                    CF=CFL;
%                elseif sign(pA)==0||sign(pB)==0
%                   CF = CFR; 
%                else
%                 CFR=[0;0];
%                 CFL =CFR;
%                 CF = [0;0];
%                end
%             else
%                 CFR=[0;0];
%                 CFL =CFR;
%                 CF = [0;0];
%             end
%             if 
            %最初に最小射影と離れる奴の和で入力計算
            if isempty(in_num)
            input = k2*u;

            else
            input = k2*u+.8*direction_goal;
            end
            [~,kkkk]=ode45(@(x,t) odefun(0,[state.p(1:2);0;0;0;0],A,B,10*[input;0;0;0;0],dt),[0 dt],[state.p(1:2);0;0;0;0]);
            ref_point{num} = kkkk(end,1:2)';
            obj.result.ref_point = ref_point{num};
            if count>0
                obj.result.ref_point = ref_point{num};
            end
            
            parfor j = 1:pillar_num
                pillar =pillar-[[env.pillar_cog(j,:)']-state.p(1:2)]/norm(env.pillar_cog(j,:)'-state.p(1:2),2)^pillar_exp;
            end
            
            % Generate of reflect potential
            agent_separate_view_point = cell2mat(arrayfun(@(i) [distance(2:3,:,i)]/(norm(distance(2:3,:,i),2))^5,1:N,'UniformOutput',false));
            agent_separate_view_point(:,num) = [];
            
            agent_separate = -cell2mat(arrayfun(@(i) [dis(2:3,:,i)]/(norm(dis(2:3,:,i),2))^10,1:N,'UniformOutput',false));
            agent_separate(:,num) = [];
            
            walk = (ref_point{num}(1:2) - state.p(1:2))/norm(ref_point{num}(1:2) - state.p(1:2),2);
            %最終的に本体にかかる入力
%             agent_input = (0.0004*sum((agent_separate_view_point),2))/Relative_N + 0.4*walk+0.1*Elliptical_potential+ 0.05*sum(F(1:2,:),2);
%             agent_input = (0.0005*sum((agent_separate_view_point),2))/Relative_N + 0.4*walk+(0.0005*sum((agent_separate),2))+ 0.05*sum(F(1:2,:),2);
%             agent_input = (0.0003*sum((agent_separate_view_point),2))/Relative_N + 0.3*input+0.1*Elliptical_potential+ 0.05*sum(F(1:2,:),2);
            agent_input = (0.00000*sum((agent_separate_view_point),2))/Relative_N + 0.2*input+(0.0005*sum((agent_separate),2))+ 0.05*sum(F(1:2,:),2);
            agent_input = v_k*agent_input/norm(agent_input);
           
%%
            grid_x =-2:0.5:11;
            grid_y =  -2:0.5:11;
            node_r = 1;
            [GX,GY] = meshgrid(grid_x,grid_y);%%χ
            [sizeX,~]=size(GX);
            [~,sizeY]=size(GY);
            map = zeros(sizeX,sizeY);
            map2 = zeros(sizeX,sizeY);
            map3 = zeros(sizeX,sizeY);
            Vp = zeros(1,num_node);
            if 1%マップ保存用
            parfor k=1:sizeX
                for j=1:sizeY
                    xm = GX(k,j);
                    ym = GY(k,j);
                    Vp = zeros(1,num_node);
%                     Vp2 = zeros(1,num_node);
%                     Vp3 = zeros(1,num_node);
                    aaa=0;
            for i=1:N
                if i~=num
                aaa =aaa +1/norm([xm;ym]-other_state{i}(1:2));
                end
            end
            for i = 1:num_node
                    
                        Vp(i) = 0.1*Cov_Vp(xm,ym,node.point(1,i),node.point(2,i),node.point(3,i))+1*buffa_c(i);
%                         if isnan(Vp(i))
%                            disp('a') 
%                         end
%                         Vp2(i) = 1*Cov_Vp(xm,ym,node.point(1,i),node.point(2,i),node.point(3,i))+1*buffa_c(i)+10*(roll_potential(x,y,2,6,node.point(1,i),node.point(2,i))-1);
%                         Vp3(i) = 1*Cov_Vp(xm,ym,node.point(1,i),node.point(2,i),node.point(3,i))+1*buffa_c(i)+1*(roll_potential(x,y,2,6,node.point(1,i),node.point(2,i))-1);

            end
            
                    min_Vp = min(Vp);
%                         if isnan(min_Vp)
%                            disp('a') 
%                         end
                    if min_Vp >15
                        min_Vp =15;
                    end
%                                         min_Vp2 = min(Vp2);
%                     if min_Vp2 >100
%                         min_Vp2 =100;
%                     end
%                                         min_Vp3 = min(Vp3);
%                     if min_Vp3 >100
%                         min_Vp3 =100;
%                     end
                    map(k,j) = min_Vp;
%                     map2(k,j) = min_Vp2;
%                     map3(k,j) = min_Vp3;

                
                end
            end
%                         figure;  surf(GX,GY,map,'EdgeColor','none');
            mapmax =max(max(map));
            obj.result.map = map./mapmax;
            if num==1
            hold on
            contour(GX,GY,obj.result.map)
            % scatter(node.point(1,:),node.point(2,:))
            hold off
            end
%             figure;  surf(GX,GY,map./mapmax,'EdgeColor','none');
%             mapmax =max(max(map2));
%             figure;  surf(GX,GY,map2./mapmax,'EdgeColor','none');
%             mapmax =max(max(map3));
%             figure;  surf(GX,GY,map3./mapmax,'EdgeColor','none');            
            end
            if isnan(agent_input)
               disp('a'); 
            end
            agent_input = [agent_input;0;0;0;0];

            obj.result.state.u = [agent_input];
            obj.result.rerativepotential = [ (0.0004*sum((agent_separate_view_point),2))/Relative_N ;(0.002*sum((agent_separate),2))];
            obj.result.rerativepotential = [ (0.0004*sum((agent_separate_view_point),2))/Relative_N ;0.1*Elliptical_potential];
            %             obj.result.map2 = map2;
            %             obj.result.map3 = map3;
            result = obj.result;
            
        end
        function show(obj,param)
            %             draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
    end
end

