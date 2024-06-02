classdef TIME_VARYING_REFERENCE_SPLIT < handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    properties
        param
        func % 時間関数のハンドル
        self
%         agent1 % cooprative情報
        ref_set
        t=[];
        cha='s';
        com % 使用制御モデル->"HL"or"Cooperative"or"Suspended"or"Split"
        dfunc
        result
        N
        P
        Pdagger
        K
        vi_pre
        muid
        m
        toR
        Muid_method
        base_time
        base_state
        ts
        te = 4;
        zd = 1; % goal altitude
        

    end

    methods
        function obj = TIME_VARYING_REFERENCE_SPLIT(self, args, agent1)
            % 【Input】ref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            arguments
                self   
                args
                agent1
            end            
            obj.self = self;   
%             obj.agent1 = agent1;
            obj.N = args{4};
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
%             obj.func = gen_func_name(param_for_gen_func{:});
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));                    
                
                elseif strcmp(args{3}, "Cooperative")
                    obj.ref_set.method = args{1};
                    obj.ref_set.orig = param_for_gen_func;
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL_Cooperative_Load(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3]));

                    obj.result.state.set_state("xd",obj.func(0));
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));%!!!!!!
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                    obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));


                elseif strcmp(args{3}, "Take_off")
                    obj.ref_set.method = args{1};
                    obj.com = args{3};
