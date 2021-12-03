classdef Thrust2Throttle_drone < INPUT_TRANSFORM_CLASS
    %UNTITLED4 このクラスの概要をここに記述
    %   詳細説明をここに記述

    properties
        self
        result
        param
        flight_phase
        thr_hover % hovering時のthrust
        state
    end

    methods

        function obj = Thrust2Throttle_drone(self, param)
            obj.self = self;
            obj.param = param;
            obj.flight_phase = 's';
            P = self.model.param;
            obj.thr_hover = P(1) * P(9);
            self.plant.set_param([param.roll_offset, param.pitch_offset, param.yaw_offset]);
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
                u_thr_offset = obj.param.th_offset;
                what = obj.self.model.state.w;
                P = obj.self.model.param;
                % statetmp=obj.self.estimator.result.state.get()+obj.self.model.dt*obj.self.model.method(obj.self.estimator.result.state.get(),obj.self.input,P);% euler approximation
                %statetmp=obj.self.model.state.get();% do_modelで事前予測を求めている．
                statetmp = obj.self.model.state.get() + obj.self.model.dt * obj.self.model.method(obj.self.model.state.get(), obj.self.input, P); % euler approximation
                obj.state.set_state(statetmp);
                whatp = obj.state.w; %statetmp(end-2:end);
                %whatp = obj.self.model.state.w;% １時刻先の事前予測
                T_thr = sum(input); % T_thr = input(1);

                uroll = obj.param.gain(1) * (whatp(1) - what(1));
                upitch = obj.param.gain(2) * (whatp(2) - what(2));
                uthr = obj.param.gain(4) * (T_thr - obj.thr_hover) + u_thr_offset; % hovering からの偏差をゲイン倍する
                % ホバリング時から変分にゲイン倍する
                uyaw = obj.param.gain(3) * (whatp(3) - what(3));
                uroll = sign(uroll) * min(abs(uroll), 500) + obj.param.roll_offset; % offset = 500
                upitch = sign(upitch) * min(abs(upitch), 500) + obj.param.pitch_offset; % offset = 500
                uyaw = -sign(uyaw) * min(abs(uyaw), 300) + obj.param.yaw_offset; % マイナスは必須 betaflightでは正入力で時計回り
                % uthr =uthr + u_thr_offset ;%sign(uthr)*min(abs(uthr),100)+ u_thr_offset;
                obj.result = [uroll, upitch, uthr, uyaw, 1000, 0, 0, 0];
            else
                obj.result = [obj.param.roll_offset, obj.param.pitch_offset, obj.param.th_offset, obj.param.yaw_offset, 1000, 0, 0, 0];
            end

            u = obj.result;
        end

    end

end
