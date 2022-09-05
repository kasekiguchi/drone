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
        
        function result=do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            t = param{1};

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
            
            z1=Z1(x,xd',P);%z方向
            z2=Z2(x,xd',vf,P);%x方向
            z3=Z3(x,xd',vf,P);%y方向
            z4=Z4(x,xd',vf,P);%yaw
            
            %手動で入力を作成
            ux=-F2*z2;
            uy=-F3*z3;
            upsi=-F4*z4;
            %外乱
%                 ux=ux+5*sin(2*pi*t/2);
                ux=ux+2;
%                 if t>=2 && t<=2.1
%                     ux=ux+1/0.025;
%                 end
            vs =[ux,uy,upsi];
            
%             vs = Vs(x,xd',vf,P,F2,F3,F4);
           %% 外乱(加速度で与える)
            dst = 0.1;
%             dst=8*sin(2*pi*t/0.2);%
%             dst=dst+10*cos(2*pi*t/1);
%             dst=2;
%             if t>=2 && t<=2.1　
%                     dst=1/0.025;
%             end
%%
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4);dst];
            obj.self.input = obj.result.input;
             %サブシステムの入力
            obj.result.uHL = [vf(1);ux;uy;upsi];
            %サブシステムの状態
            obj.result.z1 = z1;
            obj.result.z2 = z2;
            obj.result.z3 = z3;
            obj.result.z4 = z4;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

