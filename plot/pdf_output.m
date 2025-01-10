clear
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../../')); % droneまでのフォルダパス
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

%%
% cd('../../../');
figure(5);
t = 0:0.1:10;
plot(t, cos(t));
xlabel('time'); ylabel('cos(t)');
daspect([1 1 1])
legend('cos', 'Location', 'best')
% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定
% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/output_figure_20.pdf', 'ContentType', 'vector', 'Resolution', 300);

i = 21;
filename = strcat('output_figure_', num2str(i), '.pdf');
exportgraphics(gcf, filename, 'ContentType', 'vector', 'Resolution', 300);