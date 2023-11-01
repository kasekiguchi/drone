classdef TIME_VARYING_REFERENCE_SPLIT < handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    properties
        param
        func % 時間関数のハンドル
        self
        agent1 % cooprative情報
        t=[];
        cha='s';
        com % 使用制御モデル->"HL"or"Cooperative"or"Suspended"or"Split"
        dfunc
        result
    end

    methods
        function obj = TIME_VARYING_REFERENCE_SPLIT(self, args, agent1)
            % 【Input】ref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            arguments
                self   
                args
                agent1
            end
            obj.self = self;   
            obj.agent1 = agent1;
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
            obj.func = gen_func_name(param_for_gen_func{:});
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    obj.func = gen_ref_for_HL(obj.func);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));                    
                end
                if strcmp(args{3}, "Cooperative")
                    obj.func = gen_ref_for_HL_Cooperative_Load(obj.func);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3]));                    
                end
                if strcmp(args{3}, "Suspended")
                    obj.func = gen_ref_for_HL(obj.func);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));                    
                end
                if strcmp(args{3}, "Split")
                    obj.com = args{3};
                    obj.func = obj.agent1.reference.func;
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));                    
                end
            else
                obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
            end
            
            if strcmp(args{3}, "Cooperative")
                obj.result.state.set_state("xd",obj.func(0));
                obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));

            elseif strcmp(args{3}, "Suspended")
                obj.result.state.set_state("xd",obj.func(0));
                obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
            else
                obj.result.state.set_state("xd",obj.func(0));
                obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
            end
            %syms t real
            %obj.dfunc = matlabFunction(diff(obj.func,t),"Vars",t);
        end
        function result = do(obj, varargin)  
           %Param={time,FH}
           obj.cha = varargin{2};
           if obj.cha=='f'&& ~isempty(obj.t)    %flightからreferenceの時間を開始
                t = varargin{1}.t-obj.t; % 目標重心位置（絶対座標）
           else
                obj.t=varargin{1}.t;
                t = obj.t;
           end
           if strcmp(obj.com, "Split")
               loadpoint = obj.state.reference
               obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
               q = repmat(p,1,length(obj.target))+Qrho; % ケーブル付け根位置（牽引物側）
               obj.result.state.p = obj.result.state.xd(1:3);
           else
                   obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
                   obj.result.state.p = obj.result.state.xd(1:3);
           end
           % if length(obj.result.state.xd)>4
           %  obj.result.state.v = obj.result.state.xd(5:7);
           % else
           %  obj.result.state.v = [0;0;0];
           % end
           % obj.result.state.q(3,1) = atan2(obj.result.state.v(2),obj.result.state.v(1));
           result = obj.result;
        end

        function [pi,rho] = gen_pi(obj,p,Q,qi)
           % pi(k,:,i) = [xi yi zi] at time k
           Qrho = cell2mat(arrayfun(@(i) quat_times_vec(Q',obj.rho(:,i))',1:length(obj.target),'UniformOutput',false));
           q = repmat(p,1,length(obj.target))+Qrho; % ケーブル付け根位置（牽引物側）
           rho = reshape(q,size(q,1),size(q,2)/length(obj.target),length(obj.target)); % attachment point 
           pi = rho - qi.*reshape(repmat(obj.li,3,1),1,[],length(obj.target));      
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