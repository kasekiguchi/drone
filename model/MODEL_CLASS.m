classdef MODEL_CLASS <  handle
    % general model class
    % obj = MODEL_CLASS(name,param)
    %      name : 名前（obsolete）
    %      param : structure of 
    %            "state_list" : ['p','v']
    %            "num_list" : [3,3]  
    %            "initial" (optional)     : struct('p',[0;0;0],'v',[0;0;0])
    %            "dim"         : n, m, p :  number of state, input, and physical parameters
    %            "input_channel" : ['v']
    properties
        result
        name % model dynamicsの名前
        id % 一意に決定するもの : integer
        method % = str2func(name)
        projection = @(x) x; % 射影が必要な時は設定する．(obsolete ? )
        time_scale % discrete or continuous
        solver = str2func('ode15s') % 指数1　のDAEを解ける．
        % solver = str2func('ode45') % 指数1　のDAEを解ける．
        ts = 0;
        dt = 0.05;
        % state.list % 例 ["p","q","v","w"]
        % state.num_list % 例 [3,4,3,3]
        param % parameters
        dim % n, m, p :  number of state, input, and physical parameters
        input_channel % ["v","w"]
        noise
    end
    properties %(Access=private)
        state%=STATE_CLASS(); % 状態の構造体
    end
    methods
        function obj = MODEL_CLASS(name,param) % constructor
            if ~isempty(name)
                if isempty(regexp(name,"exp", 'once'))
                    obj.state=STATE_CLASS(param);
                    if isfield(param,'initial')
                        obj.set_state(param.initial);
                    end
                    obj.name = name;
                    obj.dim=param.dim;
                    obj.input_channel = param.input_channel;
                    obj.method=str2func(param.method);
                    obj.time_scale = 'continuous';
                    if contains(name,"Discrete")
                        obj.time_scale = 'discrete';
                    end
                    F = fieldnames(param);
                    for j = 1:length(F)
                        if ~strcmp(F{j},'initial') && ~strcmp(F{j},'state_list') && ~strcmp(F{j},'num_list')&& ~strcmp(F{j},'method') && ~strcmp(F{j},'time_scale')
                            if strcmp(F{j},'solver')
                                obj.solver = str2func(param.solver);
                            else
                                obj.(F{j}) = param.(F{j});
                            end
                        end
                    end
                end
            end
        end
        function [] =show_do_setting(obj)
            if contains(obj.time_scale,'discrete')
                disp("discrete time model");
            else
                disp(['continuous time model', obj.name]);
                disp(['ts = ', num2str(obj.ts),'    dt = ',num2str(obj.dt)]);
            end
        end
        function []=do(obj,u,varargin)
            if size(varargin)~=2
            if size(varargin)>0 % might too specialized to Drone system
                if isfield(varargin{1},'FH')
                    if ~isempty(varargin{1}.FH)
                          cha = get(varargin{1}.FH, 'currentcharacter');
                          if (cha == 'q' || cha == 's' || cha == 'a')
                              return
                          end
                    end
                end
                if isfield(varargin{1},'param')
                    obj.param = varargin{1}.param;
                %else
                    %obj.param = varargin{1};
                end
            end
            if ~isempty(obj.noise)
                rng('shuffle');
                u = u+obj.noise.* randn(size(u));
            end
            if contains(obj.time_scale,'discrete')
                obj.set_state(obj.projection(obj.method(obj.state.get(),u,obj.param)));
            else
                if isfield(obj.param,'solver_option')
                    [~,tmpx]=obj.solver(@(t,x) obj.method(x, u,obj.param),[obj.ts obj.ts+obj.dt],obj.state.get(),varargin{1}.solver_option);
                else
                    [~,tmpx]=obj.solver(@(t,x) obj.method(x, u,obj.param),[obj.ts obj.ts+obj.dt],obj.state.get());
                end
                obj.set_state(obj.projection(tmpx(end,:)'));
            end
            obj.result = obj.state;
            end
        end
        function []=set_state(obj,varargin)
            obj.state.set_state(varargin{1});
        end
        function state = get(obj,varargin)
            if strcmp(varargin{1},"state") % ④
                state = obj.state;
            else
                state=obj.state.get(varargin{1});
            end
        end
    end
end
