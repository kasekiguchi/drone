classdef TIME_VARYING_REFERENCE_SPLIT < handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    %TODO==============================
    %landingを質量推定値で条件分岐
    %==================================
    properties
        self                    % agent(i)を格納
        agent1                  % agent(1)を格納
        func                    % 時間関数のハンドル
        funcRotms               % rhoiを目標角度に合わせる回転行列
        cha='s'                 % コマンドの値
        com                     % 使用制御モデル->"Cooperative"or"Split"
        result                  % do method の返り値を格納
        N                       % 機体数
        ftakeoff = 0            % take off のフラグ
        flanding = 0            % landing のフラグ
        base_time_takeoff       % take off開始時刻
        base_time_landing       % landing開始時刻
        base_state_takeoff      % take offの初期位置
        base_state_landing      % landingの初期位置
        base_state12_takeoff    % take offのxy初期位置
        base_state12_landing    % landingのxy初期値
        te_takeoff = 12         % take offで目標高度に達するまでの時間goal time
        zd_takeoff = 0.8        % take offの目標高度goal altitude
        zd_takeoff_now          % take offの目標高度goal altitude
        te_landing = 20         % landingの時間goal time
        base_time_flight=[];    % 目標軌道に追従し始めたときの時刻
        constPrep               % 前時刻の制約の位置
        constPrev               % 前時刻の制約の速度

    end

    methods
        function obj = TIME_VARYING_REFERENCE_SPLIT(self, args, agent1)
            % make refernce of payload and split payload
            % payload       : args{3} = Cooperative
            % split payload : args{3} = split
            % phase         : flight, take off, landing
            arguments
                self   
                args
                agent1
            end     
            obj.agent1          = agent1;               % agent(1)の格納
            obj.self            = self;                 % agent(i)の格納
            obj.N               = args{4};              % 機体数Nの格納
            obj.com             = args{3};              % 対象になるシステムの格納
            gen_func_name       = str2func(args{1});    % referenceの関数の格納
            param_for_gen_func  = args{2};              % referenceの関数のに代入する値の格納
            
            if length(args) > 2
                if strcmp(args{3}, "Cooperative")% 牽引物の目標軌道
                    [obj.func,obj.funcRotms]    = gen_ref_for_HL_Cooperative_Load(gen_func_name(param_for_gen_func{:}));% 目標値の関数を格納
                    obj.result.state            = STATE_CLASS(struct('state_list', ["xd", "p"], 'num_list', [27, 3]));% stateクラスを格納（保存したい変数を設定）
                    obj.result.state.set_state("xd",obj.func(0));                           % 目標値の初期値を設定
                    obj.result.state.set_state("p",obj.self.reference.result.state.xd(1:3));% 目標位置の初期値を設定（特に使わない）

                elseif strcmp(args{3}, "Split")% 分割後の牽引物の目標軌道
                    obj.result.state    = STATE_CLASS(struct('state_list', ["xd", "p", "minDroneDistance", "constp","constTargetp"], 'num_list', [28, 3, 1, 1, 1]));  % stateクラスを格納（保存したい変数を設定）
                    obj.result.state.set_state("xd",zeros(28,1));                           % 目標値の初期値を設定
                    obj.result.state.set_state("p",obj.self.reference.result.state.xd(1:3));% 目標位置の初期値を設定（特に使わない）
                    obj.result.state.set_state("minDroneDistance",0);                       % 機体間距離の最小値
                    obj.result.state.set_state("constp",0);                                 % 制約の初期値
                    obj.result.state.set_state("constTargetp",0);                           % 制約の目標値
                    
                end
            else %上記以外のreference関数を複数機牽引用に修正
                temp.pYaw = gen_func_name(param_for_gen_func{:}); %位置をyaw角の目標値
                    % 回転の時間関数を設定
                    if ~isfield(temp,"q")
                        syms t
                        roll   = 0;
                        pitch  = 0;
                        yaw    = 0;
                        temp.q = [roll;pitch;yaw];%roll,pitch,yaw
                        clear t
                    end
                [obj.func,obj.funcRotms] = gen_ref_for_HL_Cooperative_Load(temp);% 目標値の関数を格納
                obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [28, 3, 3, 3]));% 目標値の初期値を設定
            end
        end

        function result = do(obj, varargin)
           dt       = varargin{1}.dt;   % 刻み時間
           obj.cha  = varargin{2};      % phase

           %flightからreferenceの時間を開始
           if obj.cha=='f'&& isempty(obj.base_time_flight)
                obj.base_time_flight  =  varargin{1}.t;
                t = obj.base_time_flight;
           elseif obj.cha=='f'
                t = varargin{1}.t - obj.base_time_flight;
           else
                t = 0;
           end

           %refernceの計算
           if strcmp(obj.com, "Split")
               %================================================
               % ~0は分割前牽引物，~iは分割後の牽引物を表す
               %================================================
               %機体の番号
                   id           = obj.self.id - 1;                    
               %parameter
                   cablei       = obj.self.parameter.get("cableL");             % 紐の長さ
                   rli          = sqrt(2)*obj.self.parameter.get("lx");         % 機体のロータまでの長さ
                   rhoi         = obj.agent1.parameter.rho(:,id);               % 牽引物の中心位置からリンクまでの距離
                   rhoiUnit12   = [rhoi(1:2)/norm(rhoi(1:2));0];                % rhoiをx-y平面に射影したベクトルの単位ベクトル
                   rhoci        = obj.agent1.parameter.rhoc(:,id);              % 紐の接続位置が頂点の多角形の重心からリンクまでの距離
               % sensor
                   sp0          = obj.agent1.sensor.result.rigid(1).p;          % 牽引物のセンサー値
               % estimator
                   epDronei     = obj.self.estimator.result.state.p;            % 機体位置
               % reference 
                   spDrones     = obj.agent1.reference.result.spDrones;         % 全ての機体位置
                   ref0         = obj.agent1.reference.result.state.xd(1:24);   % 分割前の牽引物目標軌道[xd;dxd;d2xd;d3xd;d4xd;d5xd]
                   rotms        = obj.agent1.reference.result.rotms;            % rhoiを目標位置に向ける回転行列

               %紐接合部の目標軌道を算出
                   if isprop(obj.self.sensor.result.state,"real_pL")
                       real_pL  = obj.self.sensor.result.state.real_pL;         % 牽引物位置
                   else
                       real_pL  = obj.self.sensor.result.state.pL;              % simのための牽引物位置
                   end
                   %いらないかも
                   % alpi12       = real_pL(1:2) - obj.agent1.sensor.result.state.p(1:2);
                   % alpiUnit12   = alpi12/norm(alpi12);%牽引物が垂直に傾かないと仮定
               %衝突回避reference生成用ゲイン 
                   droneDistance        = vecnorm(spDrones - epDronei);          % 自身と相手との距離
                   sortedDroneDistance  = sort(droneDistance);                  % 小さい順に並べ替え
                   minDroneDistance     = sortedDroneDistance(2)  - 2*rli;      %1が自分の位置との差のため2番目が相手との最小値そこから機体の大きさrliを考慮
                   
                   constTargetp         = 0.1/(minDroneDistance - 0.4)^2;       % sim0.1,0.4,exp0.2,0.15衝突回避するためのゲイン(最終目標位置):定数/((機体間の最小距離-2*機体のロータまでの長さ)　- 閾値)^2
                   constp               = obj.constPrep + obj.constPrev*dt;     % 現在の目標位置
                   obj.constPrep        = constp;                               % 現在時刻の制約の目標値を保存
                   kv                   = 0.05;                                 % sim0.05速度referenceのゲイン

                   % constTargetp       = 0.01/(minDroneDistance - 0.4)^2;%sim0.1,0.4,exp0.2,0.15衝突回避するためのゲイン(最終目標位置):定数/((機体間の最小距離-2*機体のロータまでの長さ)　- 閾値)^2
                   % constp             = obj.constPrep + obj.constPrev*dt;%現在の目標位置
                   % obj.constPrep      = constp;
                   % kv                 = 0.05;%sim0.05速度referenceのゲイン

                   obj.constPrev        = -kv*(constp - constTargetp);          %最終目標位置と現在目標位置との差から現在の目標速度を計算（現在目標位置の更新のみに使用）
                   constd               = constp - constTargetp;
                   
                   % 制約に関する情報の表示
                   minDroneDistance
                   constp%=0 % 制約入れない場合は0を代入
                   constTargetp
                   constd
                %flight
                   if obj.cha == 'f'
                       obj.ftakeoff = 0;                                            % take off条件分岐用フラグ
                       obj.flanding = 0;                                            % landing条件分岐用フラグ
                       rhoi         = rhoi + constp*rhoiUnit12;                     % バリア関数で機体どうしの衝突を回避
                       refi         = ref0 + sum(rotms.*repmat(rhoi',24,1),2);      % 5階微分までの回転行列とrhoの掛け算をまとめて計算
                       %外乱打ち消しreference生成．
                       % refi(9:10) = obj.self.estimator.result.state.dst(1:2);%constp*rhoicUnit12;%バリア関数で機体どうしの衝突を回避(閾値で無限大)
                       
                       %加速度目標値として制約を設定することで力の次元で制約を考慮
                       % refi           = ref0 + sum(rotm0.*repmat(rhoi',24,1),2);%5階微分までの回転行列とrhoの掛け算をまとめて計算
                       % rhoicUnit12    = rhoci(1:2)/norm(rhoci(1:2));%衝突回避用のxy方向のrhoの単位ベクトル
                       % refi(9:10)     = constp*rhoicUnit12;%バリア関数で機体どうしの衝突を回避(閾値で無限大)
                       % refi(9:10)     = 1*rhoicUnit12;%constp*rhoicUnit12;%バリア関数で機体どうしの衝突を回避(閾値で無限大)
                %take off
                   elseif obj.cha =='t'
                       obj.flanding                     = 0;                                            %landing条件分岐用フラグ
                       takeOffTime                      = varargin{1}.t-obj.base_time_takeoff;          % takeoffになってからの時間
                       %初期値
                       if isempty(obj.base_state_takeoff) || takeOffTime > obj.te_takeoff               % 初期位置がないまたは，takeoffが終わる時間を過ぎたか
                           obj.base_time_takeoff        = varargin{1}.t;                                % takeoffになった時間
                           obj.base_state12_takeoff     = real_pL(1:2);                                 % 初期の紐接続点のx,y位置
                           % 質量推定が終わるまでのとき
                           if isempty(obj.base_state_takeoff) 
                               obj.zd_takeoff_now       = sp0(3) + 0.05;                                % 目標高度設定
                               obj.base_state_takeoff   = [real_pL(1:2);p(3)-cablei];                   % 初期位置
                           %推定終わってから目標高度に行くとき
                           else 
                               obj.zd_takeoff_now       = obj.zd_takeoff;                               % 目標高度設定
                               obj.base_state_takeoff   = real_pL;                                      % 初期位置
                           end
                       end
                       % 更新
                       exrhoi                           = 0.5;                                          % rho方向に延ばす距離
                       % 紐が張る機体の高度になったか(紐の長さとexrhoiから求まる高度に牽引物の高さを加えた高度より機体が高いか)
                       if p(3) >= sqrt(cablei^2 - exrhoi^2) + real_pL(3) || obj.ftakeoff == 1 
                           obj.ftakeoff                 = 1;                                            %take off条件分岐用フラグ
                           obj.base_state_takeoff(1:2)  = obj.base_state12_takeoff + constp*rhoiUnit12; % rhoiUnit12方向に延長
                       % 紐がたわんでいる場合
                       else
                           obj.base_state_takeoff(1:2)  = obj.base_state12_takeoff + exrhoi*rhoiUnit12; % rho方向に延ばす距離
                           obj.constPrep                = exrhoi;
                           obj.constPrev                = 0;
                       end
                       % 目標値
                           refi                         = obj.gen_ref_for_take_off(takeOffTime);
                       % take offのプロポの推力値を計算
                           th_offset                    = obj.self.input_transform.param.th_offset;
                           th_offset_takeoff            = 260;% th_offset_takeoff = obj.self.input_transform.param.th_offset_tl;
                           obj.self.input_transform.param.th_offset_tl = th_offset_takeoff + (th_offset-th_offset_takeoff)*min(obj.te_takeoff,takeOffTime)/obj.te_takeoff;
                %landing
                   elseif obj.cha =='l'
                       obj.ftakeoff                     = 0;                                            %take off条件分岐用フラグ
                       % 初期値
                       if isempty(obj.base_state_landing) 
                           obj.base_time_landing        = varargin{1}.t;                                % landingになった時間
                           obj.base_state_landing       = obj.self.sensor.result.state.pL;              % 初期位置
                           obj.base_state12_landing     = obj.self.sensor.result.state.pL(1:2);         % x,y方向の初期位置
                       end
                       % 更新
                       exrhoi                           = 0.5;                                          % rhoi方向に延ばす距離
                       % 牽引物質量が小さくなったらにする
                       if p(3) - real_pL(3) >= 0.5*cablei && obj.flanding==1                            
                           obj.flanding                 = 1;                                            % landing条件分岐用フラグ一旦入ったらここの条件を使う
                           obj.base_state_landing(1:2)  = obj.base_state12_landing + constp*rhoi;       %牽引物が高い場合に紐の長さ的に目標位置に届かない可能性を考慮
                       %紐がたわんでいる場合
                       else 
                           obj.base_state_landing(1:2)  = obj.base_state12_landing + exrhoi*rhoi;
                       end
                       % 目標値
                           refi                 = obj.gen_ref_for_landing(varargin{1}.t-obj.base_time_landing);
                       % landingのプロポの推力値を計算
                           th_offset            = obj.self.input_transform.param.th_offset;
                           th_offset_landing    = 260;% th_offset_takeoff = obj.self.input_transform.param.th_offset_tl;
                           obj.self.input_transform.param.th_offset_tl_tmp = th_offset - (th_offset-th_offset_landing)*min(obj.te_landing,varargin{1}.t-obj.base_time_landing)/obj.te_landing;
                % stop, arming
                   else
                       refi = zeros(28,1); 
                   end
               
           %log
               obj.result.state.xd                  = refi;
               obj.result.state.minDroneDistance    = minDroneDistance;
               obj.result.state.constTargetp        = constTargetp;
               obj.result.state.constp              = constp;
               obj.result.state.p                   = refi(1:3);
               
           else
               %牽引物の目標軌道
                   xd                       = obj.func(t);                          % 牽引物の目標軌道
                   [q,rotms]                = obj.funcRotms(t);                     % 回転行列と高次微分
               %全ての機体の位置を取得
                   % センサクラスがMOTIVEのとき(exp)
                   if isa( obj.self.sensor,"MOTIVE")
                       rigid                 = obj.agent1.sensor.result.rigid;      % 剛体情報を全て取得
                       spDrones              = zeros(3,(length(rigid)-1)/2);
                       for i = 1:(length(rigid)-1)/2
                            spDrones(:,i)    = rigid(2*i).p;                        % 機体の位置を格納
                       end
                   % sim
                   else
                       sensor1 = obj.self.sensor.result.state;                      % 複数機モデルから機体と接続点の位置を計測
                       %分割前牽引物
                           sp                 = sensor1.p;                          % 牽引物位置
                           sR                 = RodriguesQuaternion(sensor1.Q);     % 牽引物の回転行列
                       %分割後牽引物
                           rho                = obj.self.parameter.rho;
                           spDrones = zeros(size(rho));
                           for i = 1:size(rho,2)
                               spL            = sp + sR * rho(:,i);                 % 分割後の質量重心位置
                               spT            = sensor1.qi(3*i-2:3*i,1);            % 分割後の紐の方向ベクトル
                               spDrones(:,i)  = spL - obj.self.parameter.li(i)*spT; % 機体位置
                           end
                   end
               %log
                   obj.result.state.xd  = [xd;q];    %角度を最後に追加
                   obj.result.rotms     = rotms;     %目標値の回転列
                   obj.result.spDrones   = spDrones; %機体
                   obj.result.state.p   = xd(1:3);
           end
           result = obj.result;% 戻り値
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
        
        %% take off refernce
        function Xd = gen_ref_for_take_off(obj,t)
          % Setting
          % calc reference position and its higher time derivatives
          % reference designed as a 9-degree polynomial function of time
          % [Inputs]
          % t : current time
          %
          % [Output]
          % Xd : reference [p; p^(1);p^(2); p^(3);p^(4);p^(5)] as column vector
    
          %Variable set
          Xd  = zeros(28, 1);
          d = obj.zd_takeoff_now - obj.base_state_takeoff(3,1); % goal altitude : relative value
          te = obj.te_takeoff; % terminal time to reach zd
          % Set Xd
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
        %% landing refernce
        function Xd = gen_ref_for_landing(obj,t)
              % Setting
              % calc reference position and its higher time derivatives
              % reference designed as a 9-degree polynomial function of time
              % [Inputs]
              % t : current time
              %
              % [Output]
              % Xd : reference [[p;yd], [p^(1);0], [p^(2);0], [p^(3);0], [p^(4);0]] as column vector
              %    : Xd in R^20
              %    : yd is a yaw angle reference
        
              % Variable set
              Xd  = zeros( 28, 1);% Set Xd
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

    end
end