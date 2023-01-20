classdef Tbug_aida < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        state %現在位置 
        sensor %センサ情報
        state_initial %初期位置
        goal %目標位置
        pitch %laser間隔
        self
        param
        margin % 円の半径
        radius % 測距範囲
        haba % 車体幅

        l_points
        threshold
    end

    methods
        function obj = Tbug_aida(self, varargin)
            obj.pitch = self.sensor.lrf.pitch;
            obj.state_initial = [0,0,0]';
            obj.goal = [5,0,0]';
            obj.self=self;
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v","q"], 'num_list', [3, 1, 3]));
            obj.margin = 1;%閾値変更0.5
            obj.haba = 1;%閾値変更0.3
            obj.radius = 20;
            obj.threshold = 2.0;
            obj.l_points
%             DroneMargin = obj.state_initial/2;
        end
        
        function result = do(obj, t)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.state = obj.self.estimator.result.state; %自己位置
            yaw = obj.state.q(3);
            obj.sensor = obj.self.sensor.result; %

            obj.l_points = obj.sensor.sensor_points';

            R = [cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
            l_goal = R'*(obj.goal-obj.state.p); % local でのゴール位置
            % 障害物検知
            goalLength = l_goal-obj.state.p;
            r = vecnorm(goalLength); % 目標までの距離
            angle = atan2(goalLength(2),goalLength(1)); % 目標までの角度

            sensor_b = 0:obj.pitch:2 * pi;
            path = obj.make_path(sensor_b,obj.haba,obj.sensor.angle,obj.radius,angle,r);

            if find(obj.sensor.length < path)


%             for i = 1:length(obj.sensor.angle)
% %                 if -0.05 <= angle - obj.sensor.angle(i) <= 0.05
% %                     angle2 = obj.sensor.angle(i); % 目標に近い障害物の角度
% %                     angle2Length = obj.sensor.length(i); % 目標に近い障害物の距離
% %                     break
% %                 end
%             end



%             if r >= angle2Length %目標までの距離が目標に近い障害物の距離以上の時

                % 端点検出
                % 右の端点
%                 for i = 1:720
%                     if abs(obj.sensor.length(i)-obj.sensor.length(i+1)) >= 2.5%閾値変更1
%                 % 点群間距離が障害物の距離よりも大きい時
%                         right_anchor = obj.sensor.length(i+1);
%                         right_anchor_point = obj.sensor.sensor_points(i+1,:);
%                         break
%                     end
%                 end
%                 % 左の端点
%                 for j = 720:-1:2
%                     if abs(obj.sensor.length(j)-obj.sensor.length(j-1)) >= 3.5%閾値変更1
%                 % 点群間距離が障害物の距離よりも大きい時
%                         left_anchor = obj.sensor.length(j-1);
%                         left_anchor_point = obj.sensor.sensor_points(j-1,:);
%                         break
%                     end
%                 end
                

                %改善案
                nlength = circshift(obj.sensor.length,1);
                edge_ids = find(abs(nlength-obj.sensor.length) > obj.threshold); %近い端点のindex配列
                tmp = obj.sensor.length(edge_ids) > nlength(edge_ids);
                edge_ids(tmp) = edge_ids(tmp) - 1;

                reference_goal = l_goal(1:2) - obj.l_points(:,edge_ids);
                reference_goal = vecnorm(reference_goal);
                [~,tmp] = min(obj.sensor.length(edge_ids)+reference_goal);
                tid = edge_ids(tmp);
                Length = [obj.sensor.length(end),obj.sensor.length,obj.sensor.length(1)];
                edge_p = obj.sensor.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];
                if Length(tid+2) > Length(tid) % 左回りで避ける
                    %tid = obj.width_check(tid,-1);
                    [~,~,tmp1,tmp2] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin);
                    obj.result.state.p = [tmp1;tmp2;0];
                else % 右回り
                    %tid = obj.width_check(tid,1);
                    [tmp1,tmp2,~,~] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin);
                    obj.result.state.p = [tmp1;tmp2;0];
                end


                % 距離比較
                % 右の距離
%                 initial2right = right_anchor_point-obj.state.p(1:2)'; % 右の端点と初期位置の差
%                 right2goal = l_goal(1:2)'-right_anchor_point; % 目標位置と右の端点の差
%                 right_length = vecnorm(initial2right)+vecnorm(right2goal); % 右の目標までの距離
%                 % 左の距離
%                 initial2left = left_anchor_point-obj.state.p(1:2)'; % 左の端点と初期位置の差
%                 left2goal = l_goal(1:2)'-left_anchor_point; % 目標位置と左の端点の差
%                 left_length = vecnorm(initial2left)+vecnorm(left2goal); % 左の目標までの距離
% 
%                 if right_length <= left_length
%                     [A_x,A_y,~,~] = obj.conection(0,0,right_anchor_point(1),right_anchor_point(2),obj.margin);
%                     obj.result.state.p = [A_x,A_y,0]'; % local座標での位置
%                 else
%                     [~,~,B_x,B_y] = obj.conection(0,0,left_anchor_point(1),left_anchor_point(2),obj.margin);
%                     obj.result.state.p = [B_x,B_y,0]'; % local座標での位置
%                 end

                % local座標での位置
                obj.result.state.q = [0;0;atan2(obj.result.state.p(2),obj.result.state.p(1))];
                obj.result.state.p = [R*obj.result.state.p+obj.state.p];
                obj.result.state.v = 0.5;
                obj.result.state.q = [R*obj.result.state.q+obj.state.q];
                result = obj.result;

            else
                obj.result.state.p = l_goal;
                obj.result.state.q = [0;0;atan2(obj.result.state.p(2), ...
                obj.result.state.p(1))];
                obj.result.state.p = [R*obj.result.state.p+obj.state.p];
                obj.result.state.v = 0.5;
                obj.result.state.q = [R*obj.result.state.q+obj.state.q];

                result = obj.result;
            end



            % マージン生成
