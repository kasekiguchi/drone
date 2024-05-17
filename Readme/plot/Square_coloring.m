%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2017/1/28 Y.R ＆ T.I @ Univ.T
% Input : Xrange, color, Baseline, Yrange
%
% ## Need version after MATLAB 2015b ##
% 
% PX = [X1, X2];
% color : [red, green, blue], ex) 'm', 'c'
% PY = [Y1, Y2];
% Bace : Filled up above this value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Square_coloring(PX, color, PY, Bace ,ax)
arguments
  PX
  color = []
  PY = [];
  Bace = [];
  ax = [];
end
if isempty(ax)
  figure();
  ax = gca;
end
hold(ax,"on");

xlimit = get(ax, 'XLim');                                                  % デフォルトXレンジ設定
ylimit = get(ax, 'YLim');                                                  % デフォルトXレンジ設定
colordflt = [1.0 1.0 0.9];                                                  % デフォルト色：クリーム

margin = 0.002*(ylimit(2)-ylimit(1));                                       % 見栄えのためAreaの塗る範囲を少し削ります

if isempty(Bace), Bace = ylimit(1) + margin; end                                 % 以下，引数が足りない時に埋めます。
if isempty(PY), PY = [ylimit(2) - margin, ylimit(2) - margin]; end             % 本来の領域よりmargin=0.2%分縦に削って埋めています。
if isempty(color), color = colordflt; end                                         % 
if isempty(PX), PX = [xlimit(1), xlimit(2)]; end                               % 

Area_handle = area(ax,PX , PY, Bace,'FaceAlpha',0.5);                          % 塗る範囲([X_1 X_2],[y1 y2])
                                                                            % alpha値 0.5にします
hold(ax,"off");
set(Area_handle,'FaceColor', color);                                        % 塗りつぶし色
set(Area_handle,'LineStyle','none');                                        % 塗りつぶし部分に枠を描かない
set(Area_handle,'ShowBaseline','off');                                      % ベースラインの不可視化
set(ax,'layer','bottom');                                                  % gridを塗りつぶしの前面に出す
set(Area_handle.Annotation.LegendInformation, 'IconDisplayStyle','off');    % legendに入れないようにする
children_handle = get(ax, 'Children');                                     % Axisオブジェクトの子オブジェクトを取得
set(ax, 'Children', circshift(children_handle,[-1 0]));                    % 子オブジェクトの順番変更

set(ax,'Xlim',xlimit);							    % 表示の調整
set(ax,'Ylim',ylimit);							    %
end
