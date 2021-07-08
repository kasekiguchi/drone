classdef trace_birds_pestbirds < REFERENCE_CLASS
    %EXAMPLE_WAYPOINT このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        param
    end
    
    methods
        function obj = trace_birds_pestbirds(varargin)
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
        end
        
        function result= do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = Param{4};
            state =  Param{1}.state.p;
            agent_v = Param{1}.state.v;
            other_state = Param{3};
            N = length(other_state);
            Nb = Param{9};
            pre_info = Param{6}.save.agent;
%             rs = Param{5}(1);ra = Param{5}(2);
            rc = Param{5}(3); 
            tarm1 = zeros(3,length(other_state));
            adjust =  zeros(3,length(other_state));
            keep = zeros(3,1);
            away = zeros(3,length(other_state));
            go_farm = zeros(3,1);
            fp = [Param{7};0];
            want_falm = Param{8};
            k1 = 0.5;%%離れる
            k2 = 0.5;%%整列
            k3 = 2.;%%保持する
            k4 = 30.;%%逃げる：初期化下で内分点の計算から求めている．
            k5 = 0;%%畑に向かう
            [~,count] = size(pre_info{1}.state);
            R=5;
            flont = zeros(1,Nb);
            %%%近づく離れる第一講%%%%%%%%%%%%%%%5
            result = arrayfun(@(i) Cov_distance(state,other_state{i}.p,1),1:N);%鳥とその他（ドローンを含む）の距離計算
            tmp = struct2cell(result);
            distance = cell2mat(tmp);
            if count >1
%                keep = pre_info{num}.state(4:6,end)-agent_v;
               keep = ((fp-state)/norm((fp-state),2)) ;
                %内積計算
                AA = arrayfun(@(i) dot( pre_info{num}.state(4:5,end),distance(2:3,:,i)),1:Nb);
                %前にいるやつの把握
                flont = AA>0;
                
                
               k5 = 0;%*distance{N}.result/(distance{N}.result + A.result);%%畑へ向かう力

            end
            for i=1:N
                if i~=num&&i<=Nb&&flont(i)==1
                    if distance(1,:,i)<rc&&abs(distance(1,:,i))>0.
                        tarm1(:,i) = -(1-[R^3/distance(1,:,i)^3])*[distance(2:3,:,i);0];
                        adjust(:,i) = other_state{i}.v - agent_v;                       
                    end
                end
                if i>Nb%ドローンから逃げる力
                    away(:,i) = [distance(2:3,:,i);0]/norm(distance(2:3,:,i))^2;
                end     
            end
            %%目標位置に向かう用のやつ
            if rand(1)>0.5
                r= -0.1;
            else 
                r=0.1;
            end
            fp = fp + r * rand(1);
            if fp-state==0
                go_farm = (fp-state);
            else
                go_farm = (fp-state)/norm(fp-state);
            end
            %内分点によるゲインのさくせい\
            vv = norm(agent_v);
            if count >1&&sum(agent_v)~=0
                input =k1*sum(tarm1,2)/Nb + k2*sum(adjust,2)/Nb + k3*keep + k4*sum(away,2);
%                 input_v = 6*(agent_v)/norm(agent_v,2);
%                 if vv>10
%                     agent_v =  10*(agent_v)/norm(agent_v,2);
%                 elseif vv<4&&norm((fp-state),2)>10
%                     agent_v =  4*(agent_v)/norm(agent_v,2);   
%                 else
%                 end
                
                input_v = agent_v;
            else
                k5 = 60;
                input = k5*go_farm;
                input_v = agent_v;
            end
%             if norm(input)<5.9
%                disp(norm(input)) 
%             end
            obj.result.state.u = [input_v;input];%
            result = obj.result;
            
        end
        function show(obj,param)
%             draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
    end
end

