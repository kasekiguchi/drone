classdef DRAW_COOPERATIVE_DRONES
  % フレーム付きで動画を作成するためのクラス
  % obj = DRAW_DRONE_MOTION(logger,param)
  % obj.draw(p,q,u) : １スナップを描画
  % obj.animation(logger,param) : 動画描画
  % TODO : methodなど一般化して抽象化したほうが良いか？

  properties
    frame
    thrust
    ax
    xlim
    ylim
    zlim
    L
    frame_size = [0.33, 0.3];
    system_size = [1.5 1.5 1];
    rotor_r= 0.1;
    load
    target
    rho
    li
    N
  end

  methods
    function obj = DRAW_COOPERATIVE_DRONES(logger,varargin)
      param = struct(varargin{:});
      obj.target = param.target;
      obj.N = length(param.target);
      obj.rho = param.self.parameter.rho;
      obj.li = param.self.parameter.li;
      data = logger.data(1,"p","e");
      tM = max(data,1);
      tm = min(data,1);
      M = [max(tM(1:3:end)),max(tM(2:3:end)),max(tM(3:3:end))];
      m = [min(tm(1:3:end)),min(tm(2:3:end)),min(tm(3:3:end))];
      if isfield(param,'frame_size')
        L = param.frame_size;
      else
        L = obj.frame_size;
      end
      obj.L = L;
      S = obj.system_size;
      obj.xlim = [m(1)-S(1) M(1)+S(1)];
      obj.ylim = [m(2)-S(2) M(2)+S(2)];
      obj.zlim = [-S(3) M(3)+S(3)+1];
      if isfield(param,'ax')
        ax = param.ax;
      else
        figure();
        ax = axes('XLim',obj.xlim,'YLim',obj.ylim,'ZLim',obj.zlim);
        varargin = {varargin{:},'ax',ax};
      end
      obj=obj.gen_frame(varargin{:});
      obj=obj.gen_load(varargin{:},'cube',[sum(abs(obj.rho(1:3:end)))/2,sum(abs(obj.rho(2:3:end)))/2,sum(abs(obj.rho(3:3:end)))/2]);

      view(ax,3)
      grid(ax,'on')
      daspect(ax,[1 1 1]);
    end
    function obj=gen_frame(obj,varargin)%param)
      % arguments
      %     obj
      %     param.frame_size
      %     param.rotor_r
      %     param.target = 1;
      %     param.fig_num = 1;
      % end
      param = struct(varargin{:});
      % if class(param.fig_num)=="matlab.ui.Figure"
      %     obj.fig = param.fig_num;
      %     ax = obj.fig.CurrentAxes;
      % else
      %     obj.fig = figure(param.fig_num);
      %     ax = axes('XLim',obj.xlim,'YLim',obj.ylim,'ZLim',obj.zlim);
      % end
      obj.ax = param.ax;
      ax = obj.ax;
      xlabel(obj.ax,"x [m]");
      ylabel(ax,"y [m]");
      zlabel(ax,"z [m]");
      hold(ax,"on");

      L = obj.L;

      % rotor setup
      if isfield(param,'rotor_r')
        r = param.rotor_r;
      else
        r = obj.rotor_r;
      end
      [xr,yr,zr] = cylinder(ax,[0 r]); % rotor
      zr = 0.001*zr;

      % body setup
      [xb,yb,zb] = ellipsoid(ax,0,0,0, 1.2*L(1)/4, 0.8*L(2)/4, 0.02);
      d = L/2; % 重心からローター１の位置ベクトル
      rp = [d(1),d(2),0.02;-d(1),d(2),0.02;d(1),-d(2),0.02;-d(1),-d(2),0.02]; % relative rotor position
      c = ["red","green","blue","cyan",'#4DBEEE'];

      % arm setup
      [x,y,z] = cylinder(ax,0.01);
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
        % h(n,7) = trisurf([5 1 2;5 2 3; 5 3 4; 5 4 1], ...
        %   [0.02;0.02;0.02;0.02;4*1.2*L(1)/8], ...
        %   0.8*L(2)*[1;-1;-1;1;0]/6, ...
        %   0.01*[1;1;-1;-1;0],'FaceColor',c(5)); % 前を表す四角錐

        t(n) = hgtransform('Parent',ax); set(h(n,:),'Parent',t(n)); % ドローンを慣性座標と紐づけ
      end
      obj.frame = t;
      obj.thrust = tt;
      %            if param.animation
      %                obj.animation(logger,"realtime",true,"target",param.target,"gif",param.gif,"Motive_ref",param.Motive_ref,"fig_num",param.fig_num,"mp4",param.mp4);
      %            end
    end
    function obj=gen_load(obj,varargin)
      param = struct(varargin{:});
      ax = obj.ax;
      [x,y,z] = cylinder(ax,1,obj.N);
      z = z*param.cube(3)-param.cube(3)/2;
      h(1) = trisurf([1:obj.N;(1:obj.N)+obj.N+1],[x(1,:),x(2,:)],[y(1,:),y(2,:)],[z(1,:),z(2,:)],'FaceColor',"cyan");
      h(2) = surf(x,y,z);
      % a = param.cube(1)/2;
      % b = param.cube(2)/2;
      % c = param.cube(3)/2;
      % Points = [-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c];
      % Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
      % h = trisurf(triangulation(Tri,Points));
      ttt = hgtransform('Parent',ax); set(h,'Parent',ttt); % 推力を慣性座標と紐づけ
      obj.load = ttt;
    end
    function draw(obj,target,p0,q0,p,q,u,rho)
      % obj.draw(p,q,u)
      % p : 一ベクトル
      % q = [x,y,z,th] : 回転軸[x,y,z]にth回転
      % u (optional): 入力
      arguments
        obj
        target
        p0
        q0
        p
        q       
        u
        rho
      end

      for n = target
        frame = obj.frame(n);
        thrust = obj.thrust(n,:);
        % Rotation matrix
        R = makehgtform('axisrotate',q(1,1:3,n),q(1,4,n));
        % Translational matrix
        Txyz = makehgtform('translate',p(1,:,n));
        % Scaling matrix
         for i = 1:4
        %   if u(1,i,n) > 0
        %     S = makehgtform('scale',[1,1,u(1,i,n)]);
        %   elseif u(i) < 0
        %     S1 = makehgtform('xrotate',pi);
        %     S = makehgtform('scale',[1,1,-u(1,i,n)])*S1;
        %   else
        %     S = eye(4);
        %     S(3,3) = 1e-5;
        %   end
           set(thrust(i),'Matrix',Txyz*R);
         end
        % Concatenate the transforms and
        % set the transform Matrix property
        set(frame,'Matrix',Txyz*R);
        
        R0 = makehgtform('axisrotate',q0(1,1:3),q0(1,4));
        % Translational matrix
        Txyz0 = makehgtform('translate',p0);
        set(obj.load,'Matrix',Txyz0*R0);
      plot3([rho(1,1,n);p(1,1,n)],[rho(1,2,n);p(1,2,n)],[rho(1,3,n);p(1,3,n)]);
      end
      drawnow
    end
    function animation(obj,logger,varargin)
      % obj.animation(logger,param)
      % logger : LOGGER class instance
      % param.realtime (optional) : t-or-f : logger.data('t')を使うか
      % param.target = 1:4 描画するドローンのインデックス
      % "rotor_r",p.rotor_r;
      % arguments
      %   obj
      %   logger
      %   param.rotor_r
      %   param.self
      %   param.realtime = false;
      %   param.target = 1;
      %   param.gif = 0;
      %   param.Motive_ref = 0;
      %   param.fig_num = 1;
      %   param.mp4 = 0;
      %   param.frame_size = [];
      %   param.opt_plot = [];
      % end
      param = struct(varargin{:});
      ax = obj.ax;
      p = obj.data_format(logger,1,"p","p");
      q = obj.data_format(logger,1,"plant.result.state.Q","p");
      [Q,Q0] = obj.gen_Q(1,q);
      u = obj.data_format(logger,obj.target,"input","");% N x 4m
      r = obj.data_format(logger,1,"p","r");
      qi = obj.data_format(logger,obj.target,"plant.result.state.qi","p");
      Qit = obj.data_format(logger,obj.target,"plant.result.state.Qi","p");
      Qi = obj.gen_Q(obj.target,Qit);
      [pi,rho] = obj.gen_pi(p,Q0,qi);

      if isfield(param, "gif")
        sizen = 256;
        delaytime = 0;
        filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').gif'),':','_'),' ','_');
      end
      if isfield(param,'mp4')
        sizen = 256;
        delaytime = 0;
        filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').mp4'),':','_'),' ','_');
        v = VideoWriter(filename,"MPEG-4");
        if param.mp4
          open(v);
          writeAnimation(v);
        end
      end

      t = logger.data("t");
      tRealtime = tic;
      if isfield(param,'Motive_ref')
        for n = 1:length(param.target)
          f(n) = animatedline(ax,'Color','r','MaximumNumPoints',15); % 目標軌道の描画点の制限
        end
      end
      for i = 1:length(t)-1
        if isfield(param,'Motive_ref')
          addpoints(ax,f(n),r(i,1,param.target),r(i,2,param.target),r(i,3,param.target));
        else
          %plot3(ax,r(:,1,param.target),r(:,2,param.target),r(:,3,param.target),'k');
          plot3(ax,r(:,1),r(:,2),r(:,3),'k');
        end
        if isfield(param,"opt_plot")
          param.self.show(param.opt_plot,"logger",logger,"k",i,varargin{:});
        end
        if ~isvalid(obj.frame)
          obj=obj.gen_frame("target",param.target,"ax" ,ax);
        end
        obj.draw(param.target,p(i,:),Q(i,:),pi(i,:,param.target),Qi(i,:,param.target),u(i,:,param.target),rho(i,:,param.target));

        pause(0.01);
        if isfield(param,'gif')
          im = frame2im(getframe(obj.ax));
          [imind,cm] = rgb2ind(im,sizen);
          if i==1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',delaytime);
          else
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delaytime);
          end
        end
        if isfield(param,'mp4')
          framev = getframe(obj.ax);
          writeVideo(v,framev);
        end
      end
      if isfield(param,'mp4')
        close(v);
      end
    end
    function [pi,rho] = gen_pi(obj,p,Q,qi)
      % pi(k,:,i) = [xi yi zi] at time k
      Qrho = cell2mat(arrayfun(@(i) quat_times_vec(Q',obj.rho(:,i))',1:length(obj.target),'UniformOutput',false));
      q = repmat(p,1,length(obj.target))+Qrho;
      rho = reshape(q,size(q,1),size(q,2)/length(obj.target),length(obj.target)); % attachment point
      pi = rho - qi.*reshape(repmat(obj.li,3,1),1,[],length(obj.target));      
    end
    function D = data_format(obj,logger,target,var,att)
      % D = 3dim array : (time, var , target)
      q = logger.data(1,var,att);
      D = reshape(q,size(q,1),size(q,2)/length(target),length(target));      
    end
    function [Q,Q1] = gen_Q(obj,target,q)
      % Q : for hgtransform : unit euler angle + its norm
      % Qi : quaternion form
        Q = zeros(size(q,1),4,length(target));
       for n = 1:length(target)
        switch size(q(:,:,n),2)
          case 3
            Q1 = quaternion(Eul2Quat(q(:,:,n)')');%quaternion(q(:,:,n),'euler','XYZ','frame');
          case 4
            Q1 = quaternion(q(:,:,n));
          case 9
            Q1 = quaternion(q(:,:,n),'rotmat','frame');
        end         
        Q2 = rotvec(Q1);
        Q1 = compact(Q1);
        tmp = vecnorm(Q2,2,2);
        Q(:,:,n) = zeros(size(Q2,1),4);
        Q(tmp==0,:,n) = 0;
        Q(tmp==0,1,n) = 1;
        Q(tmp~=0,:,n) = [Q2(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];
      end
    end
  end
end