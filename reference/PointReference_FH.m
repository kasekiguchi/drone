classdef PointReference_FH < REFERENCE_CLASS
    properties
        param
        flight_phase = 's';
        flag = 's';
        self
        base_time
        base_state
    end
    
    methods
        function obj = PointReference_FH(self,varargin)
            % �Q��
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p"],'num_list',[3]));
        end
        function  result= do(obj,Param,varargin)
            % �yInput�zvarargin = {Xd(optional)}
            %  Param = FH,xd,time.t
            %  Xd (optional) : ����reference obj�Ő������ꂽ�ڕW�l
            if ~isempty(varargin)  % ����reference obj�ł̎Q�ƒl������ꍇ
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
            if strcmp(cha,'l') % landing phase
                if strcmp(obj.flag,'l')
                    obj.result.state.p=gen_ref_for_landing(obj.result.state.p);
                else% ���߂�landing �ɓ������Ƃ�
                    obj.result.state.p=gen_ref_for_landing(obj.self.estimator.result.state.p);
                end
                if isprop(obj.result.state,'xd')
                    obj.result.state.xd = obj.result.state.p; % ���̂悤�ɂ��邱�Ƃ�f �̌�ł����f�����
                end
                obj.flag='l';
            elseif strcmp(cha,'t') % take off phase
                if strcmp(obj.flag,'t')
                    %obj.result.state.p=gen_ref_for_take_off(obj.result.state.p);
%                    obj.result.state.xd=gen_ref_for_take_off(obj.base_state,1,10,Param{3}-obj.base_time);
                    obj.result.state.xd=gen_ref_for_take_off(obj.result.state.p,obj.base_state,1,10,Param{3}-obj.base_time);
                else % ���߂�take off �ɓ������Ƃ�
                    obj.base_time=Param{3};
                    obj.base_state=obj.self.estimator.result.state.p;
                    obj.result.state.xd=gen_ref_for_take_off(obj.base_state,obj.base_state,1,10,0);
                end
%                 if isprop(obj.result.state,'xd')
%                     obj.result.state.xd = obj.result.state.p; % ���̂悤�ɂ��邱�Ƃ�f �̌�ł����f�����
%                 end
                obj.result.state.p = obj.result.state.xd(1:3);
                obj.flag='t';
            elseif strcmp(cha,'f') % flight phase
                obj.flag='f';
                if strcmp(class(Param{2}),"STATE_CLASS")
                    obj.result.state = state_copy(Param{2}); % �ڕW�d�S�ʒu�i��΍��W�j
                else
                    obj.result.state.p = Param{2};
                end
            else
                obj.result.state.p = obj.self.estimator.result.state.p;
            end
            result=obj.result;
        end
        function show(obj,param)
           
        end
    end
end

