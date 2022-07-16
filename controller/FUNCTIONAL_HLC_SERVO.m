classdef FUNCTIONAL_HLC_SERVO < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
        Vf
        Vs
        z
    end
    
    methods
        function obj = FUNCTIONAL_HLC_SERVO(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
            obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル 
            obj.z = [0;0;0];
        end
        
        function result=do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w, z]に並べ替え
            xd = ref.state.get();

            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            t = param{1};
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
            
            % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
            % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w, z]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            
            if t > 5
                obj.z = obj.z + xd(1:3)-x(5:7);
            end
            %% calc Z
            z1 = Z1(x,xd',P);
            vf = obj.Vf(z1,F1,obj.z);
            z2 = Z2(x,xd',vf,P);
            z3 = Z3(x,xd',vf,P);
            z4 = Z4(x,xd',vf,P);
            vs = obj.Vs(z2,z3,z4,F2,F3,F4,obj.z);

            %% calc actual input
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs,P);
            obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4)];
            obj.self.input = obj.result.input;
            obj.result.z= obj.z;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

