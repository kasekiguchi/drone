classdef STATE_CLASS < matlab.mixin.SetGetExactNames & dynamicprops & matlab.mixin.Copyable
    % Interface class for creating a class taking a state
    % Subclass constructor
    properties
        list % name list : ["x","v"]
        num_list % number of state corresponding list : [ 3, 3] means "x" and "v" are 3 dimensional variables.
        type % attitude type :
        %                   4 : compact : unit quaternion
        %                   3 : euler : euler angle
        %                   9 : rotmat : rotation matrix
        %state % structure named "state" with member variables of list. state.x/ state.v
    end
    methods
        function obj=STATE_CLASS(varargin)
            if isempty(varargin)
                obj.list = ["p","v"];
                obj.num_list = [3,3];
            else
                param = varargin{1};
                obj.list=param.state_list;
                obj.num_list=param.num_list;
                for i = 1:length(param.state_list)
                    addprop(obj,param.state_list(i));
                end
            end
            if sum(contains(obj.list,"q"))
                obj.type=obj.num_list(contains(obj.list,"q"));
            end
        end
    end
    methods %(Access = protected)
        function [] = set_state(obj,varargin)
            % �@�@set_state("p",[0;0;0],"v",[0;0;0]);
            % �A�@set_state(struct("p",[0;0;0],"v",[0;0;0])); % �S��ԃZ�b�g����Ƃ�����������g�����Ƃ𐄏�
            % �B�@set_state(x0); % state_list �ǂ���ɕ���ł�����̂Ƃ��đ��
            %if mod(length(varargin{1}),2)==0 % �@�@�������w�肵�đ������ꍇ
            if mod(length(varargin),2)==0 % �@�@�������w�肵�đ������ꍇ
                %varargin=varargin{1};
                for i =1:nargin/2
                    if strcmp(varargin{2*i-1},"q")
                        obj.q=obj.check_and_convert_q(varargin{2*i});
                    else
                        obj.(varargin{2*i-1})=varargin{2*i};
                    end
                end
            else
                %value=varargin{1}{1};
                value=varargin{1};
                if isstruct(value) % �A �\���̂Ő������w�肷��ꍇ
                    tmpf=fields(value);
                    for i = 1:length(tmpf)
                        if isprop(obj,tmpf{i})
                            if strcmp(tmpf{i},"q")
                                obj.q=obj.check_and_convert_q(value.(tmpf{i}));
                            else
                                obj.(tmpf{i})=value.(tmpf{i});
                            end
                        end
                    end
                else % �B ��ԃx�N�g���ő������ꍇ
                    tmpvalue=value;
                    for i = 1:length(obj.list)
                        if strcmp(obj.list(i),"q")
                            obj.q=obj.check_and_convert_q(tmpvalue(1:obj.num_list(i)));
                        else
                            obj.(obj.list(i))=tmpvalue(1:obj.num_list(i));
                        end
                        tmpvalue=tmpvalue(obj.num_list(i)+1:end);
                    end
                    if ~isempty(tmpvalue);    warning("ACSL : check compatibility with state.list"); end
                end
            end
        end
    end
    methods
        function output = get(obj, varargin)
            % �@�@get(); ��ԃx�N�g�������o��
            % �A�@get("p"); �����w�肵�Ď��o��
            % �B�@get(["p","v"]); ���𕡐��w�肵�Ď��o��
            % �C�@get("state"); �\���̂Ƃ��ďo��
            if isempty(varargin) % �@
                output = cell2mat(arrayfun(@(t) obj.(t)',string(obj.list),'UniformOutput',false))';
            else % �A�C�B �����w�肵�Ď��o���ꍇ
                if strcmp(varargin{1},"state")
                    F = fieldnames(obj);
                    for i = 1:length(F)
                        if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
                            output.(F{i})=obj.(F{i});
                        end
                    end
                else
                    output = cell2mat(arrayfun(@(t) obj.(t)',string(varargin{1}),'UniformOutput',false))';
                end
            end
        end
        function q = getq(obj,type)
            % type ~= obj.type
            switch type
                case {"compact"}
                    if obj.type == 4
                        q=obj.q;
                    else
                        if obj.type == 3
                            q=Eul2Quat(obj.q);
                        else
                            value=reshape(obj.q,[3,3])';
                            q = R2q(value);
                        end
                    end
                case {"euler"}
                    if obj.type == 3
                        q=obj.q;
                    else
                        if obj.type == 4
                            q=Quat2Eul(obj.q);
                        else
                            value=reshape(obj.q,[3,3])';
                            q = Quat2Eul(R2q(value));
                        end
                    end
                case {"rotmat"}
                    if obj.type == 9
                        q=obj.q;
                    else
                        if obj.type == 3
                            q=RodriguesQuaternion(Eul2Quat(obj.q));
                        else
                            q = RodriguesQuaternion(obj.q);
                        end
                    end
            end
        end
        function q=check_and_convert_q(obj,value)
            if isempty(obj.type)
                error("ACSL : Attitude is not in the state");
            else
                len = length(value);
                if obj.type==len
                    q = value;
                else
                    switch obj.type
                        case 4 % �o�͂�unit quaternion�̏ꍇ
                            if len==3
                                q=Eul2Quat(value);
                            else
                                value=reshape(value,[3,3])';
                                q = R2q(value);
                            end
                        case 3 % �o�͂�euler angle �̏ꍇ
                            if len==4
                                q=Quat2Eul(value);
                            else
                                value=reshape(value,[3,3])';
                                q= Quat2Eul(R2q(value));
                            end
                        case 9 % �o�͂���]�s��̏ꍇ
                            if len==4
                                q= R2v(RodriguesQuaternion(value));
                            else
                                q= R2v(RodriguesQuaternion(Eul2Quat(value)));
                            end
                    end
                end
            end
        end
    end
end

