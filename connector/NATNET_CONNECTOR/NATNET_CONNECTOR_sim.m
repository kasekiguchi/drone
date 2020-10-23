classdef NATNET_CONNECTOR_sim < CONNECTOR_CLASS
    % Motive��simulation�p�N���X�F�o�^���ꂽ�G�[�W�F���g�̈ʒu�Ǝp�����킩��
    % motive = NATNET_CONNECTOR_sim(param)
    % param :
    %     rigid_num : agnet number
    %     marker_num % number of UnLabeledmarker
    %     on_marker_num % total number of markers on agents
    %     (optional) local_marker : (cell array)
    %       is local position of on_markers : local_marker{s} = [x1 y1 z1; x2 y2 z2; ...]
    %     (optional) Flag : Noise��structure
    %     (optional) sigmaw : Observation noise variance
    
    properties
        name      = "Motive";
        result
        interface = @(x) x;
    end
    properties (Access = private)
        previous
        t_natnet_start % timer start time
        on_marker
        on_marker_num
        dt
    end
    properties %(GetAccess = ?Motive_sim)%private) % construct ������ς��Ȃ��l�D
        Flag = struct('Noise',     0);                                    % '1' = Additional noise exists
        local_marker_default     = [ 0.075, -0.075,  0.015;                               % X, Y. Z
            -0.075, -0.075, -0.015;
            -0.075,  0.075,  0.015;
            0.075,  0.075, -0.015];
        sigmaw    = [6.716E-5; 7.058E-5; 7.058E-5];                        % Observationm noise variance
    end
    
    methods
        function obj = NATNET_CONNECTOR_sim(param)
            obj.dt = param.dt;
            obj.result.rigid_num=param.rigid_num;
            if isfield(param,'local_marker')
                obj.result.local_marker = param.local_marker; %
            else
                obj.result.local_marker=cell(1,obj.result.rigid_num);
                for i = 1:obj.result.rigid_num
                    obj.result.local_marker{i} = obj.local_marker_default; % �S�@�̓����}�[�J�[�z�u
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
        function result = getData(obj,Param)
            %    result = sensor.motive.do(Param)
            % �yInput�z
            %  Param{1} : agent obj
            %  Param{2} : .marker_num > on_marker_num:
            %  �ݒ肷���UnLabeledmarker����`�����
            %             .occlusion :
            %             �ݒ肷��ƃI�N���[�W�������N������D���̂͌Œ�C���̏�̃}�[�J�[�̓����_���ɏ�����
            %             ����[1, 1.2]�͈̔͂ō���1,2
            %             �C����[1.5,1.6]�͈̔͂ō���2���I�N���[�W�������N������
            %             .occlusion.cond = ["t >= 1.0 && t<1.2","t>=1.5&&t<1.6]
            %             .occlusion.target = {[1,2],[2]}
            % �yfields of result�z
            % rigid : (struct array) rigid body info
            % marker : all marker position :
            %            row = marker id,
            %            column = position x, y, and z
            % rigid_num % number of rigid bodies
            % marker_num % number of UnLabeledmarker
            % local_marker_nums % ���̏�̃}�[�J�[�̐��i�^�l�j
            % local_marker      % ���̏d�S���猩���}�[�J�[�̈ʒu
            % time      % time from inittime
            
            if isempty(obj.t_natnet_start)
                obj.t_natnet_start=tic;% timer start
                obj.result.time = 0;
            end
            
            %% rigidBodyCount and Labeledmarker
            for s = 1:obj.result.rigid_num
                Position = Param{1}(s).state.p;
                obj.on_marker{s} = (Param{1}(s).state.getq('rotmat')*obj.result.local_marker{s}'+Position)';
                obj.result.rigid(s).p  = Position;
                obj.result.rigid(s).q    = Param{1}(s).state.getq('compact');
            end
            %% Additional noise for rigid body
            if obj.Flag.Noise == 1 %% Noise %%
                for k = 1:obj.result.rigid_num % �S���̂Ɉ�l�ɉe��
                    rng('shuffle');
                    obj.result.rigid(k).p = obj.result.rigid(k).p + (sqrt(obj.sigmaw) .* randn(3,1));
                    % �p���p�ւ̉e����sigmaw/100
                    %obj.result.rigid(k).q = R2q(Rodrigues(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]))*RodriguesQuaternion(obj.result.rigid(k).q))';
                    obj.result.rigid(k).q = rotm2quat(Rodrigues(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]))*RodriguesQuaternion(obj.result.rigid(k).q))';
                    %obj.result.rigid(k).q = compact(quaternion(sqrt(obj.sigmaw'/100) .* (rand(1,3)-0.5*[1 1 1]),'rotvec')*quaternion(obj.result.rigid(k).q'))';
                end
            end
            %% Occulusion
            if isfield(Param{2},'occlusion')
                Occlusion(obj,Param{2}.occlusion);
            end
            %% Unlabeledmarker
            if isfield(Param{2},'marker_num')
                obj.result.marker_num = Param{2}.marker_num;
            end
            tmp = arrayfun(@(i) obj.on_marker{i}',1:obj.result.rigid_num,'UniformOutput',false);
            obj.result.marker = [tmp{:}]';
            if obj.result.marker_num > obj.on_marker_num
                if obj.result.rigid_num == 1
                    cog = sum(obj.on_marker{1},1)/obj.on_marker_num;
                    radius=max(obj.on_marker{1}-cog);
                else
                    rigid_p = [obj.result.rigid(:).p]'; % �m�C�Y���݂̒l
                    cog = sum(rigid_p,1)/obj.result.rigid_num; % �S�G�[�W�F���g�̕��ψʒu
                    radius=max(rigid_p-cog);
                end
                rng('shuffle');
                obj.result.marker = [obj.result.marker;(cog +  (2*obj.sigmaw'+abs(radius)/2).* randn(obj.result.marker_num-obj.on_marker_num,3))];
                % cog �𒆐S��cog�����ԉ����G�[�W�F���g�̔����̋����𕪎U�ɂ΂���ʒu��UnLabeledmarker��z�u
            end
            
            %% Additional noise for marker
            if obj.Flag.Noise == 1 %% Noise %%
                for k = 1:obj.result.rigid_num % �S���̂Ɉ�l�ɉe��
                    if ~isempty(obj.on_marker{k})
                        rng('shuffle');
                        obj.on_marker{k} = obj.on_marker{k}+sqrt(obj.sigmaw') .*randn(size(obj.on_marker{k}));% �S�}�[�J�[�Ɉ�l�ɉe��
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
        function Occlusion(obj,param)
            for i = 1:length(param.cond)
                if evalin('base',param.cond(i))
                    disp(strcat("occlusion is occurring to agent ",string(param.target{i})));
                    for j = 1:length(param.target{i})
                        s= param.target{i}(j);
                        obj.result.rigid(s) = obj.previous(s);
                        szt=obj.result.local_marker_nums(s);
                        rng('shuffle');
                        sz=randi([1,szt]); % �c���� % -1 ������ƑS�������P�[�X���Č��D
                        if sz==0 % sz��-1������Ƃ����ɗ��邱�Ƃ�����D����K�v�Ȃ��D
                            obj.on_marker{s} = [];
                        else
                            obj.on_marker{s}=obj.on_marker{s}(randperm(szt,sz),:);
                        end
                    end
                end
            end
        end
        function [rigidVel,markerVel,previous] = CalcVelocity(obj,state,dt)
            previous = state;                   % ���ݏ�Ԃ��������Ŏg�p���邽�ߕۑ�
            if ~isfield(obj.previous, 'p')      % �O�����̏�Ԃ��Ȃ����������̎�
                old = state;
            else
                old = obj.previous.p;
            end
            tmp = (state - old)/dt;
            rigidVel = tmp(1,:)';
            markerVel = tmp(2:end,:);
        end
        function [AngleVel,previous] = CalcAngleVelocity(obj,state,type,dt)
            previous = state;               % ���ݏ�Ԃ��������Ŏg�p���邽�ߕۑ�
            if ~isfield(obj.previous, 'q')       % �O�����̏�Ԃ��Ȃ����������̎�
                old = state;
            else
                old = obj.previous.q;
            end
            if strcmp(type ,"euler")
                euler=state;
                euler_old=old;
            else
                euler     = Quat2Eul(state);
                euler_old = Quat2Eul(old);
            end
            AngleVel  = (euler - euler_old)/dt;
        end
    end
end
