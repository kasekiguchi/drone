classdef TIME_VARYING_REFERENCE_SPLIT < handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TIME_VARYING_REFERENCE()
    properties
        param
        func % 時間関数のハンドル
        self
        agent1 % cooprative情報
        ref_set
        t=[];
        cha='s';
        com % 使用制御モデル->"HL"or"Cooperative"or"Suspended"or"Split"
        dfunc
        result
        N
        P
        Pdagger
        K
        muid
        m
        toR
        Muid_method
        base_time
        base_state
        ts
        te = 1;
        zd = 1; % goal altitude
        

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
            obj.N = args{4};
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
%             obj.func = gen_func_name(param_for_gen_func{:});
            if length(args) > 2
                if strcmp(args{3}, "HL")
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [20, 3, 3, 3]));                    
                end
                if strcmp(args{3}, "Cooperative")
                    obj.ref_set.method = args{1};
                    obj.ref_set.orig = param_for_gen_func;
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL_Cooperative_Load(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3]));
                elseif strcmp(args{3}, "Take_off")
                    obj.ref_set.method = args{1};
                    obj.com = args{3};
%                     obj.ref_set.method = "gen_ref_sample_take_off";
                    obj.ref_set.orig = param_for_gen_func;
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL_Cooperative_Load(temp);
%                   
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v", "o"], 'num_list', [27, 3, 3, 3,3])); 

                elseif strcmp(args{3}, "Split2")
                    obj.com = args{3};
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));  

                    obj.P = self.parameter.get("all","row");
                    P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],agent1.parameter.rho));
                    obj.Pdagger = pinv(P);
                    obj.K =obj.agent1.controller.gains;
                    obj.Muid_method = str2func(agent1.controller.Param.method2);
                    obj.result.m = [];
                    obj.result.Muid = [];

                    if obj.agent1.estimator.model.state.type ==3
                        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
                    else
                        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
                    end
                end
                if strcmp(args{3}, "Suspended")
                    temp = gen_func_name(param_for_gen_func{:});
                    obj.func = gen_ref_for_HL(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));                    
                end
                if strcmp(args{3}, "Split")
                    initial_loadref = obj.agent1.reference.result.state.xd;
                    rho = obj.agent1.parameter.rho(:,obj.self.id-1);
                    R_load = obj.agent1.reference.result.state.getq("rotm"); %ペイロードの回転行列
                    Qrho = initial_loadref(1:3,1)+R_load*rho;

                    gen_func_name = str2func(agent1.reference.ref_set.method);
%                     obj.func = gen_func_name(param_for_gen_func{:});
                    agent1.reference.ref_set.orig{4} = Qrho;
%                     set_orig = {"freq",100,"orig",Qrho,"size",1*[4,4,0]};
%                     temp = gen_func_name(set_orig{:});
                    temp = gen_func_name(agent1.reference.ref_set.orig{:});
                    obj.com = args{3};
%                     obj.func = gen_ref_for_HL(obj.agent1.reference.func);
                    obj.func = gen_ref_for_HL_Cooperative_Load(temp);
                    obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [24, 3, 3, 3]));  


                    obj.P = self.parameter.get("all","row");
                    P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],agent1.parameter.rho));
                    obj.Pdagger = pinv(P);
                    obj.K =obj.agent1.controller.gains;
                    obj.Muid_method = str2func(agent1.controller.Param.method2);

                    if obj.agent1.estimator.model.state.type ==3
                        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
                    else
                        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
                    end
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
            elseif strcmp(args{3}, "Take_off")
                obj.result.state.set_state("xd",obj.func(0));
                obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
                obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));
            elseif strcmp(args{3}, "Split2")
                obj.result.state.set_state("xd",zeros(24,1));
%                 obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
%                 obj.result.state.set_state("q",obj.self.estimator.result.state.get("Q"));
%                 obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
%                 obj.result.state.set_state("o",obj.self.estimator.result.state.get("O"));

            
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
               model = obj.agent1.estimator.result.state;
               ref = obj.agent1.reference.result.state;                         
               x = model.get(["p"  "Q" "v"    "O"    "qi"    "wi"  "Qi"  "Oi"]);
               qi = reshape(model.qi,3,obj.N);
               Ri = obj.toR(model.Qi);
               R0 = obj.toR(model.Q);               
               %xd = 0*ref.xd;
               xd = ref.xd;
               R0d = reshape(xd(end-8:end),3,3);

               id = obj.self.id;

               obj.muid = obj.Muid_method(x,qi,R0,R0d,xd,obj.K,obj.P,obj.Pdagger); %3xN
               muid_myagent = obj.muid(:,id-1); %3x1

%                R0TFdMd = CSLC_6_R0TFdMd(x,xd,R0,R0d,obj.P,obj.K);
%                obj.muid = reshape(kron(eye(6),R0)*obj.Pdagger*R0TFdMd,3,6); % 3xN

