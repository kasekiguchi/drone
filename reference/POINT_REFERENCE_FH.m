classdef POINT_REFERENCE_FH < REFERENCE_CLASS

properties
    param
    flight_phase = 's';
    flag = 's';
    self
    base_time
    base_state
end

methods

    function obj = POINT_REFERENCE_FH(self, varargin)
        % 参照
        obj.self = self;
        obj.result.state = STATE_CLASS(struct('state_list', ["p", "v"], 'num_list', [3]));
    end

    function result = do(obj, Param, result)
        % 【Input】result = {Xd(optional)}
        %  Param = FH,xd,time.t
        %  Xd (optional) : 他のreference objで生成された目標値
        if isempty(obj.base_state)
            obj.base_state = obj.self.estimator.result.state.p;
        end

        if ~strcmp(class(Param{1}), 'matlab.ui.Figure')
            error("ACSL : require figure window");
        else
            FH = Param{1}; % figure handle
        end

%                     cha = get(FH, 'currentcharacter');
        cha = 'f';

        if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f' && cha ~= 'l' && cha ~= 't')
            cha = obj.flight_phase;
        end

        obj.flight_phase = cha;

        if strcmp(cha, 'l') % landing phase

            if strcmp(obj.flag, 'l')
                [obj.result.state.p, obj.result.state.v] = gen_ref_for_landing(obj.result.state.p, Param{4});
            else % 初めてlanding に入ったとき
                [obj.result.state.p, obj.result.state.v] = gen_ref_for_landing(obj.self.reference.result.state.p, Param{4});
            end

            obj.flag = 'l';
        elseif strcmp(cha, 't') % take off phase

            if strcmp(obj.flag, 't')
                [obj.result.state.p, obj.result.state.v] = gen_ref_for_take_off(obj.result.state.p, obj.base_state, 1 - obj.base_state(3), 5, Param{3} - obj.base_time);
            else % 初めてtake off に入ったとき
                obj.base_time = Param{3};
                obj.base_state = obj.self.estimator.result.state.p;
                [obj.result.state.p, obj.result.state.v] = gen_ref_for_take_off(obj.base_state, obj.base_state, 1 - obj.base_state(3), 5, 0);
            end

            obj.flag = 't';
        elseif strcmp(cha, 'f') % flight phase
            obj.flag = 'f';

            if nargin == 3 % 他のreference objでの参照値がある場合
                Param{2} = result.state;
            end

            if strcmp(class(Param{2}), "STATE_CLASS")
                state_copy(Param{2}, obj.result.state);
            else
                obj.result.state.p = Param{2};
            end

        else
            obj.result.state.p = obj.base_state;
        end

        result = obj.result;
    end

    function show(obj, param)

    end

end

end
