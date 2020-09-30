classdef Thrust2Throttle_drone < INPUT_TRANSFORM_CLASS
    %UNTITLED4 ‚±‚ÌƒNƒ‰ƒX‚ÌŠT—v‚ð‚±‚±‚É‹Lq
    %   Ú×à–¾‚ð‚±‚±‚É‹Lq
    
    properties
        self
        result
        param
        flight_phase
        thr_hover
    end
    
    methods
        function obj = Thrust2Throttle_drone(self,param)
            obj.self = self;
            obj.param = param;
            obj.flight_phase = 's';
            P = self.model.param;
            obj.thr_hover = P(1)*P(6);
            self.plant.set_param([param.roll_offset,param.pitch_offset,param.yaw_offset]);
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
                %obj.self.model.do(obj.self.input,obj.self.model.param);% 1 step —\‘ª
                P = obj.self.model.param;
                statetmp=obj.self.model.state.get()+obj.self.model.dt*obj.self.model.method(obj.self.model.state.get(),obj.self.input,P);
                T_thr = sum(input);
                %whatp = obj.self.model.state.w;% ‚PŽžæ‚ÌŽ–‘O—\‘ª
                whatp = statetmp(end-2:end);
                uroll       = param.gain(1) * (whatp(1) - what(1))    ;
                upitch      = param.gain(2) * (whatp(2) - what(2))   ;
                uthr        = param.gain(4) * (T_thr-obj.thr_hover) + u_thr_offset; % m*g ‚ÅŠ„‚Á‚Ä‚¢‚é
                uyaw        = param.gain(3) * (whatp(3) - what(3)) ;
                uroll = sign(uroll)*min(abs(uroll),500)+ param.roll_offset; %500
                upitch = sign(upitch)*min(abs(upitch),500)+ param.pitch_offset; 
                uyaw = sign(uyaw)*min(abs(uyaw),300)+ param.yaw_offset; 
                % uthr =uthr + u_thr_offset ;%sign(uthr)*min(abs(uthr),100)+ u_thr_offset; 
%                 uroll = uroll+ param.roll_offset; 
%                 upitch = upitch+ param.pitch_offset; 
%                 uyaw = uyaw+ param.yaw_offset; 
                obj.result = [ uroll, upitch, uthr, uyaw, 1600,1600,600,600];
            else
                obj.result = [ param.roll_offset, param.pitch_offset, param.th_offset, param.yaw_offset, 1600,1600,600,600];
            end
            u = obj.result;
        end
    end
end

