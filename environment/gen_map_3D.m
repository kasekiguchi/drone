function [outputArg1,outputArg2] = gen_map_3D(inputArg1,inputArg2)
% Vertex : 対象領域
% d : グリッド幅
% q : 重要度の位置 [xi yi zi] を縦に並べる
% sigma : 正規分布の分散の逆数　dでスケールされる
% map : 実スケールマップ
% grid : 行列マップ  grid(1,1)=map(0,0),  grid(end,1)=map(map_max(1),1)
% グラフ表示するときに工夫する
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end