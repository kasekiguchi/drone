classdef DRAW_DRONE_MOTION
    % フレーム付きで動画を作成するためのクラス
    % obj = DRAW_DRONE_MOTION(logger,param)
    % obj.draw(p,q,u) : １スナップを描画
    % obj.animation(logger,param) : 動画描画
    % TODO : methodなど一般化して抽象化したほうが良いか？

    properties
        frame
        thrust
        fig
    end

    methods
        function obj = DRAW_DRONE_MOTION(logger,param)
            % 【usage】 obj = DRAW_DRONE_MOTION(logger,param)
            % logger : LOGGER class instance
            % param.frame_size : drone size [lx,ly]
            % param.rotor_r : rotor radius r
            % param.plot_ref : reference plot true or not
            arguments
                logger
                param.frame_size
                param.rotor_r
                param.plot_ref = true;
                param.animation = false;
            end
            data = logger.data(1,"p","e");
            M = max(data);
            m = min(data);
            L = param.frame_size;
            figure();
            ax = axes('XLim',[m(1)-L(1) M(1)+L(1)],'YLim',[m(2)-L(2) M(2)+L(2)],'ZLim',[0 M(3)+1]);
            obj.fig = ax;

            view(3)
            grid on
            daspect([1 1 1]);
            hold on

            r = param.rotor_r;
            [x,y,z] = cylinder([0 r]);
            z = 0.001*z;
            [xb,yb,zb] = ellipsoid(0,0,0, 1.2*L(1)/4, 0.8*L(2)/4, 0.02);
            d = L/2; % 重心からローター１の位置ベクトル
            rp = [d(1),d(2),0.02;-d(1),d(2),0.02;d(1),-d(2),0.02;-d(1),-d(2),0.02]; % relative rotor position
            c = ["red","green","blue","cyan",'#4DBEEE'];
            for i = 1:4
                h(i) = surface(ax,x+rp(i,1),y+rp(i,2),z+rp(i,3),'FaceColor',c(i)); % rotor 描画
                T(i) = quiver3(ax,rp(i,1),rp(i,2),rp(i,3),0,0,1,'FaceColor',c(i)); % 推力ベクトル描画
                tt(i) = hgtransform('Parent',ax); set(T(i),'Parent',tt(i)); % 推力を慣性座標と紐づけ
            end
            % アーム部
            [x,y,z] = cylinder(0.01);
            z = z*vecnorm(d)*2;
            R1 = rotmat(quaternion([1,1,0]*pi/(2*sqrt(2)),"rotvec"),'frame');
            R2 = rotmat(quaternion([-1,1,0]*pi/(2*sqrt(2)),"rotvec"),'frame');
            F1 = [R1*[x(1,:);y(1,:);z(1,:)];R1*[x(2,:);y(2,:);z(2,:)]]+[d(1);-d(2);0;d(1);-d(2);0];
            F2 = [R2*[x(1,:);y(1,:);z(1,:)];R2*[x(2,:);y(2,:);z(2,:)]]+[d(1);d(2);0;d(1);d(2);0];
            h(5) = surface(ax,[F1(1,:);F1(4,:);NaN(1,size(F1,2));F2(1,:);F2(4,:)], ...
                [F1(2,:);F1(5,:);NaN(1,size(F1,2));F2(2,:);F2(5,:)], ...
                [F1(3,:);F1(6,:);NaN(1,size(F1,2));F2(3,:);F2(6,:)],'FaceColor',c(5)); % アーム部
            h(6) = surface(ax,xb,yb,zb,'FaceColor',c(5)); % ボディ楕円体
            h(7) = trisurf([5 1 2;5 2 3; 5 3 4; 5 4 1], ...
                [0.02;0.02;0.02;0.02;4*1.2*L(1)/8], ...
                0.8*L(2)*[1;-1;-1;1;0]/6, ...
                0.01*[1;1;-1;-1;0],'FaceColor',c(5)); % 前を表す四角錐

            t = hgtransform('Parent',ax); set(h,'Parent',t); % ドローンを慣性座標と紐づけ
            obj.frame = t;
            obj.thrust = tt;
            if param.animation
                obj.animation(logger,"realtime",true);
            end
        end

        function draw(obj,p,q,u)
            % obj.draw(p,q,u)
            % p : 一ベクトル
            % q = [x,y,z,th] : 回転軸[x,y,z]にth回転
            % u (optional): 入力
            arguments
                obj
                p
                q
                u = [1;1;1;1];
            end

            % Rotation matrix
            R = makehgtform('axisrotate',q(1:3),q(4));
            % Translational matrix
            Txyz = makehgtform('translate',p);
            % Scaling matrix
            for i = 1:4
                if u(i) > 0
                    S = makehgtform('scale',[1,1,u(i)]);
                elseif u(i) < 0
                    S1 = makehgtform('xrotate',pi);
                    S = makehgtform('scale',[1,1,-u(i)])*S1;
                else
                    S = zeros(4);
                end
                set(obj.thrust(i),'Matrix',Txyz*R*S);
            end
            % Concatenate the transforms and
            % set the transform Matrix property
            set(obj.frame,'Matrix',Txyz*R);
            drawnow
        end
        function animation(obj,logger,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            arguments
                obj
                logger
                param.realtime = false;
            end
            p = logger.data(1,"p","e");
            q = logger.data(1,"q","e");
            u = logger.data(1,"input");
            r = logger.data(1,"p","r");
            switch size(q,2)
                case 3
                    q = quaternion(q,'euler','ZYX','frame');
                case 4
                    q = quaternion(q);
                case 9
                    q = quaternion(q,'rotmat','frame');
            end
            q = rotvec(q);
            tmp = vecnorm(q,2,2);
            Q = zeros(size(q,1),4);
            Q(tmp==0,:) = 0;
            Q(tmp==0,1) = 1;
            Q(tmp~=0,:) = [q(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];

            t = logger.data("t");
            for i = 1:length(t)-1
                plot3(r(:,1),r(:,2),r(:,3),'k');
                obj.draw(p(i,:),Q(i,:),u(i,:));
                if param.realtime
                    pause(t(i+1)-t(i));
                else
                    pause(0.1);
                end
            end
        end
    end
end