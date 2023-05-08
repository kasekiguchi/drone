classdef (Abstract) ABSTRACT_SYSTEM < dynamicprops
    % 制御対象としてのプラントモデルの持つべき性質を規定するクラス
    % 【Properties】 plant, model, sensor, estimator, estimator_substance, reference, controller,
    %                         input_tranform, (id, input, inner_input, state)
    %  plant : 実制御対象 model obj
    %  model : 制御モデル model obj
    %  sensor : sensor obj 構造体 : センサー全ての結果をsensor.resultに集約
    %  estimator : 推定器 % 複数の場合定義された順番に計算される
    %  reference : 目標状態生成 reference obj
    %                     % 複数の場合定義された順番に計算される
    %  controller : 制御モデルに対する制御入力算出 controller obj
    % 複数の場合定義された順番に計算される
    %  input_transform : 実対象に入力できるよう入力を変換する input_transform obj
    %  【Usage】obj=ABSTRACT_SYSTEM(varargin)
    %  varargin needs to have fields
    %     type : class name of plant(=model)
    %     name (optional): ~
    %     param : parameter for "type" class constructor
    %                  : agent.plant = str2func(type)({type,param})
    % Notice that property "state" ( : state of a plant) and metod "get_state" are defined in STATE_CLASS
    properties % (Abstract) % General param
        % ここから先のproperty は各名前のクラスのインスタンス : 例 model
        model % MODEL_CLASSのインスタンス（コントローラモデル）
        sensor % 複数のセンサをpropertyとして持つ、並列で扱われる
        controller % 複数の場合定義された順番に計算される
        estimator % 複数の場合定義された順番に計算される
        reference % 複数の場合定義された順番に計算される
        connector
        input_transform % plant と modelで入力の型が違う時に変換するため
        parameter % 物理パラメータ用クラス
    end

    properties % (SetAccess=private) % Input
        input
        inner_input
    end

    properties
        id
        plant % MODEL_CLASSのインスタンス（プラントモデル）
    end

    %% Plant
    methods
        function obj = ABSTRACT_SYSTEM(args,param)
            arguments
                args
                param
            end
            obj.parameter = param;
            obj.plant = MODEL_CLASS(args);
            obj.plant.param = obj.parameter.get(obj.parameter.parameter_name,"plant");
        end
    end

    methods

        function do_plant(obj, plant_param, emergency)
            arguments
                obj
                plant_param = [];
                emergency = [];
            end

            if ~isempty(emergency) % 実験緊急事態
                obj.plant.do(obj.input, [], "emergency");
            else
                if isempty(obj.input_transform)
                    obj.plant.do(obj.input, plant_param);
                else
                    obj.inner_input = obj.input;
                    for i = 1:length(obj.input_transform.name)
                        obj.inner_input = obj.input_transform.(obj.input_transform.name(i)).do(obj.inner_input, plant_param);
                    end
                    obj.plant.do(obj.inner_input, plant_param);
                end
            end
        end
    end

    %% General
    methods

        function set_input(obj, input)
            % controller result も上書きするべきでは？
            obj.input = input;
        end

    end

    methods % Set methods
        function set_estimator(obj, prop, args)
            obj.set_property(prop,args);
            % modelの状態でestimatorの状態を生成
            obj.estimator.result.state = state_copy(obj.model.state);
        end
        function set_model(obj, args)
          obj.model = MODEL_CLASS(args);
          obj.model.param = obj.parameter.get(args.parameter_name);
        end
    end

    methods % Do methods

        function do_sensor(obj, param)
            obj.do_parallel("sensor", param);
        end

        function do_estimator(obj, param)
            obj.do_sequential("estimator", param);
        end

        function do_reference(obj, param)
            obj.do_sequential("reference", param);
        end

        function do_controller(obj, param)
            obj.do_parallel("controller", param);
        end

        function do_model(obj, param)
            % 推定値でmodelの状態を上書きした上でmodelのdo method を実行
            if obj.model.state.list == obj.estimator.result.state.list % TODO　１回目の時に右辺が定義されていないのでは？
                obj.model.state.set_state(obj.estimator.result.state.get());
            else

                for i = 1:length(obj.model.state.list)
                    obj.model.state.set_state(obj.model.state.list(i), obj.estimator.result.state.(obj.model.state.list(i)));
                end

            end

            obj.model.do(obj.input, param);
        end

    end

    methods % set, do property

        function set_property(obj, prop, args)

            arguments
                obj
                prop {mustBeInPropList}
                args {mustBeSpecifiedStructure}
            end

            subclass = str2func(args.type);
            obj.(prop).(args.name) = subclass(obj, args.param);

            if isfield(obj.(prop), 'name')
                obj.(prop).name = [obj.(prop).name, args.name];
            else
                obj.(prop).name = args.name;
            end

            obj.(prop).result = [];
        end

        function do_parallel(obj, prop, param)
            % prop : property name
            % param : parameter to do a property
            result = obj.(prop).(obj.(prop).name(1)).do(param{1});

            for i = 2:length(obj.(prop).name) % (prop).resultに結果をまとめるため
                tmp = obj.(prop).(obj.(prop).name(i)).do(param{i});
                F = fieldnames(tmp);

                for j = 1:length(F)

                    if strcmp(F{j}, 'state')

                        if isfield(result, 'state')
                            Fs = fieldnames(tmp.state);

                            for k = 1:length(Fs)

                                if ~isprop(result.state, Fs{k})
                                    addprop(result.state, Fs{k});
                                end

                                result.state.set_state(Fs{k}, tmp.state.(Fs{k}));
                            end

                        else
                            result.(F{j}) = state_copy(tmp.(F{j}));
                        end

                    else
                        result.(F{j}) = tmp.(F{j});
                    end

                end

            end

            obj.(prop).result = result;
        end

        function do_sequential(obj, prop, param)
            % prop : property name
            % param : parameter to do a property
            % 複数同じpropertyを設定した場合recursiveに参照値を求める．
            % result = prop.prop1.do(param{1})
            % result = prop.prop2.do(param{2},result)
            % result = prop.prop3.do(param{3},result) ...
            result = obj.(prop).(obj.(prop).name(1)).do(param{1});

            for i = 2:length(obj.(prop).name) % prop.resultに結果をまとめるため
                tmp = obj.(prop).(obj.(prop).name(i)).do(param{i}, result);
                F = fieldnames(tmp);

                for j = 1:length(F)

                    if strcmp(F{j}, 'state')
                        result.(F{j}) = state_copy(tmp.(F{j}));
                    else
                        result.(F{j}) = tmp.(F{j});
                    end

                end

            end

            obj.(prop).result = result;
        end

        function set_model_error(obj,p,v)
            obj.parameter.set_model_error(p,v);
            obj.plant.param = obj.parameter.get("all","plant");
        end
    end

end

function mustBePlantStructure(s)

    if ~(isfield(s, 'type') && isfield(s, 'param'))
        eidType = 'mustBePlantStructure:notStructure';
        msgType = 'ACSL : Input must be a structure with specified fields.';
        throwAsCaller(MException(eidType, msgType))
    end

end

function mustBeSpecifiedStructure(s)

    if ~(isfield(s, 'type') && isfield(s, 'name'))
        eidType = 'mustBeStructure:notStructure';
        msgType = 'ACSL : Input must be a structure with specified fields.';
        throwAsCaller(MException(eidType, msgType))
    end

end

function mustBeInPropList(s)

    if ~(sum(strcmp(s, {'model', 'sensor', 'estimator', 'controller', 'reference', 'connector', 'input_transform'})))
        eidType = 'mustBeInPropList:notProp';
        msgType = 'ACSL : Input must be a property of this class.';
        throwAsCaller(MException(eidType, msgType))
    end

end
