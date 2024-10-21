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
    end
    
    methods
        function obj = HLC_SUSPENDED_LOAD(self,param)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));    
            obj.u_opt0 = [(self.parameter.mass + self.parameter.loadmass)*self.parameter.gravity;0;0;0];
            obj.fmc_options = optimoptions(@fmincon,'Display','off');
            obj.vdro_pre = 0;
            obj.vL_pre = 0;
            obj.aidrns=zeros(3,20);
            obj.ais =zeros(3,20);
            obj.ms = ones(1,10)*0.4;
            % obj.estimate_load_mass = ESTIMATE_LOAD_MASS(self);
        end
        
        function result=do(obj,agent,~)
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
            if model.state.p(3) < 1
                P(15) =0;% obj.self.estimater.model.loadmass;

                obj.vL_pre = model.state.vL;
                obj.vdro_pre = model.state.v;
                ai=0;
                aidrn=0;
                %filt
                % vdro = model.state.v;
                % vL = model.state.vL;
                % aidrn = (vdro - obj.vdro_pre)/Param.dt + normrnd(0,0.01,[3,1]); %機体加速度%前時刻の運動方程式から加速度求めてもいいかも
                % ai = (vL - obj.vL_pre)/Param.dt + normrnd(0,0.01,[3,1]);%牽引物加速度
                % obj.aidrns = [obj.aidrns(:,2:end),aidrn];
                % obj.ais = [obj.ais(:,2:end),ai];
                % windowSize =10;
                % b = (1/windowSize)*ones(1,windowSize);
                % faidrn = filter(b,1,obj.aidrns);
                % fai = filter(b,1,obj.ais);
                % obj.aidrns(:,end) = faidrn(:,end);
                % obj.ais(:,end) = fai(:,end);

            else
            %張力算出
            %MODELクラスのインスタンスでloadmassの代入とdoメソッドで質量の代入を確認する
                g = [0;0;-P(6)];
                mi   = P(1);
                Ri = model.state.getq("rotm");
                vdro = model.state.v;
                vL = model.state.vL;
                
                ui  = Ri*[0;0;obj.self.controller.result.input(1) + 0*normrnd(0,0.5)];%推力,離散時間なので現在時刻まで同じ入力が入ると仮定
                aidrn = (vdro - obj.vdro_pre)/Param.dt + 0*normrnd(0,0.1,[3,1]); %機体加速度%前時刻の運動方程式から加速度求めてもいいかも
                ai = (vL - obj.vL_pre)/Param.dt + 0*normrnd(0,0.1,[3,1]);%牽引物加速度
                
                % obj.aidrns = [obj.aidrns(:,2:end),aidrn];%filt
                % obj.ais = [obj.ais(:,2:end),ai];%filt
                % windowSize =20;%filt
                % b = (1/windowSize)*ones(1,windowSize);%filt
                % faidrn = filter(b,1,obj.aidrns);%filt
                % fai = filter(b,1,obj.ais);%filt
                % mui      = mi*faidrn(:,end) - mi*g - ui;%filt                 %ドローン座標系からの張力
                % mui      = -mui;%filt%分割後の牽引物系から張力

                % aidrn = (vdro - obj.vdro_pre)/Param.dt; %機体加速度%前時刻の運動方程式から加速度求めてもいいかも
                % ai = (vL - obj.vL_pre)/Param.dt;%牽引物加速度
                mui      = mi*aidrn - mi*g - ui;                 %ドローン座標系からの張力
                mui      = -mui;%分割後の牽引物系から張力
                
                obj.vL_pre = vL;
                obj.vdro_pre = vdro;
            %分割後質量推定 mLi*ai = mLi*g + mui
                A    = ai - g;
                % A    = fai(:,end) - g;%filt
                AtA  = A'*A;
                mLi  = (AtA\A')*mui;%分割後質量
                
                % obj.ms = [obj.ms(:,2:end),mLi];%filt
                % windowSize =10;%filt
                % b = (1/windowSize)*ones(1,windowSize);%filt
                % fms = filter(b,1,obj.ms);%filt
                % fms = obj.ms/windowSize;%filt
                % P(15) = fms(end);%filt

                % P(15) = mLi
                obj.result.mLi =mLi;

                % obj.aidrns(:,end) = faidrn(:,end);%filt
                % obj.ais(:,end) = fai(:,end);%filt
                % disp(" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4)+" aidrn: "+num2str(aidrn,4)+" ai: "+num2str(ai,4))

                % elm = obj.estimate_load_mass.estimate([agent,mLi,mui]);
                % obj.result.xh_pre = elm.xh_pre;
                % obj.result.mL = elm.mL;
                % P(15) = elm.mL;
            end
            P(15) = model.state.mL;
            % aaa = P(15) 
            % disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4))
            disp(" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(15),4)+" aidrn: "+num2str(norm(aidrn),3)+" ai: "+num2str(norm(ai),3))
            % obj.result.mLi=P(15);
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
            % obj.result.Z1 = Z1_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z2 = Z2_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z3 = Z3_SuspendedLoad(x,xd',vf,P);
            % obj.result.Z4 = Z4_SuspendedLoad(x,xd',vf,P);
            vs = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);
            
            %subsystemでcfbを用いる
            % z2 = obj.result.Z2;
            % z3 =  obj.result.Z3;
            % ref = reshape(xd,4,[])';
            % refx = ref(:,1);
            % refy = ref(:,2);
            % pL = model.state.pL;
            % p = model.state.p;
            % a = [1E5;1E4;1E3;1E2;1E1;1E0]*1e-2;
            % a = [1e2;1e-1;1e-1;1e-1;1e-2;1e-2];
            % C = 1;
            % if model.state.p(3) > 1
            %     vs(1:2)
            %     j = [2,1];
            %         % fun = @(u_opt) sqrt((u_opt - vs(1:2))*(u_opt - vs(1:2)'));
            %         fun =  @(u_opt)sqrt(([u_opt(1),u_opt(2)]-vs(1:2))*([u_opt(1),u_opt(2)]-vs(1:2))');
            %         % [A,b] = conic_cfb_HL(refx, refy, z2, z3, p(1), p(2), a,C);%{refx, refy, xix, xiy, sxQ, syQ, a,C}
            %         [A,b] = conic_cfb_HL2(refx(1), refy(1), z2, z3, p(1), p(2), a,C);%{refx, refy, xix, xiy, sxQ, syQ, a,C}
            %         vs(1:2) = fmincon(fun,[0;0],A,b,[],[],[],[],[],obj.fmc_options);
            %     % for i = 1:2
            %     %     fun = @(u_opt) sqrt((u_opt - vs(i))'*(u_opt - vs(i)));
            %     %     [A,b] = conic_cfb_HL(z2z3(:,i), pL(j(i)),p(i),p(j(i)),a,C);
            %     %     vs(i) = fmincon(fun,0,A,b,[],[],[],[],[],obj.fmc_options);
            %     % end
            %     vs(1:2)
            %     % theta = acos(-[0,0,1]*model.state.pT)*180/pi
            %     sqrt(sum((p(1:2)-pL(1:2)).^2))
            % end

            uf = Uf_SuspendedLoad(x,xd',vf,P);
            
            %usの計算
                % h234 = obj.H234_SuspendedLoad(x,xd',vf,vs',P);%ただの単位行列なのでなくてもいい
                invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);
                vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);%vs - alpha
                us = [0;invbeta2*vs_alpha2];%h234*invbeta2*a2;
            %{
            cha = obj.self.reference.cha;
            tmpHL = obj.self.controller.hlc.result.input;%flight以外は通常のモデルで飛ばす
            if strcmp(cha,'f')%計算時間的に@do_controllerで分岐させた方がいい
                tmp = uf + us;
            else
                tmp = tmpHL;
            end
            obj.self.controller.result.input = tmp;
            obj.result.input = tmp;
            %}

            tmp = uf + us;
            % control barrier funciton
                % fun = @(u_opt) sqrt((u_opt - tmp)'*(u_opt - tmp));
                % a=[10;4.8];
                % k = 5;
                % C=5;%deg
                % Cq =5;%機体角度
                % % [A,b] = conic_q_cfb(x,P,a,C*pi/180,Cq*pi/180);
                % % [A,b] = conic_cfb(x,P,a,C*pi/180);
                % 
                % % [A,b] = conic_cfb_x3(x,P,a,C*pi/180);
                % % x = [model.state.q;model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
                % % [A,b] = conic_cfb_eul(x,P,a,C*pi/180);
                % % [A,b] = conic_cfb_sigmoid(x,P,a,k,C*pi/180);
                % % [A,b] = conic_cfb_log(x,P,a,C*pi/180);
                % % [h1,h2]=conic_cfb_h1h2(x,obj.u_opt0,P,a,C*pi/180);
                % 
                % 
                % % if h2 < 0
                % %     am=[100;10];
                % %     [A,b] = conic_cfb(x,P,am,C*pi/180);
                % % else
                % %     aM=[100;10];
                % %     [A,b] = conic_cfb(x,P,aM,C*pi/180);
                % % 
                % % % [A,b] = conic_cfb_sigmoid(x,P,aM,k,C*pi/180);
                % % end
                % [A,b] = conic_cfb(x,P,a,C*pi/180);
                % tmp_opt = fmincon(fun,obj.u_opt0,A,b,[],[],[],[],[],obj.fmc_options);
                % % obj.u_opt0 = 10;
                % obj.u_opt0 = tmp_opt;
                % if agent{1}.t >0
                %     tmp = tmp_opt;
                % end
                % 
                % %チェック用
                % pT = model.state.pT;
                % % wL = model.state.wL
                % % h1 = wL(2)*pT(1)-wL(1)*pT(2)+1*h0;
                % % [h1,h2] = conic_q_cfb_h1h2(x,tmp_opt,P,a,C*pi/180,Cq*pi/180);
                % [h1,h2]=conic_cfb_h1h2(x,tmp_opt,P,a,C*pi/180);
                % % [h1,h2]=conic_cfb_x3_h1h2(x,tmp_opt,P,a,C*pi/180);
                % % [h1,h2]=conic_cfb_eul_h1h2(x,tmp_opt,P,a,C*pi/180);
                % % [h1,h2]=conic_cfb_sigumoid_h1h2(x,tmp_opt,P,a,k,C*pi/180);
                % % [h1,h2]=conic_cfb_log_h1h2(x,tmp_opt,P,a,C*pi/180);
                % theta = acos(-[0,0,1]*pT)*180/pi;
                % 
                % % [ERb0,EL] = RodriguesQuaternion(model.state.getq('4')); 
                % % h0=-pT(3)-cos(C*pi/180)+(ERb0*[0;0;1])'*[0;0;1] - cos(Cq*pi/180);
                % h0=-pT(3)-cos(C*pi/180);
                % 
                % % if h2<0
                % %     a_h0 = am(1)*h0;
                % % else
                % %     a_h0 = aM(1)*h0;
                % % end
                % % dh0 = h1 - a_h0;
                % % if h2<0
                % %     a_h1 = am(2)*h1;
                % % else
                % %     a_h1 = aM(2)*h1;
                % % end
                % 
                % a_h0 = a(1)*h0;
                % dh0 = h1 - a_h0;
                % a_h1 = a(2)*h1;
                % % a_h1 = a(2)*h1^3;
                % % a_h1 = a(2)*(1/(exp(-k*h1) + 1) - 0.5);
                % % a_h1 = a(2)*log(h1 +1);
                % dh1 = h2 - a_h1;
                % 
                % fprintf("t:%3.3f[s] \t  theta:%3.3f[deg] \t h0:%1.3f \t dh0:%1.3f \t h1:%1.3f \t dh1:%1.3f \t h2:%1.3f \t A:%1.3f \t  B:%1.3f \t b/A:%1.3f \n\n", agent{1}.t,theta,h0,dh0,h1,dh1,h2, A(1),b, b/A(1))
                % obj.result.C = C;
                % obj.result.theta = theta;
                % obj.result.h0 = h0;
                % obj.result.ah0 = a_h0;
                % obj.result.dh0 = dh0;
                % obj.result.h1 = h1;
                % obj.result.ah1 = a_h1;
                % obj.result.dh1 =dh1;
                % obj.result.a =a;

                
            obj.result.input = tmp;
            % obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            result = obj.result;
            
            
        end
        function show(obj)
            obj.result
        end
    end
end