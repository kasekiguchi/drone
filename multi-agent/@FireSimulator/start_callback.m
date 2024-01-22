function start_callback(app,event)
value = app.StartButton.Text;
if strcmp(value,"Start")
  Il = app.map.ti;
  nx = app.map.nx;
  ny = app.map.ny;
  unum = app.unum;
  step_end = app.step_end;
  N = nx*ny;

  init_fx = app.outbreak(:,1);
  init_fy = app.outbreak(:,2);
  init_I = sparse(N,1);
  r=randi(1,numel(init_fx),numel(init_fy));
  W_vec = reshape(app.map.W,N,1);
  W_vec2 = logical(mod(W_vec,0));     %W_vecを0と1のみのlogical値に変換．これをしないと初期引火点が何時までも消火しない
  init_I(ny*(init_fx-1)+init_fy) = 1.*W_vec2(ny*(init_fx-1)+init_fy);
  init_R = sparse(N,1);
  app.map.initialize_each_grid(init_I,init_R);
  app.logger.k=zeros(1,step_end);
  app.logger.S(:,1) = app.map.S(:);
  app.logger.I(:,1) = app.map.I(:);
  app.logger.R(:,1) = app.map.R(:);
  app.logger.U(:,1) = app.map.U(:);
  app.logger.P = sparse(N,step_end);
  p = app.map.arranged_position([nx,ny],unum,2,0);
  p = (p(1,:)'-1)*ny + p(2,:)';% init position indices
  pt = zeros(unum,1);
  k = 1;
  X = app.map.W;
  Xm = min(app.map.W,[],'all');
  XM = max(app.map.W,[],'all');
  while (k <= step_end) && sum(find(app.map.I))
    app.TimeSlider.Value = k;
    app.TimeSliderLabel.Text = "k : " + k;
    wi = app.map.wind_time(k);
    app.map.draw_state(app.map,app.UIAxes);
    delete(app.NorthWindDir.Children);
    vx = [app.map.wind(wi,2)*cos(app.map.wind(wi,1));10*cos(app.map.shape_opts.north_dir)];
    vy = [app.map.wind(wi,2)*sin(app.map.wind(wi,1));10*sin(app.map.shape_opts.north_dir)];
    compass(app.NorthWindDir,vx,vy);
    app.NorthWindDir.Children(1).LineWidth = 2;
    app.NorthWindDir.Children(1).Color = 'b';
    app.NorthWindDir.Children(2).LineWidth = 2;
    app.NorthWindDir.Children(2).Color = 'r';
    view(app.NorthWindDir,-90,90);
    pause(0.001);
    E = app.map.EF{wi} + app.map.ES{wi};
    fi= find(app.map.I);% 燃えているマップのインデックス
    tmpX = X(fi)+(Il-app.map.I(fi));% 燃えているマップの重要度：X = V, Wどちらでも縦ベクトルになる．

    % target point t 選択：重要度の高い順にtunum個選択
    tunum = min(unum,length(fi));
    u = zeros(tunum,1);% extinguish input indices
    for iu=1:tunum
      [~,I]= max(tmpX);
      u(iu) = fi(I);%
      tmpX(I)=Xm;% 選択済みのものを最低rankに設定
    end
    U = sparse(u,1,1,N,1);

    app.map.next_step_func(U,wi);% obj 更新
    % log
    app.logger.k(k)=k;
    app.logger.S(:,k) = app.map.S(:);
    app.logger.I(:,k) = app.map.I(:);
    app.logger.R(:,k) = app.map.R(:);
    app.logger.U(:,k) = app.map.U(:);
    app.logger.UF(:,k) = app.map.vf(:); % 飛び火の発生回数の保存 Logger(i).UFで確認
    k = k+1;

    if k == 9
      unum = unum + 16;
    elseif k == 25
      unum = unum + 7;
    elseif k == 33
      unum = unum + 19;
    elseif  k == 42
      unum = unum + 4;
    elseif  k == 69
      unum = unum + 3;
    elseif  k == 120
      unum = unum + 12;
    end
  end
end
end