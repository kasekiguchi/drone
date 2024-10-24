classdef MPC_CONTROLLER_HL <handle
    % MCMPC_CONTROLLER MCMPCのコントローラー

    properties
    self
    result
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end

    properties
%         options
        current_state
        previous_input
        input
        state
        const
        reference
        fRemove
        model
    end
    properties
        modelf
        modelp
        F1
        weight
        weightF
        weightR
        % weightRp
        A
        B
        C
        H
        mpc
        qpparam
    end

    methods
        function obj = MPC_CONTROLLER_HL(self, param)
            %-- 変数定義
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
            obj.input = obj.param.input; % obj.param = Controller_HLMPC.mで設定したパラメーター

            %% HL関連
            obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.dt);
            % 重みの配列サイズ変換
            obj.weight = blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI);
            obj.weightF = blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf);
            obj.weightR = obj.param.R;  % 目標入力
            % obj.weightRp = obj.param.RP; % 前ステップとの入力
            obj.H = obj.param.H;
            % HL. A, B行列定義
            % z, x, y, yawの順番
            A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
            B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
            sysd = c2d(ss(A,B,eye(12),0),param.dt); % 離散化
            obj.A = sysd.A;
            obj.B = sysd.B;
            obj.C = eye(12); 
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力事前定義(これがないと初期化で失敗する)
            obj.previous_input = repmat(obj.input.u, 1, obj.H); % MPC用の初期入力

            %% QP change_equationの共通項をあらかじめ計算
            Param = struct('A',obj.A,'B',obj.B,'C',obj.C,'weight',obj.weight,'weightF',obj.weightF,'weightR',obj.weightR,'H',obj.H);
            [obj.qpparam.H, obj.qpparam.F] = change_equation_drone(Param);
            % H: 変数
            % F: fを生成するために必要な行列
            obj.result.setting.weight = struct('Q',obj.weight,'Qf',obj.weightF,'R',obj.weightR);
            obj.result.setting.A = obj.A;
            obj.result.setting.B = obj.B;
            obj.result.setting.C = obj.C;
        end

        %-- main()的な
        function result = do(obj,varargin)
            tic
            %% ほぼ2コン
            %%initialize
            time = varargin{1};
            phase = varargin{2};
            obj.param.t = time.t;
            %% phaseによるcontrollerの選択
            % result: controllerで算出された入力
            obj.state.ref = obj.generate_reference();
            result = obj.controller_HLMPC(varargin);
            % if phase == 'a'
            %     obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input;0;0;0],1,obj.param.H);
            %     result = obj.controller_HLMPC(varargin);
            %     disp('controller: MPC  phase: a');
            % elseif phase == 't' || phase == 'l'
            %     result = obj.controller_HL(varargin);
            %     disp('controller: HL   phase: t or l');
            % elseif phase == 'f'
            %     obj.state.ref = obj.generate_reference();
            %     result = obj.controller_HLMPC(varargin);
            %     disp('controller: MPC  phase: f');
            % end 
            toc
            % profile viewer
        end
        function show(obj)
            obj.result
        end

        function result = controller_HL(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            xd = ref.state.xd;
            xd0 =xd;
            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
    
            % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
            % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            %if isfield(obj.param,'dt')
            if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
                dt = varargin{1}.dt;
            else
                dt = obj.param.dt;
                % vf = Vf(x,xd',P,F1);
                % vs = Vs(x,xd',vf,P,F2,F3,F4);
            end
            vf = Vfd(dt,x,xd',P,F1);
            vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
            %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            % max,min are applied for the safty
            obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            result = obj.result;
        end

        function result = controller_HLMPC(obj, varargin)
            xd = [obj.state.ref(1:3,1); 0; obj.state.ref(7:9,1); 0]; % 9次多項式にも対応
            xd = [xd; zeros(24, 1)];
    
            model_HL = obj.self.estimator.result;
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            xn = [R2q(Rb0'*model_HL.state.getq("rotmat"));Rb0'*model_HL.state.p;Rb0'*model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            P = obj.self.parameter.get();
            vfn = Vf(xn,xd',P,obj.param.F1); %v1
            z1n = Z1(xn,xd',P);
            z2n = Z2(xn,xd',vfn,P);
            z3n = Z3(xn,xd',vfn,P);
            z4n = Z4(xn,xd',vfn,P);
            obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)];
    
            %% Referenceの取得、ホライズンごと
            % xrを仮想状態目標値に変換 ホライズン分の変換
            % xyz yaw v_{xyz yaw} a_{xyz yaw}
            obj.reference.xd_imagine = [obj.state.ref(1:3,:); zeros(1,obj.param.H); obj.state.ref(7:9,:); zeros(1,obj.param.H); obj.state.ref(17:19,:); zeros(21, obj.param.H)]; % 実状態目標値=Rb0をかけるために合わせる
            % yaw入力時にHL用に目標値が切り替わるように　Rb0をかけるようにする
            xr_imagine(1:3,:)=Rb0'*obj.reference.xd_imagine(1:3,:);
            xr_imagine(4,:) = zeros(1,obj.param.H);
            xr_imagine(5:7,:)=Rb0'*obj.reference.xd_imagine(5:7,:);
            xr_imagine(9:11,:)=Rb0'*obj.reference.xd_imagine(9:11,:);
            xr_imagine(13:15,:)=Rb0'*obj.reference.xd_imagine(13:15,:);
            xr_imagine(17:19,:)=Rb0'*obj.reference.xd_imagine(17:19,:);
            % 仮想状態の目標値
            obj.reference.xr_org = [xr_imagine(3,:);xr_imagine(7,:);xr_imagine(1,:);xr_imagine(5,:);xr_imagine(9,:);xr_imagine(13,:);xr_imagine(2,:);xr_imagine(6,:);xr_imagine(10,:);xr_imagine(14,:);xr_imagine(4,:);xr_imagine(8,:)];
            % 仮想状態の目標値。Objectiveで使用。　現在地から目標値（座標）への誤差
            % obj.reference.xr = obj.reference.xr_org(:,1) - obj.reference.xr_org;
            % obj.reference.xr = -obj.current_state; % Hを考慮できていない
    
            % current
            act = model_HL.state.get();
            img = [act(3); act(9); act(1); act(7); 0;0; act(2); act(8); 0;0; act(6); act(12)];
            obj.reference.qp = img - obj.reference.xr_org;
            obj.reference.xr = [obj.reference.qp; obj.state.ref(13:16,:)];

            % 最適化部分
            Param = struct('current_state',obj.current_state,'ref',obj.reference.xr,'qpH', obj.qpparam.H, 'qpF', obj.qpparam.F,'lb',obj.param.input.lb,'ub',obj.param.input.ub,'previous_input',obj.previous_input,'H',obj.H);
            % [var, fval, exitflag] = quad_drone_mex(Param); %自PCでcontroller:0.6ms, 全体:2.7ms
            [var, fval, exitflag] = quad_drone(Param);
            %%--

            obj.previous_input = var; % 最適化の初期値

            vf = var(1, 1);     % 最適な入力の取得
            vs = var(2:4, 1);     % 最適な入力の取得
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);  % 入力変換
            obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
            % obj.result.input =
            % [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            % % HL同様の入力制限
            obj.input.u = obj.result.input; % 入力をcontroller内に保存
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;
            obj.result.mpc.current = obj.current_state;
            obj.result.mpc.xr_real = obj.state.ref;
            obj.result.mpc.xr_img = obj.reference.xr_org;

            obj.result.input_v = [vf; vs]; % 仮想入力の保存
            % obj.result.xr = xr_real;
            result = obj.result;
        end

        
        function [xr] = generate_reference(obj, ~)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(16, obj.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.H-1
                t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3); % 位置
                xr(7:9, h+1) = ref(5:7); % 速度
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0]; % 姿勢角速度
                xr(13:16, h+1) = obj.param.ref_input; % 入力
                xr(17:19, h+1) = [0;0;0]; % 加速度
            end
        end
    end
end
