%　DataPlot
%%
% resultPath = "C:\Users\81809\OneDrive\デスクトップ\results";
% winopen(resultPath)
%filelist.nameでファイルのリストを表示
% filelist = dir('C:\Users\81809\OneDrive\デスクトップ\results\sim\2024_0201_23TADR_sim_modelError\loggers\*.mat');
% if ~exist(resultPath,"dir")
%     addpath(genpath(resultPath))
%     cd(resultPath)
% end
%%
close all
clear multiFigure option addingContents f loggers
%選択    
fMul =1;%複数まとめるかレーダーチャートの時は無視される
fspider=10;%レーダーチャート1
fF=10;%flightのみは１
frmse = 10;%rmseのみ知りたい場合
startTime = 0;
endTime = 7400;
fnowdata = 1;
%どの時間の範囲を描画するか指定   
% startTime = [10,10,10,80];%モデル誤差用
% endTime = [30,30,30,100];

% clear allData
if fnowdata==1
    if exist("gui","var")
        logger = gui.logger;
        logger.fExp = gui.fExp;
    end
    if ~exist("loggers","var")
        for i = 1:length(logger.target)
            loggers{i,1} = simplifyLogger(logger,i);
            % loggers{i,1} = simplifyLoggerForCoop(logger,i);
            % loggers{i,1} = simplifyLoggerForSingle(logger,i);
        end
    end
    droneID = logger.target(1:end-1);
else 
    % loggers = simple_log_epandAndLoadSysEKFsensorNoize0_01inputNoizeT0_01Tq0_;
    % loggers = simple_log_expandSysEKF;
    % loggers = simple_log_ptopx01210_1_2y0000000z05_yaw10;
    % loggers = simple_log_saddle_rot_updateRef;
    if 1
        loggers = [
                    % simple_log_circle_success_PC1;...
                    % simple_log_circle_success_PC2(2:end)
                    % simple_log_saddle_rotPC1;...
                    % simple_log_saddle_rotPC2(2:end)
                    simple_log_saddle08T12_rottm3_4sin_3PC1;...
                    simple_log_saddle08T12_rottm4_3sin_3PC2(2:end)
                    % simple_log_saddle_rott_Noise
                    % simple_log_saddle_rott_noNoise
                    % simple_log_saddle2T10_rott2_3sin_m5
                    ];
    end
    droneID = 1:length(loggers)-1;
end
lgnd.payload=["payload","split payload" + droneID];
lgnd.drone="drone" + droneID;
%========================================================================
%図を選ぶ
% "t_p0"	"x_y0"	"x_z0"	"y_z0"	"t_x0"	"t_y0"	"t_z0"
% "error0"	"t_errx0"	"t_erry0"	"t_errz0"	
% "attitude0"	"t_qroll0"	"t_qpitch0""t_qyaw0"
% "velocity0"	"t_vx0"	"t_vy0"	"t_vz0"	
% "angular_velocity0"	"t_wroll0" "t_wpitch0"	"t_wyaw0"
% "three_D0"	"pp0"	"pv0"	"pq0"	"pw0"
% "t_p"	"x_y"	"x_z"	"y_z"	"t_x"	"t_y"	"t_z"
% "error"	"t_errx"	"t_erry"	"t_errz"
% "attitude"	"t_qroll"	"t_qpitch"	"t_qyaw"
% "velocity"	"t_vx"	"t_vy" "t_vz"
% "angular_velocity"	"t_wroll"	"t_wpitch"	"t_wyaw"	
% "three_D"	"pp" "pv"	"pq"	"pw"	
% "input"	"u"	"inner_input" 
% "inputTrust" "inputRoll"	"inputPitch"	"inputYaw"
% "inputsum"	"inputsumT"	"inputsumTq"	"inputTrust"
% "mAll" "mL"	"ai"	"mui"
% "DronePayload1"	"linkDir1" "DronePayload2"	"linkDir2"	"DronePayload3"	"linkDir3"	"DronePayload4"	"linkDir4"	"DronePayload5" "linkDir5"	"DronePayload6"	"linkDir6"
% ["DronePayload"+logger.target(1:end-1)]
% "rmse" "xrmse"	"yrmse"	"zrmse"
%========================================================================
%singleFigure
     % n=["t_p","t_x","t_y","t_z","error","t_errx","t_erry","t_errz","input","Trs","attitude","velocity","angular_velocity","x_y" ,"three_D","z1","z2","z3","z4","uHL"];%,"F1z1","F2z2","F3z3","F4z4"];
     % n = ["xrmse","yrmse","zrmse","rmse","inputsumT","inputsumTq","x_y" ,"t_x" ,"t_y" ,"t_z","t_errx","t_erry","t_errz","input","uHL","uHLsum","t_vx" ,"t_vy" ,"t_vz","t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw"];
     % n = ["xrmse","yrmse","zrmse","rmse","inputsumT","inputsumTq","t_errx","t_erry","t_errz","input","uHL","uHLsum","t_vx" ,"t_vy" ,"t_vz","t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw","t_x" ,"t_y" ,"t_z","x_y","three_D"];
     % n = ["t_x" ,"t_y" ,"t_z","x_y","three_D"];
     n = ["t_p0","t_x0","t_y0","t_z0","t_errx0","t_erry0","t_errz0","three_D0","mAll","mL"];%,"ai"+droneID,"aidrn"+droneID];
     n = ["t_errx0","t_erry0","t_errz0"];
     n = ["t_sx0" "t_sy0" "t_sz0","t_p","t_sqyaw0","expThree_D","x_y","x_z","y_z","t_x","t_y","t_z","mAll","mL","inputTrust" "inputRoll"	"inputPitch"	"inputYaw"];%比較するとき複数まとめる
     n = "inputTrust";
     % n = ["t_sx0" "t_sy0" "t_sz0","t_p","expThree_D","x_y","x_z","y_z","t_x","t_y","t_z","inputTrust" "inputRoll"	"inputPitch"	"inputYaw"];%比較するとき複数まとめる
     % n = ["mAll","mL"];%,"ai"+droneID,"aidrn"+droneID];
     % n = ["three_D0"];%,"ai"+droneID,"aidrn"+droneID];