%                loadref = obj.agent1.reference.result.state.xd;
%                
%                rho = obj.agent1.parameter.rho(:,id-1);
%                R_load = obj.agent1.reference.result.state.getq("rotm"); %ペイロードの回転行列
%                Qrho = loadref(1:3,1)+R_load*rho;
% %                obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
%                obj.result.state.xd = Qrho; % 目標重心位置（絶対座標）
% %                q = repmat(p,1,length(obj.target))+Qrho; % ケーブル付け根位置（牽引物側）
%                obj.result.state.p = obj.result.state.xd(1:3);
               obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
               obj.result.state.p = obj.result.state.xd(1:3);
               a = obj.result.state.xd(7:9);
               g = [0;0;-1]*obj.agent1.parameter.g;
               m=inv(a'*a)*a'*(m0*g+muid_myagent);

           elseif strcmp(obj.com, "Split2")
               initial_loadref = obj.agent1.reference.result.state.xd;
               rho = obj.agent1.parameter.rho(:,obj.self.id-1);
               R_load = obj.agent1.reference.result.state.getq("rotm"); %ペイロードの回転行列
               Qrho = initial_loadref(1:3,1)+R_load*rho;

               model = obj.agent1.estimator.result.state;
               ref = obj.agent1.reference.result.state; 
               ref.xd(1:3)=ref.xd(1:3)+Qrho;
               ref.p=ref.p+Qrho;
               x = model.get(["p"  "Q" "v"    "O"    "qi"    "wi"  "Qi"  "Oi"]);
               qi = reshape(model.qi,3,obj.N);
               Ri = obj.toR(model.Qi);
               R0 = obj.toR(model.Q);               
               %xd = 0*ref.xd;
               xd = ref.xd;
               R0d = reshape(xd(end-8:end),3,3);

               id = obj.self.id;

%                Muid = obj.Muid_method(x,qi,R0,R0d,xd,obj.K,obj.P,obj.Pdagger); %3xN
%                muid_myagent = Muid(:,id-1); %3x1
%                obj.result.Muid = Muid(:,id-1)';

               Muid = obj.agent1.controller.result.mui; %3xN
               muid_myagent = Muid(4:6,id-1); %3x1
               obj.result.Muid = muid_myagent';
               

               obj.result.state.xd = obj.agent1.reference.result.state.xd; % 目標重心位置（絶対座標）
               obj.result.state.p = obj.result.state.xd(1:3);
               a = obj.result.state.xd(7:9);
               g = [0;0;-1]*obj.agent1.parameter.g;

               A=a-g;
               obj.result.m=inv(A'*A)*A'*muid_myagent;
%                obj.result.m = m;
           elseif strcmp(obj.com, "Take_off")
               if isempty( obj.base_state ) % first take
               obj.base_time=varargin{1}.t;
               obj.base_state = obj.self.estimator.result.state.p;
               obj.result.state.xd = [obj.base_state;obj.result.state.xd(4:27,1)];
%                  
           end
           obj.result.state.xd(1:12,1) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
           obj.result.state.p = obj.result.state.xd(1:3,1);
           obj.result.state.v = obj.result.state.xd(4:6,1);
%                obj.self.input_transform.param.th_offset = obj.th_offset0 + (obj.th_offset-obj.th_offset0)*min(obj.te,varargin{1}.t-obj.base_time)/obj.te;
           result = obj.result;       
           else
               obj.result.state.xd = obj.func(t); % 目標重心位置（絶対座標）
               obj.result.state.p = obj.result.state.xd(1:3);
           end

%            if strcmp(obj.com, "Take_off")
%                if isempty( obj.base_state ) % first take
%                    obj.base_time=varargin{1}.t;
%                    obj.base_state = obj.self.estimator.result.state.p;
%                    obj.result.state.xd = [obj.base_state;obj.result.state.xd(4:27,1)];
% %                  
%                end
%                obj.result.state.xd(1:12,1) = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
%                obj.result.state.p = obj.result.state.xd(1:3,1);
%                obj.result.state.v = obj.result.state.xd(4:6,1);
% %                obj.self.input_transform.param.th_offset = obj.th_offset0 + (obj.th_offset-obj.th_offset0)*min(obj.te,varargin{1}.t-obj.base_time)/obj.te;
%                result = obj.result;
%            end
           
           % if length(obj.result.state.xd)>4
           %  obj.result.state.v = obj.result.state.xd(5:7);
           % else
           %  obj.result.state.v = [0;0;0];
           % end
           % obj.result.state.q(3,1) = atan2(obj.result.state.v(2),obj.result.state.v(1));
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

        function Xd = gen_ref_for_take_off(obj,t)
          %% Setting
          % calc reference position and its higher time derivatives
          % reference designed as a 9-degree polynomial function of time
          % [Inputs]
          % t : current time
          %
          % [Output]
          % Xd : reference [[p;yd], [p^(1);0], [p^(2);0], [p^(3);0], [p^(4);0]] as column vector
          %    : Xd in R^20
          %    : yd is a yaw angle reference
    
          %% Variable set
          Xd  = zeros( 12, 1);
          zd = 1;
          d = zd-obj.base_state(3,1); % goal altitude : relative value
          te = obj.te; % terminal time to reach zd
          %% Set Xd
          if t<=te
            tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
            dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
            ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
            d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
            d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
          elseif t> te
            tra=d;
            dtra = 0;
            ddtra = 0;
            d3tra = 0;
            d4tra = 0;
          end
          Xd(1:3,1) = obj.base_state(1:3);
          Xd(3,1) = tra + Xd(3,1);
          Xd(6,1) = dtra;
          Xd(9,1) = ddtra;
          Xd(12,1) = d3tra;
%           Xd(19,1) = d4tra;
        end

    end
end