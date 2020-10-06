classdef EKF < ESTIMATOR_CLASS
   % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : EKF���������鐧��Ώۂ̐��䃂�f��
    %   param : required field : Q,R,B,JacobianH
    %  JacobianH(x,p) : �o�͕������̊g�����`�������֐���handle
      properties
        %state
        result
        JacobianF
        JacobianH
        H
        Q
        R
        dt
        B
        n
        y
        self
    end
    
    methods
        function obj = EKF(self,param)
            obj.self= self;
            obj.self.input = [0;0;0;0];
            model = self.model;
            ELfile=strcat("Jacobian_",model.name);
            if ~exist(ELfile,"file")
                obj.JacobianF=ExtendedLinearization(ELfile,model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.result.state= state_copy(model.state);
            obj.y= state_copy(model.state);
            if isfield(param,'list')
                obj.y.list = param.list;
            else
                obj.y.list = [];
            end
            obj.H = param.H; % �o�͕�����
            obj.JacobianH = param.JacobianH;
            obj.n = length(model.state.get());
            obj.Q = param.Q;% ���U
            obj.R = param.R;% ���U
            obj.dt = model.dt; % ����
            obj.B = param.B;
            obj.result.P = param.P;
        end
        
        function [result]=do(obj,param,~)
            %   param : optional
            model=obj.self.model;
            sensor = obj.self.sensor.result;
            x = obj.result.state.get(); % �O�񎞍�����l
            xh_pre = obj.result.state.get() + model.method(x,obj.self.input,model.param) * obj.dt;	% ���O����
%             xh_pre = model.state.get(); % ���O���� �F���͂���̏ꍇ �imodel���X�V����Ă���O��j
            if isempty(obj.y.list)
                obj.y.list=sensor.state.list; % num_list�͑�����Ă͂����Ȃ��D
            end
                state_convert(sensor.state,obj.y);% sensor�̒l��y�`���ɕϊ�
            p = model.param;
            if ~isempty(param)
                F=fieldnames(param);
                for i = 1: length(F)
                    if strcmp(F{i},"P")
                        obj.result.(F{i}) = param.(F{i}); %
                    else
                        obj.(F{i}) = param.(F{i}); %
                    end
                end
            end
            A = eye(obj.n)+obj.JacobianF(x,p)*obj.dt; % Euler approximation
            C = obj.JacobianH(x,p);

            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % ���O�덷�����U�s��
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % �J���}���Q�C���X�V
            P    = (eye(obj.n)-G*C)*P_pre;	% ����덷�����U
            tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	% ���㐄��
            obj.result.state.set_state(tmpvalue);
            obj.result.G = G;
            obj.result.P = P;
            result=obj.result;
        end
        function show()
        end
    end
end

