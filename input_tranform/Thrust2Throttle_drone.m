classdef Thrust2Throttle_drone < INPUT_TRANSFORM_CLASS
    % Calculate throttle level from desired thrust forces to send via transmitter
    % Do 1 step simulation wrt the model to derive a desired angular velocity wd and thrust force Fd.
    % To follow wd and Fd minor feedback is designed as a P control.
    % throttle level = K (sum(u) - hover_thrust_force) + throttle_offset
    % roll,pitch,yaw throttle = K (w - wd) + w_offset
    % This calculation is conducted at do_plant method in ABSTRACT_SYSTEM
    properties
        self % Drone class instance
        result % derived throttle level
        param  % offsets and gains
        flight_phase % flight phase input to figure handle FH
        hover_thrust_force % hovering時のthrust force
        state
    end

    methods

        function obj = Thrust2Throttle_drone(self, param)
            obj.self = self;
            obj.param = param;
            obj.flight_phase = 's';
            P = self.model.param;
            obj.hover_thrust_force = P(1) * P(9);
            obj.state = state_copy(self.model.state);
        end

        function u = do(obj, input, varargin)
            %% 実験用入力生成  uroll, upitch, uthr, uyaw
            % 【Input】varargin : struct with field FH
            if ~isfield(varargin{1}, 'FH')
                error("ACSL : require figure window");
            else
                FH = varargin{1}.FH; % figure handle
            end

            cha = get(FH, 'currentcharacter');

            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f' && cha ~= 'l' && cha ~= 't')
                cha = obj.flight_phase;
            end

            obj.flight_phase = cha;

            if cha == 't' || cha == 'f' || cha == 'l'
                throttle_offset = obj.param.throttle_offset;
                what = obj.self.model.state.w;
                P = obj.self.model.param;
                % statetmp=obj.self.estimator.result.state.get()+obj.self.model.dt*obj.self.model.method(obj.self.estimator.result.state.get(),obj.self.input,P);% euler approximation
                %statetmp=obj.self.model.state.get();% do_modelで事前予測を求めている．
                statetmp = obj.self.model.state.get() + obj.self.model.dt * obj.self.model.method(obj.self.model.state.get(), obj.self.input, P); % euler approximation
                obj.state.set_state(statetmp);
                whatn = obj.state.w; %statetmp(end-2:end);
                %whatn = obj.self.model.state.w;% １時刻先の事前予測
                T_thr = sum(input); % T_thr = input(1);

                % TODO : 以下であるべきでは？　要チェック
                %what = obj.self.estimator.result.state.w; % 現在の角速度推定値
                %whatn = obj.self.model.state.w;           % 現時刻に算出した入力による1step 未来の値(do_model ですでに予測値を算出している)

                uroll = obj.param.gain(1) * (whatn(1) - what(1));
                upitch = obj.param.gain(2) * (whatn(2) - what(2));
                uthr = obj.param.gain(4) * (T_thr - obj.hover_thrust_force) + throttle_offset; % hovering からの偏差をゲイン倍する
                % ホバリング時から変分にゲイン倍する
                uyaw = obj.param.gain(3) * (whatn(3) - what(3));
                uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset; % offset = 500
                upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset; % offset = 500
                uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % マイナスは必須 betaflightでは正入力で時計回り
                % uthr =uthr + u_throttle_offset ;%sign(uthr)*min(abs(uthr),100)+ u_throttle_offset;
                obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 0];
            else
                obj.result = [obj.param.roll_offset, obj.param.pitch_offset, obj.param.th_offset, obj.param.yaw_offset, 1000, 0, 0, 0];
            end

            u = obj.result;
        end

    end

end
