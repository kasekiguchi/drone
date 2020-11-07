classdef Quat13_Model < MODEL_CLASS
    % Discrete time model
    properties
        fig
    end
    
    methods
        function obj = Quat13_Model(args)
            obj= obj@MODEL_CLASS("Quat13_Model",args);
            %obj.id = self.id
            % 
            %   詳細説明をここに記述
            if isprop(args,'fig')
                obj.fig = args.fig;
            end
        end
        function show(obj)
            %rad = norm(rot);
            %dir = rot/rad;
            pp =patch(obj.fig(1),'FaceAlpha',0.3);
            pf =patch(obj.fig(2),'EdgeColor','flat','FaceColor','none','LineWidth',0.2);

            pobj=[pp;pf];
            for i = 1:length(pobj)
                pobj(i).Vertices = (obj.state.getq('rotmat')*pobj(i).Vertices')'+obj.state.p';
            end
            %rotate(obj,dir,180*rad/pi,orig+trans);
        end
        
    end
end

