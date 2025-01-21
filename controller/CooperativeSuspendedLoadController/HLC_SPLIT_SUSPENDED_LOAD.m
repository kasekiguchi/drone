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
        flag_anti_spike=0
        % preW
    end
    
    methods
        function obj = HLC_SPLIT_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            obj.u_opt0 = [(self.parameter.mass + self.parameter.loadmass)*self.parameter.gravity;0;0;0];
            obj.fmc_options = optimoptions(@fmincon,'Display','off');
            obj.estimate_load_mass = ESTIMATE_LOAD_MASS(self);
            % obj.preW =zeros(3,1);
        end
        
        function result=do(obj,varargin)
            % tStart = tic;
            if isscalar(varargin)
                agent = varargin{1};
            else
                agent = varargin;
            end
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            Param = obj.param;
            model = obj.self.estimator.result;
            ref   = obj.self.reference.result;
            x     = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            % xq    = [model.state.getq('4');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            % x(7) = max(min(x(7),-10),10);
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応する用
            else
                xd = ref.state.get();
            end
            % fixPi = fix(model.state.q(3)/pi);
            % if mod(fixPi,2) == 0 
            %     yaw = min(model.state.q(3) - pi*fixPi, pi);%y軸正
            % else
            %     yaw = max(model.state.q(3) - pi*fixPi - pi, -pi);%y軸負
            % end
            % if abs(yaw-xd(4)) > 2*pi - 0.2
            %     %前時刻と現在時刻でqのあたいが飛ぶ
            %     x(1:4) = Eul2Quat([model.state.q(1:2);xd(4)]);
            %     x(5:7) = obj.preW;
            % else
            %     obj.preW = model.state.w;
            % end
            P  = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity","km1","km2","km3","km4","k1","k2","k3","k4", "loadmass", "cableL"]);
            
            
            %拡張質量システムのekfで牽引物の質量を求める場合
            if contains(obj.self.estimator.model.name,"load_mL")
                
                if model.state.pL(3)< 0.1 && varargin{2} == "l"
                    p(15) = 0;
                else 
                    P(15) = max(model.state.mL,0);
                end
                obj.result.mLi= P(15);
                if isfield(model.state,"fdst")
                    fdst = model.state.fdst;
                    disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4)+" estimated thrust dst: "+num2str(fdst,4))
                else
                    disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4))
                end
            end
            
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
            % toc(tStart)
            %usの計算
                % h234 = H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
                invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
                % toc(tStart)
                vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                % toc(tStart)
                us = [0;invbeta2*vs_alpha2];%h234*invbeta2*a2;

                %invbeta2(vs - alhpa2)の計算の試行錯誤
                % vs_alhpa = v_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
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
            obj.result.tmp =tmp;
            if isfield(model.state,"fdst")
                obj.result.input = [max(0,min(20,tmp(1) - fdst));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.002,1);normrnd(0,0.001,[3,1])];
            else
                obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.002,1);normrnd(0,0.001,[3,1])];
            end
            obj.self.controller.result.input = obj.result.input;%tmp;
            result = obj.result;  
            % control barrier funciton
            % fun = @(u_opt) (u_opt - tmp)'*(u_opt - tmp);
            % [A,b] = conic_cfb(xq,P,[10;1],10*pi/180);%deg
            % tmp = fmincon(fun,obj.u_opt0,A,b,[],[],[],[],[],obj.fmc_options);
            % obj.u_opt0 = tmp;

        end
        function show(obj)
            obj.result
        end
    end
end
