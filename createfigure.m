function createfigure(X1, Y1, X2, Y2)
%CREATEFIGURE(X1, Y1, X2, Y2)
%  X1:  plot x データのベクトル
%  Y1:  plot y データのベクトル
%  X2:  plot x データのベクトル
%  Y2:  plot y データのベクトル

%  MATLAB からの自動生成日: 24-Jan-2023 12:03:07

% figure を作成
figure('OuterPosition',[935 163 963 877]);

% axes を作成
axes1 = axes;
hold(axes1,'on');

% plot を作成
plot(X1,Y1,'DisplayName','Reference','LineWidth',3);

% plot を作成
plot(X2,Y2,'DisplayName','Towed object','LineWidth',3);

% ylabel を作成
ylabel({'$y$ [m]'},'Interpreter','latex');

% xlabel を作成
xlabel({'$x$ [m]'},'Interpreter','latex');

% Axes の X 軸の範囲を保持するために以下のラインのコメントを解除
% xlim(axes1,[-2 2]);
% Axes の Y 軸の範囲を保持するために以下のラインのコメントを解除
% ylim(axes1,[-2 2]);
box(axes1,'on');
grid(axes1,'on');
axis(axes1,'square');
hold(axes1,'off');
% 残りの座標軸プロパティの設定
set(axes1,'FontSize',21);
% legend を作成
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','latex','EdgeColor','none');

