classdef Suspended_Load_Model < MODEL_CLASS
    % Discrete time model
%     properties
%         Property1
%     end
    
    methods
        function obj = Suspended_Load_Model(args)
            obj= obj@MODEL_CLASS("Suspended_Load_Model",args);
            %obj.id = self.id
            % 
            %   �ڍא����������ɋL�q
        end
        function initialize(obj,load_obj,pos)
            % initialize(obj,load_obj,pos)
            % load_obj : load �p���̃I�u�W�F�N�g
            % pos : agent �̏����ʒu
            obj.set_state([pos;[1;0;0;0];[0;0;0];[0;0;0];pos+[0;0;-1]*obj.param(end);[0;0;0];[0;0;-1];[0;0;0]]);
            load_obj.model.set_state([obj.state.pL;[0;0;0];[0;0;0];[0;0;0]]);
        end
    end
end
