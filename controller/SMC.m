classdef SMC < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
        Vf
        Vs
    end
    
    methods
        function obj = SMC(self,param)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get(obj.parameter_name);
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
            obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル 
        end

        function result=do(obj,param,~)
            t = param{1};
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd = ref.state.get();
            
            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            %     xd=Xd.p;
            %     if isfield(Xd,'v')
            %         xd=[xd;Xd.v];
            %         if isfield(Xd,'dv')
            %             xd=[xd;Xd.dv];
            %         end
            %     end
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
            
            %% calc Z
            z1 = Z1(x,xd',P);
            vf = obj.Vf(z1, F1);
            %% smc
            z2 = Z2(x,xd',vf,P);
            z3 = Z3(x,xd',vf,P);
            SB=obj.param.SB;
            SA=obj.param.SA;         
            
%             %sigmaの設計
            sigmax=obj.param.S*z2;
            sigmay=obj.param.S*z3;
% %%            
            q=20;%circle
            k=10;
            ka=30;
            alp=0.7;%0<alp<1
            at=1;
%             定常到達則
%             ux=-inv(SB)*(SA*z2+q*sign(sigmax));%sign
%             uy=-inv(SB)*(SA*z3+q*sign(sigmay));
%             ux=-inv(SB)*(SA*z2+q*tanh(at*sigmax));%tanh
%             uy=-inv(SB)*(SA*z3+q*tanh(at*sigmay));
             %比例到達則
             ux=-inv(SB)*(SA*z2+q*sign(sigmax)+k*sigmax);%sgn
             uy=-inv(SB)*(SA*z3+q*sign(sigmay)+k*sigmay);
%              ux=-inv(SB)*(SA*z2+q*tanh(at*sigmax)+k*sigmax);%tanh
%              uy=-inv(SB)*(SA*z3+q*tanh(at*sigmay)+k*sigmay);
            %加速率
%             ux = -inv(SB)*(SA*z2+ka*abs(sigmax)^alp*sign(sigmax));%sgn
%             uy = -inv(SB)*(SA*z3+ka*abs(sigmay)^alp*sign(sigmay));
%             ux = -inv(SB)*(SA*z2+k*abs(sigmax)^alp*tanh(sigmax));%tanh
%             uy = -inv(SB)*(SA*z3+k*abs(sigmay)^alp*tanh(sigmay));
            %%
            z4 = Z4(x,xd',vf,P);
            upsi = -F4*z4;
            vs = [ux;uy;upsi];
 %% 外乱(加速度で与える)
                        dst = 0;%m/s^2
%             dst=0.5*sin(2*pi*t/2);%
%             dst=8*sin(2*pi*t/0.2);%
%             dst=dst+10*cos(2*pi*t/1);
%             dst=2;
             ts = 2 ; te =5.33;
             T2 = 2*(te - ts);
            if t>=ts && t<= te
%                     dst=0.6;
                    dst=0.4*sin(2*pi*(t-ts)/T2)+0.6;
            end
            %% calc actual input
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs,P);
            obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4);dst];
%             obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4)];
            obj.self.input = obj.result.input;
            %サブシステムの入力
             obj.result.uHL = [vf(1);vs];
            %サブシステムの状態
            obj.result.z1 = z1;
            obj.result.z2 = z2;
            obj.result.z3 = z3;
            obj.result.z4 = z4;
            obj.result.vf = vf;
            obj.result.sigmax = sigmax;
            obj.result.sigmay = sigmay;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

