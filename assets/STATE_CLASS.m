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
            % ①　set_state("p",[0;0;0],"v",[0;0;0]);
            % ②　set_state(struct("p",[0;0;0],"v",[0;0;0])); % 全状態セットするときもこちらを使うことを推奨
            % ③　set_state(x0); % state_list どおりに並んでいるものとして代入
            %if mod(length(varargin{1}),2)==0 % ①　成分を指定して代入する場合
            if mod(length(varargin),2)==0 % ①　成分を指定して代入する場合
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
                if isstruct(value) % ② 構造体で成分を指定する場合
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
                else % ③ 状態ベクトルで代入する場合
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
            % ①　get(); 状態ベクトルを取り出す
            % ②　get("p"); 情報を指定して取り出す
            % ③　get(["p","v"]); 情報を複数指定して取り出す
            % ④　get("state"); 構造体として出力
            if isempty(varargin) % ①
                output = cell2mat(arrayfun(@(t) obj.(t)',string(obj.list),'UniformOutput',false))';
            else % ②，③ 情報を指定して取り出す場合
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
                        case 4 % 出力がunit quaternionの場合
                            if len==3
                                q=Eul2Quat(value);
                            else
                                value=reshape(value,[3,3])';
                                q = R2q(value);
                            end
                        case 3 % 出力がeuler angle の場合
                            if len==4
                                q=Quat2Eul(value);
                            else
                                value=reshape(value,[3,3])';
                                q= Quat2Eul(R2q(value));
                            end
                        case 9 % 出力が回転行列の場合
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

