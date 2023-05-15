% A = rand(3,1); %randは0-1の範囲で乱数を生成
% B = randi([-1000,1000],3,1)*0.001;
% C = randi([-10,10],4,1)*0.001;
% D = load('D:\workspace\GitHub\drone\drone-isobe2022\drone-isobe2022\Data\simData_KoopmanApproach_2023_5_9_newdata\simtest_2.mat');
% E = logger
% mkdir /drone-isobe2022 newFolder
% w = rand(3,1)*0.02-0.01
% p = rand(3,1)*6-3
p = rand(3,1)*6-3 % rand(3,1)*0.02で生成範囲を0~0.02に変更、後ろのマイナスで-0.01~0.01にしてる(イメージ:0-0.01 ~ 0.02-0.01)
% p(3,1) = rand*8-4
