classdef LANDING_REFERENCE_KYO< handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    properties
        param
        func % 時間関数のハンドル
        self
        t=[];
        cha='s';
        dfunc
        result
        te
        base_state
        th_offset
        th_offset0 = 200;
    end

    methods
        function obj=LANDING_REFERENCE_KYO(self)
        
        arguments
            self  
        end
            obj.self = self;
             
        end


        function Xd = LANDING_REFERENCE_KYOREF(obj,t)
            %UNTITLED2 Summary of this class goes here
            %   Detailed explanation goes here  
            Xd  = zeros( 20, 1);
            %% Set Xd
            if t <= obj.te
                Zd = curve_interpolation_9order(t,obj.te,obj.base_state(3),0,0,0);
            elseif t> obj.te
                Zd = zeros(1,5);
            end
            Xd(1:3,1) = obj.base_state(1:3);
            Xd(3,1) = Zd(1);
            Xd(7,1) = Zd(2);
            Xd(11,1) = Zd(3);
            Xd(15,1) = Zd(4);
            Xd(19,1) = Zd(5);
            % if length(varargin) > 2
            %     if strcmp(varargin{3}, "HL")
            %         obj.func = gen_ref_for_HL(obj.func);
            %         obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));
            %     end
            % else
            %     obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
            % end
            % obj.result.state.set_state("xd",obj.func(0));
            % obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            % obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            % obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
            % func=obj.func;
        end
    end
end

