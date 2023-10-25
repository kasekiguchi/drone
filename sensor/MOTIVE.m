classdef MOTIVE < handle
% Motive用クラス：登録されたエージェントの位置と姿勢がわかる
%  sensor.motive = MOTIVE(self, ~)
%       self : agent
properties
    name = "Motive";
    result
    state
    self
    interface = @(x) x;
    old_time
    rigid_num % rigid indices
    motive
    initq
end

methods

    function obj = MOTIVE(self, args)

        arguments
            self
            args
        end

        %%% Output equation %%%
        obj.self = self;
        obj.motive = args.motive;
        obj.rigid_num = args.rigid_num;
        %obj.initq = quaternion(Eul2Quat([args.initial_yaw_angle;0;0])');
        obj.initq = quaternion(Eul2Quat([0;0;args.initial_yaw_angle])');

        obj.result.state = STATE_CLASS(struct('state_list', ["p", "q"], "num_list", [3, 4]));

        if sum(contains(self.estimator.result.state.list, "q")) == 1
            obj.result.state.num_list = [3, length(self.estimator.result.state.q)]; % modelと合わせる
            obj.result.state.type = length(self.estimator.result.state.q);
        end

    end

    function result = do(obj, varargin)
        % result=sensor.motive.do(motive)
        %   set obj.result.state : State_obj,  p : position, q : quaternion
        %   result :
        % 【入力】motive ：NATNET_CONNECOTR object
        data = obj.motive.result;

        if isempty(obj.old_time)
            obj.old_time = data.time;
        end

        id = obj.rigid_num(1);

        if sum(contains(obj.result.state.list, "q")) == 1
            tmpq = quaternion(data.rigid(id).q');
            tmpq = conj(obj.initq) * tmpq;
            [Q(1) Q(2) Q(3) Q(4)] = parts(tmpq);
            obj.result.state.set_state('q', Q');
        end

        obj.result.state.set_state('p', data.rigid(id).p);
        obj.result.rigid = data.rigid;
        obj.result.feature = data.marker;
        obj.result.feature_num = data.marker_num;
        obj.result.local_feature = data.local_marker{id};
        obj.result.on_feature_num = data.local_marker_nums(id);
        obj.result.dt = data.time - obj.old_time;
        obj.old_time = data.time;
        result = obj.result;
    end

    function show(obj, varargin)

        if ~isempty(obj.result)
        else
            disp("do measure first.");
        end

    end

end

end
