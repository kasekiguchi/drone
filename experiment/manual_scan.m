clc;clear;close all;
%% ros2設定
matlabnode = ros2node("/testnode",25);
j=1;
ros2("topic","list","DomainID",25)
while(1)    
    try
        %megarover
        % topics.Pubcmd_vel = ros2publisher(matlabnode,"/rover_twist","geometry_msgs/Twist");
        % topics.cmd_msg = ros2message("geometry_msgs/Twist");
        % topics.imudata_sub=ros2subscriber(matlabnode,"/rover_odo","geometry_msgs/Twist");
        % topics.tf_sub=ros2subscriber(matlabnode,"/tf");
        % %camRSトピック(D435i)
        % topics.camRS_Sub = ros2subscriber(test_node,"/camera/camera/depth/color/points");%,"History","keepall","Reliability","besteffort");
        %lidarトピック
        topics.scanback_Sub = ros2subscriber(matlabnode,"/scan_back","History","keepall","Reliability","besteffort");
        topics.scanfront_Sub = ros2subscriber(matlabnode,"/scan_front","History","keepall","Reliability","besteffort");
        disp("node set!")
        break;
    catch
        str = ['miss:',num2str(j)];
        disp(str);
        j = j + 1;
    end
end
%% マニュアルで動く
%%%%%%%%%%%%%%%%各種設定%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = 1;%刻み時間幅
dt_new=dt;%刻み時間幅更新用
times.systemtime=tic;%刻み時間測定
%%%%%%%%%%%%%ndt初期設定%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fixedSeg = pcread("fixedmap_room_1.pcd");
fixedSeg = scanpcplot_rov(topics);
%初期位置チューニング
rot_ini = eul2rotm(deg2rad([0 0 0]),'XYZ'); %回転行列(roll,pitch,yaw)
T_ini = [0 0 0]; %並進方向(x,y,z)
initialtform = rigidtform3d(rot_ini,T_ini);
%%%%%%%%%%%%%%%mainループ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
while(1)
    point = cast(toc(times.systemtime),"int32");%disp(dt_new)
    PCdata_use = scanpcplot_rov(topics);
    tform = pcregisterndt(PCdata_use,fixedSeg,0.5, ...
        "InitialTransform",initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
    nowpose(1,1) = tform.A(1,4);
    nowpose(1,2) = tform.A(2,4);
    nowpose(1,3) = rad2deg(acos(tform.R(1,1)));
    
    if point > dt_new
        disp(nowpose);
        ndtPCdata = pctransform(PCdata_use,tform);
        %savedataに保存
        savedata(i).tform       = tform;
        savedata(i).ndtPCdata   = ndtPCdata;
        savedata(i).timestamp   = point;
        i = i + 1;
        dt_new=dt*i;
        
        fixedSeg = pcmerge(fixedSeg,ndtPCdata,0.05);
    end
    initialtform = tform;
    TF = kaihi(PCdata_use);
    if TF(2).TF == false
        disp('左前方注意')
    elseif TF(3).TF == false
        disp('右前方注意')
    end
    if TF(1).TF == false
        disp('前方注意')
    end
end
% rover_pub(topics,0);
% fprintf('動いた時間は %2.2f \n',toc(times.systemtime));
% clear matlabnode & topics & times;
%% 自己位置推定プロット
figure
num_lim = i-1;
for j=1:num_lim
    ndtx(j) = savedata(j).tform.A(1,4) ;%+ 1;
    ndty(j) = savedata(j).tform.A(2,4);
end
plot(ndtx,ndty,'*-','MarkerSize',5);
grid on
daspect([1 1 1])
xlabel('X');ylabel('Y');ax = gca;ax.FontSize = 15;
legend
%% 
% pcshowpair(fixedSeg,savedata(1).ndtPCdata,"MarkerSize",24,"BackgroundColor",[1 1 1])
num_lim = i-1;
mkmap = savedata(1).ndtPCdata;
for j=2:num_lim
    mkmap = pcmerge(mkmap,savedata(j).ndtPCdata, 0.001);
end
figure
pcshow(mkmap,"MarkerSize",24,"BackgroundColor",[1 1 1]);

% pcshowpair(savedata(9).ndtPCdata,fixedSeg,"MarkerSize",12,"BackgroundColor",[1 1 1])
% pcwrite(mkmap,'fixedmap_room_1.pcd','Encoding','ascii');
%%
map = mkmap;
filepass = "..\environment\pcdmap";
filename = filepass + "experimentroom_map3.mat";
save(filename,"map");

%%
function TF = kaihi(pcd)
    % indices_n = findNeighborsInRadius(pcd,[0 0 0],0.5);
        roi(1).roi = [0.15 0.4 -0.1 0.1 -1 1];%前方の障害物検知
        roi(2).roi = [0.15 0.3 0.2 0.22 -1 1];%左前方の障害物検知
        roi(3).roi = [0.15 0.3 -0.22 -0.2 -1 1];%右前方の障害物検知
    for d = 1:3
        indices_n = findPointsInROI(pcd,roi(d).roi);%直方体 ROI 内にある点のインデックスを検出
        TF(d).TF = isempty(indices_n);
    end
    % D = zeros(size(pcd.Location));
    % D(indices_n,3) = 0.1;
    % ptCloud_fnir = pctransform(pcd,D);
    % 
    % figure
    % pcshow(ptCloud_fnir,"MarkerSize",24,"BackgroundColor",[1 1 1])
    % xlabel('X');ylabel('Y');zlabel('Z')
    % view(2)
end