classdef Thrust2Throttle_drone < INPUT_TRANSFORM_CLASS
    %UNTITLED4 ‚±‚ÌƒNƒ‰ƒX‚ÌŠT—v‚ð‚±‚±‚É‹Lq
    %   Ú×à–¾‚ð‚±‚±‚É‹Lq
    
    properties
        self
        result
        param
        flight_phase
    end
    
    methods
        function obj = Thrust2Throttle_drone(self,param)
            obj.self = self;
            obj.param = param;
            obj.flight_phase = 's';
        end
        
        function u = do(obj,input,varargin)
            %% ŽÀŒ±—p“ü—Í¶¬  uroll, upitch, uthr, uyaw
            % yInputzvarargin : struct with field FH
            if ~isfield(varargin{1},'FH')
                error("ACSL : require figure window");
            else
                FH = varargin{1}.FH;% figure handle
            end
            cha = get(FH, 'currentcharacter');
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f' && cha ~= 'l' && cha ~= 't')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;
            param = obj.param;
            if cha == 't' || cha == 'f' || cha == 'l'
                u_thr_offset  = obj.param.th_offset;
                what=obj.self.model.state.w;
                obj.self.model.do(obj.self.input,obj.self.model.param);% 1 step —\‘ª
                P = obj.self.model.param;
                T_thr = sum(input);
                whatp = obj.self.model.state.w;% ‚PŽžæ‚ÌŽ–‘O—\‘ª
                uroll       = param.gain(1) * (whatp(1) - what(1))    + param.roll_offset;
                upitch      = param.gain(2) * (whatp(2) - what(2))    + param.pitch_offset;
                uthr        = param.gain(4) * T_thr + u_thr_offset; % m*g ‚ÅŠ„‚Á‚Ä‚¢‚é
                uyaw        = - param.gain(3) * (whatp(3) - what(3))  + param.yaw_offset;
                obj.result = [ uroll, upitch, uthr, uyaw, 1600,600,600,600];
            else
                obj.result = [ param.roll_offset, param.pitch_offset, param.th_offset, param.yaw_offset, 1600,600,600,600];
            end
            u = obj.result;
        end
    end
end

