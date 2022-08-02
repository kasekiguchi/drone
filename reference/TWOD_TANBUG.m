classdef TWOD_TANBUG < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % 接点を通過点として障害物回避するプログラム
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        state %現在位置 
        sensor %センサ情報
        state_initial %初期位置
        goal %目標位置
        obstacle %障害物である端点
        radius %laserレンジ
        margin %通過してよいかの判断の閾値
        waypoint %通過点
        target_position %疑似目標位置
        forward %ドローンが向かう座標
        d %現在位置から目標位置までの距離
        angle %ドローンの姿勢角
        e_z %z方向のベクトル
        v_max %速度ベクトルの上限
        dtheta %目標角度とセンサが見ている角度の差
        target_angle 
        param
        self
        l_points
        g_points
        length
        pitch = 0.1 % laser間隔
        path_length
        threshold
        tid = 1;
        local_tp = [0;0;0];
    end

    methods
        function obj = TWOD_TANBUG(self, varargin)
            %obj.state = [0,0,0];

            obj.pitch = self.sensor.lrf.pitch;

            obj.sensor = [0,0];
            
            obj.state_initial = [0,0,0]';
            obj.goal = [5,0,0]';% global goal position
            obj.obstacle = [2,0,0]';
            obj.radius = self.sensor.lrf.radius;
            obj.margin = 0.5;
            obj.threshold = obj.margin*2;
            obj.d = 0;
            obj.waypoint.under = [0,0,0]';
            obj.waypoint.top = [0,0,0]';
            obj.target_position = [0,0,0]';
            obj.forward = [0,0,0]';
            obj.angle = 0;
            
            obj.self=self;
            obj.e_z = [0,0,1]';
            obj.v_max = 1.0;
            obj.target_angle = 0;
%             obj.result.state = STATE_CLASS(struct('state_list', ["xd","p","q"], 'num_list', [20, 3, 3]));     
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3, 3]));
         
            obj.path_length = zeros(size(self.sensor.lrf.angle_range));
            as = 0:obj.pitch:2*pi;
            obj.margin = obj.margin;
            tmp = find((obj.radius*sin(as) >= obj.margin).*(as <= pi/2));
            obj.path_length(tmp) = obj.margin./sin(as(tmp));
            obj.path_length(1:find(obj.path_length,1)-1) = obj.radius;
            
            tmp = find((obj.radius*sin(as) <= -obj.margin).*(as >= 3*pi/2));
            obj.path_length(tmp) = -obj.margin./sin(as(tmp));
            obj.path_length(find(obj.path_length,1,'last')+1:end) = obj.radius;
            %plot(obj.path_length.*cos(as),obj.path_length.*sin(as),"o");
            obj.margin = obj.margin;
        end
        
        function result = do(obj, t)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.state = obj.self.estimator.result.state; %自己位置
            yaw = obj.state.q(3);
            R = [cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
            obj.sensor = obj.self.sensor.result; %センサ情報
            obj.length = obj.sensor.length; % 距離データ
            obj.l_points = obj.sensor.sensor_points;
            l_goal = R'*(obj.goal-obj.state.p); % local でのゴール位置
            goal_length = vecnorm(l_goal); % ゴールまでの距離
            l_goal_angle = atan2(l_goal(2),l_goal(1));
            [~,id]=min(abs(obj.sensor.angle - l_goal_angle)); % goal に一番近いレーザーインデックス
            path_length = circshift(obj.path_length,id-1); % ゴールまでの間の仮想的な通路への距離
            path_length(path_length>goal_length)=goal_length;
            if find(obj.length < path_length) % ゴールまでの間に障害物がある場合                
                % edge_ids = 近い端点のindex配列
                nlength = circshift(obj.length,1);
                edge_ids = find(abs(nlength-obj.length) > obj.threshold);
                tmp = obj.length(edge_ids) > nlength(edge_ids);
                edge_ids(tmp) = edge_ids(tmp) - 1;
                edge_ids(edge_ids==0) = length(nlength);


                te_angle = obj.pitch*abs(edge_ids - id); % angle between target-edge
                [~,tmp] = min(obj.length(edge_ids).*(obj.length(edge_ids)-goal_length*cos(te_angle))); % target id
                % TODO : b + c > d + e  <==> b^2 + c^2 > d^2 + e^2 が成り立つ前提：要チェック
                tid = edge_ids(tmp);

                Length = [obj.length(end),obj.length,obj.length(1)];
                edge_p = obj.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];
                if Length(tid+2) > Length(tid) % 左回りで避ける
                    %tid = obj.width_check(tid,-1);
                    [~,~,tmp1,tmp2] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin);
                    obj.result.state.p = [tmp1;tmp2;0];
                    obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                else % 右回り
                    %tid = obj.width_check(tid,1);
                    [tmp1,tmp2,~,~] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin);
                    obj.result.state.p = [tmp1;tmp2;0];
                    obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                end
            obj.tid = tid;
            obj.local_tp = edge_p;
            else % まっすぐゴールに行ける場合
                obj.result.state.p = l_goal; % local座標での位置
                obj.result.state.v = [0;0;0]; % local座標での位置
            end