%                     obj.ref_set.method = "gen_ref_sample_take_off";
                    obj.ref_set.orig = param_for_gen_func;
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL_Cooperative_Load(temp);
%                   
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3])); 

                    obj.result.state.set_state("xd",obj.func(0));
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                    obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));

                elseif strcmp(args{3}, "Split")%ドローン目標軌道
                    obj.com = args{3};
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));  

                    % obj.P = self.parameter.get("all","row");
                    obj.P = self.parameter.get();
                    P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],agent1.parameter.rho));
                    obj.Pdagger = pinv(P);
                    obj.Muid_method = str2func(agent1.controller.Param.method2);
                    obj.result.mLi = [];
                    obj.result.Muid = [];

                    if agent1.estimator.model.state.type ==3
                        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
                    else
                        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
                    end

                    obj.result.state.set_state("xd",zeros(24,1));
                    obj.vi_pre = obj.result.state.xd(9:11);
                    obj.result.vi_pre = obj.vi_pre;
                
                elseif strcmp(args{3}, "Suspended")
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3])); 

                    obj.result.state.set_state("xd",obj.func(0));
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                else
                    obj.result.state.set_state("xd",obj.func(0));
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                end
            end
               
            
            
        end
        function result = do(obj, varargin)%chaによって単機のtakeoffやlandingに切り換えられるようにする．普通のTIME_VARYING_REFERENCEを参考にする
           dt = varargin{1}.dt;
           obj.cha = varargin{2};
           if obj.cha=='f'&& ~isempty(obj.t)    %flightからreferenceの時間を開始
                t = varargin{1}.t-obj.t; % 目標重心位置（絶対座標）
           else
                obj.t=varargin{1}.t;
                t = obj.t;
           end
           if strcmp(obj.com, "Split")
               %================================================
               % ~0は分割前ペイロード，~iは分割後のペイロードを表す
               %================================================
               agent1 = varargin{3};
               id     = obj.self.id - 1;                    %機体の番号
               %parameter
               mi   = obj.P(1);                             %機体の質量
               li   = obj.P(end);                           %紐の長さ
               g    = [0;0;obj.P(9)];                       %重力加速度
               rhoi = agent1.parameter.rho(:,obj.self.id-1);%ペイロードの中心位置からリンクまでの距離
               %reference
               ref0 = agent1.reference.result.state.xd;     %分割前のペイロード目標軌道[xd;dxd;d2xd;d3xd;d4xd;d5xd;o0d;do0d;reshape(R0d,[],1)]
               x0d  = ref0(1:3);
               dx0d = ref0(4:6);
               o0d  = ref0(19:21);                          %分割前目標角速度
               do0d = ref0(22:24);                          %分割前目標角加速度
               %state
               model= agent1.estimator.result.state;        % x = model.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
               Q0   = model.Q;
               O0   = model.O;
               v0   = model.v;
               a0   = model.a;
               dO0  = model.dO;
               qi   = model.qi(3*id-2:3*id);
               wi   = model.wi(3*id-2:3*id);
               

           %紐接合部の目標軌道を算出
           %todo:ペイロードの姿勢も考慮する場合は角度の5階微分まで求める必要がある
               %================================================================================
               % R0d = reshape(x0d(end-8:end),3,3);%分割前ペイロードの目標回転行列
               R0d  = agent1.reference.result.state.getq("rotm");%ペイロード角度固定
               %================================================================================
               dR0d = R0d*Skew(o0d);        %分割前ペイロードの目標回転行列
               xid  = x0d + R0d*rhoi;       %分割後のペイロードの位置目標軌道
               dxid = dx0d + dR0d*rhoi;     %分割後のペイロードの速度目標軌道
               % d2xid = x0d(7:9) - g + (dR0d*Skew(o0d) + R0d*Skew(do0d))*rho;%分割後のペイロードの加速度目標軌道!!!!!!!!!!!!!
           %目標軌道を格納：角度変化しない場合なので目標軌道の時間微分のみ(回転方向の微分なし)
               refi         = zeros(24,1);  %機体のreference
               refi(1:4)    = [xid;0];      %yaw refernce = 0を代入
               diff_refi    = [reshape(ref0(4:18),3,[]);zeros(1,5)];
               refi(5:24)   = reshape(diff_refi,[],1);

           %実際のリンクと紐の加速度と張力:Mq使う必要ある？何かおかしい
               R0   = obj.toR(Q0);                                          %分割前ペイロードの回転行列
               dR0  = R0*Skew(O0);                                          %分割前ペイロードの回転行列の微分
               Ri   = obj.self.estimator.result.state.getq("rotm");         %機体回転行列
               vi   = v0 + dR0*rhoi;                                        %分割後のペイロードの速度
               ai   = a0 + g + R0*Skew(O0)^2*rhoi - R0*Skew(rhoi)*dO0;      %分割後のペイロードの加速度
               qqTi = qi*qi';
               uli  = qqTi*Ri*[0;0;obj.self.controller.result.input(1)];    %前時刻のもの離散時間なので現在時刻まで同じ入力が入ると仮定
               mui  = uli - mi*li*(wi'*wi)*qi - mi*qqTi*ai;                 %(15) 実際の張力
           %理想的な張力から張力を求める場合
               % id = obj.self.id;
               % muid_mui = agent1.controller.result.mui; %3xN 
               % mui = muid_mui(4:6,id-1); %3x1%
               % obj.result.Mui = mui';
           %加速度の算出の仕方を変更========================
               %referenceをそのまま使うタイプ
               %------------------------------------------------------
               % a =obj.result.state.xd(9:11);%各リンクの加速度を求めていないので修正が必要,これだとa=0!!!!!!!
               %------------------------------------------------------
               % a = d2xid;%各リンクのreferenceの加速度
               % vi = vrho;
               % a = (vi - obj.vi_pre)/dt;%各リンクのreference速度から差分で加速度を求める．
               
               %ペイロードの速度からリンクの速度を求めてそこからリンクの加速度求める
               % ai = (vi - obj.vi_pre)/dt; 
               % obj.vi_pre = vi;
           % =============================================
           %分割後質量推定 mLi*ai = -mLi*g +
           %muiなんか質量が1/2になるtodo何目線から見るかで加速度の値を変える必要あり？
               A    = ai + g;%
               AtA  = A'*A;
               mLi  = (AtA\A')*mui;%分割後質量
           %log
               obj.result.state.xd = refi;
               obj.result.state.p  = xid;
               obj.result.state.v  = dxid;
               obj.result.mui      = mui';
               obj.result.vi_pre   = vi;
               obj.result.ai       = ai;
               obj.result.mLi      = mLi;

           elseif strcmp(obj.com, "Take_off")
               if isempty( obj.base_state ) % first take
               obj.base_time=varargin{1}.t;
               obj.base_state = obj.self.estimator.result.state.p;
               obj.result.state.xd = [obj.base_state;obj.result.state.xd(4:27,1)];
%                  
               end
           obj.result.state.xd(1:12,1) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
           obj.result.state.p = obj.result.state.xd(1:3,1);
           obj.result.state.v = obj.result.state.xd(4:6,1);
           elseif strcmp(obj.com, "Take_off2")
               if isempty( obj.base_state ) % first take
               obj.base_time=varargin{1}.t;
               obj.base_state = obj.self.estimator.result.state.p;
               obj.result.state.xd = [obj.base_state;obj.result.state.xd(4:27,1)];
%                  
               end
           obj.result.state.xd(1:12,1) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
           temp = obj.func(t);
           obj.result.state.xd(1:2,1) = temp(1:2,1);
           obj.result.state.xd(4:5,1) = temp(4:5,1);
           obj.result.state.xd(7:8,1) = temp(7:8,1);
           obj.result.state.xd(10:11,1) = temp(10:11,1);
           obj.result.state.p = obj.result.state.xd(1:3,1);
           obj.result.state.v = obj.result.state.xd(4:6,1);
           else
               obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
               refi = obj.result.state.xd;
               obj.result.state.p = refi(1:3);
               %新しく追加p以外の値も格納するように変更(記録用)!!!!!!!!!
               obj.result.state.v = refi(4:6);
               %ペイロードの角度変化させないときはコメントアウトでいい!!!!!!
               % R0d = reshape(xd(end-8:end),3,3);
               % obj.result.state.q = Quat2Eul(R2q(R0d));%目標角度を更新軌道が事変しないとき時は現在の角度になるようにする．               
               % obj.result.state.o = xd(13:15);
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

        function Xd = gen_ref_for_take_off(obj,t)
          %% Setting
          % calc reference position and its higher time derivatives
          % reference designed as a 9-degree polynomial function of time
          % [Inputs]
          % t : current time
          %
          % [Output]
          % Xd : reference [[p;yd], [p^(1);0], [p^(2);0], [p^(3);0], [p^(4);0]] as column vector
          %    : Xd in R^20
          %    : yd is a yaw angle reference
    
          %% Variable set
          Xd  = zeros( 12, 1);
          zd = 1;
          d = zd-obj.base_state(3,1); % goal altitude : relative value
          te = obj.te; % terminal time to reach zd
          %% Set Xd
          if t<=te
            tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
            dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
            ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
            d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
            d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
          elseif t> te
            tra=d;
            dtra = 0;
            ddtra = 0;
            d3tra = 0;
            d4tra = 0;
          end
          Xd(1:3,1) = obj.base_state(1:3);
          Xd(3,1) = tra + Xd(3,1);
          Xd(6,1) = dtra;
          Xd(9,1) = ddtra;
          Xd(12,1) = d3tra;
%           Xd(19,1) = d4tra;
        end

    end
end