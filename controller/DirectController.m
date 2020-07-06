classdef DirectController <CONTROLLER_CLASS    
%     reference�Ƃ��ēn���ꂽ��Ԃ�Ԃ��R���g���[��
%     ���_���f���ŎQ�Ɠ_�Ɏ������ɍs�����ɗ��p
    properties
        self
        result
    end
    methods
        function obj = DirectController(self,~)
            obj.self= self;
        end
        
        function u = do(obj,param,~)
          % param = {state, xd}
            state=obj.self.model.state;
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
            u=obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

