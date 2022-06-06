classdef HLController_quadcopter_Suspended_Load < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        IT
        parameter_name = ["mass","Length","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","loadmass","cableL","ex","ey","ez"];
    end
    
    methods
        function obj = HLController_quadcopter_Suspended_Load(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            l = obj.param.P(2);
            km = obj.param.P(7);
            obj.IT = [1 1 1 1;sqrt(2)*l*[-1 -1 1 1]/2; sqrt(2)*l*[1 -1 1 -1]/2; km*[1 -1 -1 1]];
        end
        
        function result=do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応するよう
            else
                xd = ref.state.get();
            end
            if isempty(param)
                Param = param;
            else
                Param= obj.param;
            end
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            %     xd=Xd.p;
            %     if isfield(Xd,'v')
            %         xd=[xd;Xd.v];
            %         if isfield(Xd,'dv')
            %             xd=[xd;Xd.dv];
            %         end
            %     end
            xd=[xd;zeros(28-size(xd,1),1)];% 足りない分は０で埋める．

%             Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
%             x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
%             xd(1:3)=Rb0'*xd(1:3);
%             xd(4) = 0;
%             xd(5:7)=Rb0'*xd(5:7);
%             xd(9:11)=Rb0'*xd(9:11);
%             xd(13:15)=Rb0'*xd(13:15);
%             xd(17:19)=Rb0'*xd(17:19);
% 
%             if isfield(Param,'dt')
%                 dt = Param.dt;
%                 vf = Vfd(dt,x,xd',P,F1);
%             else
%                 vf = Vf(x,xd',P,F1);
%             end
%             vs = Vs(x,xd',vf,P,F2,F3,F4);
%             tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
%             obj.result.input = [tmp(1);
%             tmp(2);tmp(3);
%             tmp(4)];
            
            if xd(7)==0
                xd(7)=0.00001;
            end
            if xd(11)==0
                xd(11)=0.00001;
            end
            if isfield(Param,'dt')
                dt = Param.dt;
                vf = Vfd_SuspendedLoad(dt,x,xd',P,F1);
            else
                vf = Vf_SupendedLoad(x,xd',P,F1);
            end
            vs = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);
            uf = Uf_SuspendedLoad(x,xd',vf,P);
            
            h234 = H234_SuspendedLoad(x,xd',vf,vs',P);
            invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
            a = v_SuspendedLoad(x,xd',vf,vs',P);
            us = h234*invbeta2*a;
            obj.result.input = uf +[0;us(2:4)];
%             if isfield(Param,'dt')
%                 dt = Param.dt;
%                 vf = Vfdp(dt,x,xd',P,F1);
%             else
%                 vf = Vfp(x,xd',P,F1);
%             end
%             vs = Vsp(x,xd',vf,P,F2,F3,F4);
%             obj.result = Ufp(x,xd',vf,P) + Usp(x,xd',vf,vs',P);
            cha = obj.self.reference.point.flag;
            tmpHL = obj.self.controller.hlc.result.input;
            obj.result.input = obj.IT*tmpHL;
            if strcmp(cha,'f')
                obj.result.input = uf +[0;us(2:4)];
            end
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

