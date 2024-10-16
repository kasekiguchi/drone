classdef TIME_VARYING_REFERENCE_PTP < handle
    properties
        param
        func % 時間関数のハンドル
        self
        t = [];
        cha = 's';
        result
        target_position % 目標位置
        duration % 移動にかかる時間
    end

    methods
        function obj = TIME_VARYING_REFERENCE_PTP(self, args)
            % 【Input】ref_gen, param, target_position, duration
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % target_position : 移動先の目標位置
            % duration : 移動にかかる時間
            arguments
                self
                args
            end
            
            obj.self = self;
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
            obj.func = gen_func_name(param_for_gen_func{:});
            
            % 目標位置と移動時間を設定
            obj.target_position = args{2}; % 目標位置args{3};
            obj.duration = {4}; % 移動にかかる時間
            
            % 状態の初期化
            obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
            obj.result.state.set_state("xd", obj.func(0));
            obj.result.state.set_state("p", obj.self.estimator.result.state.get("p"));
            obj.result.state.set_state("q", obj.self.estimator.result.state.get("q"));
            obj.result.state.set_state("v", obj.self.estimator.result.state.get("v"));
        end
        
        function result = do(obj, varargin)
            % Param={time, cha}
            obj.cha = varargin{2};
            if obj.cha == 'f' && isempty(obj.t) % flightからreferenceの時間を開始
                obj.t = varargin{1}.t; % 現在の時間
            end
            
            t = varargin{1}.t - obj.t; % 経過時間
            
            % スムーズな移動を計算
            obj.result.state.xd = obj.smooth_move(t); % 目標重心位置（絶対座標）
            obj.result.state.p = obj.result.state.xd(1:3);
            result = obj.result;
        end
        
        function xd = smooth_move(obj, t)
            % スムーズな移動を計算
            if t < 0
                t = 0; % 最初はゼロ
            elseif t > obj.duration
                t = obj.duration; % 最後まで
            end
            
            start_position = obj.self.estimator.result.state.p; % 現在の位置
            end_position = obj.target_position; % 目標位置
            
            % 三次のポリノミアルで移動を計算
            a0 = start_position;
            a1 = zeros(3, 1); % 初速
            a2 = 3 * (end_position - start_position) / (obj.duration^2);
            a3 = -2 * (end_position - start_position) / (obj.duration^3);
            
            xd = a0 + a1 * t + a2 * t^2 + a3 * t^3; % スムーズな位置
        end
        
        function show(obj, logger)
            rp = logger.data(1, "p", "r");
            plot3(rp(:, 1), rp(:, 2), rp(:, 3)); % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on;
            ep = logger.data(1, "p", "e");
            plot3(ep(:, 1), ep(:, 2), ep(:, 3)); % xy平面の軌道を描く
            legend(["reference", "estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off;
        end
    end
end
