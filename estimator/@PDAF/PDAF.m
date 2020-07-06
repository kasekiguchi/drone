classdef PDAF < ESTIMATOR_CLASS
    % Probabilistic data association filter based on feature points
    % yReceived information from NATNETz
    %    EThe number of feature points
    %    EThe feature point position on robot coordinate
    %    EAll observations from sensor
    properties (Access = public)
        %state
        result
        dt                             % Sampling time
        feature                        % All observations from sensor
        param                          % Prameter of drone and PDAF
        ProbabilityDensityFunction     % Probability density function
        local_feature                  % Feature point position of estimated object on robot cordinate
        JacobianF                      % Coefficient matrix generation function after extended linearization
        H                              % Output function
        JacobianH                      % Extended linearization of output function
        self
    end
    methods
        function obj = PDAF(self,Param)
            %yInputz self : agent  obj
            %          param : Construct of sensor
            %yOutputzobj
            obj.self= self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","q","v","w"],'num_list',[3,3,3,3],'type','euler'));
            %%% Parameter for estimationg as the drone %%%
            % For simulation
            param = Param{1};
            obj.param.sigmaw      = param.sigmaw;                                    % The variance vector of observation noise 
            obj.param.sigmav      = [8.0E-6;8.0E-6;8.0E-6;1.0E-6;1.0E-6;1.0E-6];     % The variance vector of system noise
            obj.param.R           = [];                                              % Observation covariance matrix of all object feature
            obj.param.PD          = 0.8;                                             % Target probability
            obj.param.PG          = 0.8;                                             % Gate probability
            obj.param.lambda      = 1;                                               % Expected value of Poisson distribution
            obj.param.gamma       = 1;                                               % Validation region
            obj.param.SNR         = 1.0E-5;                                          % SN ratio for initial value of posterior error covariance matrix

            % For experiment for model less
%             obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
%             obj.param.sigmav      = [50;50;50;0.9E02;0.9E02;1.8E02];                 % The variance vector of system noise
%             obj.param.lambda      = 4;                                               % Expected value of Poisson distribution
%             obj.param.gamma       = 1.2;                                             % Validation region
%             obj.param.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix
            
             % For experiment for using input model
