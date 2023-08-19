classdef EKF < handle
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
        y
        y_param
        self
        model
        timer= [];
    end
    
    methods
        function obj = EKF(self,param)
            obj.self= self;
            obj.model = param.model;
            ELfile=strcat("Jacobian_",obj.model.name);
            if ~exist(ELfile,"file")
                obj.JacobianF=ExtendedLinearization(ELfile,obj.model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.result.state= state_copy(obj.model.state);
            obj.y = param.output_func; % output function handle : function of obj.self
            obj.y_param = param.output_param;
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
            %sensor = obj.self.sensor.result;
            %state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
            y = obj.y(obj.self,obj.y_param);
            x = obj.result.state.get(); % estimated state at previous step
            % Pre-estimation
            obj.model.do(varargin{:});
            % 
            % for i = obj.y.qlist
            %   yq = obj.y.get(i);
            %   mq = obj.model.state.get(i);
            %   ids = abs(yq(3:3:end)-mq(3:3:end)) > pi;
            %   mq(3:3:end) = mq(3:3:end) + sign(ids.*mq(3:3:end))*2*pi;
            %   obj.model.state.set_state(i,mq);
            % end
            xh_pre = obj.model.state.get(); % 

            p = obj.self.parameter.get();
            A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
            C = obj.JacobianH(x,p);
            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % Predicted covariance
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
            % G(:,7:8) = 0;
            P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
            tmpvalue = xh_pre + G*(y-C*xh_pre);	% Update state estimate
            tmpvalue = obj.model.projection(tmpvalue);
            obj.result.state.set_state(tmpvalue);
            obj.model.state.set_state(tmpvalue);
            obj.result.G = G;
            obj.result.P = P;
            result=obj.result;
            obj.timer = tic;
        end
    end
end

