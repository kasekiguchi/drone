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
        vdro_pre
        vL_pre
        aidrns
        ais
        ms
        estimate_load_mass
        flag_anti_spike=0
        % preT
    end
    
    methods
        function obj = HLC_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));    
            obj.u_opt0 = [(self.parameter.mass + self.parameter.loadmass*0)*self.parameter.gravity;0;0;0];
            obj.fmc_options = optimoptions(@fmincon,'Display','off');
            obj.vdro_pre = 0;
            obj.vL_pre = 0;
            obj.aidrns=zeros(3,20);
            obj.ais =zeros(3,20);
            obj.ms = ones(1,10)*0.4;
            % obj.estimate_load_mass = ESTIMATE_LOAD_MASS(self);
        end
        
        function result=do(obj,varargin)
            tStart = tic;
            if isscalar(varargin)
                agent = varargin{1};
            else
                agent = varargin;
            end
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
           

            % if model.state.pL(3)<-10000
            %     P(15) = 0;
            % else
            %      %EKFで質量推定
            if obj.self.estimator.model.name == "load_mL_HL"
                P(15) = model.state.mL;
                obj.result.mLi=P(15);
                disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4))
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
            % obj.result.Z1 = Z1_SuspendedLoad(x,xd',P);
            % obj.result.Z2 = Z2_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z3 = Z3_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z4 = Z4_SuspendedLoad(x,xd',vf,P);
            vs = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);
            

            uf = Uf_SuspendedLoad(x,xd',vf,P);
            toc(tStart)
            %usの計算
                % h234 = obj.H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
                invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
                toc(tStart)
                vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                toc(tStart)
                us = [0;invbeta2*vs_alpha2];%h234*invbeta2*a2;
            % cha = agent{2};
            % tmpHL = obj.self.controller.hlc.result.input;%flight以外は通常のモデルで飛ばす
            % if strcmp(cha,'f')%計算時間的に@do_controllerで分岐させた方がいい
            %      % if obj.flag_anti_spike < 5
            %      %   tmp =[uf(1);0;0;0];
            %      %   obj.flag_anti_spike=obj.flag_anti_spike+1;
            %      % else
            %         tmp = uf + us;
            %      % end
            % else
            %     % tmp = tmpHL;
            %     tmp = uf + us;
            % end
            tmp = uf + us;
            obj.result.tmp =tmp;
            obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.002,1);normrnd(0,0.001,[3,1])];
            obj.self.controller.result.input = obj.result.input;%tmp;
            result = obj.result;  
            
        end
        function show(obj)
            obj.result
        end
    end
end