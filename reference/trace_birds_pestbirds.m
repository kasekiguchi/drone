classdef trace_birds_pestbirds < REFERENCE_CLASS
    % このクラスの概要をここに記述
    % 速度次元の入力モデル
    
    properties
        self
        param
    end
    
    methods
        function obj = trace_birds_pestbirds(self,param)
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","u"],'num_list',[3]));
        end
        
        function result = do(obj,Param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            num = obj.self.id;%今計算している鳥の番号
            state =  obj.self.estimator.result.state.p;%num番目の鳥の位置
            N = Param{3};%mainのN
            Nb = Param{4};%鳥の数
            for i=Nb+1:N
                drone_state(:,i) = [Param{1,1}(1,i).plant.state.p];%ドローンの情報
            end
            for i=1:N
                other_state(:,i) = [Param{1,1}(1,i).plant.state.p];%すべての鳥とドローンの情報
            end
            pre_info = Param{2};%1時刻前の状態
%             rs = Param{5}(1);ra = Param{5}(2);
            rc = Param{6}(3); %群れる距離
            tarm1 = zeros(3,length(other_state));%鳥の群れる項
            adjust =  zeros(3,length(other_state));%鳥がほかの鳥から離れる
            keep = zeros(3,1);%畑への進行
            away = zeros(3,length(drone_state));%ドローンから離れる
            fp = Param{5};%畑エリア
            k1 = 1;%%離れる
            k2 = 1;%%整列
            k3 = 3;%畑に向かう%1機のとき1にしてた．
            k4 = 1;%ドローンから逃げる
            [~,count] = size(pre_info.Data.t');
            R=5;
            flont = zeros(1,Nb);
            %%%近づく離れる第一講%%%%%%%%%%%%%%%5
            result = arrayfun(@(i) Cov_distance(state,other_state(:,i),1),1:N);%鳥とその他（ドローンを含む）の距離計算
            tmp = struct2cell(result);
            distance = cell2mat(tmp);%[distance;dx;dy;dz];
            if count >1
%                keep = pre_info{num}.state(4:6,end)-agent_v;
                for i=1:numel(fp)
                    d(:,i)=norm(state-fp{i});
                end
                [~,farm] = min(d);
                fp = fp{farm};
               keep = (fp-state)/norm(fp-state) ;
                %内積計算
                if pre_info.i==1
                    agent_v = arrayfun(@(AAA) (state-[0;0;0])/0.1,1:N,'UniformOutput',false);
                else
                    agent_v = arrayfun(@(AAA) (state-pre_info.Data.agent{pre_info.i-1,4,AAA}.state.p)/0.1,1:N,'UniformOutput',false);
                end
                result = arrayfun(@(i) Cov_distance(other_state(:,i),state,1),1:N);
                tmp = struct2cell(result);
                dis = cell2mat(tmp);
                AA = arrayfun(@(i) dot(agent_v{num}(1:2),dis(2:3,:,i)),1:Nb);
                %前にいるやつの把握
                flont = AA;
                
%                k5 = 0;%*distance{N}.result/(distance{N}.result + A.result);%%畑へ向かう力

            end
            % 凝集入力
            if i~=num&&i<=Nb&&flont(i)==1
                if distance(1,:,i)<rc&&distance(1,:,i)>0.
                    tarm1(:,i) = -(1-[R^3/distance(1,:,i)^3])*[distance(1,:,i)];
                    adjust(:,i) = agent_v{i} - agent_v{num};                       
                end
            end
            for i=Nb+1:N%ドローンから逃げる力
                away(:,i) = (distance(2:4,:,i))/norm(distance(2:4,:,i));
            end     
            %%目標位置に向かう用のやつ
            if rand(1)>0.5
                r= -0.1;
            else 
                r=0.1;
            end
            fp = fp(1:2) + r * rand(1);
            fp = [fp;1];
            if fp-state==0
                go_farm = (fp-state);
            else
                go_farm = (fp-state)/norm(fp-state);
            end
            
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
%             kind_speed = 82 * 10/36;%鳥の平均飛行速度
%             ref_point = fp;
%             th_xd = atan2(ref_point(2)-state(2),ref_point(1)-state(1));%角速度
%             figure;
%             scatter(ref_point(1),ref_point(2),'r')
%             hold on;
%             scatter(state(1),state(2),'b')
%             xlim([state(1)-norm(ref_point-state)-3,state(1)+norm(ref_point-state)+3])
%             ylim([state(2)-3-norm(ref_point-state),state(2)+3+norm(ref_point-state)])
%             qtrans = quat2eul(q');
%             q3 = qtrans(3);
%             th_dd = th_xd-q3;
%             if th_dd>pi
%                 q3=q3+2*pi;
%             elseif th_dd<=-pi
%                 q3= q3-2*pi;
%             end
%                         th_dd = th_xd-q3;
%             eul = [0,0,th_dd];
%             quat = eul2quat(eul);
            obj.result.state.u = input;
            result = obj.result;
        end
        function show(obj,param)
        end
    end
end

