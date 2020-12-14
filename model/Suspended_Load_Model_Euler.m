classdef Suspended_Load_Model_Euler < MODEL_CLASS
    % Discrete time model
%     properties
%         Property1
%     end
    
    methods
        function obj = Suspended_Load_Model_Euler(args)
            obj= obj@MODEL_CLASS("Suspended_Load_Model_Euler",args);
            %obj.id = self.id
            % 
            %   詳細説明をここに記述
        end
        function initialize(obj,load_obj,pos)
            % initialize(obj,load_obj,pos)
            % load_obj : load 用剛体オブジェクト
            % pos : agent の初期位置
            obj.set_state([pos;[0;0;0];[0;0;0];[0;0;0];pos+[0;0;-1]*obj.param(end);[0;0;0];[0;0;-1];[0;0;0]]);
            load_obj.model.set_state([obj.state.pL;[0;0;0];[0;0;0];[0;0;0]]);
        end
    end
end
