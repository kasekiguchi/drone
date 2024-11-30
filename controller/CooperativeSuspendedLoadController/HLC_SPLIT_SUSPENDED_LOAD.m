classdef HLC_SPLIT_SUSPENDED_LOAD < handle
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        IT
        u_opt0
        fmc_options 
        estimate_load_mass 
    end
    
    methods
        function obj = HLC_SPLIT_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            obj.u_opt0 = [(self.parameter.mass + self.parameter.loadmass)*self.parameter.gravity;0;0;0];
            obj.fmc_options = optimoptions(@fmincon,'Display','off');
            obj.estimate_load_mass = ESTIMATE_LOAD_MASS(self);
        end
        
        function result=do(obj,varargin)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model = obj.self.estimator.result;
            ref   = obj.self.reference.result;
            x     = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            % xq    = [model.state.getq('4');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応する用
                % xd(1:3) = ref.x0d + ref.R0d*ref.rho;%質量と牽引物と紐との接続点から計算した目標軌道
                % xd(1:3) = ref.x0d;%牽引物重心の目標軌道と同様
            else
                xd = ref.state.get();
            end
            Param = obj.param;
%             P = Param.P;
            P     = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity","km1","km2","km3","km4","k1","k2","k3","k4", "loadmass", "cableL"]);
            P(15) = obj.self.reference.result.state.mLi;%均等分割(コメントアウト)か推定して分割したモデル化を変えられる
            
            %拡張質量システムのekfで牽引物の質量を求める場合
            if isprop(model.state,"mL")
                % P(15) = max(obj.self.estimator.result.state.mL,0);
                P(15) = obj.self.estimator.result.state.mL;
            end
            %牽引物システムの質量推定
            % mui = obj.self.reference.result.state.mui;
            % mLi = P(15);
            % elm = obj.estimate_load_mass.estimate(varargin{1},mLi,mui');
            % obj.result.xh_pre = elm.xh_pre;
            % obj.result.mL = elm.mL;
            % P(15) = elm.mL;

            obj.result.mLi = P(15);%質量はコントローラに格納

            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            xd=[xd;zeros(28-size(xd,1),1)];% 足りない分は０で埋める．
            if isfield(Param,'dt')
                dt = Param.dt;
                vf = Vfd_SuspendedLoad(dt,x,xd',P,F1);
            else
                vf = Vf_SupendedLoad(x,xd',P,F1);
            end
            vs = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);
            % obj.result.Z1 = Z1_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z2 = Z2_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z3 = Z3_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z4 = Z4_SuspendedLoad(x,xd',vf,P);

            uf = Uf_SuspendedLoad(x,xd',vf,P);
            
            %usの計算
                % h234 = H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
                invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
                %invbeta2(vs - alhpa2)の計算の試行錯誤
                % vs_alhpa = v_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                us = [0;invbeta2*vs_alpha2];%h234*invbeta2*a2;
                % alpha21 = alpha21_SuspendedLoad(x,xd',vf,P);
                % alpha22 = alpha22_SuspendedLoad(x,xd',vf,P);
                % alpha23 = alpha23_SuspendedLoad(x,xd',vf,P);
                % alpha2 = [alpha21;alpha22;alpha23];
                % us = [0;invbeta2*(vs' - alpha2)];%h234*invbeta2*a2;
            %{
            cha = obj.self.reference.cha;
            tmpHL = obj.self.controller.hlc.result.input;%flight以外は通常のモデルで飛ばす
            obj.result.input = tmpHL;
            if strcmp(cha,'f')%計算時間的に@do_controllerで分岐させた方がいい
                obj.result.input = uf + us;
            end
            obj.result.input = uf + us;
            obj.self.controller.result.input = obj.result.input;
            %}

            tmp = uf + us;
            % control barrier funciton
            % fun = @(u_opt) (u_opt - tmp)'*(u_opt - tmp);
            % [A,b] = conic_cfb(xq,P,[10;1],10*pi/180);%deg
            % tmp = fmincon(fun,obj.u_opt0,A,b,[],[],[],[],[],obj.fmc_options);
            % obj.u_opt0 = tmp;

            obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))]+[normrnd(0,0.01,1);normrnd(0,0.001,[3,1])];
            %複数牽引は慣性モーメントがかかるのでモーメントの反応が遅れる？
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end
