classdef ceiling_reference < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    properties
        param
        func % 時間関数のハンドル
        self
        margin
        t=[];
        cha='s';
        dfunc
        id
    end

    methods
        function obj = ceiling_reference(self, args)
            % 【Input】ref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            arguments
                self
                args
            end
            obj.self = self;
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
            obj.func = gen_func_name(param_for_gen_func);
            obj.id = self.sensor.motive.rigid_num;
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    obj.func = gen_ref_for_HL(obj.func);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));
                end
            else
                obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
            end
        end
        function result = do(obj, Param)  
            %Param={time,FH}　目標位置の算出
            if obj.id==1
                obj.cha = get(Param{2}, 'currentcharacter');
                if obj.cha=='f'&& ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{1}.t-obj.t; % 現在時刻 ‐ 前時刻
                    obj.t=Param{1}.t; %前時刻の保存
                else %前時刻の保存
                    obj.t=Param{1}.t;
                    t = obj.t;
                end
                 %% パラメータ
                p = obj.self.estimator.result.state.p;%自己位置
                sensor_state = obj.self.sensor.motive.result.rigid;
                a = [sensor_state(2).p(1);sensor_state(2).p(2)];%端点aの座標
                b = [sensor_state(3).p(1);sensor_state(3).p(2)];%端点bの座標
                M = (a+b)/2;
                sita = atan(-(p(2)-M(2))/(p(1)-M(1)));
                margin_y = 1;
                %% x座標
                goal_potential = obj.func(t);%目標位置に向かうポテンシャル
                if Param{6}==1
                    obs_potential_x = -obj.func(t)/(obj.self.sensor.VL.result.distance.teraranger)^2;%障害物からのポテンシャル(実験用)
                else
                    if p(2)<a(2)&&p(2)>b(2)&&p(1)<M(1)
                        dicetance_wall = M(1)-p(1);
                    else
                        dicetance_wall = M(1)-p(1)+3;
                    end
                        obs_potential_x = -obj.func(t)/(dicetance_wall)^2;%障害物からのポテンシャル
                end
                obj.result.state.p = obs_potential_x + goal_potential;%potentialの合成
                obj.result.state.p(1) = p(1) + obj.result.state.p(1);%現在位置にpotentialを付与
                %% y座標
%                 w_y = 3;%重み
%                 v_y = 0.3;%デフォルトの速度
%                 if Param{6}==1
%                     obs_potential_y = w_y*v_y*sin(sita)/(obj.self.sensor.VL.result.distance.teraranger);%障害物からのポテンシャル
%                 else
%                     obs_potential_y = w_y*v_y*sin(sita)/(dicetance_wall);%障害物からのポテンシャル
%                 end
%                 goal_potential_y = -v_y*p(2)/abs(-M(2)+(a(2)-b(2))/2+margin_y);
%                 obj.result.state.p(6) = goal_potential_y+obs_potential_y;%y方向速度
%                 obj.result.state.p(2) = p(2) + t*obj.result.state.p(6);%y目標座標
                %%         y方向の設定
                w_y = 3;%障害物の重み
                weight_y = 0.7;%目標位置の重み
                obs_potential_y = w_y*0.5*sin(sita)/(distance_wall);%障害物からのポテンシャル
                goal_potential_y = -weight_y*0.5*p(2)/abs(a(2)-b(2));
                obj.result.state.p(6) = goal_potential_y+obs_potential_y;%y方向速度
                obj.result.state.p(2) = p(2) + t*obj.result.state.p(6);%目標座標
                %% %sensorの値から高度を指定　z座標
                margin_z = Param{4};
                if Param{6}==1
                    obj.result.state.p(3) = 1;%obj.self.sensor.VL.result.distance.VL + p(3) - margin_z;
                else
                    obj.result.state.p(3) = obj.self.sensor.celing.result.ceiling_distance + p(3) - margin_z;%z方向の目標位置
                end
                %% 目標位置にたどり着いたか
%                 if obj.cha =='f'
%                     if norm(Param{5}(1)-obj.self.reference.result.state.p(1)) < 0.1%目標位置にたどり着いたか
%                         obj.result.state.p(1) = p(1);%Param{5}(1);%その場停滞
%                         obj.result.state.p(5) = 0;
%                     end
%                     if norm(Param{5}(2)-obj.self.reference.result.state.p(2)) < 0.1%目標位置にたどり着いたか
%                        obj.result.state.p(2) = Param{5}(2);%その場停滞
%                     end
%                 end
            else
                obj.result.state.p = obj.self.estimator.result.state.p;
            end
           result = obj.result;
        end
        function show(obj, logger)
            rp = logger.data(1,"p","r");
            plot3(rp(:,1), rp(:,2), rp(:,3));                     % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep = logger.data(1,"p","e");
            plot3(ep(:,1), ep(:,2), ep(:,3));       % xy平面の軌道を描く
            legend(["reference", "estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end


