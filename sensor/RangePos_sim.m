classdef RangePos_sim < SENSOR_CLASS
    % RangePosのsimulation用クラス：登録されたエージェントのうち半径内のエージェントの位置を返す
    %   rpos = RangePos_sim(param)
    %   (optional) param.r : 半径
    %   (optional) param.target : 自機を含む対象配列
    %   param.id : このセンサーを積んでいる機体のidと一致させる．
    properties
        name = "RangePos";
      %  result
        interface = @(x) x;
        target % センシング対象のhandle object
        self % センサーを積んでいる機体のhandle object
        result
    end
    properties (SetAccess = private) % construct したら変えない値．
        r = 10;
        id
    end
    
    methods
        function obj = RangePos_sim(self,param)
            %  このクラスのインスタンスを作成
            obj.self=self;
            if isfield(param,'r'); obj.r= param.r;end
%            if isfield(param,'target'); obj.target= param.target;end
            obj.id= obj.self.id;
        end
        
        function result = do(obj,varargin)
            % result=rpos.do(Target) : obj.r 内にいるTargetの位置を返す．
            %   result.state : State_obj,  p : position
            % 【入力】Target ：観測対象のModel_objのリスト
            if ~isempty(varargin)
                Target=varargin{1}{1};
%                obj.target=Target;
            else
                Target=obj.target;
            end
            obj.target=obj.check_range(Target);
            obj.result.neighbor=cell2mat(arrayfun(@(i) obj.target(i).state.p,1:length(obj.target),'UniformOutput',false)); % private プロパティとしてのplant（実システム）の状態にアクセス．
            result=obj.result;
        end
        function target=check_range(obj,Target)
            neighbor.p=cell2mat(arrayfun(@(i) Target(i).state.p,1:length(Target),'UniformOutput',false)); % private プロパティとしてのplant（実システム）の状態にアクセス．
%             if isempty(obj.self)
%                 obj.self=Target([Target.id]==obj.id); % 自機の真値状態をそのまま渡す．
%             end
            epos=neighbor.p-obj.self.state.p;
            len2=sum(epos.*epos,1); % 仮距離を計算
            rid = logical((len2< obj.r^2)-(len2==0)); % 通信範囲内のエージェントID，第二項は自機体を除くため
            target=Target(rid);% センサー範囲内のエージェントを返す．
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                if isempty(varargin)
                    states=[obj.result.neighbor];
                    points=[states.p];
                    plot(points(:,1),points(:,2),'rx');axis equal;
                else
                    disp("p=");obj.self.state.p
                end
            else
                disp("do measure first.");
            end
        end
    end
end