%========================================================================
% multiFigure
% nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],["attitude0"	"t_qroll0"	"t_qpitch0" "t_qyaw0"],["velocity0"	"t_vx0"	"t_vy0"	"t_vz0"	],["angular_velocity0"	"t_wroll0" "t_wpitch0"	"t_wyaw0"],...
%     "three_D0",["t_p" "t_x" "t_y"	"t_z"],["error"	"t_errx"	"t_erry"	"t_errz"],["attitude"	"t_qroll"	"t_qpitch"	"t_qyaw"],"attitude"+droneID,["velocity"	"t_vx"	"t_vy" "t_vz"],["angular_velocity"	"t_wroll"	"t_wpitch"	"t_wyaw"],...
%     "three_D",["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"input",["mAll","mL"],"DronePayload"+droneID,"linkDir"+droneID,"mui"+droneID,"ai"+droneID,"aidrn"+droneID,"dwi"+droneID,["a" "dO"]};%比較するとき複数まとめる
% nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0",["mAll","mL"],"mui"+droneID,"ai"+droneID,"aidrn"+droneID};%比較するとき複数まとめる
% nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,"vi"+droneID,"wi"+droneID,"vLi"+droneID,"wLi"+droneID,["mAll","mL"],"mui"+droneID,"ai"+droneID,"aidrn"+droneID,"dwi"+droneID,["a" "dO"]};%比較するとき複数まとめる
% nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],"mui"+droneID,"ai"+droneID,"aidrn"+droneID,"dwi"+droneID,["a" "dO"]};%比較するとき複数まとめる
nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"]};%比較するとき複数まとめる
nM = {["t_sx0" "t_sy0" "t_sz0","t_sqyaw0","t_p"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"expThree_D",["x_y","x_z","y_z","t_x","t_y","t_z"],"attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"]};%比較するとき複数まとめる
nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0",["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"constRef"+droneID,"minDroneDistance",["t_qroll0","t_qpitch0","t_qyaw0"]};%比較するとき複数まとめる
% nM = {"mui"+droneID};%比較するとき複数まとめる
nM = {["t_sx0" "t_sy0" "t_sz0","t_sqyaw0","t_p"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","expThree_D",["x_y","x_z","y_z","t_x","t_y","t_z"],"pi"+droneID,"attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],["t_qroll0","t_qpitch0","t_qyaw0"]};%比較するとき複数まとめる
n = ["t_p0","t_x0","t_y0","t_z0","three_D0","error0" "t_errx0"	"t_erry0"	"t_errz0","mAll","mL","inputTrust" "inputRoll"	"inputPitch"	"inputYaw","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
% n = ["t_p0","t_x0","t_y0","t_z0","three_D0","error0" "t_errx0"	"t_erry0"	"t_errz0","mAll","inputTrust" "inputRoll"	"inputPitch"	"inputYaw","constRef"+droneID,"minDroneDistance","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
n = ["t_p0","attitude0"];
if fnowdata==1
    n = ["t_p0","t_x0","t_y0","t_z0","t_errx0","t_erry0","t_errz0","three_D0","mAll","mL"];%,"ai"+droneID,"aidrn"+droneID];
    nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","pepi"+droneID,"peqi"+droneID,"pepLi"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"constRef"+droneID,"minDroneDistance",["t_qroll0","t_qpitch0","t_qyaw0"]};%比較するとき複数まとめる
    % nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"three_D0","peqi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"constRef"+droneID,"minDroneDistance",["t_qroll0","t_qpitch0","t_qyaw0"]};%比較するとき複数まとめる
    % n = ["t_p0" "t_x0" "t_y0" "t_z0" "error0"	"t_errx0"	"t_erry0"	"t_errz0" "three_D0" "peqi"+droneID "mAll" "mL" "inputTrust" "inputRoll"	"inputPitch"	"inputYaw" "constRef"+droneID "minDroneDistance" "t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
    nM = {["t_sx0" "t_sy0" "t_sz0","t_sqyaw0","t_p"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],"expThree_D",["x_y","x_z","y_z","t_x","t_y","t_z"],"attitude"+droneID,"pevi"+droneID,"pewi"+droneID,"pevLi"+droneID,"pewLi"+droneID,["mAll","mL"],["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"constRef"+droneID,"minDroneDistance",["t_qroll0","t_qpitch0","t_qyaw0"]};%比較するとき複数まとめる
    % n = ["t_p0","t_x0","t_y0","t_z0","three_D0","error0" "t_errx0"	"t_erry0"	"t_errz0","expThree_D","x_y","x_z","y_z","t_x","t_y","t_z","mAll","mL","inputTrust" "inputRoll"	"inputPitch"	"inputYaw","constRef"+droneID,"minDroneDistance","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
    % n = ["t_p0","t_x0","t_y0","t_z0","three_D0","error0" "t_errx0"	"t_erry0"	"t_errz0","expThree_D","t_z","mAll","mL","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
    n = ["t_p0","t_x0","t_y0","t_z0","three_D0","error0" "t_errx0"	"t_erry0"	"t_errz0","mAll","inputTrust" "inputRoll"	"inputPitch"	"inputYaw","constRef"+droneID,"minDroneDistance","attitude0","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
    n = ["t_p0","three_D0","error0","mAll","attitude0","minDroneDistance","constRef"+1];%比較するとき複数まとめる
    % n = ["t_p0","expThree_D","t_z","mAll","mL","t_qroll0","t_qpitch0","t_qyaw0"];%比較するとき複数まとめる
end
multiFigure.layout = cell(1,length(nM));

%tile layoutの行列数を作成
for i = 1:length(nM)
   nMiLength = length(nM{i});
   tile = [1, factor(nMiLength)];
   if length(tile) == 2  && tile(2) > 3
       tile = [1, factor(nMiLength +1)];
   end
   while 1
       sortedTile = sort(tile);
       lnSortedTile = length(sortedTile);
       if lnSortedTile > 2
        tile = [sortedTile(1)*sortedTile(2),sortedTile(3:end)];
       else
        tile = sortedTile;
           break
       end
   end
   multiFigure.layout{i} = tile;
   multiFigure.title(i) = join(nM{i},"_");
end
% multiFigure.title = ["bars","err_inp","vqw","position"];%[" state", " subsystem"];%title name
% multiFigure.title = string(zeros(1,length(nM)));%[" state", " subsystem"];%title name
multiFigure.num = length(nM);%figの数
multiFigure.fontSize = 16;
multiFigure.pba = [1,0.78084714548803,0.78084714548803];%各図の縦横比
multiFigure.padding = 'tight';
multiFigure.tileSpacing = 'tight';
multiFigure.f = fMul;

option.lineWidth = 2;%linewidth
option.fontSize = 18;%デフォルト9，フォントサイズ変更
option.legendColumns = 4;
option.aspect = [];
option.camposition = [];
% option.fExp = fExp;

%figごとに追加する場合のもの
addingContents.aspect = [1,1,1];
addingContents.camposition = [-45,-45,20];

%data setting
if ~exist("oldStartTime","var") ||~exist("oldEndTime ","var")
    oldStartTime = -1;
    oldEndTime = -1;
end
if ~exist("allData","var") || oldStartTime - startTime ~= 0 || oldEndTime - endTime ~=0
    [allData,RMSE] = dataSummarize(loggers, lgnd, option, addingContents, fF, startTime, endTime);
    oldStartTime = startTime;
    oldEndTime = endTime;
end
%% plot
tic
if multiFigure.f == 1 && fspider ~=1 && frmse~=1%multiFigure
    for mfn = 1: multiFigure.num
        f(mfn)=figure('name',multiFigure.title(mfn));
        % f(mfn)=figure;
        f(mfn).WindowState = 'maximized';
        tpolt = tiledlayout(multiFigure.layout{1,mfn}(1), multiFigure.layout{1,mfn}(2));
        tpolt.Padding = multiFigure.padding;%'tight'; %'compact';
        tpolt.TileSpacing = multiFigure.tileSpacing;%tight';%  'compact';
        for fN = 1:length(nM{mfn}) 
            nexttile
            plot_data_multi(allData.(nM{mfn}(fN)), multiFigure);
        end
    end
elseif frmse~=1 %singleFigure
    % f = zeros(length(n),1);
     for fN = 1:length(n) 
          f(fN)  = figure('Name',n(fN));
          plot_data_single(fN, n(fN), allData.(n(fN)));
     end
end
toc
isSaved = 0;%input("Save figure : '1' \nNot now : '0' \nFill in : ");
if isSaved
    %% save 
    run("makeSavePath")
    % n=[2,7,10,11];%spider
    fself = 10;
    if fMul==1 && fself ~=1
        % nn=string(1:length(nM));
        nn=multiFigure.title ;
    elseif fself ~=1
        nn=n;
    else
        %自分で指定する場合
        nn = "mui1_mui2_mui3_mui4_mui5_mui6";
    end
    nf=length(nn);
    SaveTitle=strings(1,nf);
    %保存する図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
    for i=1:nf
    %     SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',figName(n(i)));
        SaveTitle(i)=strcat(contents,'_',nn(i));
        saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'fig');
        %見切れないようにする
        f(i).Units = 'centimeters';
        f(i).PaperUnits = f(i).Units;
        f(i).PaperPosition = [0, 0, f(i).Position(3:4)];
        f(i).PaperSize = f(i).Position(3:4);
        saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'pdf');
        % saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'jpg');
        % saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'eps');
    end
    %%
    %RMSEの保存
    run("makeSavePath")
    RMSE(1,1)="";
    filenameRMSE=strcat(fullfile(FolderNameR, 'RMSEs'),'.txt');
    fExist=exist(filenameRMSE,'file');
    if fExist
        writematrix([strings(1,4);"<"+contents+">",strings(1,6);"time (s)",string(startTime)+"-"+string(endTime),strings(1,5);RMSE(:,1:7)],strcat(fullfile(FolderNameR, 'RMSEs'),'.txt'),'Delimiter','tab','WriteMode','append')
    else
        writematrix(["<"+contents+">",strings(1,6);"time (s)",string(startTime)+"-"+string(endTime),strings(1,5);RMSE(:,1:7)],strcat(fullfile(FolderNameR, 'RMSEs'),'.txt'),'Delimiter','tab')
    end
    
    %% single save
    i=6;%figiureの番号
    % n=length(f);
    SaveTitle=strings(1,1);
        SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(i));
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'jng');
        saveas(f(i), fullfile(FolderNameF, SaveTitle(i) ),'fig');
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');
    %% save
    FolderNameF="C:\Users\81809\OneDrive\デスクトップ\results\exp\2024_0327_23TADR_saddle_modelerror\figure"
    SaveTitle = "sd_me_input"
    i =1;
    mkdir(FolderNameF);
    saveas(f(i), fullfile(FolderNameF, SaveTitle ),'fig');
    % saveas(f(i), fullfile(FolderNameF, SaveTitle ),'epsc');
    %% グラフ上下入換え
    h = get(gca,'Children'); % 軸オブジェクトの子オブジェクトを取得(複数の場合はベクトル)
    formerLegend = "1";
    hg = findobj(h,'displayName',formerLegend); % 青色のlineオブジェクトを検出
    % オブジェクトの順番の入れ替え
    % 青色ラインの要素を取得
    ind = (h == hg); % h において hg であるかどうかを論理値で出力
    % 青色ラインのハンドルを一番上に設定
    newh = [h(ind); h(~ind)]; % h(ind)：青色ラインのハンドル、h(~ind)：それ以外のハンドル
    for i = 1:length(h)
        DN(i) = string(newh(i).DisplayName);
    end
    legend([newh(1),newh(2:end)],DN);
    % legend([newh(1),newh(2)],h(1).DisplayName,h(2).DisplayName);
    set(gca,'children',newh) % Childrenプロパティ値の再設定(順番の入れ替え)
end
%% functions
function [allData,RMSElog]=dataSummarize(loggers, lgnd, option, addingContents, fF, startTime, endTime)
    tic 
    fExp = loggers{1}.fExp;
    logNum = length(loggers);
    if length(startTime)<logNum
        startTime = startTime*ones(1,logNum);
        endTime = endTime*ones(1,logNum);
    end
    if fF==1
        for i = 1:logNum
            t{i} = loggers{i}.t';
            %flightのインデックス
            kl = find(loggers{i}.phase == 102);
            kf(i)= kl(1);
            ke(i)= kl(end);
            %時間表示に使用するインデックス
            sTime(i) = t{i}(kf(i)) + startTime(i);
            eTime(i) = t{i}(kf(i)) + endTime(i);
            spanIndex{i} = find(t{i} <= eTime(i) & t{i} >= sTime(i) );
            kf(i) = spanIndex{i}(1);
            ke(i) = min(ke(i), spanIndex{i}(end));%flightのindex数以下になる
            lt(i) = ke(i)-kf(i)+1;%flightのindex数以下になる
            ts{i} = t{i}(kf(i):ke(i));
            t0(i) = t{i}(kf(i));
        end
        %表示する時間を最小のものに合わせる
        % minSpan = min(mxi);
        [mlt,mi] = min(lt);
        minte = t{mi}(mlt);
        for i = 1:logNum
            ke(i) = kf(i) + find(t{i}<=minte,1,"last") - 1;
            ts{i} = t{i}(kf(i):ke(i));
            lt(i) = length(ts{i});
        end
    else 
        %flite のみでない場合
        for i = 1:logNum
            t{i} = loggers{i}.t';
            spanIndex{i} = find(t{i} <= endTime(i) & t{i} >= startTime(i) );
            % kf(i) = min(spanIndex{i});
            % ke(i) = max(spanIndex{i});
            lt(i) = length(spanIndex{i});%flightのindex数以下になる
            kf(i) = spanIndex{i}(1);
            ke(i) = spanIndex{i}(end);
            ts{i} = t{i}(kf(i):ke(i));
            t0(i)=0;
        end
    end
    for i = 1:logNum
        %初期値設定
        zero1 = zeros(1,lt(i));zero3=zeros(3,lt(i));zero4=zeros(4,lt(i));
        ev{i}=zero3;eq{i}=zero3;ew{i}=zero3;pL{i}=zero3;pT{i}=zero3;
        cinput{i}=zero4;inner_input{i}=zeros(8,lt(i));
        ev0{1} = zero3;vx0{1}=zero1;vy0{1} = zero1;vz0{1} = zero1;
        

        %変数に代入
        fieldLog = fieldnames(loggers{i});
        if loggers{i}.fExp
            fieldLog = fieldLog(find(fieldLog=="sensor"):end-1);
            inner_input{i} = loggers{i}.inner_input;
            pp{i} = zero3;pv{i} = zero3;pq{i} = zero3;pw{i} = zero3; ppL{i}=zero3;
            pvL{i}=zero3;pwL{i}=zero3;
            qroll0{i}=zero1;qpitch0{i}=zero1;qyaw0{i} =zero1;
            wroll0{i}=zero1;wpitch0{i}=zero1;wyaw0{i} =zero1;epL{i}=zero3;
            rai{i}=zero3;rmui{i}=zero3;rdwi{i}=zero3;raidrn{i}=zero3;
             cQeul{i}=zero3;cQeul{i}=zero3;cQeul{i}=zero3;eO{i}=zero3;eO{i}=zero3;eO{i}=zero3;ep{i}=zero3;
             eQ{i} = zero3;pQ{i} = zero3;eO{i} = zero3;pO{i} = zero3;edO{i} = zero3;ea{i} = zero3;
             constp{i}=zero1;constTargetp{i}=zero1;minDroneDistance{i}=zero1;
        else
            fieldLog = fieldLog(find(fieldLog=="sensor"):end);
            sx0{1} = zero1;sy0{1} = zero1;sz0{1} = zero1;
            sq0{1} = zero1;sq0{1} = zero1;sq0{1} = zero1;
            sq{i}=zero3;
            rai{i}=zero3;rmui{i}=zero3;rdwi{i}=zero3;raidrn{i}=zero3;
             cQeul{i}=zero3;cQeul{i}=zero3;cQeul{i}=zero3;eO{i}=zero3;eO{i}=zero3;eO{i}=zero3;ep{i}=zero3;
             eQ{i} = zero3;pQ{i} = zero3;eO{i} = zero3;pO{i} = zero3;edO{i} = zero3;ea{i} = zero3;
             constp{i}=zero1;constTargetp{i}=zero1;minDroneDistance{i}=zero1;mAll{i}=zero1;mLi{i}=zero1;
        end
        for j = 1:length(fieldLog)
            fieldVar = fieldnames(loggers{i}.(fieldLog{j}));
            for j2 = 1:length(fieldVar)
                F = fieldLog{j}(1);
                if i == 1 
                    if fieldVar{j2} ~= "mui"
                       eval([F,fieldVar{j2},'{i}= loggers{i}.',fieldLog{j},'.',fieldVar{j2},'(:,kf(i):ke(i));']);
                    end
                else
                    eval([F,fieldVar{j2},'{i}= loggers{i}.',fieldLog{j},'.',fieldVar{j2},'(:,kf(i):ke(i));']);
                end
            end
        end
        %=PAYLOAD=================================================
        %plant      : "p" "Q" "v" "O" "qi" "wi"	"Qi" "Oi" "a" "dO"
        %sensor     : "p" "Q" "v" "O" "qi" "wi"	"Qi" "Oi" "a" "dO"
        %estimator  : "p" "Q" "v" "O" "qi" "wi"	"Qi" "Oi" "a" "dO"
        %reference  : "xd" "p" "q" "v" "o"
        %controller : "input(1-N)" "mui(muid,mui)"
        %input      : "input(1-N)"
        %=DRONE===================================================
        %plant      : "p" "v" "q" "w" "pL" "vL" "pT" "wL" (p,v以外は対応する変数に分割前ペイロードの真値が代入されている)
        %sensor     : "p" "v" "q" "w" "pL" "vL" "pT" "wL"
        %estimator  : "p" "v" "q" "w" "pL" "vL" "pT" "wL"
        %reference  : "xd" "p" "v" "ai" "mui" "mLi"
        %controller : "input"
        %=========================================================
        time{i} = ts{i}-t0(i);
        if i == 1
            % cmui{i} = loggers{1}.controller.mui;  
            % for j =1:logNum-1
            %     reMui = reshape(cmui{i}(:,j),6,[]);
            %     muid = reMui(1:3,:);
            %     muid_norm = sqrt(sum(muid.^2));
            %     muid_unit = muid./muid_norm;
            %     muid_units(:,:,j) = muid_unit;
            % 
            %     linki(:,:,j) = -eqi{i}(3*j-2:3*j,:);
            % end
            ref0=rxd{i}(1:3,:);
            refx0{1} = rxd{i}(1,:);
            refy0{1} = rxd{i}(2,:);
            refz0{1} = rxd{i}(3,:);
            refeul0 = rxd{i}(end-3:end-1,:)*180/pi;
            
            if ~fExp
                ex0{1} = ep{i}(1,:);
                ey0{1} = ep{i}(2,:);
                ez0{1} = ep{i}(3,:);
                epL{1} = ep{i};
                err{1} = ep{1}-ref0;%誤差
                ev0{1} = ev{i};
                vx0{1} = ev{i}(1,:);
                vy0{1} = ev{i}(2,:);
                vz0{1} = ev{i}(3,:);
                q0{1} = cQeul{i}*180/pi;
                qroll0{1} = cQeul{i}(1,:)*180/pi;
                qpitch0{1} = cQeul{i}(2,:)*180/pi;
                qyaw0{1} = cQeul{i}(3,:)*180/pi;
                wroll0{1} = eO{i}(1,:);
                wpitch0{1} = eO{i}(2,:);
                wyaw0{1} = eO{i}(3,:);
            else
                %sensor
                sx0{1} = sp{i}(1,:);
                sy0{1} = sp{i}(2,:);
                sz0{1} = sp{i}(3,:);
                ex0{1} = sp{i}(1,:);
                ey0{1} = sp{i}(2,:);
                ez0{1} = sp{i}(3,:);
                err{1} = sp{1}-ref0;%誤差
                epL{1} = sp{1};
                q0{1} = sq{i}*180/pi;
                qroll0{1} = sq{i}(1,:)*180/pi;
                qpitch0{1} = sq{i}(2,:)*180/pi;
                qyaw0{1} = sq{i}(3,:)*180/pi;
            end
            errx0{1} = err{1}(1,:);
            erry0{1} = err{1}(2,:);
            errz0{1} = err{1}(3,:);
                sqroll0{1} = sq{i}(1,:);
                sqpitch0{1} = sq{i}(2,:);
                sqyaw0{1} = sq{i}(3,:);
            % end
        else
            j = i - 1;
            %sensor
            sx{j} = sp{i}(1,:);
            sy{j} = sp{i}(2,:);
            sz{j} = sp{i}(3,:);
            sqroll{j} = sq{i}(1,:);
            sqpitch{j} = sq{i}(2,:);
            sqyaw{j} = sq{i}(3,:);
            % estimator
            % refx{j} = rp{i}(1,:);%
            % refy{j} = rp{i}(2,:);
            % refz{j} = rp{i}(3,:);
            ref{j} = rxd{i}(1:3,:);
            refx{j} = rxd{i}(1,:);%
            refy{j} = rxd{i}(2,:);
            refz{j} = rxd{i}(3,:);
            constp{j} = rconstp{i};
            constTargetp{j} = rconstTargetp{i};
            minDroneDistance{j} = rminDroneDistance{i};
            err{i} = epL{i}-rxd{i}(1:3,:);%誤差
            errx{j} = err{i}(1,:);
            erry{j} = err{i}(2,:);
            errz{j} = err{i}(3,:);
            epi{j} = ep{i};
            epx{j} = ep{i}(1,:);
            epy{j} = ep{i}(2,:);
            epz{j} = ep{i}(3,:);
            evi{j} = ev{i};
            evx{j} = ev{i}(1,:);
            evy{j} = ev{i}(2,:);
            evz{j} = ev{i}(3,:);
            eqi{j} = eq{i};
            qroll{j} = eq{i}(1,:);
            qpitch{j} = eq{i}(2,:);
            qyaw{j} = eq{i}(3,:);
            ewi{j} = ew{i};
            wroll{j} = ew{i}(1,:);
            wpitch{j} = ew{i}(2,:);
            wyaw{j} = ew{i}(3,:);
            epi{j} = ep{i};
            epLi{j} = epL{i};
            epLx{j} = epL{i}(1,:);
            epLy{j} = epL{i}(2,:);
            epLz{j} = epL{i}(3,:);
            evLi{j} = evL{i};
            evLx{j} = evL{i}(1,:);
            evLy{j} = evL{i}(2,:);
            evLz{j} = evL{i}(3,:);
            epTi{j} = -epT{i};
            epTx{j} = -epT{i}(1,:);
            epTy{j} = -epT{i}(2,:);
            epTz{j} = -epT{i}(3,:);
            ewLi{j} = ewL{i};
            %plant
            ppi{j} = pp{i};
            pqi{j} = pq{i};
            ppLi{j} = ppL{i};
            pvi{j} = pv{i};
            pwi{j} = pw{i};
            pvLi{j} = pvL{i};
            pwLi{j} = pwL{i};
            %controller
            cinputT{j} = cinput{i}(1,:);
            cinputR{j} = cinput{i}(2,:);
            cinputP{j} = cinput{i}(3,:);
            cinputY{j} = cinput{i}(4,:);
            inputsum(:,j) = sqrt(sum((cinput{i}(1:4,:)).^2,2)/lt(i));
            mAll{j} =  cmLi{i};
            mLi{j} = cmLi{i};
            % ai{j} = rai{i};
            % mui{j} = rmui{i};
            % dwi{j} = rdwi{i};
            % aidrn{j} = raidrn{i};
        end
    end
        % for i = 1:logNum-1
        %     tmpM(i,:) = mLi{i};
        % end
        % mAll{logNum} = sum(tmpM);
        [mLi,mAll] = sum_mLi(time,logNum,lt,mLi,mAll);
        %plotする為の構造体を作成する
        % allData.figName : (data, label, legendLabels, option)   
        %option : titleName, lineWidth, fontSize, legend, aspect, campositon
        %=====================================================
        % allData.example = {struct('x',{{time1,time2}},'y',{{data1,data2,data3}}),...
        %                                 struct('x','xlabel [dim]','y','ylabel [dim]','z','zlabel [dim]'),...
        %                                 {'$xleg$','$yleg$','$zleg$'},...
        %                                 add_option(["aspect","camposition"],option,addingContents)};
        %=====================================================
        % if isempty(c)
        %     c = string(1:logNum);
        % end
        C = lgnd.payload;
        Cref = C + " ref.";
        Rc = [C,"Reference"];
        Rc0 = num2cell([Rc(1),Rc(end)]);
        C0 = num2cell(C(1));
        Rci = num2cell(Rc(2:end));
        Ci = num2cell(C(2:end));
        CDi = num2cell(lgnd.drone);
        t1 = {ones(lt(1),3).*time{1}'};
        allData.t_p0 = {struct('x',{[t1,t1]},'y',{[{ref0'},{epL{1}'}]}), struct('x','time (s)','y','payload position (m)'), {'$x$ ref.','$y$ ref.','$z$ ref.','$x$ Est.','$y$ Est.','$z$ Est.'},add_option([],option,addingContents)};
        allData.x_y0 = {struct('x',{[ex0,refx0]},'y',{[ey0,refy0]}), struct('x','$x$ (m)','y','$y$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.x_z0 = {struct('x',{[ex0,refx0]},'y',{[ez0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.y_z0 = {struct('x',{[ey0,refy0]},'y',{[ez0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.t_x0 = {struct('x',{[time(1),time(1)]},'y',{[ex0,refx0]}), struct('x','time (s)','y','$x$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_y0 = {struct('x',{[time(1),time(1)]},'y',{[ey0,refy0]}), struct('x','time (s)','y','$y$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_z0 = {struct('x',{[time(1),time(1)]},'y',{[ez0,refz0]}), struct('x','time (s)','y','$z$ (m)'),Rc0,add_option([],option,addingContents)};
        
        allData.sx_sy0 = {struct('x',{[sx0,refx0]},'y',{[sy0,refy0]}), struct('x','$x$ (m)','y','$y$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.sx_sz0 = {struct('x',{[sx0,refx0]},'y',{[sz0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.y_sz0 = {struct('x',{[sy0,refy0]},'y',{[sz0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.t_sx0 = {struct('x',{[time(1),time(1)]},'y',{[sx0,refx0]}), struct('x','time (s)','y','$x$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_sy0 = {struct('x',{[time(1),time(1)]},'y',{[sy0,refy0]}), struct('x','time (s)','y','$y$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_sz0 = {struct('x',{[time(1),time(1)]},'y',{[sz0,refz0]}), struct('x','time (s)','y','$z$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_sqyaw0 = {struct('x',{time(1)},'y',{sqyaw0}), struct('x','time (s)','y','$q_{yaw}$ (rad)'),C0,add_option([],option,addingContents)};
        
        allData.error0 = { struct('x',{time(1)},'y',{err(1)}), struct('x','time (s)','y','error (m)'), LgndCrt(["$x$","$y$","$z$"],C0),add_option([],option,addingContents)};
        allData.t_errx0 = {struct('x',{time(1)},'y',{errx0} ), struct('x','time (s)','y','error $x$ (m)'),C0,add_option([],option,addingContents)};
        allData.t_erry0 = {struct('x',{time(1)},'y',{erry0} ), struct('x','time (s)','y','error $y$ (m)'),C0,add_option([],option,addingContents)};
        allData.t_errz0 = {struct('x',{time(1)},'y',{errz0} ), struct('x','time (s)','y','error $z$ (m)'),C0,add_option([],option,addingContents)};
        allData.attitude0 = {struct('x',{time(1)},'y',{[{refeul0'},q0(1)']}), struct('x','time (s)','y','payload attitude (deg)'), {'$\theta_{roll}$ ref.','$\theta_{pitch}$ ref.','$\theta_{yaw}$ ref.','$\theta_{roll}$ plant','$\theta_{pitch}$ plant','$\theta_{yaw}$ plant'},add_option([],option,addingContents)};
        allData.t_qroll0 = {struct('x',{time(1)},'y',{[qroll0{1}',{refeul0(1,:)'}]}), struct('x','time (s)','y','$\theta_{roll}$ (deg)'),Rc0,add_option([],option,addingContents)};
        allData.t_qpitch0 = {struct('x',{time(1)},'y',{[qpitch0{1}',{refeul0(2,:)'}]}), struct('x','time (s)','y','$\theta_{pitch}$ (deg)'),Rc0,add_option([],option,addingContents)};
        allData.t_qyaw0 = {struct('x',{time(1)},'y',{[qyaw0{1}',{refeul0(3,:)'}]}), struct('x','time (s)','y','$\theta_{yaw}$ (deg)'),Rc0,add_option([],option,addingContents)};
        allData.velocity0 = {struct('x',{time(1)},'y',{ev0(1)}), struct('x','time (s)','y','velocity(m/s)'), LgndCrt(["$x$","$y$","$z$"],C0),add_option([],option,addingContents)};
        allData.t_vx0 = {struct('x',{time(1)},'y',{vx0}), struct('x','time (s)','y','$v_x$ (m/s)'),C0,add_option([],option,addingContents)};
        allData.t_vy0 = {struct('x',{time(1)},'y',{vy0}), struct('x','time (s)','y','$v_y$ (m/s)'),C0,add_option([],option,addingContents)};
        allData.t_vz0 = {struct('x',{time(1)},'y',{vz0}), struct('x','time (s)','y','$v_z$ (m/s)'),C0,add_option([],option,addingContents)};
        allData.angular_velocity0 = { struct('x',{time(1)},'y',{eO(1)}), struct('x','time (s)','y','angular velocity(rad/s)'), LgndCrt(["$roll$","$pitch$","$yaw$"],C0),add_option([],option,addingContents)};
        allData.t_wroll0 = {struct('x',{time(1)},'y',{wroll0}), struct('x','time (s)','y','$w_{roll}$ (rad/s)'),C0,add_option([],option,addingContents)};
        allData.t_wpitch0 = {struct('x',{time(1)},'y',{wpitch0}), struct('x','time (s)','y','$w_{pitch}$ (rad/s)'),C0,add_option([],option,addingContents)};
        allData.t_wyaw0 = {struct('x',{time(1)},'y',{wyaw0}), struct('x','time (s)','y','$w_{yaw}$ (rad)/s'),C0,add_option([],option,addingContents)};
        allData.three_D0 = {struct('x',{[ex0,refx0]},'y',{[ey0,refy0]},'z',{[ez0,refz0]}), struct('x','$x$ (m)','y','$y$ (m)','z','$z$ (m)'), Rc0,add_option(["aspect","camposition"],option,addingContents)};
        allData.pp0 = {struct('x',{time(1)},'y',{[ep(1),pp(1)]}), struct('x','time (s)','y','position (m)'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],C0),add_option([],option,addingContents)};
        allData.pv0 = {struct('x',{time(1)},'y',{[ev(1),pv(1)]}), struct('x','time (s)','y','velocity (m/s)'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],C0),add_option([],option,addingContents)};
        allData.pq0 = {struct('x',{time(1)},'y',{[eQ,pQ]}), struct('x','time (s)','y','attitude (rad)'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],C0),add_option([],option,addingContents)};
        allData.pw0 = {struct('x',{time(1)},'y',{[eO,pO]}), struct('x','time (s)','y','angular velocity (rad/s)'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],C0),add_option([],option,addingContents)};
        allData.mAll = {struct('x',{time(1)},'y',{mAll}), struct('x','time (s)','y','mass (kg)'), [Ci,C0],add_option([],option,addingContents)};
        allData.dO = {struct('x',{time(1)},'y',{edO}), struct('x','time (s)','y','angular acceleration (rad/$\mathrm{s^2}$)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
        allData.a = {struct('x',{time(1)},'y',{ea}), struct('x','time (s)','y','acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};

        time2 = time(2:end);
        allData.t_p = {struct('x',{[time2,time2]},'y',{[ref,ep(2:end)]}), struct('x','time (s)','y','position (m)'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ Estimator','$y$ Estimator','$z$ Estimator'},add_option([],option,addingContents)};
        allData.x_y = {struct('x',{[epLx,refx]},'y',{[epLy,refy]}), struct('x','$x$ (m)','y','$y$ (m)'),[C(2:end),Cref(2:end)],add_option(["aspect"],option,addingContents)};
        allData.x_z = {struct('x',{[epLx,refx]},'y',{[epLz,refz]}), struct('x','$x$ (m)','y','$z$ (m)'),Rci,add_option(["aspect"],option,addingContents)};
        allData.y_z = {struct('x',{[epLy,refy]},'y',{[epLz,refz]}), struct('x','$x$ (m)','y','$z$ (m)'),Rci,add_option(["aspect"],option,addingContents)};
        allData.t_x = {struct('x',{[time2,time2]},'y',{[epLx,refx]}), struct('x','time (s)','y','$x$ (m)'),[C(2:end),Cref(2:end)],add_option([],option,addingContents)};
        allData.t_y = {struct('x',{[time2,time2]},'y',{[epLy,refy]}), struct('x','time (s)','y','$y$ (m)'),[C(2:end),Cref(2:end)],add_option([],option,addingContents)};
        allData.t_z = {struct('x',{[time2,time2]},'y',{[epLz,refz]}), struct('x','time (s)','y','$z$ (m)'),[C(2:end),Cref(2:end)],add_option([],option,addingContents)};
        allData.error = { struct('x',{time2},'y',{err}), struct('x','time (s)','y','error (m)'), LgndCrt(["$x$","$y$","$z$"],Ci),add_option([],option,addingContents)};
        allData.t_errx = {struct('x',{time2},'y',{errx}), struct('x','time (s)','y','error $x$ (m)'),Ci,add_option([],option,addingContents)};
        allData.t_erry = {struct('x',{time2},'y',{erry}), struct('x','time (s)','y','error $y$ (m)'),Ci,add_option([],option,addingContents)};
        allData.t_errz = {struct('x',{time2},'y',{errz}), struct('x','time (s)','y','error $z$ (m)'),Ci,add_option([],option,addingContents)};
        allData.input = { struct('x',{time2},'y',{cinput}), struct('x','time (s)','y','thrust (N) or trque (Nm)'), LgndCrt(["thrust","roll","pitch","yaw"],Ci),add_option([],option,addingContents)};
        allData.inner_input = { struct('x',{time2},'y',{inner_input}), struct('x','time (s)','y','inner input'), LgndCrt(["roll", "pitch", "thrst", "yaw", "5", "6", "7", "8"],Ci),add_option([],option,addingContents)};
        allData.attitude = {struct('x',{time2},'y',{eqi}), struct('x','time (s)','y','attitude (rad)'), LgndCrt(["$roll$","$pitch$","$yaw$"],Ci),add_option([],option,addingContents)};
        allData.t_qroll = {struct('x',{time2},'y',{qroll}), struct('x','time (s)','y','$q_{roll}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.t_qpitch = {struct('x',{time2},'y',{qpitch}), struct('x','time (s)','y','$q_{pitch}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.t_qyaw = {struct('x',{time2},'y',{qyaw}), struct('x','time (s)','y','$q_{yaw}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.velocity = {struct('x',{time2},'y',{ev(2:end)}), struct('x','time (s)','y','velocity(m/s)'), LgndCrt(["$x$","$y$","$z$"],Ci),add_option([],option,addingContents)};
        allData.t_vx = {struct('x',{time2},'y',{evx}), struct('x','time (s)','y','$v_x$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.t_vy = {struct('x',{time2},'y',{evy}), struct('x','time (s)','y','$v_y$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.t_vz = {struct('x',{time2},'y',{evz}), struct('x','time (s)','y','$v_z$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.angular_velocity = { struct('x',{time2},'y',{ewi}), struct('x','time (s)','y','angular velocity(rad/s)'), LgndCrt(["$roll$","$pitch$","$yaw$"],Ci),add_option([],option,addingContents)};
        allData.t_wroll = {struct('x',{time2},'y',{wroll}), struct('x','time (s)','y','$w_{roll}$ (rad/s)'),Ci,add_option([],option,addingContents)};
        allData.t_wpitch = {struct('x',{time2},'y',{wpitch}), struct('x','time (s)','y','$w_{pitch}$ (rad/s)'),Ci,add_option([],option,addingContents)};
        allData.t_wyaw = {struct('x',{time2},'y',{wyaw}), struct('x','time (s)','y','$w_{yaw}$ (rad)/s'),Ci,add_option([],option,addingContents)};
        %ペイロード位置も3D入れる
        allData.three_D = {struct('x',{[ex0,epLx,refx0]},'y',{[ey0,epLy,refy0]},'z',{[ez0,epLz,refz0]}), struct('x','$x$ (m)','y','$y$ (m)','z','$z$ (m)'), [C0,Rci],add_option(["aspect","camposition"],option,addingContents)};
        allData.expThree_D = {struct('x',{[sx0,epLx,refx0,refx]},'y',{[sy0,epLy,refy0,refy]},'z',{[sz0,epLz,refz0,refz]}), struct('x','$x$ (m)','y','$y$ (m)','z','$z$ (m)'), [C,Cref],add_option(["aspect","camposition"],option,addingContents)};
        allData.pp = {struct('x',{time2},'y',{[ep(2:end),pp(2:end)]}), struct('x','time (s)','y','position (m)'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],Ci),add_option([],option,addingContents)};
        allData.pv = {struct('x',{time2},'y',{[ev(2:end),pv(2:end)]}), struct('x','time (s)','y','velocity (m/s)'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],Ci),add_option([],option,addingContents)};
        allData.pq = {struct('x',{time2},'y',{[eq,pq]}), struct('x','time (s)','y','attitude (rad)'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],Ci),add_option([],option,addingContents)};
        allData.pw = {struct('x',{time2},'y',{[ew,pw]}), struct('x','time (s)','y','angular velocity (rad/s)'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],Ci),add_option([],option,addingContents)};
        allData.inputsum = {struct('x',{{["Thrust","roll","pitch","yaw"]}},'y',{{inputsum}}), struct('x',[],'y','Value'), CDi,add_option([],option,addingContents)};
        allData.inputsumT = {struct('x',{{"thrust"}},'y',{{inputsum(1,:)}}), struct('x',[],'y','Force (N)'), CDi,add_option([],option,addingContents)};
        allData.inputsumTq = {struct('x',{{["roll","pitch","yaw"]}},'y',{{inputsum(2:4,:)}}), struct('x',[],'y','Torque (Nm)'), CDi,add_option([],option,addingContents)};
        allData.inputTrust = {struct('x',{time2},'y',{cinputT}), struct('x','time (s)','y','Thrust (N)'), CDi,add_option([],option,addingContents)};
        allData.inputRoll = {struct('x',{time2},'y',{cinputR}), struct('x','time (s)','y','$T_{roll}$ (Nm)'), CDi,add_option([],option,addingContents)};
        allData.inputPitch = {struct('x',{time2},'y',{cinputP}), struct('x','time (s)','y','$T_{pitch}$ (Nm)'), CDi,add_option([],option,addingContents)};
        allData.inputYaw = {struct('x',{time2},'y',{cinputY}), struct('x','time (s)','y','$T_{yaw}$ (Nm)'), CDi,add_option([],option,addingContents)};
        allData.mL = {struct('x',{time2(1)},'y',{mLi}), struct('x','time (s)','y','mass (kg)'), Ci,add_option([],option,addingContents)};
        allData.minDroneDistance = {struct('x',{time2(1)},'y',{minDroneDistance(1:end-1)}), struct('x','time (s)','y','minimum distance from other drones (m)'), CDi,add_option([],option,addingContents)};
        % allData.ai = {struct('x',{time2},'y',{ai}), struct('x','time (s)','y','accele (m/s^2)'), Ci,add_option([],option,addingContents)};
        % allData.mui = {struct('x',{time2},'y',{mui}), struct('x','time (s)','y','tension (N)'), Ci,add_option([],option,addingContents)};
        for i = 1:logNum-1
            %ペイロードと機体!!!
            %全ての状態について作る
            allData.("DronePayload"+string(i)) = {struct('x',{[time(1),time2(i)]},'y',{[ep(1),epLi(i)]}), struct('x','time (s)','y','position (m)'), ["$x_{0}$","$y_{0}$","$z_{0}$",combineLgntI(["$x$","$y$","$z$"],i)] ,add_option([],option,addingContents)};
            t2 = {ones(lt(i+1),3).*time2{i}'};
            % allData.("linkDir"+string(i)) = {struct('x',{t2},'y',{{linki(:,:,i)'}}), struct('x','time (s)','y','Unit vector'),combineLgntI(["$x~Link$","$y~Link$","$z~Link$"] ,i),add_option([],option,addingContents)};
            % allData.("linkDir"+string(i)) = {struct('x',{[t2,t2,t2]},'y',{[{muid_units(:,:,i)'},{linki(:,:,i)'},{epTi{i}'}]}), struct('x','time (s)','y','Unit vector'),combineLgntI(["$x~\mu d$","$y~\mu d$","$z~\mu d$","$x~Link$","$y~Link$","$z~Link$","$x~pT$","$y~pT$","$z~pT$"] ,i),add_option([],option,addingContents)};
            % allData.("mui"+string(i)) = {struct('x',{t2},'y',{{mui{i}'}}), struct('x','time (s)','y','payload'+string(i)+' tension (N)'),["$x$","$y$","$z$"],add_option([],option,addingContents)};
            %plant
            allData.("pvi"+string(i)) = {struct('x',{t2},'y',{[{pvi{i}'},evi{i}']}), struct('x','time (s)','y','drone'+string(i) +' velocity (m/s)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("pvLi"+string(i)) = {struct('x',{t2},'y',{{pvLi{i}'}}), struct('x','time (s)','y','payload'+string(i) +' velocity (m/s)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};            
            allData.("pwi"+string(i)) = {struct('x',{t2},'y',{{pwi{i}'}}), struct('x','time (s)','y','drone'+string(i) +' angular velocity (rad/s)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            allData.("pwLi"+string(i)) = {struct('x',{t2},'y',{{pwLi{i}'}}), struct('x','time (s)','y','link'+string(i) +' angular velocity (rad/s)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            %plant+est
            allData.("pepi"+string(i)) = {struct('x',{t2},'y',{[{ppi{i}'},{epi{i}'}]}), struct('x','time (s)','y','drone'+string(i) +' position (m)'), ["$x_p$","$y_p$","$z_p$","$x_e$","$y_e$","$z_e$"],add_option([],option,addingContents)};
            allData.("pepLi"+string(i)) = {struct('x',{t2},'y',{[{ppLi{i}'},{epLi{i}'}]}), struct('x','time (s)','y','payload'+string(i) +' position (m)'), ["$x_p$","$y_p$","$z_p$","$x_e$","$y_e$","$z_e$"],add_option([],option,addingContents)};            
            allData.("peqi"+string(i)) = {struct('x',{t2},'y',{[{pqi{i}'},{eqi{i}'}]}), struct('x','time (s)','y','drone'+string(i) +' angle (rad)'), ["$roll_p$","$pitch_p$","$yaw_p$","$roll_e$","$pitch_e$","$yaw_e$"],add_option([],option,addingContents)};
            
            allData.("pevi"+string(i)) = {struct('x',{t2},'y',{[{pvi{i}'},evi{i}']}), struct('x','time (s)','y','drone'+string(i) +' velocity (m/s)'), ["$x_p$","$y_p$","$z_p$","$x_e$","$y_e$","$z_e$"],add_option([],option,addingContents)};
            allData.("pevLi"+string(i)) = {struct('x',{t2},'y',{[{pvLi{i}'},{evLi{i}'}]}), struct('x','time (s)','y','payload'+string(i) +' velocity (m/s)'), ["$x_p$","$y_p$","$z_p$","$x_e$","$y_e$","$z_e$"],add_option([],option,addingContents)};            
            allData.("pewi"+string(i)) = {struct('x',{t2},'y',{[{pwi{i}'},{ewi{i}'}]}), struct('x','time (s)','y','drone'+string(i) +' angular velocity (rad/s)'), ["$roll_p$","$pitch_p$","$yaw_p$","$roll_e$","$pitch_e$","$yaw_e$"],add_option([],option,addingContents)};
            allData.("pewLi"+string(i)) = {struct('x',{t2},'y',{[{pwLi{i}'},{ewLi{i}'}]}), struct('x','time (s)','y','link'+string(i) +' angular velocity (rad/s)'),  ["$roll_p$","$pitch_p$","$yaw_p$","$roll_e$","$pitch_e$","$yaw_e$"],add_option([],option,addingContents)};
            %estimator
            allData.("pi"+string(i)) = {struct('x',{t2},'y',{{epi{i}'}}), struct('x','time (s)','y','drone'+string(i) +' position (m)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("vi"+string(i)) = {struct('x',{t2},'y',{{evi{i}'}}), struct('x','time (s)','y','drone'+string(i) +' velocity (m/s)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("vLi"+string(i)) = {struct('x',{t2},'y',{{evLi{i}'}}), struct('x','time (s)','y','payload'+string(i) +' velocity (m/s)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("attitude"+string(i)) = {struct('x',{t2},'y',{{eqi{i}'}}), struct('x','time (s)','y','drone'+string(i) +' attitude (rad)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            allData.("wi"+string(i)) = {struct('x',{t2},'y',{{ewi{i}'}}), struct('x','time (s)','y','drone'+string(i) +' angular velocity (rad/s)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            allData.("wLi"+string(i)) = {struct('x',{t2},'y',{{ewLi{i}'}}), struct('x','time (s)','y','link'+string(i) +' angular velocity (rad/s)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            
            allData.("constRef"+string(i)) = {struct('x',{time2(1)},'y',{[{constTargetp{i}'},{constp{i}'}]}), struct('x','time (s)','y','drone '+string(i) +' constraint (m)'), ["Target position at current time","Constraint value."],add_option([],option,addingContents)};
            % allData.("ai"+string(i)) = {struct('x',{t2},'y',{{ai{i}'}}), struct('x','time (s)','y','payload'+string(i) +' acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            % allData.("aidrn"+string(i)) = {struct('x',{t2},'y',{{aidrn{i}'}}), struct('x','time (s)','y','drone'+string(i)+' acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            % allData.("dwi"+string(i)) = {struct('x',{{time2{i}'}},'y',{{dwi{i}'}}), struct('x','time (s)','y','link'+string(i)+' angular acceleration (rad/$\mathrm{s^2}$)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
            % allData.("inputsum"+string(i)) = {struct('x',{{["Thrust","roll","pitch","yaw"]}},'y',{{inputsum}}), struct('x',[],'y','Value'), CDi,add_option([],option,addingContents)};
        end
        %二乗誤差平均
        % RMSElog(1,1:13) = ["RMSE","x","y","z","vx","vy","vz","roll","pitch","yaw","wroll","wpitch","wyaw"];
        RMSElog(1,1:7) = ["RMSE","x","y","z","roll","pitch","yaw"];
        RMSE = zeros(logNum,12);
        
        for i =1:logNum
            if i ==1
                RMSE(i,1:3) = rmse(ref0,epL{1,i});
                RMSE(i,4:6) = rmse(refeul0,[qroll0{1}; qpitch0{1}; qyaw0{1}]);
            else
                RMSE(i,1:3) = rmse(ref{1,i-1},epL{1,i});
            end
            RMSElog(i+1,1:7) = [C(i),RMSE(i,1:6)];
            fprintf('#%s RMSE\n',C(i));
            % fprintf('  x\t y\t z\t | vx\t vy\t vz\t| roll\t pitch\t yaw\t | wroll\t wpitch\t wyaw \n');
            % fprintf('  %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f \n',RMSElog(i+1,2:13));
            fprintf('\tx\t y\t z\t roll\t pitch\t yaw\t \n');
            fprintf('\t%.4f\t %.4f\t %.4f\t %.4f\t %.4f\t %.4f\t \n',RMSElog(i+1,2:7));
        end
        % for i =1:logNum
        %     refs = zeros(3,lt(i));%kはtimeの長さ
        %     RMSE(i,1:12) = [rmse(rp{1,i},ep{1,i}),rmse(refs,ev{1,i}),rmse(refs,eq{1,i}),rmse(refs,ew{1,i})];
        %     RMSElog(i+1,1:13) = [c(i),RMSE(i,1:12)];
        %     fprintf('#%s RMSE\n',c(i));
        %     % fprintf('  x\t y\t z\t | vx\t vy\t vz\t| roll\t pitch\t yaw\t | wroll\t wpitch\t wyaw \n');
        %     % fprintf('  %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f \n',RMSElog(i+1,2:13));
        %     fprintf('  x\t y\t z\t \n');
        %     fprintf('  %.4f    %.4f    %.4f \n',RMSElog(i+1,2:4));
        % end
        aveRMSE = mean(RMSE(:,1:3),2);
        allData.rmse = {struct('x',{{["$x$","$y$","$z$","average"]}},'y',{{[RMSE(:,1:3),aveRMSE]'}}), struct('x',[],'y','RMSE  (m)'),C,add_option([],option,addingContents)};         
        allData.xrmse = {struct('x',{{"$x$"}},'y',{{RMSE(:,1)}}), struct('x',[],'y','RMSE  (m)'),C,add_option([],option,addingContents)};         
        allData.yrmse = {struct('x',{{"$y$"}},'y',{{RMSE(:,2)}}), struct('x',[],'y','RMSE  (m)'),C,add_option([],option,addingContents)};         
        allData.zrmse = {struct('x',{{"$z$"}},'y',{{RMSE(:,3)}}), struct('x',[],'y','RMSE  (m)'),C,add_option([],option,addingContents)};         
        toc
end

function option = add_option(add,option,contents)
    if ~isempty(add)
        for i = 1:length(add)
            if add(i) == "aspect"
                option.aspect = contents.aspect;
            elseif add(i) == "camposition"
                option.camposition = contents.camposition;
            end
        end
    end
end

function RMSE = rmse(ref,est)
    n = size(ref,2);
    RMSE_x=sqrt(sum(((ref(1,:)-est(1,:)).^2)/n));
    RMSE_y=sqrt(sum(((ref(2,:)-est(2,:)).^2)/n));
    RMSE_z=sqrt(sum(((ref(3,:)-est(3,:)).^2)/n));
    RMSE = [RMSE_x RMSE_y RMSE_z];
end

%     function f =plot_data_single(figureNumber, figName, branchData)
function plot_data_single(~, ~, branchData)
        data = branchData{1,1};
        label = branchData{1,2};
        legendLabels = branchData{1,3};
        option = branchData{1,4};
        plotNum = length(data.y);
        if ~isfield(data, 'z')
                hold on
                if length(data.x) ~= length(data.y)
                    for i = 1:plotNum 
                        % h(i) = plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth);
                        plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth);
                    end
                elseif ~isstring(data.x{1})
                    for i = 1:plotNum 
                        % h(i) = plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth);
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth);
                    end
                else
                    X = categorical(data.x{1});
                    X = reordercats(X,data.x{1});
                    b = bar(X, data.y{1});
                    % for i = 1:length(b)
                    %     xtips1 = round(b(i).XEndPoints,2,"significant");
                    %     ytips1 = round(b(i).YEndPoints,2,"significant");
                    %     labels1 = string(round(b(i).YData,2,"significant"));
                    %     text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
                    % end
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                % legend([h(3),h(1),h(4),h(2)],legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                % title(option.titleName)
                set(gca,'FontSize',option.fontSize,"TickLabelInterpreter","latex")
                grid on
                grid minor
                hold off
        else
                hold on
                for i = 1:plotNum 
                    plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                zlabel(label.z,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                daspect(option.aspect)
                campos(option.camposition)
                % title(option.titleName)
                set(gca,'FontSize',option.fontSize,"TickLabelInterpreter","latex")
                grid on
                grid minor
                hold off
        end
    end

    function plot_data_multi(branchData, multi)
        data = branchData{1,1};
        label = branchData{1,2};
        legendLabels = branchData{1,3};
        option = branchData{1,4};
        plotNum = length(data.y);
        if ~isfield(data, 'z')
                hold on
                if length(data.x) ~= length(data.y)
                    for i = 1:plotNum 
                        plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                elseif ~isstring(data.x{1})
                    for i = 1:plotNum 
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                else
                    X = categorical(data.x{1});
                    X = reordercats(X,data.x{1});
                    bar(X, data.y{1});
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                set(gca,'FontSize',multi.fontSize,"TickLabelInterpreter","latex")
                pbaspect(multi.pba)  
                grid on
                grid minor
                hold off
        else
                hold on
                for i = 1:plotNum 
                    plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                zlabel(label.z,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                daspect(option.aspect)
                campos(option.camposition)
                set(gca,'FontSize',multi.fontSize,"TickLabelInterpreter","latex")
                pbaspect(multi.pba)  
                grid on
                grid minor
                hold off
        end
    end

    function LC = LgndCrt(a,c)
        na = length(a);
        nc = length(c);
        k=1;
            if nc~=0
                for i = 1:nc
                    for j = 1:na
                        LC{k} = a(j)+" "+[c(i)];
                        k=k+1;
                    end
                end
            else
                for j = 1:na
                        LC{j} = a(j);
                end
            end
    end
    function lgnd = combineLgntI(L,num)
        nL = length(L);
        lgnd = string(zeros(1,nL));
        for i =  1:nL
            charLi = char(L(i));
            lgnd(1,i) =  charLi(1:end-1) + "_{" + num + "}"+ charLi(end);

        end
    end
    function newlog = changeResult(log,controllerName)
        controllerName2 = "result_" + controllerName;
        newlog.k = log.k;
        newlog.fExp = log.fExp;
        newlog.Data.t = log.Data.t;
        newlog.Data.phase = log.Data.phase;
        for i = 1:newlog.k
            newlog.Data.agent.estimator.result{1, i}.state = log.Data.agent.estimator.result{1, i}.(controllerName2);
            newlog.Data.agent.reference.result{1, i}.state = log.Data.agent.reference.result{1, i}.state;
            newlog.Data.agent.controller.result{1, i} = log.Data.agent.controller.result{1, i}.(controllerName);
            newlog.Data.agent.input{1, i} = log.Data.agent.controller.result{1, i}.(controllerName).input;
        end
        newlog.Data.agent.inner_input = log.Data.agent.inner_input;  
    end
    function [mLi,mAll] =sum_mLi(timeAll,logNum,lt,mLi,mAll)
        time = timeAll(2:end);
        timeL = lt(2:end);
        tmpM(1,:) = mLi{1};
        for i = 2:logNum-1
            if timeL(i-1)<timeL(i)%短い制御周期を長い物に合わせる
                tmpM(i,:) = zeros(1,timeL(i-1));
                kNow = 1;
                for j = 1:timeL(i-1)
                    tBase = time{i-1}(j);
                    for k = kNow:timeL(i)
                            tNow =  time{i}(k);
                        if tBase<tNow
                            if k>1
                                if abs(tBase-time{i}(k))<abs(tBase-time{i}(k-1))
                                    tmpM(i,j) = mLi{i}(k);
                                    kNow = k+1;
                                else
                                    tmpM(i,j) = mLi{i}(k-1);
                                    kNow = k;
                                end
                            else
                                tmpM(i,j) = mLi{i}(k);
                            end
                            break
                        end
                        
                    end
                end
                mLi{i}=tmpM(i,:);
                mAll{i}=tmpM(i,:);
                timeL(i) = timeL(i-1);
            elseif timeL(i-1)>timeL(i)%長い制御周期を短い物に合わせる
                tmpM(i,:) = zeros(1,timeL(i-1));
                kNow = 1;
                for j = 1:timeL(i)
                    tBase = time{i}(j);
                    for k = kNow:timeL(i-1)
                            tNow =  time{i-1}(k);
                        if tBase>tNow
                            tmpM(i,k) = mLi{i}(j);
                        else
                            kNow = k;
                            break
                        end
                    end
                end
                mLi{i}=tmpM(i,:);
                mAll{i}=tmpM(i,:);
                timeL(i) = timeL(i-1);
            else
                tmpM(i,:) = mLi{i};
            end
        end
        mAll{logNum} = sum(tmpM);
    end