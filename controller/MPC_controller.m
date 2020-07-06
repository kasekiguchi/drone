classdef MPC_controller <CONTROLLER_CLASS
    %MPC_CONTROLLER MPC�̃R���g���[���[
    %   fminicon�Ŏ��_�x�[�X��MPC������
    %   �ڍא����������ɋL�q
    
    properties
        options
        param
        previous_input
        previous_state
        model
        result
        self
    end
    
    methods
        function obj = MPC_controller(self,param)
            obj.self = self;
            %options_setting
            obj.options = optimoptions('fmincon');
            obj.options.UseParallel            = false;
            obj.options.Algorithm			   = 'sqp';
            % obj.options.Display                = 'none';
            obj.options.Diagnostics            = 'off';
            obj.options.MaxFunctionEvaluations = 1.e+12;%�֐��]���̍ő��
            obj.options.MaxIterations		   = Inf;%�����̍ő勖�e��
            % obj.options.StepTolerance          = 1.e-12;%x�Ɋւ���I�����e�덷
            obj.options.ConstraintTolerance    = 1.e-3;%����ᔽ�ɑ΂��鋖�e�덷
            % obj.options.OptimalityTolerance    = 1.e-12;%1 ���̍œK���Ɋւ���I�����e�덷�B
            % obj.options.PlotFcn                = [];
            %---MPC�p�����[�^�ݒ�---%
            obj.param.H  = 10;                % ���f���\������̃z���C�]��
            obj.param.dt = 0.25;              % ���f���\������̍��ݎ���
            obj.param.input_size = self.model.dim(2);
            obj.param.state_size = self.model.dim(1);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %������Ԃƃz���C�]�����̍��v
            %�d��%
            obj.param.Q = diag(10*ones(1,obj.param.state_size));
            obj.param.R = diag(10*ones(1,obj.param.input_size));
            obj.param.Qf = diag(10*ones(1,obj.param.state_size));
            
            obj.previous_input = zeros(obj.param.input_size,obj.param.Num);

            obj.model = self.model;
        end
        
        function u = do(obj,param,~)
            % param = {model, reference}
            % param{1}.state : ���肵��state�\����
            % param{2}.result.state : �Q�Ə�Ԃ̍\���� % n x Num :  n : number of state,  Num : horizon
            % param{3} : �\����
            
            %state = state_copy(param{1}.state);
            %model = param{1};
            ref = obj.self.reference.result.state;
            if [obj.param.state_size,obj.param.Num] == size(ref)
                obj.param.Xr = ref.get();
            else
                obj.param.Xr = repmat(0*obj.self.model.state.get(),1,obj.param.Num);%repmat([eul2quat([0,0,0])';10;0;1;zeros(6,1)],1,obj.param.Num) ;
                obj.param.Xr(1:3,:) = repmat(ref.p,1,obj.param.Num);
            end
            
            %obj.param.t = t;
            obj.param.X0 = obj.self.model.state.get();%[state.p;state.q;state.v;state.w];
            obj.param.model = obj.self.model.method;
            obj.param.model_param = obj.self.model.param;
            obj.previous_state = repmat(obj.param.X0,1,obj.param.Num);
            problem.solver    = 'fmincon';
            problem.options   = obj.options;
            problem.objective = @(x) obj.objective(x, obj.param);  % �]���֐�
            problem.nonlcon   = @(x) obj.constraints(x, obj.param);% �������
            problem.x0		  = [obj.previous_state;obj.previous_input]; % �������
            %[var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
            [var, ~,~,~,~,~,~] = fmincon(problem);
            obj.result.input = var(obj.param.state_size + 1:obj.param.total_size, 1);
            u = obj.result;
            obj.previous_input = var(obj.param.state_size + 1:obj.param.total_size, :);            
        end
        function show(obj)
            
        end
        function [eval] = objective(obj,x, params)
            % ���f���\������̕]���l���v�Z����v���O����

            %-- MPC�ŗp����\����� X�Ɨ\������ U��ݒ�
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:end, :);
            
            %-- ��ԋy�ѓ��͂ɑ΂���ڕW��Ԃ�ڕW���͂Ƃ̌덷���v�Z
            tildeX = X - params.Xr;
            %     tildeU = U - params.Ur;
            tildeU = U;
            %-- ��ԋy�ѓ��͂̃X�e�[�W�R�X�g���v�Z
            stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
            stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
            %-- ��Ԃ̏I�[�R�X�g���v�Z
            terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
            %-- �]���l�v�Z
            eval = sum(stageState + stageInput) + terminalState;
        end
        function [cineq, ceq] = constraints(obj,x, params)
            % ���f���\������̐���������v�Z����v���O����
            cineq  = zeros(params.state_size, 4*params.H);
            %-- MPC�ŗp����\����� X�Ɨ\������ U��ݒ�
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:end, :);
            
            %-- ������Ԃ����ݎ����ƈ�v���邱�ƂƏ�ԕ������ɏ]�����Ƃ�ݒ�
            %TEMP_predictX = cell2mat(arrayfun(@(N) ode45(@(t,x) params.model(x,U(:,N),params.model_param),[params.dt*(N-2) params.dt*(N-1)],X(:,N-1)),2:params.Num,'UniformOutput',false));
            %PredictX = cell2mat(arrayfun(@(L) TEMP_predictX(L).y(:,end),1:params.H,'UniformOutput',false));
            PredictX = X+obj.param.dt*obj.self.model.method(X,U,obj.param.model_param);
            
            ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  -  PredictX(:,L-1), 2:params.Num, 'UniformOutput', false))];
            %-- �\�����͂����͂̏㉺������ɏ]�����Ƃ�ݒ�
            %     cineq(:, 1: params.H)	        = cell2mat(arrayfun(@(L) params.U(:, 1) - U(:, L), 1:params.H, 'UniformOutput', false));
            %     cineq(:, params.H+1: 2*params.H)= cell2mat(arrayfun(@(L) U(:, L) - params.U(:, 2), 1:params.H, 'UniformOutput', false));
            %     %-- �\�����͊Ԃł̕ω��ʂ��ω��ʐ���ȉ��ƂȂ邱�Ƃ�ݒ�
            %     cineq(:, 2*params.H+1: 3*params.H) = [cell2mat(arrayfun(@(L) -params.S - (U(:, L) - U(:, L-1)) , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
            %     cineq(:, 3*params.H+1: 4*params.H) = [cell2mat(arrayfun(@(L) (U(:, L) - U(:, L-1)) - params.S  , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
        end
    end
end

