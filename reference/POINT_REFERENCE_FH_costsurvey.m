classdef POINT_REFERENCE_FH_costsurvey < REFERENCE_CLASS
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
        function obj = POINT_REFERENCE_FH_costsurvey(self,varargin)
            % 参照
            obj.t = [];
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v"],'num_list', [3]));
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
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't'  && cha ~= 'h' && cha ~= 'u' && cha ~= 'z' && cha ~= 'r' && cha ~= 'o' && cha ~= 'x' && cha ~= 'y' && cha ~= 'd')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;

            if strcmp(cha,'l') % landing phase
                if strcmp(obj.flag,'l')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing(obj.result.state.p,Param{4});
                else% 初めてlanding に入ったとき
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing(obj.self.reference.result.state.p,Param{4});
                end
                obj.flag='l';

            elseif strcmp(cha,'t') % take off phase
                if strcmp(obj.flag,'t')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_take_off(obj.result.state.p,obj.base_state,1-obj.base_state(3),5,Param{3}-obj.base_time);
                else % 初めてtake off に入ったとき
                    obj.base_time=Param{3};
                    obj.base_state=obj.self.estimator.result.state.p;
                    [obj.result.state.p,obj.result.state.v] = gen_ref_for_take_off(obj.base_state,obj.base_state,1-obj.base_state(3),5,0);
                end
                obj.flag='t';

            elseif strcmp(cha,'f') % flight phase (時間関数)  その場にいる
               if obj.flag~='f'
                    obj.t=[];
                end
                obj.flag='f';
                if ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{3}-obj.t; 
                else
                    obj.t=Param{3};
                    t = 0;
                end
                if norm(Param{2}-obj.self.reference.result.state.p(1:3)) > 0.01
                    
                    yaw = atan(Param{2}(2)/Param{2}(1));
                    x = obj.self.estimator.result.state.p(1);
                    y = obj.self.estimator.result.state.p(2);
                    z = obj.self.estimator.result.state.p(3);
                    obj.result.state.p = [x;y;z];
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                    t = 0;
                end

%             elseif strcmp(cha,'f') % flight phase
%                 obj.flag='f';
%                 if nargin==3 % 他のreference objでの参照値がある場合
%                     Param{2} = result.state;
%                 end
%                 if strcmp(class(Param{2}),"STATE_CLASS")
%                     state_copy(Param{2},obj.result.state);
%                 else
%                     obj.result.state.p = Param{2};
%                 end
           elseif strcmp(cha,'x') % flight phase (時間関数)  前移動
               if obj.flag~='x'
                    obj.t=[];
                end
                obj.flag='x';
                if ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{3}-obj.t; 
                else
                    obj.t=Param{3};
                    t = 0;
                end
                if norm(Param{2}-obj.self.reference.result.state.p(1:3)) > 0.01
                    v = 0.25;
                    yaw = atan(Param{2}(2)/Param{2}(1));
                    x = v*t;
                    y = 0;
                    z = Param{2}(3);
                    obj.result.state.p = [x;y;z];
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                    t = 0;
                end

            elseif strcmp(cha,'y') % flight phase (時間関数)  右移動
                if obj.flag~='y'
                    obj.t=[];
                end
                obj.flag='y';
                if ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{3}-obj.t; 
                else
                    obj.t=Param{3};
                    t = 0;
                end
                if norm(Param{2}-obj.self.reference.result.state.p(1:3)) > 0.01
                    v = 0.25;
                    yaw = atan(Param{2}(2)/Param{2}(1));
                    x = 0;
                    y = -v*t;
                    z = Param{2}(3);
                    obj.result.state.p = [x;y;z];
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                    t = 0;
                end
            elseif strcmp(cha,'z') % flight phase (時間関数)  上移動
                if strcmp(obj.flag,'z')   %takeoff関数を用いて1m上昇(2m地点)
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_take_off(obj.result.state.p,obj.base_state,2-obj.base_state(3),4,Param{3}-obj.base_time);
                else % 初めてtake off に入ったとき
                    obj.base_time=Param{3};
                    obj.base_state=obj.self.estimator.result.state.p;
                    [obj.result.state.p,obj.result.state.v] = gen_ref_for_take_off(obj.base_state,obj.base_state,2-obj.base_state(3),4,0);
                end
                obj.flag='z';
%                 obj.flag='u';
%                 if ~isempty(obj.t)    %flightからreferenceの時間を開始
%                     t = Param{3}-obj.t; 
%                 else
%                     obj.t=Param{3};
%                     t = 0;
%                 end
%                 if norm(Param{2}-obj.self.reference.result.state.p(1:3)) > 0.1
%                     v = 0.25;
%                     yaw = atan(Param{2}(2)/Param{2}(1));
%                     x = 0;
%                     y = 0;
%                     z = Param{2}(3)+v*t;
%                     obj.result.state.p = [x;y;z];
%                 else
%                     obj.result.state.p = obj.self.reference.result.state.p;
%                     t = 0;
%                 end
            elseif strcmp(cha,'o') % landing phase
                obj.result.state.p = [0;0;1];
                obj.result.state.p(4)=obj.self.estimator.result.state.q(3)+0.5;
                obj.flag='o';


            elseif strcmp(cha,'r') %原点に戻る
                if obj.flag~='r'
                    obj.t=[];
                end
                
                obj.flag='r';
                if ~isempty(obj.t)    %flightからreferenceの時間を開始
                    t = Param{3}-obj.t; 
                else
                    obj.t=Param{3};
                    t = 0;
                end
                if norm([0;0;1]-obj.self.reference.result.state.p(1:3)) > 0.01
                    v = 0.25;
                    yaw = atan(obj.self.estimator.result.state.p(2)/obj.self.estimator.result.state.p(1));
                    x = -v*cos(yaw)*t+obj.self.estimator.result.state.p(1);
%                     x = 0;
%                     y = abs(v*sin(yaw))*t+obj.self.estimator.result.state.p(2);
                    y = 0;
                    z = Param{2}(3);
                    obj.result.state.p = [x;y;z];
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                    t = 0;
                end
            
            elseif strcmp(cha,'d') % flight phase (時間関数)  上移動戻る
                if norm([0;0;9]-obj.self.reference.result.state.p(1:3)) > 0.1
                if strcmp(obj.flag,'d')
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.result.state.p,Param{4},0.25,1);
                else% 初めてlanding に入ったとき
                    [obj.result.state.p,obj.result.state.v]=gen_ref_for_landing_speed(obj.self.reference.result.state.p,Param{4},0.25,1);
                end
                else
                    obj.result.state.p = obj.self.reference.result.state.p;
                end                    

                if obj.flag~='d'
                    obj.t=[];
                end
                obj.flag='d';

%                 if ~isempty(obj.t)    %flightからreferenceの時間を開始
%                     t = Param{3}-obj.t; 
%                 else
%                     obj.t=Param{3};
%                     t = 0;
%                 end
%                 if norm([0;0;0.9]-obj.self.reference.result.state.p(1:3)) > 0.1
%                     v = 0.25;
%                     yaw = atan(Param{2}(2)/Param{2}(1));
%                     x = 0;
%                     y = 0;
%                     z = obj.self.estimator.result.state.p(3)-v*t;
%                     obj.result.state.p = [x;y;z];
%                 else
%                     obj.result.state.p = obj.self.reference.result.state.p;
%                 end


            

            else
                obj.result.state.p = obj.base_state;
            end
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end

