% Params.Weight.P = diag([90.0; 90.0; 1.0]);    % 座標   1000 10
% Params.Weight.V = diag([90.0; 90.0; 110.0]);    % 速度
% Params.Weight.R = diag([1.0; 1.0; 1.0; 1.0]); % 入力
% Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
% Params.Weight.QW = diag([2000; 2200; 1700; 1; 1; 1]);  % 姿勢角、角速度
% Params.Weight.Pf = diag([300; 300; 1]);
% Params.Weight.Vf = diag([170; 170; 200]);
% Params.Weight.QWf = diag([4500; 5000; 2000; 1; 1; 1]);

% Params.Weight.P = diag([90.0; 90.0; 0]);    % 座標   1000 10
% Params.Weight.V = diag([50.0; 50.0; 1]);    % 速度
% Params.Weight.R = 1e2 * diag([1.0; 1.0; 1.0; 1.0]); % 入力
% Params.Weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
% Params.Weight.QW = diag([2100; 2100; 500; 10; 10; 300]);  % 姿勢角、角速度
% Params.Weight.Pf = Params.Weight.P;
% Params.Weight.Vf = Params.Weight.V;
% Params.Weight.QWf = Params.Weight.QW; %姿勢角、角速度終端

%-- ホバリングかなりいいやつ
% Params.Weight.P = diag([77.0; 37.0; 0]);    % 座標   1000 10
% Params.Weight.V = diag([15.0; 22.0; 1]);    % 速度
% Params.Weight.R = diag([1.0; 1.0; 1.0; 1.0]); % 入力
% Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
% Params.Weight.QW = diag([984; 797; 561; 9; 1; 70]);  % 姿勢角、角速度
% Params.Weight.Pf = diag([73; 209; 0]);
% Params.Weight.Vf = diag([96; 80; 257]);
% Params.Weight.QWf = diag([367; 1777; 420; 2; 1; 133]); %姿勢角、角速度終端


Params.Weight.P = diag([1000.0; 1000.0; 10]);    % 座標   1000 10
Params.Weight.V = diag([1000; 1000; 100]);    % 速度
Params.Weight.R = diag([1.0; 1.0; 1.0; 1.0]); % 入力
Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
Params.Weight.QW = diag([1000; 1000; 1000; 1; 1; 1]);  % 姿勢角、角速度
Params.Weight.Pf = Params.Weight.P;
Params.Weight.Vf = Params.Weight.V;
Params.Weight.QWf = Params.Weight.QW; %姿勢角、角速度終端

% Params.Weight.P = diag([1000.0; 1000.0; 1000]);    % 座標   1000 10
% Params.Weight.V = diag([100; 100; 10]);    % 速度
% Params.Weight.R = diag([1.0; 1.0; 1.0; 1.0]); % 入力
% Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
% Params.Weight.QW = diag([1000; 1000; 1000; 1; 1; 1]);  % 姿勢角、角速度
% Params.Weight.Pf = Params.Weight.P;
% Params.Weight.Vf = Params.Weight.V;
% Params.Weight.QWf = Params.Weight.QW; %姿勢角、角速度終端


