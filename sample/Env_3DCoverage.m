function env = Env_3DCoverage()
%3次元環境生成クラス用の関数
% d : grid間距離
% q : 重要点の位置
% Vertices : 立方領域全体の頂点
% min : 任意立方領域の最小値
% max : 任意立方領域の最大値
%% enviroment class demo
% env propertyをEnv classのインスタンス配列として定義
env.d = 0.05;
env.Vertices = -6*[1,1,1]+ 12*[0,0,0;0,1,0;1,0,0;1,1,0;0,0,1;0,1,1;1,0,1;1,1,1];
env.min = -2;
env.max = 2;
end

