classdef HLController_plusMEC_quadcopter < CONTROLLER_CLASS
    % �N�A�b�h�R�v�^�[�p�K�w�^���`�����g�������͎Z�o�Ƀ��f���덷�⏞��𓱓�
    properties
        self
        result
        param
        Q
        K%�⏞�Q�C�� input�̎����ɍ��킹�� �Q�l ��΂���
        dv1p %1�����O�̕⏞����
        A2 = [0 1;0 0];
        B2 = [0;1];
        A4 =diag([1 1 1],1);
        B4 = [0;0;0;1];
    end
    
    methods
        function obj = HLController_plusMEC_quadcopter(self,param,~)
            obj.self = self;
            obj.param = param;
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            %MEC�ǉ�
            obj.dv1p = 0;
            obj.K = param.K;

        end
        
        function result = do(obj,param,varargin) 
            % param (optional) : �\���́F�����p�����[�^P�C�Q�C��F1-F4 
            % varargin : nominal input
            
            model = obj.self.model;
            ref = obj.self.reference.result;
            xn = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]�ɕ��בւ�
            plant = obj.self.estimator;%estimator�̒l���V�X�e���̏o�͂Ƃ݂Ȃ�
            x  = [plant.result.state.getq('compact');plant.result.state.p;plant.result.state.v;plant.result.state.w]; % [q, p, v, w]�ɕ��בւ�

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
            %     xd=Xd.p;
            %     if isfield(Xd,'v')
            %         xd=[xd;Xd.v];
            %         if isfield(Xd,'dv')
            %             xd=[xd;Xd.dv];
            %         end
            %     end
            xd=[xd;zeros(20-size(xd,1),1)];% ����Ȃ����͂O�Ŗ��߂�D
            %x=cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
            %x = state.get();%��ԃx�N�g���Ƃ��Ď擾
% 
%             Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
%             x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]�ɕ��בւ�
%             xd(1:3)=Rb0'*xd(1:3);
%             xd(4) = 0;
%             xd(5:7)=Rb0'*xd(5:7);
%             xd(9:11)=Rb0'*xd(9:11);
%             xd(13:15)=Rb0'*xd(13:15);
%             xd(17:19)=Rb0'*xd(17:19);
%             
            if isfield(Param,'dt')
                dt = Param.dt;
                vfn = Vfd(dt,xn,xd',P,F1);
                vf = Vfd(dt,x,xd',P,F1);
            else
                vfn = Vf(xn,xd',P,F1);%v1
                vf = Vf(x,xd',P,F1);%v1
            end
            
            %��������MEC
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
            
            dv1 =  obj.K(1)*dy(1);%�⏞����
            dv1d = (dv1 - obj.dv1p)/dt;
            
            vf = vf + [dv1 dv1d 0 0];
            
            vs = Vs(x,xd',vf,P,F2,F3,F4);%v2-4
            dv2 = obj.K(2)* dy(3);
            dv3 = obj.K(3)* dy(7);
            dv4 = 0;
            vs = vs + [dv2 dv3 dv4];
            
           tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);   %Uf,Us:�����͕ϊ�
           obj.result.input = [tmp(1);
                                        tmp(2);
                                        tmp(3);
                                        tmp(4)];
            
%             obj.result.input = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P); 
            
            obj.dv1p =dv1; %dv1p�X�V

          
%             if isfield(Param,'dt')
%                 dt = Param.dt;
%                 vf = Vfdp(dt,x,xd',P,F1);
%             else
%                 vf = Vfp(x,xd',P,F1);
%             end
%             vs = Vsp(x,xd',vf,P,F2,F3,F4);
%             obj.result = Ufp(x,xd',vf,P) + Usp(x,xd',vf,vs',P);
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

