classdef FTController_quadcopter < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        Q
    end
    
    methods
        function obj = FTController_quadcopter(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
        end
        
        function u = do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応するよう
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            kx=[3.16,6.79,40.54,12.27];%ゲイン
            kx=F2;
            ky=[3.16,6.79,40.54,12.27];%後でparamに格納
            ky=F3;
            kz=[2.23,2.28];
            kpsi=[1.41,1.35];
            ax=[0.692,0.75,0.818,0.9];%alpha
            ay=[0.692,0.75,0.818,0.9];
            az=[0.692,0.75];
            apsi=[0.692,0.75];
%             ax=[1,1,1,1];%SMCへのスイッチ
%             ay=[1,1,1,1];
%             az=[1,1];
%             apsi=[1,1];
            %     xd=Xd.p;
            %     if isfield(Xd,'v')
            %         xd=[xd;Xd.v];
            %         if isfield(Xd,'dv')
            %             xd=[xd;Xd.dv];
            %         end
            %     end
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);

            if isfield(Param,'dt')
                dt = Param.dt;
                vf = Vfd(dt,x,xd',P,F1);
            else
                vf = Vf(x,xd',P,F1);
            end
%             vs = Vs(x,xd',vf,P,F2,F3,F4);
            z1=Z1(x,xd',P);%z方向
            z2=Z2(x,xd',vf,P);%x方向
            z3=Z3(x,xd',vf,P);%y方向
            z4=Z4(x,xd',vf,P);%yaw
            %x1-x4をｚの成分を出す形に
            ux=-kx(1)*sign(z2(1))*abs(z2(1))^ax(1)-(kx(2)*sign(z2(2))*abs(z2(2))^ax(2))-(kx(3)*sign(z2(3))*abs(z2(3))^ax(3))-(kx(4)*sign(z2(4))*abs(z2(4))^ax(4));%（17）式
            uy=-ky(1)*sign(z3(1))*abs(z3(1))^ay(1)-(ky(2)*sign(z3(2))*abs(z3(2))^ay(2))-(ky(3)*sign(z3(3))*abs(z3(3))^ay(3))-(ky(4)*sign(z3(4))*abs(z3(4))^ay(4));%(19)式
            uz=-kz(1)*sign(z1(1))*abs(z1(1))^az(1)-(kz(2)*sign(z1(2))*abs(z1(2))^az(2));%(19)式

            upsi=-F4*z4;
            %upsi=-kpsi(1)*sign(z1(1))*abs(z1(1))^apsi(1)-(kpsi(2)*sign(z2(1))*abs(z2(1)))^apsi(2);%F4*Z4;%今回はこれで()
            vs =[ux,uy,uz,upsi];
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            obj.result.input = [tmp(1);
                tmp(2);tmp(3);
                tmp(4)];
            obj.self.input = obj.result.input;
            result = obj.result;

            u = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

