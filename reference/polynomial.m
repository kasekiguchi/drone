%% polynomial を生成するファイル
%-- 終端速度：＋上昇する形で終了
z0 = initial.p(3); % z初期値
ze = 0.4; % z収束値 -0.5
v0 = -0.2; % 初期速度
ve = 0.5; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1

Time.delay = 3; % かける時間 : 2sで落下＋移動
t = 0:0.025:Time.delay+1;
data.ref.Z = curve_interpolation_9order(t',Time.delay,z0,v0,ze,ve);

x0 = initial.p(1); % -1
xe = 0;
v0 = 0;
ve = 0;
% teref = 1.5;
delay = 0;
data.ref.X = curve_interpolation_9order(t'-delay,Time.delay,x0,v0,xe,ve);

v0 = 0;
y0 = initial.p(2);
ye = 0;
data.ref.Y = curve_interpolation_9order(t',Time.delay,y0,v0,ye,ve);

% plot
figure(101); 
subplot(2,1,1); plot(t', [data.ref.X(:,1), data.ref.Y(:,1), data.ref.Z(:,1)]); 
legend("x", "y", "z"); grid on; xlim([0 Time.delay]);
subplot(2,1,2); plot(t', [data.ref.X(:,2), data.ref.Y(:,2), data.ref.Z(:,2)]); 
legend("vx", "vy", "vz"); grid on; xlim([0 Time.delay]);