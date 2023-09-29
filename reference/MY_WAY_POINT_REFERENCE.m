classdef MY_WAY_POINT_REFERENCE < handle
    properties
        param
        self
        coefficients
        time
        dtime
        t_powers
        t_ref
        t0
        t_ref0
        names
        i
        fref
        result
    end
    
    methods
        function obj = MY_WAY_POINT_REFERENCE(self,varargin)
            %縦ベクトルで書く
            %最初のコマンドは"f"で始める
            % 参照
            
            obj.self = self;
            val = varargin{1};
            n = val.n;
            obj.coefficients = val.coefficients;
            obj.names = fieldnames(val.coefficients);            
            for i = 1:length(obj.names)
                obj.t_powers.(obj.names{i}) = @(t) (t).^(0:n+1-i)';
            end
            obj.time = val.t;
            obj.dtime = val.dt;
            obj.i=1;
            obj.fref=0;
            obj.t_ref0=0;
            
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
            obj.result.state.set_state("xd",zeros(6,1));
            obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            if isempty(obj.t0)
                obj.t0=varargin{1}.t;%目標地点が定められた時刻
            end
            
            t_f = varargin{1}.t - obj.t0;%目標地点が定められた時間からの経過時間
            obj.t_ref= t_f - obj.t_ref0;

            if round(obj.t_ref,4) >= obj.dtime(obj.i) 
               obj.i=obj.i+1;
                if obj.i > length(obj.time)
                    obj.i = length(obj.time);
                    obj.t_ref = obj.dtime(end);
                    %繰り返し用
                    % obj.i = 1;
                    % obj.t_ref0 = round(t_f,4);
                    % obj.t_ref=0;
                else
                    obj.t_ref0 = round(t_f,4);
                    obj.t_ref=0;
                end
            end

            xd=zeros(4,4);
            for j = 1:3
                xd(:,j) = [obj.coefficients.(obj.names{j})(:,:,obj.i)*obj.t_powers.(obj.names{j})(obj.t_ref); 0];
            end
            obj.result.state.xd = reshape(xd,16,1);%3階微分まで
            obj.result.state.p = xd(1:3)';
            obj.result.state.v = xd(5:7)';
            obj.result.state.q(3,1) = 0;%yaw
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
