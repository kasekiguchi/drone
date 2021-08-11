classdef wheelchair_input < REFERENCE_CLASS
    %人用のインプット生成
    
    properties
        param
    end
    
    methods
        function obj = wheelchair_input(varargin)
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
        end
        
        function result= do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = Param{4};
            state =  Param{1}.state.p;
            w = Param{1}.state.q;
            %             agent_v = Param{1}.state.v;
            other_state = Param{3};
            N = length(other_state);
            wark_area = Param{5}.wall;
            xd = Param{6};
            gather = zeros(2,length(other_state));%引力
            ref_to_other_separate = zeros(2,length(other_state));
            ref_to_ref_separate = zeros(2,length(other_state));
            bamp1=0;
            bamp2=0;
            pillar =[0;0];
            walk = zeros(2,1);
            flag = Param{7};
            pre_info = Param{8}.save.agent;
            dt = Param{8}.dt;
            count = Param{8}.main_roop_count;
            agent_v=cell(N,1);
            k1 = .3;%%離れる
            k2 = .5;%目標に向かう
            k3 = .04;%寄る
            %通路の最大最小
            xmax = max(wark_area(:,1));xmin = min(wark_area(:,1));
            ymax = max(wark_area(:,2));ymin = min(wark_area(:,2));
            flont = zeros(1,N);
            env = Param{5};
            grid_x = -5:0.1:30;
            grid_y = grid_x;

            %%%%%%%  Start to algorithm %%%%%%%%%%%%
            result = arrayfun(@(i) Cov_distance(state,other_state{i}.p,1),1:N);%Calclate distance between human and other one.
            tmp = struct2cell(result);
            distance = cell2mat(tmp);

            %%柱の数をカウントする
            [pillar_num,~]=size(env.pillar_cog);

            if count>2
                % Calclate speed of all humans 
                agent_v = arrayfun(@(AAA) (pre_info{AAA}.state(1:2,end)-pre_info{AAA}.state(1:2,end-1))/dt,1:N,'UniformOutput',false);
                %内積計算
                % Calclate vectar state->other state
                result = arrayfun(@(i) Cov_distance(other_state{i}.p,state,1),1:N);
                tmp = struct2cell(result);
                dis = cell2mat(tmp);
                % Calclate inner product. if vectar state->other state and
                % speed is negative, the other one is front of human
                AA = arrayfun(@(i) dot( agent_v{num}(1:2),dis(2:3,:,i)),1:N);
                %前にいるやつの把握
                flont = AA<0;
                %                 back = AA>0;
            end
            if isempty(cell2mat(agent_v'))==0
                
%                 ref_point = eye(2)*state(1:2) + eye(2)*(10*agent_v{num});
                % Generate refarance. 
                ref_point = arrayfun(@(i) eye(2)*other_state{i}.p + eye(2)*(agent_v{i}/norm(agent_v{i},2)),1:N,'uniformoutput',false);
            else
                ref_point = arrayfun(@(i) xd{i},1:N,'uniformoutput',false);
            end
            %Distance between predict point to other human state.
            result = arrayfun(@(i) Cov_distance(ref_point{num},other_state{i}.p,1),1:N);
            tmp = struct2cell(result);
            ref_to_other_distance = cell2mat(tmp);
            %Distance between predictpoint to other one.
            result = arrayfun(@(i) Cov_distance(ref_point{num},ref_point{i},1),1:N);
            tmp = struct2cell(result);
            ref_to_ref_distance = cell2mat(tmp);
            for i=1:N
                if i~=num&&((ymin<=state(2)&&state(2)<=ymax)||(ymin<=ref_point{num}(2)&&ref_point{num}(2)<=ymax))
                    % Generate of reflect potential
                    ref_to_other_separate(:,i) = [ref_to_other_distance(2:3,:,i)]/norm(ref_to_other_distance(2:3,:,i),2)^2.2;
                    ref_to_ref_separate(:,i) = [ref_to_ref_distance(2:3,:,i)]/norm(ref_to_ref_distance(2:3,:,i),2)^2.2;
                end
            end
            if isempty(cell2mat(agent_v'))==0
                % Calclate of rerative speed
                Relative_v = arrayfun(@(i) dot(agent_v{num}(:,end),agent_v{i}(:,end)),1:N,'UniformOutput',false);
                for i=1:N
                    if num<N/2
                        if Relative_v{i}>0&&flag(num) ==1&&i~=num&&flont(i)>0&&(ymin<=state(2)&&state(2)<=ymax)
                            %相対速度相対速度で同じ方向に移動いているやつらには引力を印加
                            gather(:,i) = -[distance(2:3,:,i)]/norm(distance(2:3,:,i),2);
                        end
                    else
                        if Relative_v{i}>0&&flag(num) ==1&&i~=num&&flont(i)>0&&(ymin<=state(2)&&state(2)<=ymax)
                            %相対速度相対速度で同じ方向に移動いているやつらには引力を印加
                            gather(:,i) = -[distance(2:3,:,i)]/norm(distance(2:3,:,i),2);
                        end
                    end
                end
                
            end
            wall_exp = 5;
            pillar_exp = 6;
%             if ((ymin<=state(2)&&state(2)<=ymax)||(ymin<=ref_point{num}(2)&&ref_point{num}(2)<=ymax))
                % Genelate of wall force
                bamp1 = -[xmax-ref_point{num}(1);0]/norm((xmax+0.2)-ref_point{num}(1),2)^wall_exp;
                if norm(bamp1)>=10
                    disp('a')
                end  
                bamp2 = -[xmin-ref_point{num}(1);0]/norm((xmin-0.2)-ref_point{num}(1),2)^wall_exp;
                
                for j = 1:pillar_num
                    pillar =pillar-[[env.pillar_cog(j,:)']-ref_point{num}]/norm(env.pillar_cog(j,:)'-ref_point{num}(1:2,:),2)^pillar_exp;
                end
                
                
%             end
            %%目標位置に向かう用のやつ
            if flag(num) ==1
                walk = (xd{num} - state)/norm((xd{num} - state),2);
            end
            input = k1*sum(ref_to_other_separate,2)+ k1*sum(ref_to_ref_separate,2) + k2*walk +k3*sum(gather,2)+ 1*(bamp1 +bamp2 +pillar);
%             if ((xmin+.5)>state(1)||state(1)>(xmax-.5))
%                 input = k2*walk+20*(bamp1 +bamp2 +pillar);
%             end
            
            % Genelate of refalance
            ref_point{num} = eye(2)*ref_point{num} + eye(2)*(input);
            obj.result.ref_point = ref_point{num};
            u1 = norm(ref_point{num}-state);
            if u1 >=5
            u1 = 5;
            end
            
            th_xd = atan2(ref_point{num}(2)-state(2),ref_point{num}(1)-state(1));
            u2 = th_xd-w;
            
            obj.result.state.u = [u1;10;u2];
            result = obj.result;
            
%             
%                         G_pillar = zeros(length(grid_x),length(grid_y));
%             G_bamp = zeros(length(grid_x),length(grid_y));
%             G_human = zeros(length(grid_x),length(grid_y));
%             [GX,GY] = meshgrid(grid_x,grid_y);
%             for n =1:length(GX)
%                 for m=1:length(GY)
%                     G_bamp(n,m) = G_bamp(n,m) +1/norm([(xmin-.5)]-[GX(n,m)],2)^wall_exp + 1/norm([(xmax+.5)]-[GX(n,m)],2)^wall_exp;
%                     for j = 1:pillar_num
%                         G_pillar(n,m) = G_pillar(n,m) + 1/norm(env.pillar_cog(j,1)-[GX(n,m);GY(n,m)],2)^pillar_exp;
%                     end
% 
%                 end
%             end
%             for j = 1:N
%                 G_human(n,m) = G_human(n,m) - 1/norm(distance(2:3,:,j),2)^2.2+1/norm(ref_to_other_distance(2:3,:,j),2)^2.2+1/norm(ref_to_ref_distance(2:3,:,j),2)^2.2;
%             end
%             Genv =(G_bamp+G_pillar+G_human);
%             figure(4)
%             surf(GX,GY,Genv,'EdgeColor','none');
% %             contour(GX,GY,Genv);
%             xlim([xmin-1 xmax+1]);ylim([ymin-1 ymax+1]);
%             view(2);
        end
        function show(obj,param)
            %             draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
    end
end