%             obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
%             obj.param.sigmav      = [50;50;50;6.0E01;6.0E01;6.0E01];                 % The variance vector of system noise
%             obj.param.lambda      = 4;                                               % Expected value of Poisson distribution
%             obj.param.gamma       = 1.0;                                             % Validation region
%             obj.param.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix

            % For simulation
            obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
            obj.param.sigmav      = [50;50;50;100;100;200];                          % The variance vector of system noise
            obj.param.lambda      = 4;                                               % Expected value of Poisson distribution
            obj.param.gamma       = 1.8;                                             % Validation region
            obj.param.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix
            
            % Common parameter for simulation and experiment
            obj.param.Q           = eye(6).*obj.param.sigmav;                        % Covariance matrix of system noise
            obj.param.Ri          = eye(3).*obj.param.sigmaw;                        % Observation covariance matrix of one feature
            obj.param.InvRi       = inv(obj.param.Ri);                               % Inverse Observation covariance matrix of one feature
            obj.param.P           = eye(12)*obj.param.SNR;                           % Initial posterior error covariance matrix
            
            % Output eauation
            X_sym  = sym('X_sym', [12,1]);                                  % The symboric of state
            mx     = sym('mx',    [3,1]);                                   % The symboric of feature point position on robot cordinate
            OFfile = "output_function_for_marker_position";
            if exist(OFfile,"file")
                obj.H = str2func(OFfile);
                obj.JacobianH = str2func(strcat("Jacobian_",OFfile));
            else
                % Rotation matrix
                Rotation_sym    = [cos(X_sym(6)),-sin(X_sym(6)),0;sin(X_sym(6)),cos(X_sym(6)),0;0,0,1]*...
                                  [cos(X_sym(5)),0,sin(X_sym(5));0,1,0;-sin(X_sym(5)),0,cos(X_sym(5))]*...
                                  [1,0,0;0,cos(X_sym(4)),-sin(X_sym(4));0,sin(X_sym(4)),cos(X_sym(4))];
                % Output equation against one feature
                %   Simultaneous transformation matrix of feature point position in robot coordinate system and feature point position in global coordinate system
                obsmodel_sub     = Rotation_sym * mx + X_sym(1:3);
                obj.H  =matlabFunction(obsmodel_sub,'File',"estimator/ExtendedLinearization/output_function_for_marker_position.m",'Vars',{X_sym,mx},'Comments',"yInputsz\n\t pos ([1;1;1]): position of COG of the rigid body\n\t mx (=[1 2 3;1 1 1]): marker position w. r. t. pos");
                % Extended initialization of output equation of one feature
                dhi_sub          = pdiff(obsmodel_sub,X_sym);
                obj.JacobianH    = matlabFunction(dhi_sub,'File',"estimator/ExtendedLinearization/Jacobian_output_function_for_marker_position.m",'Vars',{X_sym,mx});
            end
            % Probability density function
            Z          = sym('Z',    [1, 3]);                               % Symbolic of observation
            hatZ       = sym('hatZ', [1, 3]);                               % Symbolic of predicted observation
            Cov        = sym('Cov',  [3, 3]);                               % Symbolic of error covariance matrix
            PDfunction = 1 / sqrt((2 * pi())^3* det(Cov)) * exp(-1/2 * (Z - hatZ) / (Cov) * (Z - hatZ)');
            obj.ProbabilityDensityFunction = matlabFunction(PDfunction,'Vars',{Z,hatZ,Cov});            
            %            [obj.H,obj.JacobianH,obj.ProbabilityDensityFunction,obj.param] = DroneParam(param);
            model = obj.self.model;
            obj.dt = model.dt;                                        % Sampling time
            ELfile=strcat("Jacobian_",model.name);                    % Extended initialization of model
            if ~exist(ELfile,"file")
                obj.JacobianF = ExtendedLinearization(ELfile,model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.JacobianF = @(x,~) diag(ones(1,6),6);
        end
        function result = do(obj,param,~)
            %yInputz  param : optional
            %yOutputz obj            
            model  = obj.self.model;                                              % agent.model
            sensor = obj.self.sensor.result;                                              % agent.sensor.result
            if isempty(obj.local_feature)
                obj.local_feature = sensor.local_feature;                   % Feature point position of estimated object on robot cordinate
            end
            if ~isfield(obj.param,'on_feature_num')
                warning("ACSL : check all feature points on target are visible.");
                obj.param.on_feature_num = sensor.on_feature_num;           % The number of estimated object feature
            end
            obj.param.feature_num = size(sensor.feature,1);                 % The number of observation
            if isempty(obj.param.R)
                % Observation covariance matrix of all object feature
                obj.param.R      = eye(obj.param.on_feature_num*3) .*repmat(obj.param.sigmaw,[obj.param.on_feature_num,1]);
            end
            obj.feature  = sensor.feature;                                  % All observations from sensor
            if isempty(obj.feature)
                error("ACSL : all marker lost.");
            end
            
            %%% Probabilistic data association filter %%%
            obj.dt = sensor.dt;                                             % Sampling time
            % Prior estimation with input 
            tmp.Xhbar  = [model.state.p;model.state.getq('euler');model.state.v;model.state.w];
            % Prior estimation without input
%             tmp.Xhbar  = (eye(12)+diag(obj.dt*ones(1,6),6))*obj.result.state.get();
            A          = expm(obj.JacobianF(model.state.get(),model.param)*obj.dt);                                                        % Discretized linear matrix
            B          = [eye(6)*obj.dt^2;eye(6)*obj.dt];                                                                                  % System noise coefficient matrix
            tmp.dh     = arrayfun(@(k) obj.JacobianH(tmp.Xhbar,obj.local_feature(k,:)'),1:obj.param.on_feature_num,'UniformOutput',false); % Extended linearized matrix of output equations
            tmp.Pbar   = A * obj.param.P * A' + B * obj.param.Q * B';                                                                      % Prior error covariance matrix
            tmp.S      = cell2mat(tmp.dh') * tmp.Pbar * cell2mat(tmp.dh')' +  obj.param.R;                                                 % Innovation covariance matrix against rigid 
            tmp.Si     = arrayfun(@(k) tmp.dh{k} * tmp.Pbar * tmp.dh{k}' + obj.param.Ri,1:obj.param.on_feature_num,'UniformOutput',false); % Innovation covariance matrix of one feature point
            for k = 1:obj.param.on_feature_num
                [tmpvec,tmpval] = eig(tmp.Si{k});                           % Eigenvalues of the innovation covariance matrix
                obj.result.Eigenvalues_hold(1,3*(k-1)+1:3*k)=trace(tmpval);
                obj.result.Eigenvaluesvector_hold{1,k} = tmpvec;            % Right eigenvector of the innovation covariance matrix
            end
            
            tmp = ValidationStep(obj,tmp);                                  % Determining observations within the validation region
            tmp = CalculateWeightting(obj,tmp);                             % Calculating weightting factor
            tmp = FilteringStep(obj,tmp);                                   % Filtering step

            obj.param.P  = tmp.P;                                           % Update posterior error covariance matrix
            obj.result.state.set_state(tmp.Xh);

            % Save result
            obj.result.pSum          = tmp.pSum;                            % The sum of weightting factor against observation in the validation region
            obj.result.ValidationNum = tmp.ValidationNum-1';                % The number of observation in validation region
            Mhat = cell2mat(arrayfun(@(k) obj.H(tmp.Xh,obj.local_feature(k,:)'),1:obj.param.on_feature_num,'UniformOutput',false))';
            obj.result.Mhat          = Mhat;                                % Feature point estimation of estimated object
            result=obj.result;
        end
        function show(obj)
            % ƒRƒ}ƒ“ƒhƒEƒBƒ“ƒh‚É•\Ž¦(Šm”F—p)
            disp("validation numumber = ");
            disp(obj.result.ValidationNum);
            % „’èˆÊ’u‚ð•\Ž¦(‰¼)
            fprintf("p : %.5f,\t%.5f,\t%.5f\n", obj.result.state.p(1),obj.result.state.p(2),obj.result.state.p(3));
            fprintf("q : %.5f,\t%.5f,\t%.5f\n", obj.result.state.q(1),obj.result.state.q(2),obj.result.state.q(3));
            fprintf("v : %.5f,\t%.5f,\t%.5f\n", obj.result.state.v(1),obj.result.state.v(2),obj.result.state.v(3));
            fprintf("w : %.5f,\t%.5f,\t%.5f\n", obj.result.state.w(1),obj.result.state.w(2),obj.result.state.w(3));
        end
    end
end
