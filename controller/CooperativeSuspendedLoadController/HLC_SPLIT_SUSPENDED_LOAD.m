classdef HLC_SPLIT_SUSPENDED_LOAD < handle
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        IT
    end
    
    methods
        function obj = HLC_SPLIT_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
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
            Param= obj.param;
%             P = Param.P;
            P = obj.self.parameter.get(["mass", "Lx", "jx", "jy", "jz", "gravity","km1","km2","km3","km4","k1","k2","k3","k4", "loadmass", "cableL"]);
            P(15) = obj.self.reference.result.state.mLi;%均等分割(コメントアウト)か推定して分割したモデル化を変えられる

            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            xd=[xd;zeros(28-size(xd,1),1)];% 足りない分は０で埋める．
            %目標軌道の時間微分が1階までしかないので追従性が悪くなる!!!!!!!!
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
            % obj.result.Z1 = Z1_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z2 = Z2_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z3 = Z3_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z4 = Z4_SuspendedLoad(x,xd',vf,P);

            uf = Uf_SuspendedLoad(x,xd',vf,P);
            % h234 = H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
            invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
            vs_alhpa = v_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
            us = [0;invbeta2*vs_alhpa];%h234*invbeta2*a;
            % cha = obj.self.reference.cha;
            % tmpHL = obj.self.controller.hlc.result.input;%flight以外は通常のモデルで飛ばす
            % obj.result.input = tmpHL;
            % if strcmp(cha,'f')%計算時間的に@do_controllerで分岐させた方がいい
            %     obj.result.input = uf + us;
            % end
            % obj.result.input = uf + us;
            % obj.self.controller.result.input = obj.result.input;
            tmp = uf + us;
            obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];

            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end
