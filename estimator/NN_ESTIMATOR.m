classdef NN_ESTIMATOR < handle
   % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : EKFを実装する制御対象の制御モデル
    %   param : required field : Q,R,B,JacobianH
    %  JacobianH(x,p) : 出力方程式の拡張線形化した関数のhandle
      properties
        result
            % state : estimated state
        JacobianF
        JacobianH
        Q
        R
        dt
        B
        n
        sensor % function to get sensor value
        sensor_param
        output_func % function of state
        output_param
        self
        model
        timer= [];
        NN1
        NN2
        Ad
        Bd
        F1
        F2
        F3
        F4
        F
    end
    
    methods
        function obj = NN_ESTIMATOR(self,param)
            obj.self= self;
            obj.model = param.model;
            ELfile=strcat("Jacobian_",obj.model.name);
            if ~exist(ELfile,"file")
                obj.JacobianF=ExtendedLinearization(ELfile,obj.model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.result.state= state_copy(obj.model.state);
            obj.sensor = param.sensor_func; % output function handle : function of obj.self
            obj.sensor_param = param.sensor_param;
            obj.output_func = param.output_func;
            obj.output_param = param.output_param;
            % obj.y= state_copy(obj.model.state);
            % if isfield(param,'list')
            %     obj.y.list = param.list;
            % else
            %     obj.y.list = [];
            % end
            obj.JacobianH = param.JacobianH;
            obj.n = length(obj.model.state.get());
            obj.Q = param.Q;% 分散
            obj.R = param.R;% 分散
            obj.dt = obj.model.dt; % 刻み
            obj.B = param.B;
            obj.result.P = param.P;
            obj.result.G = zeros(obj.n,size(obj.R,2));
            obj.result.NN_est = obj.model.state.get();

            NN1 = importNetworkFromONNX("..\VarietyPack\Takano\HLNN\Result\HLNN_model_tmp1.onnx");
            NN1.Initialized
            % layer =inputLayer([24 1], "SC");
            layer = inputLayer([14 1], "SC");
            obj.NN1 = addInputLayer(NN1,layer);

            NN2 = importNetworkFromONNX("..\VarietyPack\Takano\HLNN\Result\HLNN_model_tmp2.onnx");
            NN2.Initialized
            % layer =inputLayer([24 1], "SC");
            layer = inputLayer([52 1], "SC");
            obj.NN2 = addInputLayer(NN2,layer);

            load("./Data/OriginalData/Ad_Bd_F.mat")
            obj.Ad = Ad;
            obj.Bd = Bd;


            Ac2 = [0,1;0,0];
            Bc2 = [0;1];
            Ac4 = diag([1,1,1],1);
            Bc4 = [0;0;0;1];
            obj.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],obj.dt);                                % 
            obj.F2=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],obj.dt); % xdiag([100,10,10,1])
            obj.F3=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],obj.dt); % ydiag([100,10,10,1])
            obj.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],obj.dt);                       % ヨー角
            obj.F = blkdiag(obj.F1,obj.F2,obj.F3,obj.F4);

            % obj.result.state.set_state("NN_est",[]);
        end
        
        function [result]=do(obj,varargin)
          if ~isempty(obj.timer)
            dt = toc(obj.timer);
            if dt > obj.dt
              dt = obj.dt;
            end
          else
            dt = obj.dt;
          end
          if varargin{1}.t ~= 0
            y = obj.sensor(obj.self,obj.sensor_param); % sensor output
            x = obj.result.state.get(); % estimated state at previous step
            obj.model.do(varargin{:}); % update state
            xh_pre = obj.model.state.get(); % Pre-estimation
            yh = obj.output_func(xh_pre,obj.output_param); % output estimation
            p = obj.self.parameter.get(); 
            A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
            C = obj.JacobianH(x,p);
            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % Predicted covariance
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
            P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
            tmpvalue = xh_pre + G*(y-yh);	% Update state estimate
            tmpvalue = obj.model.projection(tmpvalue);
            obj.result.state.set_state(tmpvalue);
            obj.model.state.set_state(tmpvalue);
           

            xi1 = obj.self.controller.result.z1;
            xi2 = obj.self.controller.result.z2;
            xi3 = obj.self.controller.result.z3;
            xi4 = obj.self.controller.result.z4;

            ref_p = obj.self.reference.result.state.p;
            ref_q = obj.self.reference.result.state.q;
            ref_v = obj.self.reference.result.state.v;
            xd = obj.self.reference.result.state.xd;
            my_xd = zeros([12, 1]);
            my_xd(1) = xd(3);
            my_xd(2) = xd(7);
            my_xd(3) = xd(1);
            my_xd(4) = xd(5);
            my_xd(5) = xd(9);
            my_xd(6) = xd(13);
            my_xd(7) = xd(2);
            my_xd(8) = xd(6);
            my_xd(9) = xd(10);
            my_xd(10) = xd(14);
            my_xd(11) = xd(4);
            my_xd(12) = xd(8);

            A1 = obj.Ad(1:2,1:2);
            B1 = obj.Bd(1:2,1:2);
            F1_ = obj.F(1:2,1:2);
            xi1 = [x(3);x(9)];
            delta1 = xi1-xd(1:2);
            v1   = -F1_*delta1;
            % v1   = -F1*xi1;
            % dv1  = -F1*(A1 - B1*F1)*xi1;
            % ddv1 = -F1*(A1 - B1*F1)^2*xi1;

            x_ = x;
            x_(1:3) = x_(1:3) - obj.self.plant.state.p;

            xi = cast(predict(obj.NN1,[x_;v1]), "double")';
            xi = [xi1;x(1);x(7);xi(1:2);x(2);x(8);xi(3:4);x(6);x(12)];
            
            v = obj.F*(xi-my_xd);
            xi_plus = obj.Ad*xi - obj.Bd*v;

            input_NN2 = [x_;xi;xi_plus;v;my_xd];
            prob = cast(predict(obj.NN2, input_NN2)', "double");
            obj.result.NN_est = prob;

            xh_pre = prob; % Pre-estimation
            yh = obj.output_func(xh_pre,obj.output_param); % output estimation
            p = obj.self.parameter.get(); 
            A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
            C = obj.JacobianH(x,p);
            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % Predicted covariance
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
            P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
            tmpvalue = xh_pre + G*(y-yh);	% Update state estimate
            tmpvalue = obj.model.projection(tmpvalue);
            % obj.result.NN_est = tmpvalue;


            % obj.result.state.set_state(tmpvalue);
            % obj.model.state.set_state(tmpvalue);
            
            tmpvalue
            % obj.result.state.set_state(prob(5:end));
            % obj.model.state.set_state(prob(5:end));
          end
            result=obj.result;
            obj.timer = tic;
        end
    end
end