% 
%             % ここからglobal 座標での議論
%             obj.g_points = ([cos(yaw),-sin(yaw);sin(yaw),cos(yaw)]*obj.l_points')' + obj.state.p(1:2)'; % sensor points on global coord.
%             goal_angle = atan2((obj.goal(2) - obj.state.p(2)),(obj.goal(1) - obj.state.p(1))); %目標位置の角度
%             
%             for k=2:length(obj.sensor.angle)
%                 obj.dtheta = goal_angle - obj.sensor.angle(k - 1);%目標位置の角度との差の角度
%                 if abs(obj.dtheta) < 0.1
%                    L = obj.sensor.length(k - 1);%目標方向の測距距離
%                    sensor_index = k - 1;%目標位置方向にある障害物点
%                    break
%                 end
%             end
% %                                    
% %             anchor_R = sensor_index; %障害物点を右の端点とする
% %             anchor_L = sensor_index; %障害物点を左の端点とする
%             if( L < 2.5)%目標位置方向に障害物があるか
% %                 for k=2:length(obj.sensor.angle)
% %                 obj.dtheta = obj.angle - obj.sensor.angle(k - 1);
% %                     if abs(obj.dtheta) < 0.1
% %                         L = obj.sensor.length(k-1);%目標方向の測距距離
% %                        sensor_index = k - 1;%目標位置方向にある障害物点
% %                        break
% %                     end
% %                 end
%                                    
%                 anchor_R = sensor_index; %障害物点を右の端点とする
%                 anchor_L = sensor_index; %障害物点を左の端点とする
%                 %左右の端点の検出
%                 while(1) %右の端点を検出
%                     if anchor_R == 1
%                         anchor_R = 63;
%                     else
%                         obj.sensor.P_R = obj.sensor.sensor_points(anchor_R-1,:);
%                         obj.sensor.P_R = [obj.sensor.P_R';0];%wextend('1','zpd',obj.sensor.P_R, 1,'r');
%                         obj.sensor.P_index = obj.sensor.sensor_points(anchor_R,:);
%                         obj.sensor.P_index = [obj.sensor.P_index';0];%wextend('1','zpd',obj.sensor.P_index, 1,'r');
%                         length_right = norm(obj.sensor.P_index - obj.sensor.P_R); %正面とその右隣りの距離を算出
%                         %同一の物体として認識
%                         if length_right < 1
%                             anchor_R = anchor_R - 1;%右にずらす
%                         else
%                             obj.sensor.P_R = obj.sensor.P_index;
%                             break;
%                         end
%                     end
%                 end
%             
%                 while(1) %左の端点を検出
%                     if anchor_L == 63
%                         anchor_L = 1;
%                     else
%                         obj.sensor.P_index = obj.sensor.sensor_points(anchor_L,:);
%                         obj.sensor.P_index = [obj.sensor.P_index';0];%wextend('1','zpd',obj.sensor.P_index, 1,'r');
%                         obj.sensor.P_L = obj.sensor.sensor_points(anchor_L+1,:);
%                         obj.sensor.P_L = [obj.sensor.P_L';0];%wextend('1','zpd',obj.sensor.P_L, 1,'r');
%                         length_left = norm(obj.sensor.P_index - obj.sensor.P_L); %正面とその左隣りの距離を算出
%                         %同一の物体として認識
%                         if length_left < 1
%                             anchor_L = anchor_L + 1;%右にずらす
%                         else
%                             obj.sensor.P_L = obj.sensor.P_index;
%                             break;
%                         end
%                     end
%                 end
%                 
%                 %移動経路の決定
%                 length_state_anchor_R = norm(obj.state.p - obj.sensor.P_R); % 現在位置-anchor_R 距離
%                 length_state_anchor_L = norm(obj.state.p - obj.sensor.P_L); % 現在位置-anchor_L 距離
%                 length_anchor_goal_R = norm(obj.goal - obj.sensor.P_R); % 目標位置-anchor_R 距離
%                 length_anchor_goal_L = norm(obj.goal - obj.sensor.P_L); % 目標位置-anchor_L 距離
%                 route_R = length_state_anchor_R + length_anchor_goal_R; % 現在位置から目標位置までの経路（右）
%                 route_L = length_state_anchor_L + length_anchor_goal_L; % 現在位置から目標位置までの経路（左）
%                 
%                 if route_R < route_L %右のほうが短い
%                     [obj.waypoint.under(1),obj.waypoint.under(2),obj.waypoint.top(1),obj.waypoint.top(2)] = obj.conection(obj.state.p(1),obj.state.p(2),obj.sensor.P_R(1),obj.sensor.P_R(2),obj.margin);
%                     obj.target_position(1) = obj.waypoint.under(1);
%                     obj.target_position(2) = obj.waypoint.under(2); 
%                     obj.target_angle = atan2(obj.target_position(2),obj.target_position(1));
%                     obj.sensor.angle = obj.sensor.angle - obj.target_angle;
%                     x = obj.target_position(1);
%                     y = obj.target_position(2);
%                     obj.result.state.v = obj.velocity_vector(obj.state.p,obj.sensor.P_R,obj.target_position)';
%                     z = 0;
%                     obj.result.state.p = [x;y;z];% + obj.result.state.v/norm(obj.result.state.v)* 0.1;
%                     
%                 else %左の方が短い
%                     [obj.waypoint.under(1),obj.waypoint.under(2),obj.waypoint.top(1),obj.waypoint.top(2)] = obj.conection(obj.state.p(1),obj.state.p(2),obj.sensor.P_L(1),obj.sensor.P_L(2),obj.margin);
%                     obj.target_position(1) = obj.waypoint.top(1);
%                     obj.target_position(2) = obj.waypoint.top(2);  
%                     obj.target_angle = atan2(obj.target_position(2),obj.target_position(1));
%                     obj.sensor.angle = obj.sensor.angle - obj.target_angle;
%                     x = obj.target_position(1);
%                     y = obj.target_position(2);
%                     obj.result.state.v = obj.velocity_vector(obj.state.p,obj.sensor.P_L,obj.target_position);
% %                     obj.result.state.p = obj.result.state.v;
%                     z = 0;
%                     obj.result.state.p = [x;y;z];%obj.result.state.v/norm(obj.result.state.v)* 0.1+ [x;y;z];
%                 end
%                 
%             else %前方に障害物がない
%                 x = obj.goal(1);
%                 y = obj.goal(2);
%                 z = 0;
%                 obj.result.state.p = [x;y;z];
%             end

            % local から global に変換
            obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
            obj.result.state.v = R*obj.result.state.v;
            %             L = obj.distance2(obj.state.p',obj.goal,obj.obstacle);
%            yaw = obj.angle;           
%            obj.result.state.v = obj.velocity_vector(obj.state.p,obj.obstacle,obj.target_position)       
%            obj.result.state.p = [x;y;z];
%            obj.result.state.p = obj.result.state.v;
%            obj.result.state.q = obj.angle;
%            obj.result.state.xd = [x;y;z];
%            obj.result.state.p = obj.result.state.xd;
%            obj.result.state.p = obj.result.state.v/norm(obj.result.state.v)* 0.1+ [x:y;z];
%            obj.result.state.q = [0;0;0];
%            obj.result.state.q = obj.angle;
           result = obj.result;     
        end
        
        function d = distance(~,x1,y1,x2,y2) %2点間の距離を算出
            a = [x1,y1];
            b = [x2,y2];
            d = norm(b - a);
        end      
        
        function position = transformation(~,Dx,Dy,Dyaw,Ax,Ay) %端点座標をドローン座標に変換
            % Dx,Dy:ドローンの自己位置
            % Ax,Ay:障害物の座標
            % Dyaw: ドローンの角度
            x = Ax * cos(Dyaw) - Ay * sin(Dyaw) + Dx;
            y = Ax * sin(Dyaw) + Ay * cos(Dyaw) + Dy;
            position = [x,y];
        end
        
        function d = distance2(~,Q_1,Q_2,P)
            % Q_1自己位置
            % Q_2目標位置
            % P 円の中心
            d = abs(det([Q_2(1:2) - Q_1(1:2);P(1:2) - Q_1(1:2)])/norm(Q_2 - Q_1));
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
            A_x = real(((a*D - b*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + X);
            A_y = real(((b*D + a*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + Y);
            B_x = real(((a*D + b*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + X);
            B_y = real(((b*D - a*sqrt((a^2 + b^2)*obj.margin^2 - D^2))/(a^2 + b^2)) + Y);
%             contact = [A_x,A_y,B_x,B_y];            
        end
        
        function v = velocity_vector(obj,x,y,P)
            % x:ドローンの現在位置
            % y:障害物点の座標
            % P:疑似目標位置
            T = y - x;
            P_r = P - x;
            N = P_r - T;
            t = cross(N,obj.e_z);
            o = (obj.v_max/obj.margin);
            v = t*o;
            
        end
%         function id = width_check(obj,tid,sign)
%             obj.tid
%         end


        function show(obj,env)
            arguments
                obj
                env=[]
            end
            yaw = obj.state.q(3);
            R = [cos(yaw),-sin(yaw);sin(yaw),cos(yaw)];
            angles= (0:0.01:2*pi)';
            circ = obj.margin*[cos(angles),sin(angles)];
            if isempty(env)
                obj.self.sensor.lrf.show();
                hold on
                local_rp =R'*obj.result.state.p(1:2)-obj.state.p(1:2);
                local_tp = obj.local_tp;
                angle= 0:0.1:2*pi;
                wp = obj.waypoint;
                plot(local_rp(1),local_rp(2),'ro');
                plot(local_tp(1)+circ(:,1),local_tp(2)+circ(:,2));
                plot(obj.goal(1)-obj.state.p(1),obj.goal(2)-obj.state.p(2),"ys");
            else
                plot(polyshape(env.param.Vertices));
                hold on
                tmp = (R*(obj.self.sensor.result.sensor_points'))';
                points(1:2:2*size(tmp,1),:)=tmp;
                points = points + obj.state.p(1:2)';
                plot(points(:,1),points(:,2),'r-');
                hold on; 
                text(points(1,1),points(1,2),'1','Color','b','FontSize',10);
                %plot(obj.self.sensor.result.region);
                %plot(obj.head_dir);
                plot(obj.state.p(1),obj.state.p(2),'b*');
                plot(obj.result.state.p(1),obj.result.state.p(2),'go');
                local_tp = R*obj.local_tp(1:2);
                plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));
                plot(obj.goal(1),obj.goal(2),"ys");
                axis equal;
            end

        end
    end
end
