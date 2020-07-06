classdef LPF < ESTIMATOR_CLASS
    % 仕様が定まっていないのでとても中途半端
    %   現状　後退差分近似で微分値を求められる
    properties
        list % target of LPF
        num_list
        LPF_state
        T
        state
        result
        dt   
        self
    end
    
    methods
        function obj = LPF(self,param)
            %UNTITLED このクラスのインスタンスを作成
            %   詳細説明をここに記述
            obj.self = self;
            obj.dt=obj.self.model.dt;
            obj.T = param.LPF_T;
            if isfield(param,'list')
                obj.list = param.list;
                obj.num_list = param.num_list;
            else
                obj.list = obj.self.model.state.list;
                obj.num_list = obj.self.model.state.num_list;
            end
            obj.result.state=STATE_CLASS(struct('state_list',obj.list,'num_list',obj.num_list)); % STATE_CLASSとしてコピー（値はいれない）
        end
        
        function [result]=do(obj,param,varargin)           
            % param : list  = ['v','w']  list to be applied
            if ~isempty(varargin)
                sensor = varargin;
            else
                sensor = obj.self.sensor.result;
            end
            if length(param)==2;       obj.list = param{2};end
            if isempty(obj.LPF_state) % 初期値の設定
                for i = 1:length(obj.list)
                    obj.LPF_state.(obj.list(i)) = sensor.state.(obj.list(i));
                end
                if sum(size(obj.T)~=size(obj.list))
                    obj.T = ones(size(obj.list))*obj.T(1);
                end
            end
            for i = 1:length(obj.list)
                if strcmp(obj.list(i),"q")
                    switch length(obj.LPF_state.q)
                        case 4
                            obj.LPF_state.q=projection_to_unit_quaternion(obj.LPF_state.q);
                        case 9
                            obj.LPF_state.q=projection_to_SO3(obj.LPF_state.q);
                    end
                end
                obj.result.state.set_state(obj.list(i),obj.LPF_state.(obj.list(i)));
               obj.LPF_state.(obj.list(i)) = exp(-obj.dt/obj.T(i))*obj.LPF_state.(obj.list(i))+sensor.state.(obj.list(i))*(1-exp(-obj.dt/obj.T(i)));
                %obj.LPF_state.(obj.list(i)) = sensor.state.(obj.list(i)) + exp(-obj.dt/obj.T(i))*(obj.LPF_state.(obj.list(i))-sensor.state.(obj.list(i)));
            end
            % lpf + s
            %                 obj.result.state.set_state('v',obj.LPF_v + obj.result.p/obj.T);
            %                 obj.LPF_v = exp(-obj.dt/obj.T)*obj.LPF_v-obj.result.p*(exp(-obj.dt/obj.T) - 1)/obj.T;
            result=obj.result;
        end
        function show(obj)
        end
    end
end

