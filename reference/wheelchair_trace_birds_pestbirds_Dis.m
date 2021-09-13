classdef wheelchair_trace_birds_pestbirds_Dis < REFERENCE_CLASS
    %EXAMPLE_WAYPOINT このクラスの概要をここに記述
    % 速度次元の入力モデル
    
    properties
        self
        param
    end
    
    methods
        function obj = wheelchair_trace_birds_pestbirds_Dis(self,param)
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
        end
        
        function result = do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = obj.self.id;%今計算している鳥の番号
            state =  obj.self.plant.state.p;%num番目の鳥の位置
            q = obj.self.plant.state.q;%num番目の鳥のクォータニオン
%             agent_v = Param{1}.state.v;
            N = Param{3};%mainのN
            Nb = Param{4};%鳥の数
            for i=Nb+1:N
                drone_state(:,i) = [Param{1,1}(1,i).plant.state.p];
            end
            for i=1:N
                other_state(:,i) = [Param{1,1}(1,i).plant.state.p];%すべての鳥とドローンの情報
            end
            pre_info = Param{2};%1時刻前の状態
%             rs = Param{5}(1);ra = Param{5}(2);
            rc = Param{6}(3); %群れる距離
            tarm1 = zeros(2,length(other_state));%鳥の群れる項
            adjust =  zeros(2,length(other_state));%鳥がほかの鳥から離れる
            keep = zeros(2,1);%畑への進行
            away = zeros(2,length(other_state));%ドローンから離れる
            fp = Param{5};
            k1 = 0.2;%%離れる
            k2 = 0.1;%%整列
            k3 = 3.;%畑に向かう%1機のとき1にしてた．
            k4 = 23.0;%%逃げる：初期化下で内分点の計算から求めている．
            [~,count] = size(pre_info.Data.t');
            R=5;
            flont = zeros(1,Nb);
            %%%近づく離れる第一講%%%%%%%%%%%%%%%5
            result = arrayfun(@(i) Cov_distance(state,other_state(:,i),1),1:N);%鳥とその他（ドローンを含む）の距離計算
            tmp = struct2cell(result);
            distance = cell2mat(tmp);
            if count >1
%                keep = pre_info{num}.state(4:6,end)-agent_v;
                for i=1:numel(fp)
                    d(:,i)=norm(state(1:2)-fp{i});
                end
                [~,farm] = min(d);
                fp = fp{farm};
               keep = ((fp-state(1:2))/norm((fp-state(1:2)),2)) ;
                %内積計算
                if pre_info.i==1
                    agent_v = arrayfun(@(AAA) (state(1:2)-[0;0])/0.1,1:N,'UniformOutput',false);
                else
                    agent_v = arrayfun(@(AAA) (state(1:2)-pre_info.Data.agent{pre_info.i-1,4,AAA}.state.p(1:2))/0.1,1:N,'UniformOutput',false);
                end
                result = arrayfun(@(i) Cov_distance(other_state(:,i),state,1),1:N);
                tmp = struct2cell(result);
                dis = cell2mat(tmp);
                AA = arrayfun(@(i) dot( agent_v{num}(1:2),dis(2:3,:,i)),1:Nb);
                %前にいるやつの把握
                flont = AA>0;
                
%                k5 = 0;%*distance{N}.result/(distance{N}.result + A.result);%%畑へ向かう力

            end
            if i~=num&&i<=Nb&&flont(i)==1
                if distance(1,:,i)<rc&&abs(distance(1,:,i))>0.
                    tarm1(:,i) = -(1-[R^3/distance(1,:,i)^3])*[distance(2:3,:,i)];
                    adjust(:,i) = agent_v{i} - agent_v{num};                       
                end
            end
            for i=Nb+1:N%ドローンから逃げる力
                away(:,i) = (distance(2:3,:,i))/norm(distance(2:3,:,i))^2;
            end     
            %%目標位置に向かう用のやつ
            if rand(1)>0.5
                r= -0.1;
            else 
                r=0.1;
            end
            fp = fp + r * rand(1);
            if fp-state(1:2,1)==0
                go_farm = (fp-state);
            else
                go_farm = (fp-state(1:2,1))/norm(fp-state(1:2,1));
            end
%             %畑の耐久計算
%             farea = 5;
%             xf = [fp(1)-farea fp(1)+farea];
%             yf = [fp(2)-farea fp(2)+farea];
%             if Param{2}.i == 1
%                 flag = 0;
%             end
%             if xf(1)<state(1) && xf(2)>state(1) && yf(1)<state(2) && yf(2)>state(2)
%                 if flag == 0
%                     durable_value = 100;%畑の耐久値
%                     flag = 1;
%                 end
%                 obj.param = durable_value - 0.5;
%             end
            %目標位置作成
            if count >1&&norm(agent_v{num})~=0
                input =k1*sum(tarm1,2)/Nb + k2*sum(adjust,2)/Nb + k3*keep + k4*sum(away,2);
            else
                k5 = 6;
                input = k5*go_farm;
            end
%             if norm(input)<5.9
%                disp(norm(input)) 
%             end
            kind_speed = 82 * 10/36;
            ref_point = eye(2)*state(1:2,1) + eye(2)*(kind_speed * (input/norm(input,2)));
            th_xd = atan2(ref_point(2)-state(2),ref_point(1)-state(1));%角速度
%             figure;
%             scatter(ref_point(1),ref_point(2),'r')
%             hold on;
%             scatter(state(1),state(2),'b')
%             xlim([state(1)-norm(ref_point-state)-3,state(1)+norm(ref_point-state)+3])
%             ylim([state(2)-3-norm(ref_point-state),state(2)+3+norm(ref_point-state)])
            qtrans = quat2eul(q');
            q3 = qtrans(3);
            th_dd = th_xd-q3;
            if th_dd>pi
                q3=q3+2*pi;
            elseif th_dd<=-pi
                q3= q3-2*pi;
            end
                        th_dd = th_xd-q3;
            eul = [0,0,th_dd];
            quat = eul2quat(eul);
            v_xd = kind_speed ;
            obj.result.state.u = [v_xd;0;eul(3);quat'];%[(x,y),z,omega,q]
            result = obj.result;
        end
        function show(obj,param)
%             draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
    end
end

