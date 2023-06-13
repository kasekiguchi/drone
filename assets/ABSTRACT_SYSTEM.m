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
    sensor % 複数のセンサをpropertyとして持つ
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

properties %(Access = {?Logger,?SENSOR_CLASS,?CONNECTOR_CLASS}) % plant, state
    %(SetAccess = GetAccess={?SENSOR_CLASS}) % SENSOR_CLASSは読み取りのみ
    id
    plant % MODEL_CLASSのインスタンス（プラントモデル）
    %   state % plant or model のstateだけを取り出したもの handleクラスでどちらかのhandleになっている．
end

%% Plant
methods

    function obj = ABSTRACT_SYSTEM(args, param)

        arguments
            args
            param % parameter class
        end
        obj.plant = MODEL_CLASS(args);
        addprop(obj.plant,"parameter");
        obj.plant.parameter = param;
        obj.plant.param = param.get();
    end

end

methods

    function do_plant(obj, plant_param, emergency)

        arguments
            obj
            plant_param = [];
            emergency = [];
        end
        if ~isempty(plant_param)
            switch class(plant_param)
                case 'double'
                case 'struct'                   
                otherwise % class instanceの場合
                    plant_param.plant_or_model = "plant";
            end
        end
        if ~isempty(emergency) % 実験緊急事態
%            obj.plant.do(obj.input, [], "emergency");
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
        if ~isempty(plant_param)
            switch class(plant_param)
                case 'double'
                case 'struct'                   
                otherwise % class instanceの場合
                    plant_param.plant_or_model = "model";
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

    function set_model(obj, args, param)
        obj.model = MODEL_CLASS(args);
        obj.parameter = param;
        obj.model.param = obj.parameter.get();
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
            tmp = obj.(prop).(obj.(prop).name(i)).do(param{i}); % = result
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

    function set_model_error(obj, p, v)
        % update plant parameter
        % plant = model + error;
        ps=obj.parameter.get(p,'struct');
        if isstruct(v)
            for i = v
                ps.(i) = ps.(i) + v.(i);
            end
        else
            ps.(p) = ps.(p) + v;
        end
        obj.plant.parameter.set(p,ps);
        obj.plant.param = obj.plant.parameter.get();
    end

    function update_model_param(obj, p, v)
        % update model parameter
        % this update doesn't affect plant parameter
        % p : str array : target parameter
        % v : struct : with updated value
        % parameter.(p(i)) = v.(p(i)) 
        % example
        % obj.update_model_param(["mass","l"],struct("mass",1,"l",1));
        obj.parameter.set(p,v);
        obj.model.param = obj.parameter.get();
    end

    function fh=show(obj,str,opt)
        % requires each target class' show method accept
        % "logger","FH","t","param" option inputs
        arguments
            obj
            str
            opt.FH = 1;
            opt.logger = [];
            opt.t = [];
            opt.param = [];
        end
        tmp = obj;
        for j = 1:size(str,1)
            if iscell(opt.param)
                param = opt.param{j};
            else
                param = opt.param;
            end
        for i = str(j,:)
            tmp = tmp.(i);
        end       
        fh = tmp.show("logger",opt.logger,"FH",opt.FH,"t",opt.t,"param",param);
        end
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
