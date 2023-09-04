% Figureを作成して保存する
mkdir('test')
for i = 1:10
    % Figureを作成
    x = linspace(0, 2*pi, 100);
    y = sin(x);
    figure;
    plot(x, y);
    title(['サンプルプロット ', num2str(i)]);
    xlabel('X軸');
    ylabel('Y軸');
end

% すべてのFigureを指定のフォルダに一括保存
savepath = 'test'; % 保存するディレクトリを指定
for i = 1:10
    % FigureをPNGフォーマットで保存
    saveas(i, fullfile(savepath, ['sample_plot_', num2str(i), '.png']));
end

% すべてのFigureを閉じる
% close all;
