classdef HLController_ATMEC < CONTROLLER_CLASS
    % �N�A�b�h�R�v�^�[�p�K�w�^���`�����g�������͎Z�o��AT-MEC�𓱓�
    properties
        self
        result
        param
        Q
        A2 = [0 1;0 0];
        B2 = [0;1];
        A4 =diag([1 1 1],1);
        B4 = [0;0;0;1];
        A2d
        B2d
        A4d
        B4d
        time % �ғ����Ԋ֘A�̊i�[
        dv1p %1�����O�̕⏞����
        vp%�P�����O�̉��z����
        % RLS�A���S���Y��
        G%���֊֐�
        g
        gamma %���֊֐��W��
        lambda%�Y�p�W��
        alpha %���[�p�X�t�B���^���x
        %�]���֐��v�Z
        h % =M*(xi_n(i) - xi_a(i))
        % eta = M*v(i)-F(xi_a(i) - M*xi_a(i))
        eta1 % =M*v(i)
        eta2  % =M*xi_a(i)

    end
    
    methods
        function obj = HLController_ATMEC(self,param,~)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            %MEC
            obj.dv1p = 0;
            obj.result.K = param.K;
            %�K�w�^���`��
            obj.A2 = param.A2;
            obj.B2 = param.B2;
            obj.A4 = param.A4;
            obj.B4 = param.B4;
            %AT-MEC
            %�e�ϐ�������
            obj.vp= [0 0 0];
            obj.result.Khat = param.K;
            obj.h.z1 = [0;0];
            obj.h.z2 = [0;0;0;0];
            obj.h.z3 = [0;0;0;0];
            obj.eta1.z1 = [0;0];
            obj.eta1.z2 = [0;0;0;0];
            obj.eta1.z3 = [0;0;0;0];
            obj.eta2.z1 = [0;0];
            obj.eta2.z2 = [0;0;0;0];
            obj.eta2.z3 = [0;0;0;0];
            obj.alpha = param.alpha;
            obj.gamma = param.gamma;
            obj.lambda = param.lambda;
            obj.G.z1=param.gamma.z*eye(2);
            obj.G.z2=param.gamma.x*eye(4);
            obj.G.z3=param.gamma.y*eye(4);
            obj.g.z1=[0;0];
            obj.g.z2=[0;0;0;0];
            obj.g.z3=[0;0;0;0];
            
            obj.time.previous = 0; %1step�O�̎��s���������l
            obj.time.RLS_begin = param.RLS_begin; %�⏞�Q�C���̍X�V���n�߂鎞��
            obj.time.FRIT_begin = param.FRIT_begin;%�⏞�Q�C���̐�����n�߂鎞��
        end
        
        function result = do(obj,time,varargin) 
            % param (optional) : �\���́F�����p�����[�^P�C�Q�C��F1-F4 
            % varargin : nominal input
            
            model = obj.self.model;
            ref = obj.self.reference.result;
           plant = obj.self.estimator;%estimator�̒l���V�X�e���̏o�͂Ƃ݂Ȃ�

            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20�����̖ڕW�l�ɑΉ�����悤
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            xd=[xd;zeros(20-size(xd,1),1)];% ����Ȃ����͂O�Ŗ��߂�D
            %x=cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
            %x = state.get();%��ԃx�N�g���Ƃ��Ď擾
% 
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            xn = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]�ɕ��בւ�
            x = [R2q(Rb0'*plant.result.state.getq("rotmat"));Rb0'*plant.result.state.p;Rb0'*plant.result.state.v;plant.result.state.w]; % [q, p, v, w]�ɕ��בւ�
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            
            if isfield(Param,'dt')
                dt = Param.dt;
                vfn = Vfd(dt,xn,xd',P,F1);
                vf = Vfd(dt,x,xd',P,F1);
            else
                vfn = Vf(xn,xd',P,F1);%v1
                vf = Vf(x,xd',P,F1);%v1
            end
            
%% MEC
            Kz = obj.result.K(1:2);
            Kx = obj.result.K(3:6);
            Ky = obj.result.K(7:10);
           %nominal����`��
%             obj.xn=obj.state.get();
            z1n = Z1(xn,xd',P);
            z2n = Z2(xn,xd',vfn,P);
            z3n = Z3(xn,xd',vfn,P);
            z4n = Z4(xn,xd',vfn,P);

            yn = [z1n;z2n;z3n;z4n];
            
            %plant����`��
            z1 = Z1(x,xd',P);
            z2 = Z2(x,xd',vf,P);
            z3 = Z3(x,xd',vf,P);
            z4 = Z4(x,xd',vf,P);
            y = [z1;z2;z3;z4];

            dy = yn - y; %���z��ԂƂ̌덷���Z�o
            
            dv1 =  Kz*dy(1:2);%�⏞����
            dv1d = (dv1 - obj.dv1p)/dt;
            
            vf = vf + [dv1 dv1d 0 0];
            
            vs = Vs(x,xd',vf,P,F2,F3,F4);%v2-4
            dv2 = Kx* dy(3:6);
            dv3 = Ky* dy(7:10);
            dv4 = 0;
            vs = vs + [dv2 dv3 dv4];
            
           tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);   %Uf,Us:�����͕ϊ�
           obj.result.input = [tmp(1);
                                        tmp(2);
                                        tmp(3);
                                        tmp(4)];
            
%             obj.result.input = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P); 
             
%% AT-MEC
            Kz_hat = obj.result.Khat(1:2);
            Kx_hat = obj.result.Khat(3:6);
            Ky_hat = obj.result.Khat(7:10);
            
            DT = time - obj.time.previous; % ���ݎ����ƂPstep�O�̎�������o�ߎ��Ԃ��Z�o

            % FRIT
            %FRIT_begin�Ŏw�肵�����Ԃ܂�FRIT,RLS�����s���Ȃ�
            if(time<obj.time.FRIT_begin)
                eta.z1 = obj.eta1.z1(1) - F1*(z1 - obj.eta2.z1);
                epsilon.z1 = Kz*obj.h.z1 - eta.z1;
                eta.z2 = obj.eta1.z2(1) - F2*(z2 - obj.eta2.z2);
                epsilon.z2 = Kx*obj.h.z2 - eta.z2;
                eta.z3 = obj.eta1.z3(1) - F3*(z3 - obj.eta2.z3);
                epsilon.z3 = Ky*obj.h.z3 - eta.z3;
            end
            
            if(time>=obj.time.FRIT_begin)
                %���f���𗣎U�� x[i+1] = Ad*x[i] + Bd*u[i]
                sys = ss(obj.A2,obj.B2,zeros(2),[0;0]);
                d2 = c2d(sys,DT);
                obj.A2d = d2.A;
                obj.B2d = d2.B;
                sys = ss(obj.A4,obj.B4,zeros(4),[0;0;0;0]);
                d4 = c2d(sys,DT);
                obj.A4d = d4.A;
                obj.B4d = d4.B;
                
                % c2d���g��Ȃ�1�K�����܂ł̋ߎ��v�Z��
                % A2d = eye(2)+obj.A2*dt;
                % B2d = DT*obj.B2;
                % A4d = eye(4)+obj.A4*dt;
                % B4d = DT*obj.B4;

                %�P������̏�Ԃ𗣎U��������ԕ���������v�Z
                %z1
                obj.h.z1 = obj.IdealModel(obj.A2d,obj.B2d,obj.h.z1,z1n-z1,F1);
                udu.z1 = [vf(1);(vf(1)-obj.vp(1))/DT];
                obj.eta1.z1 = obj.IdealModel(obj.A2d,obj.B2d,obj.eta1.z1,udu.z1,F1);
                obj.eta2.z1 = obj.IdealModel(obj.A2d,obj.B2d,obj.eta2.z1,z1,F1);
                eta.z1 = obj.eta1.z1(1) - F1*(z1 - obj.eta2.z1);
                epsilon.z1 = Kz*obj.h.z1 - eta.z1;
                %z2
                obj.h.z2 = obj.IdealModel(obj.A4d,obj.B4d,obj.h.z2,z2n-z2,F2);
                udu.z2 = [vs(1);(vs(1)-obj.vp(2))/DT;0;0];
                obj.eta1.z2 = obj.IdealModel(obj.A4d,obj.B4d,obj.eta1.z2,udu.z2,F2);
                obj.eta2.z2 = obj.IdealModel(obj.A4d,obj.B4d,obj.eta2.z2,z2,F2);
                eta.z2 = obj.eta1.z2(1) - F2*(z2 - obj.eta2.z2);
                epsilon.z2 = Kx*obj.h.z2 - eta.z2;
                %z3
                obj.h.z3 = obj.IdealModel(obj.A4d,obj.B4d,obj.h.z3,z3n-z3,F3);
                udu.z3 = [vs(2);(vs(2)-obj.vp(3))/DT;0;0];
                obj.eta1.z3 = obj.IdealModel(obj.A4d,obj.B4d,obj.eta1.z3,udu.z3,F3);
                obj.eta2.z3 = obj.IdealModel(obj.A4d,obj.B4d,obj.eta2.z3,z3,F3);
                eta.z3 = obj.eta1.z3(1) - F3*(z3 - obj.eta2.z3);
                epsilon.z3 = Ky*obj.h.z3 - eta.z3;
% RLS
                %z1
                hGh = obj.h.z1'*obj.G.z1*obj.h.z1;
                obj.g.z1 = (obj.G.z1 * obj.h.z1)/(obj.lambda.z+hGh);
                obj.G.z1 = (obj.G.z1 - obj.g.z1*(obj.h.z1'*obj.G.z1))/obj.lambda.z;
                Kz_hat = Kz_hat+obj.g.z1'*(eta.z1-Kz_hat*obj.h.z1);
                %z2
                hGh = obj.h.z2'*obj.G.z2*obj.h.z2;
                obj.g.z2 = (obj.G.z2 * obj.h.z2)/(obj.lambda.x+hGh);
                obj.G.z2 = (obj.G.z2 - obj.g.z2*(obj.h.z2'*obj.G.z2))/obj.lambda.x;
                Kx_hat = Kx_hat+obj.g.z2'*(eta.z2-Kx_hat*obj.h.z2);
                %z3
                hGh = obj.h.z3'*obj.G.z3*obj.h.z3;
                obj.g.z3 = (obj.G.z3 * obj.h.z3)/(obj.lambda.y+hGh);
                obj.G.z3 = (obj.G.z3 - obj.g.z3*(obj.h.z3'*obj.G.z3))/obj.lambda.y;
                Ky_hat = Ky_hat+obj.g.z3'*(eta.z3-Ky_hat*obj.h.z3);

                %�Q�C���X�V �R�����g�A�E�g�ŏ����⏞�Q�C���̂܂�=�ʏ��MEC�Ɠ���
                obj.result.Khat = [Kz_hat Kx_hat Ky_hat];

                if(time>=obj.time.RLS_begin)
%                     alpha = obj.alpha_z; % 12/03 ���[�p�X�t�B���^�����Ԃŕϓ�����������
                    Kz = (1-obj.alpha.z)*Kz+obj.alpha.z*Kz_hat;
                    Kx = (1-obj.alpha.x)*Kx+obj.alpha.x*Kx_hat;
                    Ky = (1-obj.alpha.y)*Ky+obj.alpha.y*Ky_hat;
                    obj.result.K = [Kz Kx Ky];
                end
            end
%% �v�Z����
            %previous �X�V
            obj.dv1p =dv1; %dv1p�X�V
            obj.vp = [vf(1) vs(1) vs(2)];
            obj.time.previous = time;
            
            %% ����`�F�b�N�p
            %�]���֐�
%             obj.result.h = [obj.h.z1, obj.h.z2, obj.h.z3];
%             obj.result.eta = [eta.z1, eta.z2, eta.z3];
%             obj.result.eta1 = [obj.eta1.z1, obj.eta1.z2, obj.eta1.z3];
%             obj.result.eta2 = [obj.eta2.z1, obj.eta2.z2, obj.eta2.z3];
            
            obj.result.eps = [epsilon.z1, epsilon.z2, epsilon.z3];
            %���s��������ł����epssum�������� �����Ƃ����������Ȃ���?
            if (time ==0) 
                obj.result.epssum = [0 0 0];
            end 
            obj.result.epssum = [obj.result.epssum(1)*obj.lambda.z+obj.result.eps(1)^2, obj.result.epssum(2)*obj.lambda.x+obj.result.eps(2)^2, obj.result.epssum(3)*obj.lambda.y+obj.result.eps(3)^2];
            %���z���
            obj.result.z_out = y;
            obj.result.zn_out = yn;
            %���z����
            obj.result.v_out = [vf vs];
            
            %%
            obj.self.input = obj.result.input;
            result = obj.result;
        end
    function result = IdealModel(obj,A,B,state,ref,F)
        % AT-MEC �⏞�Q�C���`���[�j���O��FRIT�A���S���Y���̗��z���f��M���܂ތv�Z
        % IdealModel(A,B,state,ref,F)
        % A,B : ���U��������ԋ�ԕ\���W��
        % state : �X�V�������o��
        % ref : �ڕW�l M*ref
        % F : �m�~�i���R���g���[��
        u = F * (ref - state);
        state = A * state + B * u;
        result = state;
    end
        function show(obj)
            obj.result
        end
        
    end
end