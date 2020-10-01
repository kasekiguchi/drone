classdef (Abstract) ABSTRACT_SYSTEM < handle & dynamicprops
    % 制御対象としてのプラントモデルの持つべき性質を規定するクラス
    % 【Properties】 plant, model, sensor, estimator, estimator_substance, reference, controller,
    %                         input_tranform, env, (id, input, inner_input, state)
    %  plant : 実制御対象 model obj
    %  model : 制御モデル model obj
    %  sensor : sensor obj 構造体 : センサー全ての結果をsensor.resultに集約
    %  estimator : 推定器 % 複数の場合定義された順番に計算される
    %  reference : 目標状態生成 reference obj
    %                     % 複数の場合定義された順番に計算される
    %  controller : 制御モデルに対する制御入力算出 controller obj
    % 複数の場合定義された順番に計算される
    %  input_transform : 実対象に入力できるよう入力を変換する input_transform obj
    %  env : エージェントが想定している環境
    %  【Usage】obj=ABSTRACT_SYSTEM(varargin)
    %  varargin needs to have fields
    %     type : class name of plant(=model)
    %     name (optional): ~
    %     param : parameter for "type" class constructor
    %                  : agent.plant = str2func(type)({type,param})
    % Notice that property "state" ( : state of a plant) and metod "get_state" are defined in STATE_CLASS
    properties% (Abstract) % General param
        % ここから先のproperty は各名前のクラスのインスタンス : 例 model
        model % MODEL_CLASSのインスタンス（コントローラモデル）
        sensor % 複数のセンサをpropertyとして持つ
        controller % 複数の場合定義された順番に計算される
        estimator % 複数の場合定義された順番に計算される
        reference % 複数の場合定義された順番に計算される
        connector
        env
        input_transform % plant と modelで入力の型が違う時に変換するため
    end
    properties% (SetAccess=private) % Input
        input
        inner_input
    end
    properties %(Access = {?Logger,?SENSOR_CLASS,?CONNECTOR_CLASS}) % plant, state
        %(SetAccess = GetAccess={?SENSOR_CLASS}) % SENSOR_CLASSは読み取りのみ
        id
        plant % MODEL_CLASSのインスタンス（プラントモデル）
        state % plant or model のstateだけを取り出したもの handleクラスでどちらかのhandleになっている．
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
            if length(varargin)>1 %実験用
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
            if ~isempty(obj.plant.state) % 実験の時はmodelの値が入る
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
            if isempty(obj.state) % 実験ではplantがstateを持たないため
                obj.state=obj.model.state; % handle の共有
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
            % 推定値でmodelの状態を上書き．
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
            for i = 2:length(obj.(prop).name) % (prop).resultに結果をまとめるため
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
            % 複数同じpropertyを設定した場合recursiveに参照値を求める．
            % result = prop.prop1.do(param{1})
            % result = prop.prop2.do(param{2},result)
            % result = prop.prop3.do(param{3},result) ...
            result = obj.(prop).(obj.(prop).name(1)).do(param{1});
            for i = 2:length(obj.(prop).name) % prop.resultに結果をまとめるため
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
