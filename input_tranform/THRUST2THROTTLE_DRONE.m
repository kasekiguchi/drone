classdef THRUST2THROTTLE_DRONE < INPUT_TRANSFORM_CLASS
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
        hover_thrust_force_SuspendedLoad % hovering時のthrust force
        state
    end

    methods

        function obj = THRUST2THROTTLE_DRONE(self, param)
            obj.self = self;
            obj.param = param;
            obj.param.roll_offset = self.plant.arming_msg(1);
            obj.param.pitch_offset = self.plant.arming_msg(2);
            obj.param.yaw_offset = self.plant.arming_msg(4);
            obj.param.P = self.parameter.get();
            obj.flight_phase = 's';
            P = self.model.param;
            obj.hover_thrust_force = P(1) * P(9);
            if self.model.name == "Suspended_Load_Model"
                obj.hover_thrust_force = P(1) * P(6);
                obj.hover_thrust_force_SuspendedLoad = (P(1)+P(15)) * P(6);
            end
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
                throttle_offset = obj.param.th_offset;
                %wh = obj.self.model.state.w;
                wh = obj.self.estimator.result.state.w;
                %P = obj.self.model.param;
                % statetmp=obj.self.estimator.result.state.get()+obj.self.model.dt*obj.self.model.method(obj.self.estimator.result.state.get(),obj.self.input,P);% euler approximation
                %statetmp=obj.self.model.state.get();% do_modelで事前予測を求めている．
                
%                 statetmp = obj.self.model.state.get() + obj.self.model.dt * obj.self.model.method(obj.self.model.state.get(), obj.self.input, P); % euler approximation
%                 obj.state.set_state(statetmp);
%                 whn = obj.state.w; %statetmp(end-2:end);
                
                whn = obj.self.model.state.w;% １時刻先の事前予測
                T_thr = sum(input); % T_thr = input(1);

                % TODO : 以下であるべきでは？　要チェック
                %wh = obj.self.estimator.result.state.w; % 現在の角速度推定値
                %whn = obj.self.model.state.w;           % 現時刻に算出した入力による1step 未来の値(do_model ですでに予測値を算出している)

                uroll = obj.param.gain(1) * (whn(1) - wh(1));
                upitch = obj.param.gain(2) * (whn(2) - wh(2));
                uthr = max(0,obj.param.gain(4) * (T_thr - obj.hover_thrust_force) + throttle_offset); % hovering からの偏差をゲイン倍する
                % ホバリング時から変分にゲイン倍する
                uyaw = obj.param.gain(3) * (whn(3) - wh(3));
                if obj.self.model.name == "Suspended_Load_Model"
                    throttle_offset_SuspendedLoad = obj.param.th_offset_SuspendedLoad;
                    T_thr = input(1);
                    if cha == 'f'
                        uroll = obj.param.gain_SuspendedLoad(1) * (whn(1) - wh(1));
                        upitch = obj.param.gain_SuspendedLoad(2) * (whn(2) - wh(2));
                        uthr = max(0,obj.param.gain_SuspendedLoad(4) * (T_thr - obj.hover_thrust_force_SuspendedLoad) + throttle_offset_SuspendedLoad); % hovering からの偏差をゲイン倍する
                        uyaw = obj.param.gain_SuspendedLoad(3) * (whn(3) - wh(3));
                    else
                        uroll = obj.param.gain(1) * (whn(1) - wh(1));
                        upitch = obj.param.gain(2) * (whn(2) - wh(2));
                        uthr = max(0,obj.param.gain(4) * (T_thr - obj.hover_thrust_force) + throttle_offset); % hovering からの偏差をゲイン倍する
                        uyaw = obj.param.gain(3) * (whn(3) - wh(3));
                    end
                end
                uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset; % offset = 500
                upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset; % offset = 500
                uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % マイナスは必須 betaflightでは正入力で時計回り
                % uthr =uthr + u_throttle_offset ;%sign(uthr)*min(abs(uthr),100)+ u_throttle_offset;
                obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 1000]; % CH8 = 1000 は自作ドローンの設定で自律飛行モードに必要
            else
                obj.result = [obj.param.roll_offset, obj.param.pitch_offset, 0, obj.param.yaw_offset, 1000, 0, 0, 0];
            end

            u = obj.result;
        end

    end

end
