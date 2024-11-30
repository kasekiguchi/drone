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
        v0_pre
        vi_pre
        O0_pre 
        wi_pre
        ui_pre
        vdro_pre
        vL_pre
        muid
        m
        toR
        Muid_method
        base_time
        base_state
        ts
        te % goal time
        zd % goal altitude
        k_yaw
        rotForYaw

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
            obj.N = args{4};
            obj.P = self.parameter.get("all","row");
            
            % A6 = [0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0];
            % B6 = [0;0;0;0;0;1];
            % obj.k_yaw=lqrd(A6,B6,diag([100000,1000,100,10,10,10]),0.01,0.025);
            % rhoi = agent1.parameter.rho(:,obj.self.id-1);
            % yaw = acos([1,0]*rhoi(1:2)/norm(rhoi(1:2)));
            % obj.rotForYaw = eul2rotm([yaw,0,0]);

            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));                    
                
                elseif strcmp(args{3}, "Cooperative")%ペイロードの目標軌道
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


                elseif strcmp(args{3}, "TakeOff")%ペイロードの目標軌道takeoff用
                    obj.ref_set.method = args{1};
                    obj.com = args{3};
                    obj.te = 10;
                    obj.zd = 1;
                    
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3])); 

                    obj.result.state.set_state("xd",[obj.self.estimator.result.state.get("p");zeros(21,1);reshape(eye(3),[],1)]);%[xd;dxd;d2xd;d3xd;d4xd;d5xd;o0d;do0d;reshape(R0d,[],1)]
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                    obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));

                elseif strcmp(args{3}, "Split")%分割後の目標軌道
                    A6 = [0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0];
                    B6 = [0;0;0;0;0;1];
                    obj.k_yaw=lqrd(A6,B6,diag([1,1,10,10,10,10]),1,0.025);

                    obj.k_yaw=lqrd(0,1,1,1,0.025);
                    % rhoi = agent1.parameter.rho(:,obj.self.id-1);
                    % yaw = acos([1,0]*rhoi(1:2)/norm(rhoi(1:2)));
                    % yaw = atan2(rhoi(2),rhoi(1));
                    % obj.rotForYaw = eul2rotm([yaw,0,0]);

                    obj.com = args{3};
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "v", "ai","mui","mLi","aidrn","dwi"], 'num_list', [24, 3, 3, 3]));  
                    
                    P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],agent1.parameter.rho));
                    obj.Pdagger = pinv(P);
                    % obj.Muid_method = str2func(agent1.controller.Param.method2);
                    obj.result.mLi = [];
                    obj.result.Muid = [];

                    if agent1.estimator.model.state.type ==3
                        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
                    else
                        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
                    end

                    obj.result.state.set_state("xd",zeros(28,1));
                    % obj.vi_pre = obj.result.state.xd(9:11);
                    obj.vi_pre = zeros(3,1);
                    obj.v0_pre = zeros(3,1);
                    obj.O0_pre = zeros(3,1);
                    obj.wi_pre = zeros(3,1);
                    obj.result.vi_pre = obj.vi_pre;

                    obj.vdro_pre = zeros(3,1);
                    obj.vL_pre = zeros(3,1);
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
               g    = [0;0;-obj.P(9)];                       %慣性座標系の重力加速度ベクトル
               rhoi = agent1.parameter.rho(:,obj.self.id-1);%ペイロードの中心位置からリンクまでの距離
               %reference
               ref0 = agent1.reference.result.state.xd;     %分割前のペイロード目標軌道[xd;dxd;d2xd;d3xd;d4xd;d5xd;d6xd;o0d;do0d;reshape(R0d,[],1)]
               x0d  = ref0(1:3);
               dx0d = ref0(4:6);
               o0d  = ref0(22:24);                          %分割前目標角速度
               do0d = ref0(25:27);                          %分割前目標角加速度
               %state
               model= agent1.estimator.result.state;        % x = model.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
               Q0   = model.Q;
               O0   = model.O;
               v0   = model.v;
               a0   = model.a;%要チェック論文も!!!!!!!!!!!!!!
               dO0  = model.dO;
               Qi   = model.Qi(4*id-3:4*id);
               qi   = model.qi(3*id-2:3*id);
               wi   = model.wi(3*id-2:3*id);
               R0       = obj.toR(Q0);                                          %分割前ペイロードの回転行列
               dR0      = R0*Skew(O0);                                          %分割前ペイロードの回転行列の微分
               SKO0     = Skew(O0);                                             %SK:歪対称行列
               SKrhoi   = Skew(rhoi);
               SKqi     = Skew(qi);
               SKwi     = Skew(wi);
               % Ri       = obj.self.estimator.result.state.getq("rotm");         %機体回転行列
               Ri       = obj.toR(Qi);                                          %機体回転行列
               vi       = v0 + dR0*rhoi;                                        %分割後のペイロードの速度

           %紐接合部の目標軌道を算出
           %todo:ペイロードの姿勢も考慮する場合は角度の5階微分まで求める必要がある
               %================================================================================
               % R0d = reshape(x0d(end-8:end),3,3);%分割前ペイロードの目標回転行列
               R0d  = agent1.reference.result.state.getq("rotm");%ペイロード角度固定
               %================================================================================
               dR0d = R0d*Skew(o0d);        %分割前ペイロードの目標回転行列の微分
               xid  = x0d + rhoi;       %分割後のペイロードの位置目標軌道
               % xid  = x0d + R0d*rhoi;       %分割後のペイロードの位置目標軌道
               dxid = dx0d; %+ dR0d*rhoi;     %分割後のペイロードの速度目標軌道
               % d2xid = x0d(7:9) - g + (dR0d*Skew(o0d) + R0d*Skew(do0d))*rho;%分割後のペイロードの加速度目標軌道!!!!!!!!!!!!!
               %目標軌道を格納：角度変化しない場合なので目標軌道の時間微分のみ(回転方向の微分なし)
               refi         = zeros(28,1);  %機体のreference
               refi(1:4)    = [xid;0];      %yaw refernce = 0を代入
               drefi    = [reshape(ref0(4:21),3,[]);zeros(1,6)];%目標軌道微分
               refi(5:end)   = reshape(drefi,[],1);

               %牽引物yaw角補正================================================================================
               % agenti = varargin{5};
               % agenti = obj.self;
               id
               paramators = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "loadmass", "cableL"]);
                alpi = obj.self.sensor.result.state.pL(1:2) - agent1.sensor.result.state.p(1:2);
                alpi_unit = alpi/norm(alpi);%牽引物が垂直に傾かないと仮定
                alpi_v_unit = [-alpi_unit(2);alpi_unit(1)];%alpi_unitに垂直な単位ベクトル
                % rhoi_unit = rhoi(1:2)/norm(rhoi(1:2));

                % alpi = obj.self.sensor.result.state.pL - agent1.sensor.result.state.p;
                % alpi_unit = alpi/norm(alpi);%牽引物が垂直に傾かないと仮定
                % alpi_v_unit = [-alpi(2);alpi(1);0]/norm([-alpi(2);alpi(1);0]);%alpiに垂直でz方向が0となるベクトル,z軸反時計回りとなる
                % rhoi_unit = rhoi/norm(rhoi);%rhoの単位ベクトル
                % theta_alpi = acos(alpi_unit'*rhoi_unit);%alpiのrhoに対する回転角
                % rot_axis = cross(rhoi_unit,alpi_unit);%alpiのrhoに対する回転角の軸
                % q = obj.generate_quaternion(theta_alpi,rot_axis/norm(rot_axis));%alpiの回転を表すクオータニオン
                % eul = Quat2Eul(q);%euler角に変換
                % yaw = eul(3)%alpiのyaw回転角
                
                %ダメ
                % alpi = obj.self.sensor.result.state.pL(1:2) - agent1.sensor.result.state.p(1:2);
                % rhoi = rhoi(1:2);
                % deltai = alpi - rhoi;
                % alpi_true = alpi + deltai;
                % alpi_unit =  alpi/norm(alpi);
                % alpi_true_unit = alpi_true/norm(alpi_true);
                % delta_yaw = sign(cross([alpi_unit;0],[alpi_true_unit;0]))*acos(alpi_unit'*alpi_true_unit);
                % yaw = yaw + delta_yaw;


                yaw = atan2(alpi_unit(2),alpi_unit(1)) - atan2(rhoi(2),rhoi(1))%180以上回転した時の条件分岐を作る
                if abs(yaw)>10
                w = -obj.k_yaw*yaw;
                dw = (-obj.k_yaw)^2*yaw*0;%入力の微分dyaw = -k*yawの関係を用いる
                d2w = (-obj.k_yaw)^3*yaw*0;
                d3w = (-obj.k_yaw)^4*yaw*0;
                d4w = (-obj.k_yaw)^5*yaw*0;
                W = [zeros(2,5);w,dw,d2w,d3w,d4w];
                Vxyz = cross(W,[alpi;0]+zeros(3,5))';
                Vxy = reshape(Vxyz(:,1:2),[],1);
                signVxy = sign(Vxy);
                refxy = [refi((2:6) *4 -3);refi((2:6) *4 -2)];
                
                ref_new = signVxy.*max(signVxy.*Vxy,signVxy.*refxy);
                refi_4_ = reshape(refi,4,[]);
                refi_4_(1:2,2:6) = reshape(ref_new,5,2)';
                refi = reshape(refi_4_,[],1);
                aaa = ref_new - Vxy
                end
                % alpi_unit-rhoi_unit
                % model = obj.self.estimator.result;
                % x = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
                % 
                % F1 = obj.self.controller.load.param.F1;
                % vf = Vfd_SuspendedLoad(dt,x,refi',paramators,F1);
                % refxId = (1:6) *4 -3; 
                % refyId = (1:6) *4 -2;
                % X = Z2_SuspendedLoad(x,refi',vf,paramators) + refi(refxId);%zで設計された現時刻の入力を用いるので少し違う
                % Y = Z3_SuspendedLoad(x,refi',vf,paramators) + refi(refyId);%zで設計された現時刻の入力を用いるので少し違う
                % % X = Z2_SuspendedLoad(x,zeros(28,1)',vf,paramators);
                % % Y = Z3_SuspendedLoad(x,zeros(28,1)',vf,paramators);
                % 
                % V = dot(alpi_v_unit.*ones(2,5),[X(2:6)';Y(2:6)']).*alpi_v_unit;%alpi_unitpへ射影
                % W = cross([alpi_unit;0].*ones(3,5),[V;zeros(1,5)]);%グローバルのz軸回りの角速度ベクトル
                % u_yaw = -obj.k_yaw*[yaw,W(3,:)]';%必要なyaw角の6階微分
                % u_xy = cross([0;0;u_yaw],[alpi;0])
                % obj.result.u_yaw = u_xy(1:2);


               %================================================================================

           %実際のリンクと紐の加速度と張力,機体の加速度を求めてから張力を求める           
           %方針：計測した値を用いて各単機モデルで推定する．
               % ai       = a0 + R0*SKO0^2*rhoi - R0*SKrhoi*dO0;      %分割後のペイロードの加速度
               ai = (vi - obj.vi_pre)/dt; 
               obj.vi_pre = vi;
               a0 = (v0 - obj.v0_pre)/dt; 
               obj.v0_pre = v0;
               dO0 = (O0 - obj.O0_pre)/dt; %差分を使うとダメ
               % obj.O0_pre = dO0;
               dwi = (wi - obj.wi_pre)/dt; %紐の角加速度%発散に関係なさそう
               obj.wi_pre = wi;
               %張力を算出
               % qqTi     = qi*qi';
               ui       = Ri*[0;0;obj.self.controller.result.input(1)];%推力,離散時間なので現在時刻まで同じ入力が入ると仮定
               % uvi      = (eye(3) - qqTi)*ui;                               %uの垂直成分
               % aig      = a0 + g + R0*SKO0^2*rhoi - R0*SKrhoi*dO0;      %紐の角加速度算出に用いる加速度
               % dwi      = (SKqi*aig - SKqi*uvi/mi)/li;              %(8)
               aidrn    = a0 + R0*SKO0^2*rhoi - R0*SKrhoi*dO0 + li*SKqi*dwi - li*SKwi^2*qi;      %分割後の機体の加速度
               mui      = mi*aidrn - mi*g - ui;                 %ドローン座標系からの張力
               mui      = -mui;%分割後の牽引物系から張力
                
               %単機牽引モデルで推定した機体速度，牽引物速度を用いて後退差分によりそれぞれの加速度を算出
               ui       = Ri*[0;0;obj.self.controller.result.input(1)];%推力,離散時間なので現在時刻まで同じ入力が入ると仮定
               vdro = obj.self.estimator.result.state.v;
               aidrn = (vdro - obj.vdro_pre)/dt; %機体加速度%前時刻の運動方程式から加速度求めてもいいかも
               obj.vdro_pre = vdro;
               vL = obj.self.estimator.result.state.vL;
               ai = (vL - obj.vL_pre)/dt;%牽引物加速度
               obj.vL_pre = vL;
               mui      = mi*aidrn - mi*g - ui;                 %ドローン座標系からの張力
               mui      = -mui;%分割後の牽引物系から張力

               % delta_a0 = v0 - a0
               % delta_ai = vi - ai
           %ペイロードの速度からリンクの速度を求めてそこからリンクの加速度求める
               % id = obj.self.id;
               % muid_mui = agent1.controller.result.mui; %3xN 
               % mui = muid_mui(1:3,id-1); %3x1%理想の張力
               % % mui = muid_mui(4:6,id-1); %3x1%現実の張力
               % ai = (vi - obj.vi_pre)/dt; 
               % obj.vi_pre = vi;

           %分割後質量推定 mLi*ai = mLi*g + mui
               A    = ai - g;%
               AtA  = A'*A;
               mLi  = (AtA\A')*mui;%分割後質量
               % mLi  = mLi;
           %log
               obj.result.x0d     = x0d;
               obj.result.R0d     = R0d;
               obj.result.state.xd      = refi;
               obj.result.state.p       = xid;
               obj.result.state.v       = dxid;
               obj.result.state.mui     = mui';
               % obj.result.state.vi_pre  = vi;
               obj.result.state.ai      = ai;
               obj.result.state.aidrn   = aidrn;
               obj.result.state.dwi     = dwi;
               obj.result.state.mLi     = mLi;

           elseif strcmp(obj.com, "TakeOff")
               if isempty( obj.base_state )
                   obj.base_time=varargin{1}.t;
                   obj.base_state = obj.self.estimator.result.state.p;
                   obj.result.state.xd(1:18) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
                   obj.result.state.xd(3) = obj.result.state.xd(3) + 1e-5;
               else
                   obj.result.state.xd(1:18) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
               end
               obj.result.state.p = obj.result.state.xd(1:3,1);
               obj.result.state.v = obj.result.state.xd(4:7,1);
               % 牽引物の加速度と角加速度を求める
                   x = obj.self.estimator.result.state.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
                   R0 = RodriguesQuaternion(x(4:7));
                   Ri = RodriguesQuaternion(reshape(x(50:73),4,[]));
                   u = obj.self.controller.result.input;
                   ddX0 = ddx0do0_6(x,R0,Ri,u,obj.P,inv(Addx0do0_6(x,R0,u,obj.P)));
                   obj.self.estimator.result.state.a   = ddX0(1:3);
                   obj.self.estimator.result.state.dO  = ddX0(4:6);
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
               % 牽引物の加速度と角加速度を求める
               if 0
                   x = obj.self.estimator.result.state.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
                   R0 = RodriguesQuaternion(x(4:7));
                   Ri = RodriguesQuaternion(reshape(x(50:73),4,[]));
                   u = obj.self.controller.result.input;
                   ddX0 = ddx0do0_6(x,R0,Ri,u,obj.P,inv(Addx0do0_6(x,R0,u,obj.P)));
                   obj.self.estimator.result.state.a   = ddX0(1:3);
                   obj.self.estimator.result.state.dO  = ddX0(4:6);
               end
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
          % Xd : reference [p; p^(1);p^(2); p^(3);p^(4);p^(5)] as column vector
    
          %% Variable set
          Xd  = zeros(18, 1);
          d = obj.zd - obj.base_state(3,1); % goal altitude : relative value
          te = obj.te; % terminal time to reach zd
          %% Set Xd
          if t<=te
            tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
            dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
            ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
            d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
            d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
            d5tra = (15120*d)/te^5 - (302400*d*t)/te^6 + (1360800*d*t^2)/te^7 - (2116800*d*t^3)/te^8 + (1058400*d*t^4)/te^9;
          elseif t> te
            tra=d;
            dtra = 0;
            ddtra = 0;
            d3tra = 0;
            d4tra = 0;
            d5tra = 0;
          end
          Xd(1:3,1) = obj.base_state(1:3);
          Xd(3,1) = tra + Xd(3,1);
          Xd(6,1) = dtra;
          Xd(9,1) = ddtra;
          Xd(12,1) = d3tra;
          Xd(15,1) = d4tra;
          Xd(18,1) = d5tra;
        end

        function q = generate_quaternion(obj,theta_alpi,rot_axis)
            q = [
                cos(theta_alpi/2);
                rot_axis*sin(theta_alpi/2);
                ];
        end

    end
end