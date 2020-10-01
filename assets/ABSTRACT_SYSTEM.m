classdef (Abstract) ABSTRACT_SYSTEM < handle & dynamicprops
    % ����ΏۂƂ��Ẵv�����g���f���̎��ׂ��������K�肷��N���X
    % �yProperties�z plant, model, sensor, estimator, estimator_substance, reference, controller,
    %                         input_tranform, env, (id, input, inner_input, state)
    %  plant : ������Ώ� model obj
    %  model : ���䃂�f�� model obj
    %  sensor : sensor obj �\���� : �Z���T�[�S�Ă̌��ʂ�sensor.result�ɏW��
    %  estimator : ����� % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
    %  reference : �ڕW��Ԑ��� reference obj
    %                     % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
    %  controller : ���䃂�f���ɑ΂��鐧����͎Z�o controller obj
    % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
    %  input_transform : ���Ώۂɓ��͂ł���悤���͂�ϊ����� input_transform obj
    %  env : �G�[�W�F���g���z�肵�Ă����
    %  �yUsage�zobj=ABSTRACT_SYSTEM(varargin)
    %  varargin needs to have fields
    %     type : class name of plant(=model)
    %     name (optional): ~
    %     param : parameter for "type" class constructor
    %                  : agent.plant = str2func(type)({type,param})
    % Notice that property "state" ( : state of a plant) and metod "get_state" are defined in STATE_CLASS
    properties% (Abstract) % General param
        % ����������property �͊e���O�̃N���X�̃C���X�^���X : �� model
        model % MODEL_CLASS�̃C���X�^���X�i�R���g���[�����f���j
        sensor % �����̃Z���T��property�Ƃ��Ď���
        controller % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
        estimator % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
        reference % �����̏ꍇ��`���ꂽ���ԂɌv�Z�����
        connector
        env
        input_transform % plant �� model�œ��͂̌^���Ⴄ���ɕϊ����邽��
    end
    properties% (SetAccess=private) % Input
        input
        inner_input
    end
    properties %(Access = {?Logger,?SENSOR_CLASS,?CONNECTOR_CLASS}) % plant, state
        %(SetAccess = GetAccess={?SENSOR_CLASS}) % SENSOR_CLASS�͓ǂݎ��̂�
        id
        plant % MODEL_CLASS�̃C���X�^���X�i�v�����g���f���j
        state % plant or model ��state���������o�������� handle�N���X�łǂ��炩��handle�ɂȂ��Ă���D
    end
    
    %% Plant
    methods (Access = private) % set plant
        function set_plant(obj,args)
            if isfield(args,'id')
                obj.id=args.id;
            end
            plant_subclass=str2func(args.type);
            obj.plant = plant_subclass(args.param);
        end
    end
    methods %(Access = private)
        function do_plant(obj,varargin)
            if length(varargin)>1 %�����p
                obj.plant.do(obj.input,[],"emergency");
            else
                if ~isempty(varargin)
                    plant_param = varargin{1};
                else
                    plant_param = [];
                end
                if isempty(obj.input_transform)
                    obj.plant.do(obj.input,plant_param);
                else
                    obj.inner_input = obj.input_transform.(obj.input_transform.name(1)).do(obj.input,plant_param);
                    obj.plant.do(obj.inner_input,plant_param);
                end
            end
        end
    end
    %% General
    methods % Constructor
        function obj=ABSTRACT_SYSTEM(varargin)
            if ~isempty(varargin{1}{1})
                obj.set_plant(varargin{1}{1}{1});
            else
                obj.set_plant();
            end
            if ~isempty(obj.plant.state) % �����̎���model�̒l������
                obj.state=obj.plant.state;
            end
        end
        function set_input(obj,input)
            obj.input=input;
        end
    end
    methods % Set methods
        function set_model(obj,args)
            model_subclass=str2func(args.type);
            obj.model = model_subclass(args.param);
            if isempty(obj.state) % �����ł�plant��state�������Ȃ�����
                obj.state=obj.model.state; % handle �̋��L
            end
        end
        function set_sensor(obj,args)
            obj.set_property("sensor",args);
        end
        function set_estimator(obj,args)
            obj.set_property("estimator",args);
        end
        function set_env(obj,args)
            obj.set_property("env",args);
        end
        function set_reference(obj,args)
            obj.set_property("reference",args);
        end
        function set_controller(obj,args)
            obj.set_property("controller",args);
        end
        function set_connector(obj,args)
            obj.set_property("connector",args);
        end
        function set_input_transform(obj,args)
            obj.set_property("input_transform",args);
        end
    end
    methods % Do methods
        function do_sensor(obj,param)
            obj.do_parallel("sensor",param);
        end
        function do_estimator(obj,param)
            obj.do_sequential("estimator",param);
        end
        function do_reference(obj,param)
            obj.do_sequential("reference",param);
        end
        function do_controller(obj,param)
            obj.do_sequential("controller",param);
            obj.input=obj.controller.(obj.controller.name(end)).result.input;
        end
        function do_model(obj,param)
            % ����l��model�̏�Ԃ��㏑���D
            if obj.model.state.list==obj.estimator.result.state.list
                obj.model.state.set_state(obj.estimator.result.state.get());
            else
                for i = 1:length(obj.model.state.list)
                    obj.model.state.set_state(obj.model.state.list(i),obj.estimator.result.state.(obj.model.state.list(i)));
                end
            end
            obj.model.do(obj.input,param);
        end
    end
    
    methods % set, do property
        function set_property(obj,prop,args,varargin)
            subclass=str2func(args.type);
            if isempty(varargin)
                obj.(prop).(args.name) = subclass(obj,args.param);
            else
                obj.(prop).(args.name) = subclass(obj,args.param,varargin{1});
            end
            if isfield(obj.(prop),'name')
                obj.(prop).name = [obj.(prop).name, args.name];
            else
                obj.(prop).name = args.name;
            end
        end
        function do_parallel(obj,prop,param)
            % prop : property name
            % param : parameter to do a property
            result = obj.(prop).(obj.(prop).name(1)).do(param{1});
            for i = 2:length(obj.(prop).name) % (prop).result�Ɍ��ʂ��܂Ƃ߂邽��
                tmp=obj.(prop).(obj.(prop).name(i)).do(param{i});
                F = fieldnames(tmp);
                for j = 1:length(F)
                    if strcmp(F{j},'state')
                        if isfield(result,'state')
                            Fs = fieldnames(tmp.state);
                            for k = 1:length(Fs)
                                if ~isprop(result.state,Fs{k})
                                    addprop(result.state,Fs{k});
                                end
                                result.state.set_state(Fs{k},tmp.state.(Fs{k}));
                            end
                        else
                            result.(F{j})=state_copy(tmp.(F{j}));
                        end
                    else
                        result.(F{j})=tmp.(F{j});
                    end
                end
            end
            obj.(prop).result=result;
        end
        function do_sequential(obj,prop,param)
            % prop : property name
            % param : parameter to do a property
            % ��������property��ݒ肵���ꍇrecursive�ɎQ�ƒl�����߂�D
            % result = prop.prop1.do(param{1})
            % result = prop.prop2.do(param{2},result)
            % result = prop.prop3.do(param{3},result) ...
            result = obj.(prop).(obj.(prop).name(1)).do(param{1});
            for i = 2:length(obj.(prop).name) % prop.result�Ɍ��ʂ��܂Ƃ߂邽��
                tmp=obj.(prop).(obj.(prop).name(i)).do(param{i},result);
                F = fieldnames(tmp);
                for j = 1:length(F)
                    if strcmp(F{j},'state')
                        result.(F{j})=state_copy(tmp.(F{j}));
                    else
                        result.(F{j})=tmp.(F{j});
                    end
                end
            end
            obj.(prop).result=result;
        end
    end
end
