classdef THRUST2THROTTLE_DRONE < handle
% Calculate throttle level from desired thrust forces to send via transmitter
% Do 1 step simulation wrt the model to derive a desired angular velocity wd and thrust force Fd.
% To follow wd and Fd minor feedback is designed as a P control.
% throttle level = K (sum(u) - hover_thrust_force) + throttle_offset
% roll,pitch,yaw throttle = K (w - wd) + w_offset
% This calculation is conducted at do_plant method in ABSTRACT_SYSTEM
properties
    self % Drone class instance
    result % derived throttle level
    param % offsets and gains
    flight_phase % flight phase input to figure handle FH
    hover_thrust_force % hovering時のthrust force
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
        P = self.parameter.get;
        obj.hover_thrust_force = P(1) * P(9);
        obj.state = state_copy(self.estimator.result.state);

        %MPC用のゲインとオフセットの設定-------
        obj.param.gain2(1) = 1000;
        obj.param.gain2(2) = 1000;
        obj.param.gain2(3) = 1000;
        obj.param.gain2(4) = 1000;
        obj.param.th_offset2 = 350;

        obj.param.gain2 = obj.param.gain;
        obj.param.th_offset2 = obj.param.th_offset;
        %--------------------------------------
    end

    function u = do(obj, varargin)
        %% u = [uroll, upitch, uthr, uyaw]
        % [Input] varargin : time, cha, logger, env, agent, i

        cha = varargin{2};
        input = varargin{5}(varargin{6}).controller.result.input;
        if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f' && cha ~= 'l' && cha ~= 't')
            cha = obj.flight_phase;
        end

        obj.flight_phase = cha;

        if cha == 't' || cha == 'f' || cha == 'l'
            wh = obj.self.estimator.result.state.w; % estimated state
            obj.self.estimator.model.do(varargin{:}); % one step prediction using current input
            whn = obj.self.estimator.model.state.w; % predicted state
            obj.self.estimator.model.state.set_state(obj.self.estimator.result.state.get); % restore estimator.model

            %1_18:MPCのゲインとオフセットを変更するために追加----------------------------------------------------------
            if cha == 'f'
                T_thr = input(1); % thrust, torque input 

                uroll = obj.param.gain2(1) * (whn(1) - wh(1));
                upitch = obj.param.gain2(2) * (whn(2) - wh(2));

                % apply gain to (thrust - hovering_thrust)
                uthr = max(0, obj.param.gain2(4) * (T_thr - obj.hover_thrust_force) + obj.param.th_offset2); 
                uyaw = obj.param.gain2(3) * (whn(3) - wh(3));
                uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset;
                upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset;
                uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % Need minus : positive rotation is clockwise in betaflight
                obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 1000]; % CH8 = 1000 required for autonomous flight 
            else
                %T_thr = sum(input); % each motor's thrust force input
                T_thr = input(1); % thrust, torque input 

                uroll = obj.param.gain(1) * (whn(1) - wh(1));
                upitch = obj.param.gain(2) * (whn(2) - wh(2));

                % apply gain to (thrust - hovering_thrust)
                uthr = max(0, obj.param.gain(4) * (T_thr - obj.hover_thrust_force) + obj.param.th_offset); 
                uyaw = obj.param.gain(3) * (whn(3) - wh(3));
                uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset;
                upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset;
                uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % Need minus : positive rotation is clockwise in betaflight
                obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 1000]; % CH8 = 1000 required for autonomous flight 
            end
            %-------------------------------------------------------------------------------------------------------


            %T_thr = sum(input); % each motor's thrust force input
            % T_thr = input(1); % thrust, torque input 
            % 
            % uroll = obj.param.gain(1) * (whn(1) - wh(1));
            % upitch = obj.param.gain(2) * (whn(2) - wh(2));
            % 
            % % apply gain to (thrust - hovering_thrust)
            % uthr = max(0, obj.param.gain(4) * (T_thr - obj.hover_thrust_force) + obj.param.th_offset); 
            % uyaw = obj.param.gain(3) * (whn(3) - wh(3));
            % uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset;
            % upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset;
            % uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % Need minus : positive rotation is clockwise in betaflight
            % obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 1000]; % CH8 = 1000 required for autonomous flight 
        else
            obj.result = [obj.param.roll_offset, obj.param.pitch_offset, 0, obj.param.yaw_offset, 1000, 0, 0, 0];
        end

        u = obj.result;
    end

end

end
