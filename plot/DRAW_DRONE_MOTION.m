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
            % param.frame_size : drone size [Lx,Ly]
            % param.rotor_r : rotor radius r
            % param.plot_ref : reference plot true or not
            arguments
                logger
                param.frame_size
                param.rotor_r
                param.plot_ref = true;
                param.animation = false;
                param.target = 1;
            end
            data = logger.data(param.target,"p","e");
            tM = max(data);
            tm = min(data);
            M = [max(tM(1:3:end)),max(tM(2:3:end)),max(tM(3:3:end))];
            m = [min(tm(1:3:end)),min(tm(2:3:end)),min(tm(3:3:end))];
            L = param.frame_size;
            figure();   disp("Press Enter key to start video");   pause();
            ax = axes('XLim',[m(1)-L(1) M(1)+L(1)],'YLim',[m(2)-L(2) M(2)+L(2)],'ZLim',[0 M(3)+1]);
            xlabel(ax,"x [m]");
            ylabel(ax,"y [m]");
            zlabel(ax,"z [m]");
            obj.fig = ax;

            view(360, 0)
%             view(3)
            grid on
            daspect([1 1 1]);
            hold on
            xx = -5:5;
            yy = zeros(1, size(xx, 2));
            zz = 3/10 * xx+0.1;
            plot3(xx, yy, zz);
            

            % rotor setup
            r = param.rotor_r;
            [xr,yr,zr] = cylinder([0 r]); % rotor
            zr = 0.001*zr;

            % body setup
            [xb,yb,zb] = ellipsoid(0,0,0, 1.2*L(1)/4, 0.8*L(2)/4, 0.02);
            d = L/2; % 重心からローター１の位置ベクトル
            rp = [d(1),d(2),0.02;-d(1),d(2),0.02;d(1),-d(2),0.02;-d(1),-d(2),0.02]; % relative rotor position
            c = ["red","green","blue","cyan",'#4DBEEE'];

            % arm setup
            [x,y,z] = cylinder(0.01);
            z = z*vecnorm(d)*2;
            R1 = rotmat(quaternion([L(2),-L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
            R2 = rotmat(quaternion([L(2),L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
            F1 = [R1*[x(1,:);y(1,:);z(1,:)];R1*[x(2,:);y(2,:);z(2,:)]]+[d(1);d(2);0;d(1);d(2);0];
            F2 = [R2*[x(1,:);y(1,:);z(1,:)];R2*[x(2,:);y(2,:);z(2,:)]]+[-d(1);d(2);0;-d(1);d(2);0];
            for n = param.target
                for i = 4:-1:1
                    h(n,i) = surface(ax,xr+rp(i,1),yr+rp(i,2),zr+rp(i,3),'FaceColor',c(i)); % rotor 描画
                    T(n,i) = quiver3(ax,rp(i,1),rp(i,2),rp(i,3),0,0,1,'FaceColor',c(i)); % 推力ベクトル描画
                    tt(n,i) = hgtransform('Parent',ax); set(T(n,i),'Parent',tt(n,i)); % 推力を慣性座標と紐づけ
                end
                h(n,5) = surface(ax,[F1(1,:);F1(4,:);NaN(1,size(F1,2));F2(1,:);F2(4,:)], ...
                    [F1(2,:);F1(5,:);NaN(1,size(F1,2));F2(2,:);F2(5,:)], ...
                    [F1(3,:);F1(6,:);NaN(1,size(F1,2));F2(3,:);F2(6,:)],'FaceColor',c(5)); % アーム部
                h(n,6) = surface(ax,xb,yb,zb,'FaceColor',c(5)); % ボディ楕円体
                h(n,7) = trisurf([5 1 2;5 2 3; 5 3 4; 5 4 1], ...
                    [0.02;0.02;0.02;0.02;4*1.2*L(1)/8], ...
                    0.8*L(2)*[1;-1;-1;1;0]/6, ...
                    0.01*[1;1;-1;-1;0],'FaceColor',c(5)); % 前を表す四角錐

                t(n) = hgtransform('Parent',ax); set(h(n,:),'Parent',t(n)); % ドローンを慣性座標と紐づけ
            end
            obj.frame = t;
            obj.thrust = tt;
            if param.animation
                obj.animation(logger,"realtime",true,"target",param.target);
            end
        end

        function draw(obj,frame,thrust,p,q,u)
            % obj.draw(p,q,u)
            % p : 一ベクトル
            % q = [x,y,z,th] : 回転軸[x,y,z]にth回転
            % u (optional): 入力
            arguments
                obj
                frame
                thrust
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
                    S = eye(4);
                    S(3,3) = 1e-5;
                end
                set(thrust(i),'Matrix',Txyz*R*S);
            end
            % Concatenate the transforms and
            % set the transform Matrix property
            set(frame,'Matrix',Txyz*R);
            drawnow
        end
        function animation(obj,logger,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            arguments
                obj
                logger
                param.realtime = false;
                param.target = 1;
                param.gif = 0;
            end

            p = logger.data(param.target,"p","e");
            q = logger.data(param.target,"q","e");
            u = logger.data(param.target,"input");
            r = logger.data(param.target,"p","r");
            p = reshape(p,size(p,1),3,length(param.target));
            q = reshape(q,size(q,1),size(q,2)/length(param.target),length(param.target));
            u = reshape(u,size(u,1),4,length(param.target));
            r = reshape(r,size(r,1),3,length(param.target));
            for n = 1:length(param.target)
                switch size(q(:,:,n),2)
                    case 3
                        Q1 = quaternion(q(:,:,n),'euler','XYZ','frame');
                    case 4
                        Q1 = quaternion(q(:,:,n));
                    case 9
                        Q1 = quaternion(q(:,:,n),'rotmat','frame');
                end
                Q1 = rotvec(Q1);
                tmp = vecnorm(Q1,2,2);
                Q(:,:,n) = zeros(size(Q1,1),4);
                Q(tmp==0,:,n) = 0;
                Q(tmp==0,1,n) = 1;
                Q(tmp~=0,:,n) = [Q1(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];
            end

            if param.gif
                sizen = 256;
                delaytime = 0;
                filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').gif'),':','_'),' ','_');
            end

            t = logger.data("t");
            tRealtime = tic;
            for i = 1:length(t)-1
                for n = 1:length(param.target)
                    plot3(r(:,1,n),r(:,2,n),r(:,3,n),'k');
                    obj.draw(obj.frame(param.target(n)),obj.thrust(param.target(n),:),p(i,:,n),Q(i,:,n),u(i,:,n));
                end
                if param.realtime
                    delta = toc(tRealtime);
                    if t(i+1)-t(i) > delta
                        pause(t(i+1)-t(i) - delta);
                    end
                    tRealtime = tic;
                else
                    pause(0.01);
                end
                if param.gif
                    im = frame2im(getframe(obj.fig));
                    [imind,cm] = rgb2ind(im,sizen);
                    if i==1
                        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',delaytime);
                    else
                        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delaytime);
                    end
                end
            end
        end
    end
end