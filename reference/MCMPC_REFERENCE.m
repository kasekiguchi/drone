classdef MCMPC_REFERENCE < handle
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
    end

    methods
        function obj = MCMPC_REFERENCE(self, args)
            % 【Input】ref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            arguments
                self
                args
            end
            obj.self = self;
            gen_func_name = str2func(args{1}); % agent
            param_for_gen_func = args{2}; % komatsu_study_trajectory ?
            obj.func = gen_func_name(param_for_gen_func{:});
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    obj.func = gen_ref_for_HL(obj.func);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));                    
                end
            else
                obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
            end
            %% 変数の定義；多分これは残ってた方が良い
            obj.result.state.set_state("xd",obj.func(0)); % time_varying_trajectory から算出した位置の微分達
            obj.result.state.set_state("p",obj.self.estimator.result.state.get("p")); % target positon
            obj.result.state.set_state("q",obj.self.estimator.result.state.get("q")); % target attitude
            obj.result.state.set_state("v",obj.self.estimator.result.state.get("v")); % target velocity
            %syms t real
            %obj.dfunc = matlabFunction(diff(obj.func,t),"Vars",t);
        end
        function result = do(obj, varargin)  
           %Param={time,FH}
           
           % obj.result.state.p = [x;y;z]
           % obj.result.state.v = [vx;vy;vz] という感じで定義
           result = obj.result;
        end
        function show(obj, logger)
            rp = logger.data(1,"p","r");
            plot3(rp(:,1), rp(:,2), rp(:,3));                     % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep = logger.data(1,"p","e");
            plot3(ep(:,1), ep(:,2), ep(:,3));       % xy平面の軌道を描く
            legend(["reference", "estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end
