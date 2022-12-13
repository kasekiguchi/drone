classdef FUNCTIONAL_JIREI_SERVO < CONTROLLER_CLASS
    %受け渡されたパラメータつかって入力設計（階層型線形化したあとに）

    properties
        self
        result
        param
        Q
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
        Vf
        Vs
        z %拡張系z
    end

    methods
        function obj = FUNCTIONAL_JIREI_SERVO(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name); % 状態を文字としてもってくる
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            obj.Vf = param.Vf;
            obj.Vs = param.Vs;
            obj.z = [0;0;0];
        end

        function result=do(obj,param,~)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w, z]に並べ替え 今の状態
            xd = ref.state.get(); % ステートの全部（目標値）

            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            t = param{1};
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)])); %オイラー角からクオータニオン
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w, z]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);

            if strcmp(cha,'f')
                obj.z = obj.z + xd(1:3)-x(5:7);
            end

%             if t > 5
%                 obj.z = obj.z + xd(1:3)-x(5:7); %z+目標値ー今の状態 （積分項）
%             end

            %% calc Z 階層型線形化
            z1 = Z1(x,xd',P);
            vf = obj.Vf(z1,F1,obj.z);
            z2 = Z2(x,xd',vf,P);
            z3 = Z3(x,xd',vf,P);
            z4 = Z4(x,xd',vf,P);
            vs = obj.Vs(z2,z3,z4,F2,F3,F4,obj.z);
             %% calc actual input 入力つくる
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