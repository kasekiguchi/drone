classdef MY_POINT_SAVE_REFERENCE < handle
    %UNTITLED このクラスの概要をここに記述
    %   詳細説明をここに記述

    properties
        param
        self
        time
        dtime
        result
    end

    methods
        function obj = MY_POINT_SAVE_REFERENCE(self, varargin)
            %UNTITLED このクラスのインスタンスを作成
            %   詳細説明をここに記述
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
            obj.result.state.set_state("xd",zeros(6,1));
            obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
        end

        function result = do(obj,varargin)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.result.state.xd = reshape(xd,16,1);%3階微分まで
            obj.result.state.p = xd(1:3)';
            obj.result.state.v = xd(5:7)';
            obj.result.state.q(3,1) = 0;%yaw
            result = obj.result;
        end
    end
end