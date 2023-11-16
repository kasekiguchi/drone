function pcdata = scanpcplot_rov(topics)
scanlidardata_b = receive(topics.scanback_Sub,2);%受け取り
scanlidardata_f = receive(topics.scanfront_Sub,2);%受け取り

moving_f = rosReadCartesian(scanlidardata_f);
moving_pc.f = pointCloud([moving_f zeros(size(moving_f,1),1)]); % moving:m*3

moving_b = rosReadCartesian(scanlidardata_b);
moving_pc.b = pointCloud([moving_b zeros(size(moving_b,1),1)]); % moving:m*3

%% ローバー自身の点群認識
roi = [0.1 0.35 -0.18 0.16 -0.1 0.1];

indices_f = findPointsInROI(moving_pc.f,roi);
Df = zeros(size(moving_pc.f.Location));

indices_b = findPointsInROI(moving_pc.b,roi);
Db = zeros(size(moving_pc.b.Location));

Df(indices_f,3) = 5;
Db(indices_b,3) = 5;
ptCloud_tf = pctransform(moving_pc.f,Df);
ptCloud_tb = pctransform(moving_pc.b,Db);
% %%%%%%%%%ローバー自身の点群除去%%%%%%%%%%%%%%
roi = [-10 10 -10 10 -1 1];%入力点群の x、y および z 座標の範囲内で直方体 ROI を定義


indices_f = findPointsInROI(ptCloud_tf,roi);%直方体 ROI 内にある点のインデックスを検出
moving_pc.f = select(ptCloud_tf,indices_f);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納    

indices_b = findPointsInROI(ptCloud_tb,roi);%直方体 ROI 内にある点のインデックスを検出
moving_pc.b = select(ptCloud_tb,indices_b);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納



%% pcd合成
rot = eul2rotm(deg2rad([0 0 180]),'XYZ'); %回転行列(roll,pitch,yaw)
T = [0.46 0.023 0]; %並進方向(x,y,z)
tform = rigidtform3d(rot,T);

moving_pc2_m_b = pctransform(moving_pc.b,tform);

ptCloudOut = pcmerge(moving_pc.f, moving_pc2_m_b, 0.001);
% ptCloudOut = pcmerge(moving_pc.f, moving_pc2_m, 0.001);

rot = eul2rotm(deg2rad([0 0 180]),'XYZ'); %回転行列(roll,pitch,yaw)
T = [0.17 0 0]; %並進方向(x,y,z)
tform = rigidtform3d(rot,T);
moving_pcm = pctransform(ptCloudOut,tform);

% % %%%%%%%%%ローバー自身の点群認識ver2%%%%%%%%%%%%%%%%%%
% roi = [-0.155 0.14 -0.18 0.15 -0.1 0.1];
% indices = findPointsInROI(moving_pcm,roi);
% D = zeros(size(moving_pcm.Location));
% D(indices,3) = 5;
% ptCloud_t = pctransform(moving_pcm,D);
% %%%%%%%%%ローバー自身の点群除去%%%%%%%%%%%%%%
% roi = [-10 10 -10 10 -1 1];%入力点群の x、y および z 座標の範囲内で直方体 ROI を定義
% indices = findPointsInROI(ptCloud_t,roi);%直方体 ROI 内にある点のインデックスを検出
% ptCloud_roi = select(ptCloud_t,indices);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納


% figure
% pcshow(moving_pc.b,"MarkerSize",12,"BackgroundColor",[1 1 1])
% view(2)

% 
% figure
% pcshowp(ptCloud_roi,moving_pcm,"MarkerSize",12,"BackgroundColor",[1 1 1])
% view(2)


pcdata = moving_pcm;
end