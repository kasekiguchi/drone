classdef PDController <CONTROLLER_CLASS    
    properties
           self
           result
           err
          Gain
    end
    
    methods
        function obj = PDController(self,param)
            obj.self = self;
            obj.Gain=param;
        end
        
        function u = do(obj,param,~)
            % u = do(obj,param,~)
            % param (optional) : Gain
            % Gain.P, Gain.D : p, d ゲイン
            state=obj.self.estimator.result.state;       % : （グローバル座標）推定状態 (state object)
            xd=obj.self.reference.result.state;           % xd : （ボディ座標）目標状態 (state object) 
            if ~isempty(param)
                obj.Gain=param;
            end
            F = fieldnames(state);
            for i = 1:length(F)
                if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
                    if isprop(xd,F{i})
                        Err.(F{i})= state.(F{i})-xd.(F{i});% 
                    else
                        Err.(F{i})= state.(F{i});
                    end
                end
            end
            obj.result.input = obj.Gain.P*Err.p;
            if isfield(Err,'v') && isfield(obj.Gain,'D')
                obj.result.input=obj.result.input+obj.Gain.D*Err.v;
            end
            u = obj.result;
        end 
        function show(obj)
            obj.result;
        end
    end
end

