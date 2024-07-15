classdef HLC_SUSPENDED_LOAD < handle
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        IT
        u_opt0
        fmc_options 
    end
    
    methods
        function obj = HLC_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));    
            obj.u_opt0 = [(self.parameter.mass + self.parameter.loadmass)*self.parameter.gravity;0;0;0];
            obj.fmc_options = optimoptions(@fmincon,'Display','off');
        end
        
        function result=do(obj,~,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            % pT = model.state.pT
            % wL = model.state.wL
            % theta = acos(-[0,0,1]*pT)*180/pi
            % h0=-pT(3)-cos(10*pi/180)
            % h1 = wL(2)*pT(1)-wL(1)*pT(2)+1*h0
            % xq    = [model.state.getq('4');x(4:end)]; % [q, w ,pL, vL, pT, wL]に並べ替え
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応するよう
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            %P = Param.P;
            P = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "loadmass", "cableL"]);

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
                % h234 = obj.H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
                invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
                vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                us = [0;invbeta2*vs_alpha2];%h234*invbeta2*a2;
            %{
            cha = obj.self.reference.cha;
            tmpHL = obj.self.controller.hlc.result.input;%flight以外は通常のモデルで飛ばす
            if strcmp(cha,'f')%計算時間的に@do_controllerで分岐させた方がいい
                tmp = uf + us;
            else
                tmp = tmpHL;
            end
            obj.self.controller.result.input = tmp;
            obj.result.input = tmp;
            %}

            tmp = uf + us;
            % control barrier funciton
                fun = @(u_opt) sqrt((u_opt - tmp)'*(u_opt - tmp));
                a=[10;1];
                k = 5;
                C=12;%deg
                % [A,b] = conic_cfb(x,P,a,C*pi/180);
                [A,b] = conic_cfb_sigmoid(x,P,a,k,C*pi/180);
                tmp_opt = fmincon(fun,obj.u_opt0,A,b,[],[],[],[],[],obj.fmc_options);
                obj.u_opt0 = tmp_opt;
                tmp = tmp_opt;
                
                %チェック用
                pT = model.state.pT;
                % wL = model.state.wL
                % h1 = wL(2)*pT(1)-wL(1)*pT(2)+1*h0;
                % [h1,h2]=conic_cfb_h1h2(x,tmp_opt,P,a,C*pi/180);
                [h1,h2]=conic_cfb_sigumoid_h1h2(x,tmp_opt,P,a,k,C*pi/180);
                theta = acos(-[0,0,1]*pT)*180/pi;
                h0=-pT(3)-cos(C*pi/180);
                a_h0 = a(1)*h0;
                dh0 = h1 - a_h0;
                % a_h1 = a(2)*h1;
                a_h1 = a(2)*(1/(exp(-k*h1) + 1) - 0.5);
                dh1 = h2 - a_h1;
                
                fprintf("theta:%-3.3f[deg] \t h0:%1.3f \t dh0:%1.3f \t h1:%1.3f \t dh1:%1.3f \n\n", theta,h0,dh0,h1,dh1)
                obj.result.C = C;
                obj.result.theta = theta;
                obj.result.h0 = h0;
                obj.result.ah0 = a_h0;
                obj.result.dh0 = dh0;
                obj.result.h1 = h1;
                obj.result.ah1 = a_h1;
                obj.result.dh1 =dh1;

            % obj.result.input = tmp;
            obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            result = obj.result;
            
            
        end
        function show(obj)
            obj.result
        end
    end
end