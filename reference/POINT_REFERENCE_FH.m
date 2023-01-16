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
        function obj = POINT_REFERENCE_FH(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p"],'num_list',[3]));
        end
        function  result= do(obj,Param,result)
            % 【Input】result = {Xd(optional)}
            %  Param = FH,xd,time.t
            %  Xd (optional) : 他のreference objで生成された目標値
            if isempty( obj.base_state )
                obj.base_state =obj.self.estimator.result.state.p;
            end
            if ~strcmp(class(Param{1}),'matlab.ui.Figure')
                error("ACSL : require figure window");
            else
                FH = Param{1};% figure handle
            end
            cha = get(FH, 'currentcharacter');
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't' && cha ~= 'h' && cha ~= 'm')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;
            if strcmp(cha,'l') % landing phase
                if strcmp(obj.flag,'l')
                    obj.result.state.xd=gen_ref_for_landing(obj.result.state.p);
                else% 初めてlanding に入ったとき
                    obj.result.state.xd=gen_ref_for_landing(obj.self.reference.result.state.p);
                end
                obj.result.state.p = obj.result.state.xd; % このようにすることでf の後でも反映される
                obj.flag='l';
            elseif strcmp(cha,'t') % take off phase
                if strcmp(obj.flag,'t')
                    obj.result.state.xd=gen_ref_for_take_off(obj.result.state.p,obj.base_state,1-obj.base_state(3),10,Param{3}-obj.base_time);
                else % 初めてtake off に入ったとき
                    obj.base_time=Param{3};
                    obj.base_state=obj.self.estimator.result.state.p;
                    obj.result.state.xd=gen_ref_for_take_off(obj.base_state,obj.base_state,1-obj.base_state(3),10,0);   % 1: 目標高度, 10秒で離陸
                end
                obj.result.state.p = obj.result.state.xd(1:3);
                obj.flag='t';
            elseif strcmp(cha,'f') % flight phase
                obj.flag='f';
                if nargin==3 % 他のreference objでの参照値がある場合
                    Param{2} = result.state;
                end
                if strcmp(class(Param{2}),"STATE_CLASS")    % timevaryingの呼び出し？
                    state_copy(Param{2},obj.result.state);
                    %                    obj.result.state = state_copy(Param{2}); % 目標重心位置（絶対座標）
                else
                    obj.result.state.xd = Param{2};
                    obj.result.state.p = obj.result.state.xd;
                end
            elseif strcmp(cha,'m') % flight phase
                if strcmp(obj.flag,'m')
                    obj.result.state.xd=gen_ref_for_monte(obj.result.state.p);
                else% 初めてlanding に入ったとき
                    obj.result.state.xd=gen_ref_for_monte(obj.self.reference.result.state.p);
                end
                obj.result.state.p = obj.result.state.xd; % このようにすることでf の後でも反映される
                obj.flag='m';
            elseif strcmp(cha,'h')
                obj.flag='h';
                obj.result.state.xd = [0; 0; 1];
                obj.result.state.p = obj.result.state.xd;
            else
                %obj.result.state.p = obj.self.estimator.result.state.p; %
                %これだと最悪上がっていく
                obj.result.state.p = obj.base_state;
                obj.result.state.xd = obj.base_state;
            end
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end

