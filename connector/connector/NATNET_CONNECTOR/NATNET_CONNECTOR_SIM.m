classdef NATNET_CONNECTOR_SIM < handle
    % MotiveのSimulation用クラス：登録されたエージェントの位置と姿勢がわかる
    % motive = NATNET_CONNECTOR_SIM(param)
    % param :（要確認：バージョン変化で変わっているかも）
    %     rigid_num : agnet number
    %     marker_num % number of UnLabeledmarker
    %     on_marker_num % total number of markers on agents
    %     (optional) local_marker : (cell array)
    %       is local position of on_markers : local_marker{s} = [x1 y1 z1; x2 y2 z2; ...]
    %     (optional) Flag : Noiseのstructure
    %     (optional) sigmaw : Observation noise variance
    
    properties
        name      = "Motive";
        result
        interface = @(x) x;
        occlusion_param = [];        %  設定するとUnLabeledmarkerが定義されオクルージョンを模擬できる
            %  剛体は固定，剛体上のマーカーはランダムに消える
            %  obj.occlusion_param : structure with fields
            %  'cond','target'
            %  .cond : condition for occlusion
            %  .target : occlusion target
            % example : For occlusions at 
            %  time span [1, 1.2] to rigid-body 1,2 and
            %  time span [1.5,1.6] to rigid-body 2,
            %  set 
            %  .occlusion_param.cond = ["t >= 1.0 && t<1.2","t>=1.5&&t<1.6"]
            %  .occlusion_param.target = {[1,2],[2]}
    end
    properties (Access = private)
        previous
        t_natnet_start % timer start time
        on_marker
        on_marker_num
        marker_num =[]; % 　marker_num > on_marker_num: 合計マーカー数
        dt
    end
    properties %(GetAccess = ?Motive_SIM)%private) % construct したら変えない値．
        Flag = struct('Noise',     0);                                    % '1' = Additional noise exists
        local_marker_default     = [ 0.075, -0.075,  0.015;                               % X, Y. Z
            -0.075, -0.075, -0.015;
            -0.075,  0.075,  0.015;
            0.075,  0.075, -0.015];
        sigmaw    = [6.716E-5; 7.058E-5; 7.058E-5];                        % Observationm noise variance
    end
    
    methods
        function obj = NATNET_CONNECTOR_SIM(param)
            obj.dt = param.dt;
            obj.result.rigid_num=param.rigid_num;
            if isfield(param,'local_marker')
                obj.result.local_marker = param.local_marker; %
            else
                obj.result.local_marker=cell(1,obj.result.rigid_num);
                for i = 1:obj.result.rigid_num
                    obj.result.local_marker{i} = obj.local_marker_default; % 全機体同じマーカー配置
                end
            end
            obj.result.local_marker_nums = [arrayfun(@(i) size(obj.result.local_marker{i},1),1:obj.result.rigid_num)];
            obj.on_marker_num = sum(obj.result.local_marker_nums);
            obj.result.marker_num=obj.on_marker_num;
            if isfield(param,'Flag')
                obj.Flag = param.Flag;
            end
            if isfield(param,'sigmaw')
                obj.sigmaw = param.sigmaw;
            end
            obj.result.rigid(1:param.rigid_num) = struct();
            obj.on_marker= cell(obj.result.rigid_num);
        end
        function result = getData(obj,Param1)
            %    result = sensor.motive.do(Param)
            % 【Input】
            %  Param1 : agent obj
            % 【fields of result】
            % rigid : (struct array) rigid body info
            % marker : all marker position :
            %            row = marker id,
            %            column = position x, y, and z
            % rigid_num % number of rigid bodies
            % marker_num % number of UnLabeledmarker
            % local_marker_nums % 剛体上のマーカーの数（真値）
            % local_marker      % 剛体重心から見たマーカーの位置
            % time      % time from inittime
            
            if isempty(obj.t_natnet_start)
                obj.t_natnet_start=tic;% timer start
                obj.result.time = 0;
            end
            
            %% rigidBodyCount and Labeledmarker
            for s = 1:obj.result.rigid_num
                if iscell(Param1)
                    obj.result.rigid(s+obj.result.rigid_num).p = Param1{1}(s).plant.state.(Param1{2}(1));
                    if length(Param1{2})==2
                        obj.result.rigid(s+obj.result.rigid_num).q = Param1{1}(s).plant.state.(Param1{2}(2));
                    elseif length(Param1{2})>2
                        for k = 3:length(Param1{2})
                            obj.result.rigid(s+obj.result.rigid_num).(Param1{2}(k)) = Param1{1}(s).plant.state.(Param1{2}(k));
                        end
                    end
                    Param1 = Param1{1};
                end
                Position = Param1(s).plant.state.p;
                obj.on_marker{s} = (Param1(s).plant.state.getq('rotmat')*obj.result.local_marker{s}'+Position)';
                obj.result.rigid(s).p  = Position;
                obj.result.rigid(s).q    = Param1(s).plant.state.getq('compact');
            end
            %% Additional noise for rigid body
            if obj.Flag.Noise == 1 %% Noise %%
                for k = 1:obj.result.rigid_num % 全剛体に一様に影響
                    rng('shuffle');
                    obj.result.rigid(k).p = obj.result.rigid(k).p + (sqrt(obj.sigmaw) .* randn(3,1));
                    % 姿勢角への影響はsigmaw/100
                    %obj.result.rigid(k).q = R2q(Rodrigues(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]))*RodriguesQuaternion(obj.result.rigid(k).q))';
                    obj.result.rigid(k).q = rotm2quat(Rodrigues(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]))*RodriguesQuaternion(obj.result.rigid(k).q))';
                    %obj.result.rigid(k).q = compact(quaternion(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]),'rotvec')*quaternion(obj.result.rigid(k).q'))';
                end
            end
            %% Occulusion
            if ~isempty(obj.occlusion_param)
                obj.occlusion();
            end
            %% Unlabeledmarker
            if ~isempty(obj.marker_num)
                obj.result.marker_num = Param2.marker_num;
            end
            tmp = arrayfun(@(i) obj.on_marker{i}',1:obj.result.rigid_num,'UniformOutput',false);
            obj.result.marker = [tmp{:}]';
            if obj.result.marker_num > obj.on_marker_num
                if obj.result.rigid_num == 1
                    cog = sum(obj.on_marker{1},1)/obj.on_marker_num;
                    radius=max(obj.on_marker{1}-cog);
                else
                    rigid_p = [obj.result.rigid(:).p]'; % ノイズ込みの値
                    cog = sum(rigid_p,1)/obj.result.rigid_num; % 全エージェントの平均位置
                    radius=max(rigid_p-cog);
                end
                rng('shuffle');
                obj.result.marker = [obj.result.marker;(cog +  (2*obj.sigmaw'+abs(radius)/2).* randn(obj.result.marker_num-obj.on_marker_num,3))];
                % cog を中心にcogから一番遠いエージェントの半分の距離を分散にばらつく位置にUnLabeledmarkerを配置
            end
            
            %% Additional noise for marker
            if obj.Flag.Noise == 1 %% Noise %%
                for k = 1:obj.result.rigid_num % 全剛体に一様に影響
                    if ~isempty(obj.on_marker{k})
                        rng('shuffle');
                        obj.on_marker{k} = obj.on_marker{k}+sqrt(obj.sigmaw') .*randn(size(obj.on_marker{k}));% 全マーカーに一様に影響
                    end
                end
            end
            %obj.result.time=toc(obj.t_natnet_start);
            obj.result.time = obj.result.time+obj.dt;
            result = obj.result;
            obj.previous=obj.result.rigid;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
            else
                disp("do measure first.");
            end
        end
    end
    methods (Static)
      function set_occlusion(obj,cond,target)
        if isempty(cond) % reset
          obj.occlusion_param = [];
        else
          obj.occlusion_param.cond = cond;
          obj.occlusion_param.target = target;
        end
      end
        function occlusion(obj)
          param = obj.occlusion_param;
            for i = 1:length(param.cond)
                if evalin('base',param.cond(i))
                    disp(strcat("occlusion is occurring to agent ",string(param.target{i})));
                    for j = 1:length(param.target{i})
                        s= param.target{i}(j);
                        obj.result.rigid(s) = obj.previous(s);
                        szt=obj.result.local_marker_nums(s);
                        rng('shuffle');
                        sz=randi([1,szt]); % 残す数 % -1 をすると全部消すケースも再現．
                        if sz==0 % szで-1をするとここに来ることもある．現状必要ない．
                            obj.on_marker{s} = [];
                        else
                            obj.on_marker{s}=obj.on_marker{s}(randperm(szt,sz),:);
                        end
                    end
                end
            end
        end
    end
end
