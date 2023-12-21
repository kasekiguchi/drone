classdef SEKF < handle
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
    means
    stds
end

methods
    function obj = SEKF(self,param)
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
        obj.result.A = zeros(obj.n,size(obj.R,2));
        obj.result.C = zeros(obj.n,size(obj.R,2));
        obj.result.param = zeros(1,18);
        obj.means =[0.4326;
               -0.0189;
                1.4434;
               -0.0023;
                0.0012;
                0.0115;
                0.0367;
                0.0283;
                0.0355;
                0.0024;
               -0.0331;
               -0.0002;
               -1.7936;
                0.9059;
                5.8232;
                0.00001;
                0.0113;
               1.2200;];
            
            obj.stds =[
                0.3981;
                0.2862;
                0.3421;
                0.0596;
                0.0392;
                0.0708;
                0.3600;
                0.2736;
                0.5002;
                0.2125;
                0.2607;
                0.2727;
                9.7668;
                0.6813;
                8.9623;
                0.00001;
                0.1702;
                0.2684];
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
        x_stand = (xh_pre-obj.means)./obj.stds;
        N = x_stand*pinv(xh_pre);
        yh = obj.output_func(xh_pre,obj.output_param); % output estimation
        xh_pre = x_stand;
        p = obj.self.parameter.get(); 
%         A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
%         C = obj.JacobianH(x,p);
%         P_pre  = pinv(N)*A*N*obj.result.P*N*A'*pinv(N) + pinv(N)*obj.B*obj.Q*obj.B'*pinv(N);  
% %         P_pre  = A*obj.result.P*A' + diag([0.001*ones(1,6),0.01*ones(1,6),0.01*ones(1,6)]); % Predicted covariance
%         G = (N*P_pre*pinv(N)*C')/(C*N*P_pre*N*C'+obj.R); % Kalman gain
%         P = (eye(obj.n)-pinv(N)*G*C*N)*P_pre;	% Update covariance
% %         P(13:end,13:end) = 0.05*eye(size(P(13:end,13:end)));
%         tmpvalue = xh_pre + pinv(N)*G*(y-yh);	% Update state estimate
        A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
        C = obj.JacobianH(x,p);
        P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';  
%         P_pre  = A*obj.result.P*A' + diag([0.001*ones(1,6),0.01*ones(1,6),0.01*ones(1,6)]); % Predicted covariance
        G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
        P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
%         P(13:end,13:end) = 0.05*eye(size(P(13:end,13:end)));
        tmpvalue = xh_pre + G*(y-yh);	% Update state estimate
        tmpvalue =  tmpvalue .* obj.stds + obj.means;
        tmpvalue = obj.model.projection(tmpvalue);
        obj.result.state.set_state(tmpvalue);
        obj.model.state.set_state(tmpvalue);
        obj.result.G = G;
        obj.result.P = P;
        obj.result.A = A;
        obj.result.C = C;
        obj.result.param = p;
      end
        result=obj.result;
        obj.timer = tic;
    end
end
end

% classdef EKF < handle
%    % Extended Kalman filter
%     % obj = EKF(model,param)
%     %   model : EKFを実装する制御対象の制御モデル
%     %   param : required field : Q,R,B,JacobianH
%     %  JacobianH(x,p) : 出力方程式の拡張線形化した関数のhandle
%       properties
%         result
%             % state : estimated state
%         JacobianF
%         JacobianH
%         Q
%         R
%         dt
%         B
%         n
%         y
%         y_param
%         self
%         model
%         timer= [];
%     end
% 
%     methods
%         function obj = EKF(self,param)
%             obj.self= self;
%             obj.model = param.model;
%             ELfile=strcat("Jacobian_",obj.model.name);
%             if ~exist(ELfile,"file")
%                 obj.JacobianF=ExtendedLinearization(ELfile,obj.model);
%             else
%                 obj.JacobianF=str2func(ELfile);
%             end
%             obj.result.state= state_copy(obj.model.state);
%             obj.y = param.output_func; % output function handle : function of obj.self
%             obj.y_param = param.output_param;
%             % obj.y= state_copy(obj.model.state);
%             % if isfield(param,'list')
%             %     obj.y.list = param.list;
%             % else
%             %     obj.y.list = [];
%             % end
%             obj.JacobianH = param.JacobianH;
%             obj.n = length(obj.model.state.get());
%             obj.Q = param.Q;% 分散
%             obj.R = param.R;% 分散
%             obj.dt = obj.model.dt; % 刻み
%             obj.B = param.B;
%             obj.result.P = param.P;
%             obj.result.G = zeros(obj.n,size(obj.R,2));
%         end
% 
%         function [result]=do(obj,varargin)
%           if ~isempty(obj.timer)
%             dt = toc(obj.timer);
%             if dt > obj.dt
%               dt = obj.dt;
%             end
%           else
%             dt = obj.dt;
%           end
%           if varargin{1}.t ~= 0
%             %sensor = obj.self.sensor.result;
%             %state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
%             y = obj.y(obj.self,obj.y_param);
%             % y = y +0.01*randn(size(y));
%             % y = y +[0.01*randn(6,1);0];
%             x = obj.result.state.get(); % estimated state at previous step
%             % Pre-estimation
%             obj.model.do(varargin{:});
%             xh_pre = obj.model.state.get(); %
% 
%             %EKF
%             p = obj.self.parameter.get();
%             A = eye(obj.n)+obj.JacobianF(x,p)*dt; % Euler approximation
%             yh = obj.JacobianH(x,p);
%             P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % Predicted covariance
%             G = (P_pre*C')/(C*P_pre*C'+obj.R); % Kalman gain
%             % G(:,7:8) = 0;
%             P = (eye(obj.n)-G*C)*P_pre;	% Update covariance
%             tmpvalue = xh_pre + G*(y-hx);	% Update state estimate
%             tmpvalue = obj.model.projection(tmpvalue);
%             obj.result.state.set_state(tmpvalue);
%             obj.model.state.set_state(tmpvalue);
%             obj.result.G = G;
%             obj.result.P = P;
%           end
%             result=obj.result;
%             obj.timer = tic;
%         end
%     end
% end