%             obj.margin = [0.5,0.5,0];
%             margin_right = right_anchor + obj.margin; % 右の端点
%             margin_left = left_anchor - obj.margin; % 左の端点

            % マージン円の生成
%             circle_right = viscircles(right_anchor,obj.margin);
%             circle_left = viscircles(left_anchor,obj.margin);


%             obj.sensor.angle 

            
%             if(r >= obj.sensor.sensor_points)
%                 Anchor = obj.sensor_points;
%             obj.sensor_points = obj.self.sensor.result.sensor_points;
            


%             datalen = 250;
            





%             obj.result.state.p = obj.goal; % local座標での位置
%             obj.result.state.v = [0;0;0];
% 
%             result = obj.result;
        end
        function [A_x,A_y,B_x,B_y] = conection(obj,x,y,X,Y,r) %接点の算出
            % x,y:初期位置
            % X,Y:障害物の座標
            % r: 円の半径
            a = x - X;
            b = y - Y; 
%             a = X - x;
%             b = Y - y;
            c = X^2 + Y^2 - x * X - y * Y - r^2;
            D = abs(a*X + b*Y + c);
            A_x = real((a*D - b*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + X;
            A_y = real((b*D + a*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + Y;
            B_x = real((a*D + b*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + X;
            B_y = real((b*D - a*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + Y;
%             contact = [A_x,A_y,B_x,B_y];            
        end

        function path = make_path(~,theta,margin,range,radius,goal_angle,goal)%検出範囲の作成
            %theta: センサの分解能
            %margin: ドローンの横幅
            %range: 角度？
            %goal_angle: ゴールまでの角度
            %goal: ゴールまでの距離
            path = zeros(size(range));
            tmp =find((radius*sin(theta) >= margin).*(theta <= pi/2));%2~16列目のインデックスを算出
            path(tmp) = margin./sin(theta(tmp));
            path(1:find(path,1)-1) = radius;
            margin =margin;
            tmp = find((radius*sin(theta) <= -margin).*(theta >= 3*pi/2));%49~63列目のインデックスを算出
            path(tmp) = -margin./sin(theta(tmp));
            path(find(path,1,'last')+1:end) = radius;
            margin =margin;
            [~,id] = min(abs(range - goal_angle));
            path = circshift(path,id-1);
            path(path>goal) = goal;
        end
        

%%
        function fh = show(obj,opt)
            %"logger",opt.logger,"FH",opt.FH,"t",opt.t,"param",param
            arguments
                obj
                opt.logger = [];
                opt.FH = 1;
                opt.t = [];
                opt.param = [];
            end

%             clf
            env = opt.param;
            yaw = obj.state.q(1);
            R = [cos(yaw),-sin(yaw);sin(yaw),cos(yaw)];
            angles= (0:0.01:2*pi)';
            circ = obj.margin*[cos(angles),sin(angles)];
            fh = figure(opt.FH);
            hold on
            if isempty(env)
                %obj.self.sensor.lrf.show();
                hold on
                local_rp =R'*obj.result.state.p(1:2)-obj.state.p(1:2);
                local_tp = obj.local_tp;
                angle= 0:0.1:2*pi;
                wp = obj.waypoint;
                plot(local_rp(1),local_rp(2),'ro');
                plot(local_tp(1)+circ(:,1),local_tp(2)+circ(:,2));
                plot(obj.goal(1)-obj.state.p(1),obj.goal(2)-obj.state.p(2),"ys");
            else
                plot(polyshape(env.param.Vertices),'FaceColor','g');
                hold on
                tmp = (R*(obj.self.sensor.result.sensor_points'))';
                points(1:2:2*size(tmp,1),:)=tmp;
                points = points + obj.state.p(1:2)';
%                 points = points + obj.state.q(3);
                plot(points(:,1),points(:,2),'r-');
                hold on; 
%                 text(points(1,1),points(1,2),'1','Color','b','FontSize',10);%センサインデックスの1を表示
                %plot(obj.self.sensor.result.region);
                %plot(obj.head_dir);
                plot(obj.state.p(1),obj.state.p(2),'b*');
                plot(obj.result.state.p(1),obj.result.state.p(2),'bo');%referenceの表示
%                 local_tp = R*obj.local_tp(1:2);
%                 plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));%接点を生成するための円
                plot(obj.goal(1),obj.goal(2),"ks","MarkerFaceColor",[0.5,0.5,0.5]);
                axis equal;
                writeAnimation('drone.gif')
            end

        end
    end
end
