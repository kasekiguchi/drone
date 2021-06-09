classdef ODV_Model < MODEL_CLASS
    % OmniDirectionalVehicle model
    % 
%     properties
%         Property1
%     end
    
    methods
        function obj = ODV_Model(args)
            obj= obj@MODEL_CLASS("OmnidirectionalMobile_Model",args);
            %obj.id = self.id
            % 
            %   詳細説明をここに記述
        end
        
    end
end
