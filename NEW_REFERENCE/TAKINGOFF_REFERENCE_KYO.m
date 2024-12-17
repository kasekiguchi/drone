classdef TAKINGOFF_REFERENCE_KYO < handle
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
        function obj=TAKINGOFF_REFERENCE_KYO(self)

            arguments
                self


            end
            obj.self = self;

        end
        function func= TAKINGOFF_REFERENCE_KYOREF (self,args)
            obj.self = self;
            % %obj.result.state.xd = obj.gen_ref_for_take_off(varargin{1}.t-obj.base_time);
            % obj.result.state.p = obj.result.state.xd(1:3,1);
            % obj.result.state.v = obj.result.state.xd(5:7,1);
            % obj.self.input_transform.param.th_offset = obj.th_offset0 + (obj.th_offset-obj.th_offset0)*min(obj.te,varargin{1}.t-obj.base_time)/obj.te;
            % result = obj.result;
            % obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
            % 
            % obj.result.state.set_state("xd",obj.func(0));
            % obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            % obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            % obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
        end
    end
end