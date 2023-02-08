classdef POINT_REFERENCE_FH_tokyu < REFERENCE_CLASS
    properties
        param
        flight_phase = 's';
        flag = 's';
        self
        base_time
        base_state
        t
    end
    
    methods
        function obj = POINT_REFERENCE_FH_tokyu(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v"],'num_list', [3]));
            obj.result.q = 0;
            obj.t = [];
        end
        function  result= do(obj,Param,result)
            % 【Input】result = {Xd(optional)}
            %  Param = FH,xd,time.t,dt,ceiling_distance
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
            %if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't' && cha ~= 'h' && cha ~= 'u' && cha ~= 'j')
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't' && cha ~= 'h' && cha ~= 'y')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;
            if strcmp(cha,'l') % landing phase
                if strcmp(obj.flag,'l')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing(obj.result.state.p,Param{4});
                else% 初めてlanding に入ったとき
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing(obj.self.reference.result.state.p,Param{4});
                end
%                 obj.result.state.p(1) = obj.self.estimator.result.state.p(1);
%                 obj.result.state.p(2) = obj.self.estimator.result.state.p(2);
%                 obj.result.state.p(4) = obj.self.estimator.result.state.q(3);
                obj.flag='l';
            elseif strcmp(cha,'t') % take off phase
                if strcmp(obj.flag,'t')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_take_off(obj.result.state.p,obj.base_state,Param{2}(3)-obj.base_state(3),8,Param{3}-obj.base_time);
                else % 初めてtake off に入ったとき
                    obj.base_time=Param{3};
                    obj.base_state=obj.self.estimator.result.state.p;
                    [obj.result.state.p,obj.result.state.v] = gen_ref_for_take_off(obj.base_state,obj.base_state,Param{2}(3)-obj.base_state(3),8,0);
                end
                obj.flag='t';
                
%             elseif strcmp(cha,'f') % flight phase
%                 obj.flag='f';
%                 if nargin==3 % 他のreference objでの参照値がある場合
%                     Param{2} = result.state;
%                 end
%                 if strcmp(class(Param{2}),"STATE_CLASS")
%                     state_copy(Param{2},obj.result.state);
%                 else
%                     Param{2}(1) = Param{2}(1)/2;
%                     Param{2}(2) = Param{2}(2)/2;
%                     obj.result.state.p = Param{2};
%                 end
            elseif strcmp(cha,'h') % 天井張り付き
                if obj.self.sensor.result.switch == 1%センサの値から推力down
                     if strcmp(obj.flag,'y')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.result.state.p,Param{4},0.04,2.7);
                    else% 初めてlanding に入ったとき
                        [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.self.reference.result.state.p,Param{4},0.04,2.7);
                     end
                     obj.flag='y';
                else
                    if strcmp(obj.flag,'h')
                        [obj.result.state.p,obj.result.state.v]=gen_ref_for_take_off(obj.result.state.p,obj.base_state,Param{5}-obj.base_state(3),4,Param{3}-obj.base_time);
                    else % 初めてtake off に入ったとき
                        obj.base_time=Param{3};
                        obj.base_state=obj.self.estimator.result.state.p;
                        [obj.result.state.p,obj.result.state.v] = gen_ref_for_take_off(obj.base_state,obj.base_state,Param{5}-obj.base_state(3),4,0);
                    end
                    obj.flag='h';
                end
%                 obj.result.state.p(1)=obj.self.estimator.result.state.p(1);
%                 obj.result.state.p(2)=obj.self.estimator.result.state.p(2);
                obj.result.state.p(1)=Param{2}(1);
                obj.result.state.p(2)=Param{2}(2);
%                 obj.result.state.p(4)=obj.self.estimator.result.state.q(3);
%                 obj.result.state.p(1)=Param{2}(1);%ホバリング用
%                 obj.result.state.p(2)=Param{2}(2);
            elseif strcmp(cha,'f') % flight phase (時間関数)
                obj.flag='f';
                if ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{3}-obj.t; 
                else
                    obj.t=Param{3};
                    t = 0;
                end
                if norm(Param{2}-obj.self.reference.result.state.p(1:3)) > 0.1
                    v = 0.5;
                    yaw = atan(Param{2}(2)/Param{2}(1));
                    x = v*cos(yaw)*t;
                    y = v*sin(yaw)*t;
                    z = Param{2}(3);
                    obj.result.state.p = [x;y;z];
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                end
%             elseif strcmp(cha,'j') % yaw角回転(右？) (時間関数)
%                 if obj.flag~='j'
%                     obj.t=[];
%                 end
%                 obj.flag='j';
%                 if ~isempty(obj.t)    %flightからreferenceの時間を開始
%                     t = Param{3}-obj.t;
%                 else
%                     obj.t=Param{3};
%                     t = 0;
%                 end
% %                 yaw = 0.5*pi()*t;
%                 yaw = 0;
%                 if yaw <= 2*pi()
%                 obj.result.state.p(1)=obj.self.estimator.result.state.p(1);
%                 obj.result.state.p(2)=obj.self.estimator.result.state.p(2);
%                 obj.result.state.p(3)=obj.self.estimator.result.state.p(3);
%                 obj.result.state.p(4)=pi()/2;
% %                 obj.result.q=pi()/2;
%                 else
%                 obj.result.state.p = obj.self.reference.result.state.p;
%                 end
%             elseif strcmp(cha,'u') % yaw角回転(左？) (時間関数)
%                 if obj.flag~='u'
%                     obj.t=[];
%                 end
%                 obj.flag='u';
%                 if ~isempty(obj.t)    %flightからreferenceの時間を開始
%                     t = Param{3}-obj.t;
%                 else
%                     obj.t=Param{3};
%                     t = 0;
%                 end
%                 yaw = -0.5*pi()*t;
%                 if yaw >= -2*pi()
%                     obj.result.state.p(1)=obj.self.estimator.result.state.p(1);
%                     obj.result.state.p(2)=obj.self.estimator.result.state.p(2);
%                     obj.result.state.p(3)=obj.self.estimator.result.state.p(3);
%                     obj.result.state.p(4)=yaw;
%                 else
%                     obj.result.state.p = obj.self.reference.result.state.p;
%                 end
            elseif strcmp(cha,'y') % landing phase
                if strcmp(obj.flag,'y')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.result.state.p,Param{4},0.04,1.3);
                else% 初めてlanding に入ったとき
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.self.reference.result.state.p,Param{4},0.04,1.3);
                end
                obj.result.state.p(1)=Param{2}(1);
                obj.result.state.p(2)=Param{2}(2);
%                 obj.result.state.p(1) = obj.self.estimator.result.state.p(1);
%                 obj.result.state.p(2) = obj.self.estimator.result.state.p(2);
%                 obj.result.state.p(4) = obj.self.estimator.result.state.q(3);
                obj.flag='y';
            else
                obj.result.state.p = obj.base_state;
            end
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end

