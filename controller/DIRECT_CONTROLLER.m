classdef DIRECT_CONTROLLER < handle    
%     referenceとして渡された状態を返すコントローラ
%     質点モデルで参照点に自時刻に行く時に利用
    properties
        self
        result
    end
    methods
        function obj = DIRECT_CONTROLLER(self,~)
            obj.self= self;
        end
        
        function u = do(obj,varargin)
          % param = {state, xd}
            state=obj.self.estimator.model.state;
            xd=obj.self.reference.result.state;
            F = fieldnames(state);
            Ref = state_copy(state);
            for i = 1:length(F)
                if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
                    if isprop(xd,F{i})
                        Ref.(F{i})= xd.(F{i});
                    end
                end
            end
            obj.result.input = Ref.get();
            obj.self.input = obj.result.input;
            u=obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

