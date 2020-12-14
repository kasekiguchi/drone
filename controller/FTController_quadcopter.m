<<<<<<< HEAD
classdef FTController_quadcopter < CONTROLLER_CLASS
    % ã‚¯ã‚¢ãƒƒãƒ‰ã‚³ãƒ—ã‚¿ãƒ¼ç”¨éšå±¤å‹ç·šå½¢åŒ–ã‚’ä½¿ã£ãŸå…¥åŠ›ç®—å‡º
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
            % param (optional) : æ§‹é€ ä½“ï¼šç‰©ç†ãƒ‘ãƒ©ãƒ¡ãƒ¼ã‚¿Pï¼Œã‚²ã‚¤ãƒ³F1-F4 
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]ã«ä¸¦ã¹æ›¿ãˆ
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20æ¬¡å…ƒã®ç›®æ¨™å€¤ã«å¯¾å¿œã™ã‚‹ã‚ˆã†
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            kx=[3.16,6.79,40.54,12.27];%ã‚²ã‚¤ãƒ³
            kx=F2;
            ky=[3.16,6.79,40.54,12.27];%å¾Œã§paramã«æ ¼ç´
            ky=F3;
            kz=[2.23,2.28];
            kpsi=[1.41,1.35];
            ax=[0.692,0.75,0.818,0.9];%alpha
            ay=[0.692,0.75,0.818,0.9];
            az=[0.692,0.75];
            apsi=[0.692,0.75];
%             ax=[1,1,1,1];%SMCã¸ã®ã‚¹ã‚¤ãƒƒãƒ
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
            xd=[xd;zeros(20-size(xd,1),1)];% è¶³ã‚Šãªã„åˆ†ã¯ï¼ã§åŸ‹ã‚ã‚‹ï¼

            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]ã«ä¸¦ã¹æ›¿ãˆ
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
            z1=Z1(x,xd',P);%zæ–¹å‘
            z2=Z2(x,xd',vf,P);%xæ–¹å‘
            z3=Z3(x,xd',vf,P);%yæ–¹å‘
            z4=Z4(x,xd',vf,P);%yaw
            %x1-x4ã‚’ï½šã®æˆåˆ†ã‚’å‡ºã™å½¢ã«
            ux=-kx(1)*sign(z2(1))*abs(z2(1))^ax(1)-(kx(2)*sign(z2(2))*abs(z2(2))^ax(2))-(kx(3)*sign(z2(3))*abs(z2(3))^ax(3))-(kx(4)*sign(z2(4))*abs(z2(4))^ax(4));%ï¼ˆ17ï¼‰å¼
            uy=-ky(1)*sign(z3(1))*abs(z3(1))^ay(1)-(ky(2)*sign(z3(2))*abs(z3(2))^ay(2))-(ky(3)*sign(z3(3))*abs(z3(3))^ay(3))-(ky(4)*sign(z3(4))*abs(z3(4))^ay(4));%(19)å¼
            uz=-kz(1)*sign(z1(1))*abs(z1(1))^az(1)-(kz(2)*sign(z1(2))*abs(z1(2))^az(2));%(19)å¼

            upsi=-F4*z4;
            %upsi=-kpsi(1)*sign(z1(1))*abs(z1(1))^apsi(1)-(kpsi(2)*sign(z2(1))*abs(z2(1)))^apsi(2);%F4*Z4;%ä»Šå›ã¯ã“ã‚Œã§()
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

=======
classdef FTController_quadcopter < CONTROLLER_CLASS
    % ƒNƒAƒbƒhƒRƒvƒ^[—pŠK‘wŒ^üŒ`‰»‚ğg‚Á‚½“ü—ÍZo
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
            % param (optional) : \‘¢‘ÌF•¨—ƒpƒ‰ƒ[ƒ^PCƒQƒCƒ“F1-F4 
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]‚É•À‚×‘Ö‚¦
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20ŸŒ³‚Ì–Ú•W’l‚É‘Î‰‚·‚é‚æ‚¤
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            kx=[3.16,6.79,40.54,12.27];%ƒQƒCƒ“
            kx=F2;
            ky=[3.16,6.79,40.54,12.27];%Œã‚Åparam‚ÉŠi”[
            ky=F3;
            kz=[2.23,2.28];
            kpsi=[1.41,1.35];
            ax=[0.692,0.75,0.818,0.9];%alpha
            ay=[0.692,0.75,0.818,0.9];
            az=[0.692,0.75];
            apsi=[0.692,0.75];
%             ax=[1,1,1,1];%SMC‚Ö‚ÌƒXƒCƒbƒ`
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
            xd=[xd;zeros(20-size(xd,1),1)];% ‘«‚è‚È‚¢•ª‚Í‚O‚Å–„‚ß‚éD

            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]‚É•À‚×‘Ö‚¦
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
            z1=Z1(x,xd',P);%z•ûŒü
            z2=Z2(x,xd',vf,P);%x•ûŒü
            z3=Z3(x,xd',vf,P);%y•ûŒü
            z4=Z4(x,xd',vf,P);%yaw
            %x1-x4‚ğ‚š‚Ì¬•ª‚ğo‚·Œ`‚É
            ux=-kx(1)*sign(z2(1))*abs(z2(1))^ax(1)-(kx(2)*sign(z2(2))*abs(z2(2))^ax(2))-(kx(3)*sign(z2(3))*abs(z2(3))^ax(3))-(kx(4)*sign(z2(4))*abs(z2(4))^ax(4));%i17j®
            uy=-ky(1)*sign(z3(1))*abs(z3(1))^ay(1)-(ky(2)*sign(z3(2))*abs(z3(2))^ay(2))-(ky(3)*sign(z3(3))*abs(z3(3))^ay(3))-(ky(4)*sign(z3(4))*abs(z3(4))^ay(4));%(19)®
            uz=-kz(1)*sign(z1(1))*abs(z1(1))^az(1)-(kz(2)*sign(z1(2))*abs(z1(2))^az(2));%(19)®

            upsi=-F4*z4;
            %upsi=-kpsi(1)*sign(z1(1))*abs(z1(1))^apsi(1)-(kpsi(2)*sign(z2(1))*abs(z2(1)))^apsi(2);%F4*Z4;%¡‰ñ‚Í‚±‚ê‚Å()
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

>>>>>>> master
