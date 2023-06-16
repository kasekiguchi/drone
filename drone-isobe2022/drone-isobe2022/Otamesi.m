opengl software
close all hidden;
% A = rand(3,1); %randは0-1の範囲で乱数を生成
% B = randi([-1000,1000],3,1)*0.001;
% C = randi([-10,10],4,1)*0.001;
% D = load('D:\workspace\GitHub\drone\drone-isobe2022\drone-isobe2022\Data\simData_KoopmanApproach_2023_5_9_newdata\simtest_2.mat');
% E = logger
% mkdir /drone-isobe2022 newFolder
% w = rand(3,1)*0.02-0.01
% p = rand(3,1)*6-3
% p = rand(3,1)*6-3 % rand(3,1)*0.02で生成範囲を0~0.02に変更、後ろのマイナスで-0.01~0.01にしてる(イメージ:0-0.01 ~ 0.02-0.01)
% p(3,1) = rand*8-4
% [n,p] = size('6_2_experiment_1.mat');
% file{1, 1}.Data.X.plot({1, "p", "es"}, {1, "q", "e"}, {1, "v", "e"}, {1, "input", ""},{1,"p1-p2","e"},{1,"p1-p2-p3","e"}, "fig_num", 5, "row_col", [2, 3]);
% rmfield(agent.id,"test")
% rmfield(agent.id,"i")
% agent.id.filename  = 1;
%% 3次元グラフの作成
% for i = 1:stepN
% x(1,1:stepN) = file{i}.simResult.reference.est.p(1,1:stepN);
% y(1,1:stepN) = file{i}.simResult.reference.est.p(2,1:stepN);
% z(1,1:stepN)  = file{i}.simResult.reference.est.p(3,1:stepN);
% end

% figure;
% plot3(x,y,z,'b.-');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('3D Plot');
% 
% 
% grid on;
% view(45,30);
%% 
array = [0, 0, 0, 5, 0, 7];  % 例として配列を定義

nonZeroIndex = find(array ~= 0, 1)

