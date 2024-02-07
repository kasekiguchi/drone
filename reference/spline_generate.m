%% スプライン補完の軌道を生成
% 位置、速度、加速度
x = 0:0.5:4;
% y = [2 2 2 0.9 0.1 0.2 0.3 0.4 0.5];
y = [2 2 2 0.9 0.1 0 0 0 0];
xq1 = 0:0.025:4;
% m = makima(x,y,xq1);
% vm = [diff(data.ref.spline.p), 0];
% vvm = [diff(data.ref.spline.v), 0, 0];

data.ref.spline.p = makima(x,y,xq1);
data.ref.spline.v = [diff(data.ref.spline.p), 0];
data.ref.spline.a = [diff(data.ref.spline.v), 0];

%%-- 確認用
figure(1);
m = data.ref.spline.p;
vm = data.ref.spline.v;
vvm = data.ref.spline.a;
subplot(3,1,1); plot(x, y, 'o', xq1, m, '--'); legend("points", "pos");
subplot(3,1,2); plot(xq1, vm); legend("vel");
subplot(3,1,3); plot(xq1, vvm); legend("acc")