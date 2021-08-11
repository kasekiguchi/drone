classdef humanController <CONTROLLER_CLASS
    %     referenceとして渡された状態を返すコントローラ
    %     質点モデルで参照点に自時刻に行く時に利用
    properties
        self
        result
        param
    end
    
    methods
        function obj = humanController(self,param)
            obj.self = self;
            obj.param = param;
        end
        
        function u = do(obj,param,input)
            % param = {state, xd}
 
            u=param{2};
            %             F = fieldnames(state);
            %             Ref = copy(state);
            %             for i = 1:length(F)
            %                 if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
            %                     addprop(Ref,F{i});
            %                     if isprop(xd,F{i})
            %                         Ref.(F{i})= xd.(F{i});
            %                     else
            %                         Ref.(F{i})= state.(F{i});
            %                     end
            %                 end
            %             end
            %             obj.result.input = Ref.get();
%             
%             obj.result.input = xd.result.state.u;
%             
%             
%             obj.self.input = obj.result.input;
%             result = obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

