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
        ftakeoff = 0
        flanding = 0
        base_time_takeoff
        base_time_landing
        base_state_takeoff
        base_state_landing
        ts
        te_takeoff = 15% goal time
        zd_takeoff = 0.5 % goal altitude
        te_landing = 20% goal time
        k_yaw
        rotForYaw
        errorVector
        agent1
        yawRef
        yawSum = 0

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
            obj.agent1=agent1;
            obj.self = self;
            obj.N = args{4};
            obj.P = self.parameter.get("all","row");

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
                    obj.te_takeoff = 10;
                    obj.zd_takeoff = 1;
                    
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3])); 

                    obj.result.state.set_state("xd",[obj.self.estimator.result.state.get("p");zeros(21,1);reshape(eye(3),[],1)]);%[xd;dxd;d2xd;d3xd;d4xd;d5xd;o0d;do0d;reshape(R0d,[],1)]
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                    obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                    obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));

                elseif strcmp(args{3}, "Split")%分割後の目標軌道
                    % A6 = [0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0];
                    % B6 = [0;0;0;0;0;1];
                    % obj.k_yaw=lqrd(A6,B6,diag([1,1,10,10,10,10]),1,0.025);

                    obj.k_yaw=lqrd(0,1,1,1,0.025);
                    obj.k_yaw=0.5;
                    obj.yawRef = obj.generate_yawReference(obj.k_yaw);

                    obj.com = args{3};
                    % obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "v", "ai","mui","mLi","aidrn","dwi","yaw"], 'num_list', [24, 3, 3, 3]));  
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "yaw","aaa"], 'num_list', [28, 3, 1,1]));  
                    obj.result.state.set_state("xd",zeros(28,1));
                    obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                    % obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                    obj.result.state.yaw=0;

                    P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],obj.agent1.parameter.rho));
                    obj.Pdagger = pinv(P);
                    % obj.Muid_method = str2func(obj.agent1.controller.Param.method2);
                    
                    if class(obj.agent1.sensor) == "MOTIVE"
                        obj.toR=eye(3);
                    else
                        if obj.agent1.estimator.model.state.type ==3 
                            obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
                        else
                            obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
                        end
                    end
                    
                    % obj.vi_pre = obj.result.state.xd(9:11);
                    % obj.vi_pre = zeros(3,1);
                    % obj.v0_pre = zeros(3,1);
                    % obj.O0_pre = zeros(3,1);
                    % obj.wi_pre = zeros(3,1);
                    % 
                    % obj.vdro_pre = zeros(3,1);
                    % obj.vL_pre = zeros(3,1);
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
               % agent1 = varargin{3};
               id     = obj.self.id - 1;                    %機体の番号
               %parameter
               % mi   = obj.P(1);                             %機体の質量
               % li   = obj.P(end);                           %紐の長さ
               g    = [0;0;-obj.P(9)];                       %慣性座標系の重力加速度ベクトル
               rhoi = obj.agent1.parameter.rho(:,id);%ペイロードの中心位置からリンクまでの距離
               %reference
               ref0 = obj.agent1.reference.result.state.xd;     %分割前のペイロード目標軌道[xd;dxd;d2xd;d3xd;d4xd;d5xd;d6xd;o0d;do0d;reshape(R0d,[],1)]
               x0d  = ref0(1:3);
               % dx0d = ref0(4:6);
               % o0d  = ref0(22:24);                          %分割前目標角速度
               % do0d = ref0(25:27);                          %分割前目標角加速度
               % %state
               % model= obj.agent1.estimator.result.state;        % x = model.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
               % Q0   = model.Q;
               % O0   = model.O;
               % v0   = model.v;
               % a0   = model.a;%要チェック論文も!!!!!!!!!!!!!!
               % dO0  = model.dO;
               % Qi   = model.Qi(4*id-3:4*id);
               % qi   = model.qi(3*id-2:3*id);
               % wi   = model.wi(3*id-2:3*id);
               % R0       = obj.toR(Q0);                                          %分割前ペイロードの回転行列
               % dR0      = R0*Skew(O0);                                          %分割前ペイロードの回転行列の微分
               % SKO0     = Skew(O0);                                             %SK:歪対称行列
               % SKrhoi   = Skew(rhoi);
               % SKqi     = Skew(qi);
               % SKwi     = Skew(wi);
               % % Ri       = obj.self.estimator.result.state.getq("rotm");         %機体回転行列
               % Ri       = obj.toR(Qi);                                          %機体回転行列
               % vi       = v0 + dR0*rhoi;                                        %分割後のペイロードの速度

           %紐接合部の目標軌道を算出
           %todo:ペイロードの姿勢も考慮する場合は角度の5階微分まで求める必要がある
               %================================================================================
               % R0d = reshape(x0d(end-8:end),3,3);%分割前ペイロードの目標回転行列
               % R0d  = obj.agent1.reference.result.state.getq("rotm");%ペイロード角度固定
               %================================================================================
               if obj.cha == 'f'
                   obj.ftakeoff = 0;
                   obj.flanding = 0;
                   xid  = x0d + rhoi + 0.0*rhoi/norm(rhoi);       %分割後のペイロードの位置目標軌道
                   %目標軌道を格納：角度変化しない場合なので目標軌道の時間微分のみ(回転方向の微分なし)
                   refi         = zeros(28,1);  %機体のreference
                   refi(1:4)    = [xid;0];      %yaw refernce = 0を代入
                   drefi    = [reshape(ref0(4:21),3,[]);zeros(1,6)];%目標軌道微分
                   refi(5:end)   = reshape(drefi,[],1);

               elseif obj.cha =='t'
                   obj.flanding = 0;
                   if isempty( obj.base_state_takeoff )
                       p = obj.self.sensor.result.state.p; 
                       obj.base_time_takeoff =varargin{1}.t;
                       obj.base_state_takeoff = [p(1:2);p(3)-obj.self.parameter.get("cableL")];%obj.self.estimator.result.state.p;
                   end
                   if obj.self.sensor.result.state.p(3)>=0.3&& obj.ftakeoff == 0
                       obj.ftakeoff =1;
                       obj.base_state_takeoff(1:2) = obj.self.sensor.result.state.real_pL(1:2);
                   end
                       refi = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time_takeoff);
                       th_offset = obj.self.input_transform.param.th_offset;
                       % th_offset_takeoff = obj.self.input_transform.param.th_offset_tl;
                       th_offset_takeoff = 260;
                       obj.self.input_transform.param.th_offset_tl = th_offset_takeoff + (th_offset-th_offset_takeoff)*min(obj.te_takeoff,varargin{1}.t-obj.base_time_takeoff)/obj.te_takeoff;
                       x0d = refi(1:3) - rhoi;
               elseif obj.cha =='l'
                   obj.ftakeoff = 0;
                   if isempty(obj.base_state_landing) 
                       obj.base_time_landing =varargin{1}.t;
                       obj.base_state_landing = obj.self.sensor.result.state.pL;
                   end
                   if obj.self.sensor.result.state.p(3)<=0.4&& obj.flanding==0
                       obj.flanding  =1;
                       alpi = obj.self.sensor.result.state.pL(1:2) - obj.agent1.sensor.result.state.p(1:2);
                       alpiUnit = alpi/norm(alpi);
                       obj.base_state_landing(1:2) = obj.self.sensor.result.state.real_pL(1:2) + 0.4*alpiUnit;
                   end
                       th_offset = obj.self.input_transform.param.th_offset;
                       % th_offset_landing = obj.self.input_transform.param.th_offset_tl;
                       th_offset_landing = 260;
                       refi = obj.gen_ref_for_landing(varargin{1}.t-obj.base_time_landing);
                       obj.self.input_transform.param.th_offset_tl_tmp = th_offset - (th_offset-th_offset_landing)*min(obj.te_landing,varargin{1}.t-obj.base_time_landing)/obj.te_landing;
                       x0d = refi(1:3) - rhoi;
               else
                   refi = zeros(28,1);
                end
               %牽引物yaw角補正================================================================================
               % agenti = varargin{5};
               % agenti = obj.self;
               id
               % paramators = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "loadmass", "cableL"]);
                alpi = obj.self.sensor.result.state.pL(1:2) - obj.agent1.sensor.result.state.p(1:2);
                alpiUnit = alpi/norm(alpi);%牽引物が垂直に傾かないと仮定
                % alpiVecUnit = [-alpiUnit(2);alpiUnit(1)];%alpi_unitに垂直な単位ベクトル
                rhoiUnit = rhoi(1:2)/norm(rhoi(1:2));

                yaw = sign(rhoiUnit'*[alpiUnit(2);-alpiUnit(1)])*real(acos(alpiUnit'*rhoiUnit));%rhoiUnit'*[alpiUnit(2);-alpiUnit(1)] : cross([rhoiUnit;0],[alpiUnit;0]の3つめ
                %誤差を加算していきyaw補正をするための目標位置を生成
                obj.yawSum = obj.yawSum + yaw;
                aaa = obj.yawSum
                k=0.01;
                if obj.self.sensor.result.state.real_pL(3)>=0.3
                    refi(1:2) = [cos(-k*obj.yawSum),-sin(-k*obj.yawSum);sin(-k*obj.yawSum),cos(-k*obj.yawSum)]*refi(1:2);
                end
                %yaw補正をするための目標速度と高次微分を計算
                yaw*180/pi
                if abs(obj.yawSum)>10*pi/180 && obj.agent1.sensor.result.state.p(3)>0.2%&& abs(yaw) < 170*pi/180 %pi
                % if abs(yaw)>20*pi/180 && obj.agent1.sensor.result.state.p(3)>-0.2%&& abs(yaw) < 170*pi/180 %pi
                yaw = obj.yawSum;
                    if isempty(obj.errorVector)
                        obj.errorVector = obj.agent1.sensor.result.state.p(1:2) - x0d(1:2);
                    end
    
                    w = -obj.k_yaw*yaw;
                    dw = (-obj.k_yaw)^2*yaw*1;%入力の微分dyaw = -k*yawの関係を用いる
                    d2w = (-obj.k_yaw)^3*yaw*1;
                    d3w = (-obj.k_yaw)^4*yaw*1;
                    d4w = (-obj.k_yaw)^5*yaw*1;
                    W = [zeros(2,5);w,dw,d2w,d3w,d4w];%加速度と微分
                    % vL = obj.self.estimator.result.state.vL;
                    % if vL~=0
                    %     vLVec = [alpiVecUnit;0]'* vL/norm(vL)*vL;
                    % else
                    %     vLVec = 0;
                    % end
                    % A = [0,norm(vLVec)^2,zeros(1,3)]/norm(rhoi(1:2));%向心方向加速度
                    Vxyz = cross(W,[alpi;0]+zeros(3,5));
                    refi4_ = reshape(refi,4,[]);
                    refi4_(1:2,2:6) = refi4_(1:2,2:6)*0 + Vxyz(1:2,:);% - A.*alpiUnit;%接線方向と向心方向(alpiUnitは半径方向なので符号を反転させる)のref
                    refi = reshape(refi4_,[],1);
                    %yaw修正中の目標軌道
                    % x0dForCorrection = x0d(1:2) + obj.errorVector;
                    % refi(1:2) = alpi + x0dForCorrection;

                    % %new version
                    % thetaAlp = acos(alpiUnit'*[1;0]);
                    % fsign = sign(cross([1;0;0],[alpiUnit;0]));
                    % if fsign(3) < 0
                    %     thetaAlp = 2*pi - thetaAlp; 
                    % end
                    % newRef = obj.yawRef(norm(rhoi(1:2)),yaw,thetaAlp,0);
                    % refi4_ = reshape(refi,4,[]);
                    % refi4_(1:2,1:6) = [newRef(:,1) + x0dForCorrection,newRef(:,2:6)];
                    % refi = reshape(refi4_,[],1);

                else
                    obj.errorVector=[];
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
           %log
               % obj.result.x0d     = x0d;
               % obj.result.R0d     = R0d;
               obj.result.state.xd      = refi;
               obj.result.state.yaw      = yaw;
               obj.result.state.aaa      = aaa*180/pi;
               % obj.result.state.p       = xid;
               % obj.result.state.v       = dxid;
               % obj.result.state.mui     = mui';
               % obj.result.state.vi_pre  = vi;
               % obj.result.state.ai      = ai;
               % obj.result.state.aidrn   = aidrn;
               % obj.result.state.dwi     = dwi;
               % obj.result.state.mLi     = mLi;

           % elseif strcmp(obj.com, "TakeOff")
           %     if isempty( obj.base_state )
           %         obj.base_time=varargin{1}.t;
           %         obj.base_state = obj.self.estimator.result.state.p;
           %         obj.result.state.xd(1:18) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
           %         obj.result.state.xd(3) = obj.result.state.xd(3) + 1e-5;
           %     else
           %         obj.result.state.xd(1:18) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
           %     end
           %     obj.result.state.p = obj.result.state.xd(1:3,1);
           %     obj.result.state.v = obj.result.state.xd(4:7,1);
           %     % 牽引物の加速度と角加速度を求める
           %         x = obj.self.estimator.result.state.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
           %         R0 = RodriguesQuaternion(x(4:7));
           %         Ri = RodriguesQuaternion(reshape(x(50:73),4,[]));
           %         u = obj.self.controller.result.input;
           %         ddX0 = ddx0do0_6(x,R0,Ri,u,obj.P,inv(Addx0do0_6(x,R0,u,obj.P)));
           %         obj.self.estimator.result.state.a   = ddX0(1:3);
           %         obj.self.estimator.result.state.dO  = ddX0(4:6);
           else
               obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
               % refi = obj.result.state.xd;
               % obj.result.state.p = refi(1:3);
               % %新しく追加p以外の値も格納するように変更(記録用)!!!!!!!!!
               % obj.result.state.v = refi(4:6);
               %ペイロードの角度変化させないときはコメントアウトでいい!!!!!!
               % R0d = reshape(xd(end-8:end),3,3);
               % obj.result.state.q = Quat2Eul(R2q(R0d));%目標角度を更新軌道が事変しないとき時は現在の角度になるようにする．               
               % obj.result.state.o = xd(13:15);
               % 牽引物の加速度と角加速度を求める
           %     if 0
           %         x = obj.self.estimator.result.state.get(["p"  "Q" "v" "O" "qi" "wi"  "Qi"  "Oi" "a" "dO"]);
           %         R0 = RodriguesQuaternion(x(4:7));
           %         Ri = RodriguesQuaternion(reshape(x(50:73),4,[]));
           %         u = obj.self.controller.result.input;
           %         ddX0 = ddx0do0_6(x,R0,Ri,u,obj.P,inv(Addx0do0_6(x,R0,u,obj.P)));
           %         obj.self.estimator.result.state.a   = ddX0(1:3);
           %         obj.self.estimator.result.state.dO  = ddX0(4:6);
           % %     end
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
        function yawRef = generate_yawReference(obj,k_yaw)
            syms l yaw theta tyaw
            syms w
            syms d4w d3w d2w d1w d0w
            x = l*cos(w*tyaw + theta);
            y = l*sin(w*tyaw + theta);
            r = [x;y];
            dr = diff(r,tyaw);
            d2r = diff(dr,tyaw);
            d3r = diff(d2r,tyaw);
            d4r = diff(d3r,tyaw);
            d5r = diff(d4r,tyaw);
            rs = [r,dr,d2r,d3r,d4r,d5r];
            dnyaw = [(-k_yaw)^5*yaw,(-k_yaw)^4*yaw,(-k_yaw)^3*yaw,(-k_yaw)^2*yaw,-k_yaw*yaw];
            dnw = [diff(w,tyaw,4),diff(w,tyaw,3),diff(w,tyaw,2),diff(w,tyaw,1),w];
            dnw2 = [d4w,d3w,d2w,d1w,d0w];
            subsrs1 = subs(rs,[dnw,tyaw],[dnw2,0]);
            subsrs2 = subs(subsrs1 ,dnw2,dnyaw);
            yawRef = matlabFunction(subsrs2,"Vars",{l,yaw,theta,tyaw});
            %  syms l yaw theta tyaw
            % syms w(tyaw)
            % syms d4w d3w d2w d1w d0w
            % x = l*cos(w*tyaw + theta);
            % y = l*sin(w*tyaw + theta);
            % r = [x;y];
            % dr = diff(r,tyaw);
            % d2r = diff(dr,tyaw);
            % d3r = diff(d2r,tyaw);
            % d4r = diff(d3r,tyaw);
            % d5r = diff(d4r,tyaw);
            % rs = [r,dr,d2r,d3r,d4r,d5r];
            % dnyaw = [(-k_yaw)^5*yaw,(-k_yaw)^4*yaw,(-k_yaw)^3*yaw,(-k_yaw)^2*yaw,-k_yaw*yaw];
            % dnw = [diff(w,tyaw,4),diff(w,tyaw,3),diff(w,tyaw,2),diff(w,tyaw,1),w];
            % dnw2 = [d4w,d3w,d2w,d1w,d0w];
            % subsrs1 = subs(rs,[dnw,tyaw],[dnw2,0]);
            % subsrs2 = subs(subsrs1 ,dnw2,dnyaw);
            % yawRef = matlabFunction(subsrs2,"Vars",{l,yaw,theta,tyaw});
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
          Xd  = zeros(28, 1);
          d = obj.zd_takeoff - obj.base_state_takeoff(3,1); % goal altitude : relative value
          te = obj.te_takeoff; % terminal time to reach zd
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
          Xd(1:3,1) = obj.base_state_takeoff(1:3);
          Xd(3,1) = tra + Xd(3,1);
          Xd(6,1) = dtra;
          Xd(9,1) = ddtra;
          Xd(12,1) = d3tra;
          Xd(15,1) = d4tra;
          Xd(18,1) = d5tra;
        end
         function Xd = gen_ref_for_landing(obj,t)
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
              Xd  = zeros( 28, 1);
                %% Set Xd
          if t<=obj.te_landing
                Zd = curve_interpolation_9order(t,obj.te_landing,obj.base_state_landing(3),0,-obj.self.parameter.get("cableL"),0);
          elseif t> obj.te_landing
            Zd = zeros(1,5);
          end
          Xd(1:3,1) = obj.base_state_landing(1:3);
          Xd(3,1) = Zd(1);
          Xd(7,1) = Zd(2);
          Xd(11,1) = Zd(3);
          Xd(15,1) = Zd(4);
          Xd(19,1) = Zd(5);
        end

        function q = generate_quaternion(obj,theta_alpi,rot_axis)
            q = [
                cos(theta_alpi/2);
                rot_axis*sin(theta_alpi/2);
                ];
        end

    end
end