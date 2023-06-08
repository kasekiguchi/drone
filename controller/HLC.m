classdef HLC < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end
    
    methods
        function obj = HLC(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
        end
        
        function result = do(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd = ref.state.get();
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
            
            if isfield(obj.param,'dt')
                dt = obj.param.dt;
                vf = Vfd(dt,x,xd',P,F1);
            else
                vf = Vf(x,xd',P,F1);
            end
            vs = Vs(x,xd',vf,P,F2,F3,F4);
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4)];
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

