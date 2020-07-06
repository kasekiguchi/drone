classdef PointReference_FH < REFERENCE_CLASS
    properties
        param
        flight_phase = 's';
        flag = 's';
        self
    end
    
    methods
        function obj = PointReference_FH(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p"],'num_list',[3]));
        end
        function  result= do(obj,Param,varargin)
            % 【Input】varargin = {Xd(optional)}
            %  Param = FH,xd
            %  Xd (optional) : 他のreference objで生成された目標値
            if ~isempty(varargin)  % 他のreference objでの参照値がある場合
                Param{2} = varargin{1}.state;
            end
             if ~strcmp(class(Param{1}),'matlab.ui.Figure')
                 error("ACSL : require figure window");
             else
                FH = Param{1};% figure handle
             end
            cha = get(FH, 'currentcharacter');
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;
            sp = obj.self.model.state.p;
            if strcmp(cha,'l') % landing phase
                if strcmp(obj.flag,'l')
                    obj.result.state.p=gen_ref_for_landing(obj.result.state.p);
                else% 初めてlanding に入ったとき
                    obj.result.state.p=gen_ref_for_landing(sp);
                end
                if isprop(obj.result.state,'xd')
                    obj.result.state.xd = obj.result.state.p; % このようにすることでf の後でも反映される
                end
                obj.flag='l';
            elseif strcmp(cha,'t') % take off phase
                if strcmp(obj.flag,'t')
                    obj.result.state.p=gen_ref_for_take_off(obj.result.state.p);
                else % 初めてtake off に入ったとき
                    sp(3) = 0.19; % 目標位置をちょっと浮いた位置からあげていく
                    obj.result.state.p=gen_ref_for_take_off(sp);
                end
                if isprop(obj.result.state,'xd')
                    obj.result.state.xd = obj.result.state.p; % このようにすることでf の後でも反映される
                end
                obj.flag='t';
            elseif strcmp(cha,'f') % flight phase
                obj.flag='f';
                if strcmp(class(Param{2}),"STATE_CLASS")
                    obj.result.state = state_copy(Param{2}); % 目標重心位置（絶対座標）
                else
                    obj.result.state.p = Param{2};
                end
            else
                obj.result.state.p = sp;
            end
            result=obj.result;
        end
        function show(obj,param)
           
        end
    end
end

