classdef PestBirds_Model < MODEL_CLASS
    % Continuous time model
%     properties
%         Property1
%     end
    
    methods
        function obj = PestBirds_Model(args)
            obj= obj@MODEL_CLASS("Pestbirds_model",args);
            %obj.id = self.id
            % 
            %   詳細説明をここに記述
        end
        
    end
end
