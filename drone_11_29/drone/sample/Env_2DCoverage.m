function env = Env_2DCoverage()
% d : grid 間隔
% q : 重要点の位置
% Vertices : 全領域のサイズ : 一筆書きで反時計回りになるように左下から並べる．
%% environment class demo
% env property をEnv classのインスタンス配列として定義
env.d = 1;
%env.q	= [60 50;50 60;25 25];%テスト単体用
env.q	= [9 74;13 72;13 77;25 45;31 36;32 31;35 38;36 25;40 28;42 24;44 20;49 25;50 28;52 20;54 23;77 88;83 81;84 73;85 78;89 86];%重要点位置
env.Vertices=[-10 -20;100 -20;100 100;-10 100];
%env.q = env.q/10;
%env.Vertices = env.Vertices/10;

% 小さい領域
env.d = 0.1;
env.q	= [1 0;2, 1;4 -2];
env.Vertices=[-2 -2.5;5.5 -2.5;5.5 3;-2 3]; 

in = inpolygon(env.q(:,1),env.q(:,2),env.Vertices(:,1),env.Vertices(:,2));
if prod(in) == 0
    warning("ACSL : query points are not in the region.")
end
end
