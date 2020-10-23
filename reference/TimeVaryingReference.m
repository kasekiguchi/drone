classdef TimeVaryingReference < REFERENCE_CLASS
    % ŠÔŠÖ”‚Æ‚µ‚Ä‚ÌƒŠƒtƒ@ƒŒƒ“ƒX‚ğ¶¬‚·‚éƒNƒ‰ƒX
    % obj = TimeVaryingReference()
    properties
        param
        func % ŠÔŠÖ”‚Ìƒnƒ“ƒhƒ‹
        self
    end
    
    methods
        function obj = TimeVaryingReference(self,varargin)
            % yInputzref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            obj.func=str2func(varargin{1}{1});
            obj.func=obj.func(varargin{1}{2});
            if length(varargin{1})>2
                if strcmp(varargin{1}{3},"HL")
                    obj.func = gen_ref_for_HL(obj.func);
                    obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[20,3]));
                end
            else
                obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[length(obj.func(0)),3]));
            end
        end
        function  result= do(obj,Param)
            % yInputzParam = {Time.t}
            obj.result.state.xd = obj.func(Param{1}.t); % –Ú•WdSˆÊ’uiâ‘ÎÀ•Wj
            obj.result.state.p = obj.result.state.xd(1:3);
            result=obj.result;
        end
        function show(obj,logger)
            rp=strcmp(logger.items,"reference.result.state.p");
            heart = cell2mat(logger.Data.agent(:,rp)'); % reference.result.state.p
            plot(heart(1,:),heart(2,:)); % xy•½–Ê‚Ì‹O“¹‚ğ•`‚­
            daspect([1 1 1]);
            hold on
            ep=strcmp(logger.items,"estimator.result.state.p");
            heart_result = cell2mat(logger.Data.agent(:,ep)'); % estimator.result.state.p
            plot(heart_result(1,:),heart_result(2,:)); % xy•½–Ê‚Ì‹O“¹‚ğ•`‚­
            legend(["reference","estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end

