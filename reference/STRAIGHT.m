classdef STRAIGHT
    %STRAIGHT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ref
        v
        pre
        result
        self
        TrackingPoint
    end
    
    methods
        function obj = STRAIGHT(self,varargin)
            %STRAIGHT Construct an instance of this class
            %   Detailed explanation goes here
            obj.self = self;
            obj.v = varargin{1,1}{1,1};
            obj.pre = [0;0;0;obj.v];
            obj.result.ref = [];
            obj.TrackingPoint = [varargin{1,1}{1,2}.p(1,1);varargin{1,1}{1,2}.p(2,1);varargin{1,1}{1,2}.q;obj.v];
%             obj.result.ref =[];
            obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
        end
        
        function result = do(obj,param)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            EstData = obj.self.estimator.result.state.get();
            if isempty(obj.result.state.p)
                obj.TrackingPoint = [EstData(1,1);0;0;obj.v] + [obj.v;0;0;0];
            else
                if obj.result.state.p > (EstData(1,1)+obj.v)
                    obj.TrackingPoint = [obj.result.state.p;0;0;obj.v];
                else
                    obj.TrackingPoint = [EstData(1,1);0;0;obj.v] + [obj.v;0;0;0];
                end
            end
%             if isempty(obj.result.state.p)
%                 obj.TrackingPoint = obj.pre(1:4,1) + [obj.v;0;0;0];
%             else
%                 if EstData(1,1) - (obj.result.state.p(1,1) + obj.v) >= obj.v+0.1
%                     obj.TrackingPoint = obj.result.state.p(1:2,1);
%                     obj.TrackingPoint = [obj.TrackingPoint;0;obj.v];
%                 else
%                     obj.TrackingPoint = obj.result.state.p(1:2,1) + [0.05;0];
%                     obj.TrackingPoint = [obj.TrackingPoint;0;obj.v];
%                 end
%             end
             
            obj.result.state.xd = obj.TrackingPoint(:,1);
            obj.result.state.p = obj.TrackingPoint(:,1);
            obj.result.state.q = obj.TrackingPoint(3,1);
            obj.result.state.v = obj.TrackingPoint(4,1);
            obj.self.reference.result.state = obj.TrackingPoint;
            obj.pre = obj.result.state.p;
            result = obj.result;
        end

        function [] = FHPlot(obj,Env,FH,flag)
            agent = obj.self;
            MapIdx = size(Env.floor.Vertices,3);
            for ei = 1:MapIdx
                tmpenv(ei) = polyshape(Env.floor.Vertices(:,:,ei));
            end
            p_Area = union(tmpenv(:));
            %plantFinalState
            pstate = agent.plant.state.p(:,end);
            pstateq = agent.plant.state.q(:,end);
%             pstate = agent.estimator.result.state.p(:,end);
%             pstateq = agent.estimator.result.state.q(:,end);
            pstatesquare = pstate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
            pstatesquare =  polyshape(pstatesquare');
%             pstatesquare =  rotate(pstatesquare,180 * pstateq / pi, pstate');

            %modelFinalState
            estate = agent.estimator.result.state.p(:,end);
            estateq = agent.estimator.result.state.q(:,end);
            estatesquare = estate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
            estatesquare =  polyshape( estatesquare');
            estatesquare =  rotate(estatesquare,180 * estateq / pi, estate');
            if isfield(agent.estimator.result,'map_param')
            Ewall = agent.estimator.result.map_param;
            Ewallx = reshape([Ewall.x,NaN(size(Ewall.x,1),1)]',3*size(Ewall.x,1),1);
            Ewally = reshape([Ewall.y,NaN(size(Ewall.y,1),1)]',3*size(Ewall.y,1),1);
            else
                Ewallx = nan;
                Ewally = nan;
            end
            %reference state
            RefState = agent.reference.result.state.p(1:3,:);
%             fWall = agent.reference.result.focusedLine;

            figure(FH)

            clf(FH)
            grid on
            axis equal
%             obj.self.show(["sensor","lrf"],[pstate;pstateq]);
            hold on
            plot(pstatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
%                agent.sensor.LiDAR.show();
            plot(estatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);

            plot(RefState(1,:),RefState(2,:),'ro','LineWidth',1);
%             plot(p_Area,'FaceColor','blue','FaceAlpha',0.5);
            plot(Ewallx,Ewally,'r-');
%             plot(fWall(:,1),fWall(:,2),'g-','LineWidth',2);
%             O = agent.reference.result.O;
% %             plot(O(1),O(2),'r*');
%             quiver(RefState(1,:),RefState(2,:),2*cos(RefState(3,:)),2*sin(RefState(3,:)));
            if isstring(flag)
                xmin = min(-5,min(Ewallx));
                xmax = max(95,max(Ewallx));
                ymin = min(-5,min(Ewally));
                ymax = max(95,max(Ewally));
                xlim([xmin-5, xmax+5]);
                ylim([ymin-5,ymax+5]);
            else
                xlim([estate(1)-7, estate(1)+7]);
                ylim([estate(2)-5,estate(2)+5]);
            end
            xlabel("$x$ [m]","Interpreter","latex");
            ylabel("$y$ [m]","Interpreter","latex");
            % pbaspect([20 20 1])
            hold off
        end
    end
end

