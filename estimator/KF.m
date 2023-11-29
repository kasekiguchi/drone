classdef KF < handle
   % Linear Kalman filter
    % obj = KF(model,param)
    %   model : EKFを実装する制御対象の制御モデル
    %   param : required field : Q,R,B,JacobianH
      properties
        %state
        result
        Q
        R
        dt
        A
        B
        C
        n
        y
        state % model と同じ状態　cf. result.state は推定値として受け渡すよう？
        self
        model
    end
    
    methods
        function obj = KF(self,param)
            obj.self= self;
            obj.model = param.model;
            obj.result.state= state_copy(obj.model.state);
            obj.y= state_copy(obj.model.state);
            if isfield(param,'list')
                obj.y.list = param.list;
            else
                obj.y.list = [];
            end
            obj.n = length(obj.model.state.get());
            obj.Q = param.Q;% 分散
            obj.R = param.R;% 分散
            obj.dt = obj.model.dt; % 刻み
            obj.A = param.A;
            obj.B = param.B;
            obj.C = param.C;
            obj.result.P = param.P;
        end
        
        function [result]=do(obj,varargin)
          %(obj,param,sensor)
            %   param : optional
            model=obj.model;
            sensor = obj.self.sensor.result;
            x = obj.result.state.get(); % 前回時刻推定値
            xh_pre = model.state.get(); % 事前推定 ：入力ありの場合 （modelが更新されている前提）
            if isempty(obj.y.list)
                obj.y.list=sensor.state.list; % num_listは代入してはいけない．
            end
            state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
            A = obj.A;
            B = obj.B;
            C = obj.C;

            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % 事前誤差共分散行列
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % カルマンゲイン更新
            P = (eye(obj.n)-G*C)*P_pre;	% 事後誤差共分散
            tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	% 事後推定
            obj.result.state.set_state(tmpvalue);
            obj.result.G = G;
            obj.result.P = P;
            obj.result.dt = obj.dt;
            result=obj.result;
        end
        function show()
        end
    end
end

