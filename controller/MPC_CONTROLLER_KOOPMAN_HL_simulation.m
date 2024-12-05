classdef MPC_CONTROLLER_KOOPMAN_HL_simulation < handle
    % MCMPC_CONTROLLER MPCのコントローラー

    properties
        param
        current_state
        previous_input
        previous_state
        input
        state
        const
        reference
        fRemove
        model
        result
        self
    end

    properties
        weight
        weightF
        weightR
        A
        B
        C
        Ae
        Be
        Ce
        H
        qpparam
        t
    end

    properties
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_HL_simulation(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存
            obj.H = obj.param.H;

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;

            if isfield(obj.param, 'Ae')
                obj.Ae = obj.param.Ae;
                obj.Be = obj.param.Be;
                obj.Ce = obj.param.Ce;
            end
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値
            obj.input.u_HL_pre = obj.result.input;

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.H);
            obj.weight = blkdiag(obj.param.weight.P, obj.param.weight.Q, obj.param.weight.V, obj.param.weight.W);
            obj.weightF = blkdiag(obj.param.weight.Pf, obj.param.weight.Qf, obj.param.weight.Vf, obj.param.weight.Wf);
            obj.weightR = obj.param.weight.R;

            %% A行列にxyzの位置を加えた拡張係数行列とする
            % A_1 = [eye(3), zeros(3), eye(3)*obj.param.dt, zeros(3, size(obj.A,1)-6)];
            % A_2 = [zeros(size(obj.A,2), 3), obj.A];
            % obj.param.A = [A_1; A_2];
            % obj.param.B = [zeros(3, 4); obj.B];
            % obj.param.C = blkdiag(eye(3), obj.C);

            %% QP change_equationの共通項をあらかじめ計算
            Param = struct('A',obj.param.A,'B',obj.param.B,'C',obj.param.C,'weight',obj.weight,'weightF',obj.weightF,'weightR',obj.weightR,'H',obj.H);
            [obj.qpparam.H, obj.qpparam.F] = change_equation_drone(Param);
            % H: 変数
            % F: fを生成するために必要な行列
            obj.result.setting.weight = struct('Q',obj.weight,'Qf',obj.weightF,'R',obj.weightR);
            obj.result.setting.A = obj.param.A;
            obj.result.setting.B = obj.param.B;
            obj.result.setting.C = obj.param.C;

            obj.param.P = [0.5 0.16	0.16 0.08 0.08 0.06	0.06 0.06 9.81 0.0301 0.0301 0.0301	0.0301 8.0e-06 8.0e-06 8.0e-06 8.0e-06];
            % obj.param.P = self.parameter.get(obj.parameter_name);

            classlist = ["TIME_VARYING_REFERENCE", "MY_POINT_REFERENCE", "MY_REFERENCE_KOMA2"];
            classname = class(obj.self.reference);
            obj.reference.classnum = find(strcmp(classname, classlist));

            % 1ステップ前の状態の保存
            % state = obj.self.estimator.result.state.get();
            % q p v w
            % value=Eul2Quat(state(4:6));
            % obj.state.previous.q = RodriguesQuaternion(Eul2Quat(state(4:6)));
            % obj.state.previous.pvw = [state(1:3);state(7:9);state(10:12)];
        end

        function result = do(obj, varargin)
            tic
            %%initialize
            time = varargin{1};
            phase = varargin{2};
            obj.t = time.t;
            %% phaseによるcontrollerの選択
            % result: controllerで算出された入力
            obj.current_state = obj.self.estimator.result.state.get(); %現在状態
            if phase == 'a'
                obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
                obj.reference.xr = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input],1,obj.param.H);
                result = obj.controller_KMPC(varargin);
                disp('controller: MC,  phase: a');
            elseif phase == 't' || phase == 'l'
                result = obj.controller_HL(varargin);
                disp('controller: HL  phase: t or l');
            elseif phase == 'f'
                obj.reference.xr = obj.generate_reference(obj.t);
                obj.input.u_hl   = obj.controller_HL(varargin); % calculated current HL input
                result = obj.controller_KMPC(varargin);
                disp('controller: MC  phase: f');
            end 
            % obj.show();
            calT = toc;
            % result.calc = calT;
        end

        %-- main()的な
        function result = controller_KMPC(obj, varargin)
            % profile on
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            var = varargin{1};
            obj.param.t = obj.t;
            rt = obj.param.t; %時間
            idx = round(rt/var{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            % [obj.reference.xr, obj.reference.xr_HL] = obj.generate_reference(rt); %リファレンスの更新

            %% HLによる入力計算
            obj.input.u_HL = obj.input.u_HL_pre;
            obj.input.u_HL_current = obj.input.u_HL; % controllerで同時計算

            % 次時刻状態の計算
            x = obj.current_state;
            u = obj.input.u_HL;
            P = obj.param.P;
            tspan = [0 0.025];
            x0 = x;
            [~,tmpx]=ode15s(@(t,x) obj.self.plant.method(x,u,P),tspan, x0); % 非線形モデル
            obj.state.HL = tmpx(end, :);

            %% reference
            obj.previous_state = obj.current_state - obj.state.HL'; % 誤差モデル
            % obj.reference.qp = [obj.reference.xr(1:12,:) - repmat(obj.state.HL',1,obj.H); obj.reference.xr(13:16,:)]; % 誤差モデル ref:Controller_MPC_Koopanのref_inputもいじってる
            obj.reference.qp = zeros(16,obj.H); % 誤差を0にしたい

            %% 最適化部分の関数化とmex化
            % obj.input.lb(2:4) = obj.param.input.lb(2:4) - obj.input.u_HL(2:4);
            % obj.input.ub = obj.param.input.ub - obj.input.u_HL;
            % Param = struct('current_state',obj.previous_state,'ref',obj.reference.qp,'qpH', obj.qpparam.H, 'qpF', obj.qpparam.F,'lb',obj.input.lb,'ub',obj.input.ub,'previous_input',obj.previous_input,'H',obj.H);
            % % [var, fval, exitflag] = obj.param.quad_drone(Param); %自PCでcontroller:0.6ms, 全体:2.7ms
            % [var, fval, exitflag] = quad_drone(Param);
            % u = var(1:4,1) + obj.input.u_HL; % 印加する入力 4入力
            % obj.result.input = u;

            %% 疑似逆行列から求める
            deltaU = abs(obj.result.input - obj.input.u_HL);
            Z = obj.A * quaternions_all([obj.previous_state; deltaU]) + obj.B * deltaU;
            % er = obj.C*Z;
            % V = [obj.previous_state; obj.current_state; obj.input.u_HL]; % e x u
            V = [quaternions_all([obj.previous_state; deltaU])];
            J = @(P) abs(sum(Z - V*P - obj.B*deltaU));
            % x0 = [obj.current_state; zeros(26-12,1)];
            x0 = 0;
            x = fminunc(J,x0);
            delU = -pinv(obj.B)*V*x;
            u = obj.input.u_HL - delU;
            obj.result.input = u;
            fval = 0; exitflag = 0;
            % MODEL_CLASSも変更必要

            %% データ表示用
            
            obj.input.u = obj.result.input; 
            calT = toc;
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;
            % obj.result.mpc.input = obj.result.input;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存
            % obj.self.input  = obj.result.input;

            %% 情報表示
            % state_monte = obj.self.estimator.result.state;
            % if idx == 1; state_monte = obj.self.estimator.result.state;
            % else; state_monte = obj.self.plant.result; end
            obj.state.x = obj.self.estimator.result.state.get();
            
            obj.show(calT,rt,fval,exitflag);

            %% z < 0で終了
            if obj.self.estimator.result.state < 0
                warning("墜落しました")
            end
            
        end
        function show(obj,calT,rt,fval,exitflag)
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
                    obj.state.x(1), obj.state.x(2), obj.state.x(3),...
                    obj.state.x(7), obj.state.x(8), obj.state.x(9),...
                    obj.state.x(4), obj.state.x(5), obj.state.x(6), ...
                    obj.state.x(10), obj.state.x(11), obj.state.x(12));       % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
                    obj.reference.xr(1,1), obj.reference.xr(2,1), obj.reference.xr(3,1),...
                    obj.reference.xr(7,1), obj.reference.xr(8,1), obj.reference.xr(9,1),...
                    obj.reference.xr(4,1), obj.reference.xr(5,1), obj.reference.xr(6,1), ...
                    obj.reference.xr(10,1), obj.reference.xr(11,1), obj.reference.xr(12,1))  % r:reference 目標状態
            % fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
            %     rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            fprintf("t: %f \t calT: %f \t fval: %f \t flag: %d \n", rt, calT, fval, exitflag);
            % fprintf("u: %f %f %f %f \t diff_u: %f %f %f %f", obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), var(1,1), var(2,1), var(3,1), var(4,1));
            fprintf("\n");
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
            result = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            obj.input.u_HL_pre = result;
        end

        function [xr, xr_HL] = generate_reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.H);    % initialize
            xr_HL = zeros(16, 1);
       
            % 時間関数の取得→時間を代入してリファレンス生成
            % P2P等は値を持ってきてホライズン分拡張
            % 1:timevarying
            % 2:P2P
            % 3:9-order polynomial
            if obj.reference.classnum == 1 % time varying
                RefTime = obj.self.reference.func;
                for h = 0:obj.H-1
                t = T + obj.param.dt * h;
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0];
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input;
                end
            elseif obj.reference.classnum == 2 % P2P
                ref = repmat(obj.self.reference.result.state.get(),1,obj.H);
                xr(1:3,:) = ref(12:14,:);
                xr(4:6,:) = ref(15:17,:);
                xr(7:9,:) = ref( 9:11,:);
                xr(10:12,:)=zeros(3,obj.H);
                xr(13:16,:)=repmat(obj.param.ref_input,1,obj.H);
            elseif obj.reference.classnum == 3 % 9-order polynomial
                ref = repmat(obj.self.reference.result.state.get(),1,obj.H);
                xr(1:9,:) = ref(1:9,:);
                xr(10:12,:)=zeros(3,obj.H);
                xr(13:16,:)=repmat(obj.param.ref_input,1,obj.H);
            end
            xr_HL(1:16, 1) = xr(1:16, 1);
        end
    end
end
