classdef DIRECT_ESTIMATOR < handle
    % Directory generate the estimated state from the sensor output.
    % obj = DIRECT_ESTIMATOR(agent,~)
    properties
        % state
        result
        self
        model
    end
    methods
        function obj = DIRECT_ESTIMATOR(self,param)
            obj.self = self;
            % obj.model = param.model;
            obj.model = param;
            obj.result.state=state_copy(obj.model.state); % STATE_CLASSとしてコピー
        end
        function result=do(obj,varargin)
            % Copy field values corresponding to the field of obj.result.state (=model.state) only.
            % 【Input】
            % 【Output】void
            F = fieldnames(obj.result.state);
            for i = 1:length(F)
                if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
                    if contains(F{i}, fieldnames(obj.self.sensor.result.state))
                        obj.result.state.set_state(F{i},obj.self.sensor.result.state.(F{i}));
                    end
                end
            end
            result=obj.result;
        end
        function show(obj)
            obj.result.state
        end
    end
end

