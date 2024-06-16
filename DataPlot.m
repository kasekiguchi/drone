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
clear t ti k spanIndex tt flightSpan time ref est pp pv pq pw err inp ininp att vel w uHL z1 z2 z3 z4 Trs vf allData
%選択
fMul =1;%複数まとめるかレーダーチャートの時は無視される
fspider=10;%レーダーチャート1
fF=1;%flightのみは１
startTime = 0;
endTime = 1000;%1E3;
%どの時間の範囲を描画するか指定   
% startTime = [10,10,10,80];%モデル誤差用
% endTime = [30,30,30,100];
for i = 1:length(logger.target)
    loggers{i,1} = simplifyLoggerForCoop(logger,i);
end
droneID = logger.target(1:end-1);
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
     n = ["xrmse","yrmse","zrmse","rmse","inputsumT","inputsumTq","t_errx","t_erry","t_errz","input","uHL","uHLsum","t_vx" ,"t_vy" ,"t_vz","t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw","t_x" ,"t_y" ,"t_z","x_y","three_D"];
     % n = ["t_x" ,"t_y" ,"t_z","x_y","three_D"];
     n = "input";
%========================================================================
% multiFigure

nM = {["t_p0" "t_x0" "t_y0" "t_z0"],["error0"	"t_errx0"	"t_erry0"	"t_errz0"],["attitude0"	"t_qroll0"	"t_qpitch0" "t_qyaw0"],["velocity0"	"t_vx0"	"t_vy0"	"t_vz0"	],["angular_velocity0"	"t_wroll0" "t_wpitch0"	"t_wyaw0"],...
    "three_D0",["t_p" "t_x" "t_y"	"t_z"],["error"	"t_errx"	"t_erry"	"t_errz"],["attitude"	"t_qroll"	"t_qpitch"	"t_qyaw"],["velocity"	"t_vx"	"t_vy" "t_vz"],["angular_velocity"	"t_wroll"	"t_wpitch"	"t_wyaw"],...
    "three_D",["inputTrust" "inputRoll"	"inputPitch"	"inputYaw"],"input",["mAll","mL"],"DronePayload"+droneID,"linkDir"+droneID,"mui"+droneID,"ai"+droneID,"aidrn"+droneID,"dwi"+droneID,["a" "dO"]};%比較するとき複数まとめる
multiFigure.layout = cell(1,length(nM));
for i = 1:length(nM)
   nMiLength = length(nM{i});
   tile = [1, factor(nMiLength)];
   if length(tile) == 2  && tile(2) > 3
       tile = [1, factor(nMiLength +1)];
   end
   sortedTile = sort(tile);
   while 1
       lnSortedTile = length(sortedTile);
       if lnSortedTile > 2
        sortedTile = [sortedTile(1)*sortedTile(2),sortedTile(3:end)];
       else
           break
       end
   end
   multiFigure.layout{i} = sortedTile;
end
% multiFigure.title = ["bars","err_inp","vqw","position"];%[" state", " subsystem"];%title name
multiFigure.title = string(zeros(1,length(nM)));%[" state", " subsystem"];%title name

multiFigure.num = length(nM);%figの数
multiFigure.fontSize = 14;
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
addingContents.camposition = [-45,-45,60];

%==================================================================================
%data setting
%図:[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
figName=["t_p" "x_y" "t_x" "t_y" "t_z" "error" "input" "attitude" "velocity" "angular_velocity" "three_D" "uHL" "z1" "z2" "z3" "z4" "inner_input" "vf" "sigma" "pp" "pv" "pq" "pw" "Trs"];
[allData,RMSE] = dataSummarize(loggers, lgnd, option, addingContents, fF, startTime, endTime);
% aaa=fieldnames(allData);
% for i = 1:84
%   aaaa(i) = string(aaa{i});
% end
% bbb=reshape(aaaa,[],12)

%% plot
tic
if multiFigure.f == 1 && fspider ~=1%multiFigure
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
else %singleFigure
    f = zeros(n,1);
     for fN = 1:length(n) 
          f(fN)  = figure('Name',n(fN));
          plot_data_single(fN, n(fN), allData.(n(fN)));
     end
end
toc
isSaved = 0;%input("Save figure : '1' \nNot now : '0' \nFill in : ");
if isSaved
    %% make folder
    %変更しない
        ExportFolder='W:\workspace\Work2023\momose';%実験用pcのパス
            % ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
            % ExportFolder='Data';
        DataFig='figure';%データか図か
        date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
        date2=string(datetime('now','Format','yyyy_MMdd'));%日付
        
    %変更========================================================
        subfolder='exp';%sim or exp
        ExpSimName='sakura2023';%実験,シミュレーション名
        % contents='FT_apx_max';%実験,シミュレーション内容
        contents='demo';%実験,シミュレーション内容
    %==========================================================
    FolderNameD=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNameR=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName));%保存先のpath
    FolderNameF=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    FolderNameL=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'logger');%保存先のpath
    
    %フォルダができてないとき
        if ~exist(FolderNameD,"dir")
            mkdir(FolderNameD);
            mkdir(FolderNameF);
            mkdir(FolderNameL);
            addpath(genpath(ExportFolder));
        end
    %フォルダをrmる
    %     rmpath(genpath(ExportFolder))
    %% save 
    % n=[2,7,10,11];%spider
    if fMul==1
        % nn=string(1:length(nM));
        nn=multiFigure.title ;
    else
        nn=nM;
    end
    nf=length(nn);
    SaveTitle=strings(1,nf);
    %保存する図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
    for i=1:nf
    %     SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',figName(n(i)));
        SaveTitle(i)=strcat(contents,'_',nn(i));
        saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'jpg');
        % saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'fig');
    %     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'eps');
    end
    %%
    %RMSEの保存
    RMSE(1,1)="";
    filenameRMSE=strcat(fullfile(FolderNameR, 'RMSEs'),'.txt');
    fExist=exist(filenameRMSE,'file');
    if fExist
        writematrix([strings(1,4);"<"+contents+">",strings(1,3);RMSE(:,1:4)],strcat(fullfile(FolderNameR, 'RMSEs'),'.txt'),'Delimiter','tab','WriteMode','append')
    else
        writematrix(["<"+contents+">",strings(1,3);RMSE(:,1:4)],strcat(fullfile(FolderNameR, 'RMSEs'),'.txt'),'Delimiter','tab')
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
        ep{i}=[];ev{i}=[];eq{i}=[];ew{i}=[];pL{i}=[];pT{i}=[];
        zero4=zeros(4,lt(i));
        cinput{i}=zero4;inner_input{i}=zeros(8,lt(i));

        %変数に代入
        fieldLog = fieldnames(loggers{i});
        if loggers{i}.fExp
            fieldLog = fieldLog(5:end-1);
            inner_input{i} = loggers{i}.inner_input;
            pp = zeros(3,lt(i));
            pv = zeros(3,lt(i));
            pq = zeros(3,lt(i));
            pw = zeros(3,lt(i));
        else
            fieldLog = fieldLog(find(fieldLog=="sensor"):end);
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
        %plant      : "p" "v" "q" "w" "pL" "vL" "pT" "wL"
        %sensor     : "p" "v" "q" "w" "pL" "vL" "pT" "wL"
        %estimator  : "p" "v" "q" "w" "pL" "vL" "pT" "wL"
        %reference  : "xd" "p" "v" "ai" "mui" "mLi"
        %controller : "input"
        %=========================================================
        time{i} = ts{i}-t0(i);
        err{i} = ep{i}-rp{i};%誤差
        if i == 1
            cmui{i} = loggers{1}.controller.mui;  
            for j =1:logNum-1
                reMui = reshape(cmui{i}(:,j),6,[]);
                muid = reMui(1:3,:);
                muid_norm = sqrt(sum(muid.^2));
                muid_unit = muid./muid_norm;
                muid_units(:,:,j) = muid_unit;
            
                linki(:,:,j) = -eqi{i}(3*j-2:3*j,:);
            end
            refx0{1} = rp{i}(1,:);
            refy0{1} = rp{i}(2,:);
            refz0{1} = rp{i}(3,:);
            ex0{1} = ep{i}(1,:);
            ey0{1} = ep{i}(2,:);
            ez0{1} = ep{i}(3,:);
            errx0{1} = err{i}(1,:);
            erry0{1} = err{i}(2,:);
            errz0{1} = err{i}(3,:);
            ev0{1} = ev{i};
            vx0{1} = ev{i}(1,:);
            vy0{1} = ev{i}(2,:);
            vz0{1} = ev{i}(3,:);
            % qroll0{1} = eQ{i}(1,:);
            % qpitch0{1} = eQ{i}(2,:);
            % qyaw0{1} = eQ{i}(3,:);
            qroll0{1} = cQeul{i}(1,:);
            qpitch0{1} = cQeul{i}(2,:);
            qyaw0{1} = cQeul{i}(3,:);
            wroll0{1} = eO{i}(1,:);
            wpitch0{1} = eO{i}(2,:);
            wyaw0{1} = eO{i}(3,:);
        else
            j = i - 1;
            refx{j} = rp{i}(1,:);
            refy{j} = rp{i}(2,:);
            refz{j} = rp{i}(3,:);
            estx{j} = ep{i}(1,:);
            esty{j} = ep{i}(2,:);
            estz{j} = ep{i}(3,:);
            errx{j} = err{i}(1,:);
            erry{j} = err{i}(2,:);
            errz{j} = err{i}(3,:);
            vi{j} = ev{i};
            vx{j} = ev{i}(1,:);
            vy{j} = ev{i}(2,:);
            vz{j} = ev{i}(3,:);
            eqi{j} = eq{i};
            qroll{j} = eq{i}(1,:);
            qpitch{j} = eq{i}(2,:);
            qyaw{j} = eq{i}(3,:);
            ewi{j} = ew{i};
            wroll{j} = ew{i}(1,:);
            wpitch{j} = ew{i}(2,:);
            wyaw{j} = ew{i}(3,:);
            epLi{j} = epL{i};
            epLx{j} = epL{i}(1,:);
            epLy{j} = epL{i}(2,:);
            epLz{j} = epL{i}(3,:);
            epTi{j} = -epT{i};
            epTx{j} = -epT{i}(1,:);
            epTy{j} = -epT{i}(2,:);
            epTz{j} = -epT{i}(3,:);
            evLx{j} = evL{i}(1,:);
            evLy{j} = evL{i}(2,:);
            evLz{j} = evL{i}(3,:);
            cinputT{j} = cinput{i}(1,:);
            cinputR{j} = cinput{i}(2,:);
            cinputP{j} = cinput{i}(3,:);
            cinputY{j} = cinput{i}(4,:);
            inputsum(:,j) = sqrt(sum((cinput{i}(1:4,:)).^2,2)/lt(i));
            mLi{j} = rmLi{i};
            mAll{j} =  rmLi{i};
            ai{j} = rai{i};
            mui{j} = rmui{i};
            dwi{j} = rdwi{i};
            aidrn{j} = raidrn{i};
        end
    end
        for i = 1:logNum-1
            tmpM(i,:) = mLi{i};
        end
        mAll{logNum} = sum(tmpM);
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
        Rc = [C,"Reference"];
        Rc0 = num2cell([Rc(1),Rc(end)]);
        C0 = num2cell(C(1));
        Rci = num2cell(Rc(2:end));
        Ci = num2cell(C(2:end));
        CDi = num2cell(lgnd.drone);
        t1 = {ones(lt(1),3).*time{1}'};
        allData.t_p0 = {struct('x',{[t1,t1]},'y',{[{rp{1}'},{ep{1}'}]}), struct('x','time (s)','y','payload position (m)'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ Estimator','$y$ Estimator','$z$ Estimator'},add_option([],option,addingContents)};
        allData.x_y0 = {struct('x',{[ex0,refx0]},'y',{[ey0,refy0]}), struct('x','$x$ (m)','y','$y$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.x_z0 = {struct('x',{[ex0,refx0]},'y',{[ez0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.y_z0 = {struct('x',{[ey0,refy0]},'y',{[ez0,refz0]}), struct('x','$x$ (m)','y','$z$ (m)'),Rc0,add_option(["aspect"],option,addingContents)};
        allData.t_x0 = {struct('x',{[time(1),time(1)]},'y',{[ex0,refx0]}), struct('x','time (s)','y','$x$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_y0 = {struct('x',{[time(1),time(1)]},'y',{[ey0,refy0]}), struct('x','time (s)','y','$y$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.t_z0 = {struct('x',{[time(1),time(1)]},'y',{[ez0,refz0]}), struct('x','time (s)','y','$z$ (m)'),Rc0,add_option([],option,addingContents)};
        allData.error0 = { struct('x',{time(1)},'y',{err(1)}), struct('x','time (s)','y','error (m)'), LgndCrt(["$x$","$y$","$z$"],C0),add_option([],option,addingContents)};
        allData.t_errx0 = {struct('x',{time(1)},'y',{errx0} ), struct('x','time (s)','y','error $x$ (m)'),C0,add_option([],option,addingContents)};
        allData.t_erry0 = {struct('x',{time(1)},'y',{erry0} ), struct('x','time (s)','y','error $y$ (m)'),C0,add_option([],option,addingContents)};
        allData.t_errz0 = {struct('x',{time(1)},'y',{errz0} ), struct('x','time (s)','y','error $z$ (m)'),C0,add_option([],option,addingContents)};
        allData.attitude0 = {struct('x',{time(1)},'y',{eQ}), struct('x','time (s)','y','attitude (rad)'), LgndCrt(["$roll$","$pitch$","$yaw$"],C0),add_option([],option,addingContents)};
        allData.t_qroll0 = {struct('x',{time(1)},'y',{qroll0}), struct('x','time (s)','y','$q_{roll}$ (rad)'),C0,add_option([],option,addingContents)};
        allData.t_qpitch0 = {struct('x',{time(1)},'y',{qpitch0}), struct('x','time (s)','y','$q_{pitch}$ (rad)'),C0,add_option([],option,addingContents)};
        allData.t_qyaw0 = {struct('x',{time(1)},'y',{qyaw0}), struct('x','time (s)','y','$q_{yaw}$ (rad)'),C0,add_option([],option,addingContents)};
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
        allData.mAll = {struct('x',{time},'y',{mAll}), struct('x','time (s)','y','mass (kg)'), [Ci,C0],add_option([],option,addingContents)};
        allData.dO = {struct('x',{time(1)},'y',{edO}), struct('x','time (s)','y','angular acceleration (rad/$\mathrm{s^2}$)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
        allData.a = {struct('x',{time(1)},'y',{ea}), struct('x','time (s)','y','acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};

        time2 = time(2:end);
        allData.t_p = {struct('x',{[time2,time2]},'y',{[rp(2:end),ep(2:end)]}), struct('x','time (s)','y','position (m)'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ Estimator','$y$ Estimator','$z$ Estimator'},add_option([],option,addingContents)};
        allData.x_y = {struct('x',{[estx,refx]},'y',{[esty,refy]}), struct('x','$x$ (m)','y','$y$ (m)'),Rci,add_option(["aspect"],option,addingContents)};
        allData.x_z = {struct('x',{[estx,refx]},'y',{[estz,refz]}), struct('x','$x$ (m)','y','$z$ (m)'),Rci,add_option(["aspect"],option,addingContents)};
        allData.y_z = {struct('x',{[esty,refy]},'y',{[estz,refz]}), struct('x','$x$ (m)','y','$z$ (m)'),Rci,add_option(["aspect"],option,addingContents)};
        allData.t_x = {struct('x',{[time2,time2]},'y',{[estx,refx]}), struct('x','time (s)','y','$x$ (m)'),Rci,add_option([],option,addingContents)};
        allData.t_y = {struct('x',{[time2,time2]},'y',{[esty,refy]}), struct('x','time (s)','y','$y$ (m)'),Rci,add_option([],option,addingContents)};
        allData.t_z = {struct('x',{[time2,time2]},'y',{[estz,refz]}), struct('x','time (s)','y','$z$ (m)'),Rci,add_option([],option,addingContents)};
        allData.error = { struct('x',{time2},'y',{err}), struct('x','time (s)','y','error (m)'), LgndCrt(["$x$","$y$","$z$"],Ci),add_option([],option,addingContents)};
        allData.t_errx = {struct('x',{time2},'y',{errx}), struct('x','time (s)','y','error $x$ (m)'),Ci,add_option([],option,addingContents)};
        allData.t_erry = {struct('x',{time2},'y',{erry}), struct('x','time (s)','y','error $y$ (m)'),Ci,add_option([],option,addingContents)};
        allData.t_errz = {struct('x',{time2},'y',{errz}), struct('x','time (s)','y','error $z$ (m)'),Ci,add_option([],option,addingContents)};
        allData.input = { struct('x',{time2},'y',{cinput}), struct('x','time (s)','y','input (N)'), LgndCrt(["T","roll","pitch","yaw"],Ci),add_option([],option,addingContents)};
        allData.inner_input = { struct('x',{time2},'y',{inner_input}), struct('x','time (s)','y','inner input'), LgndCrt(["roll", "pitch", "thrst", "yaw", "5", "6", "7", "8"],Ci),add_option([],option,addingContents)};
        allData.attitude = {struct('x',{time2},'y',{eqi}), struct('x','time (s)','y','attitude (rad)'), LgndCrt(["$roll$","$pitch$","$yaw$"],Ci),add_option([],option,addingContents)};
        allData.t_qroll = {struct('x',{time2},'y',{qroll}), struct('x','time (s)','y','$q_{roll}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.t_qpitch = {struct('x',{time2},'y',{qpitch}), struct('x','time (s)','y','$q_{pitch}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.t_qyaw = {struct('x',{time2},'y',{qyaw}), struct('x','time (s)','y','$q_{yaw}$ (rad)'),Ci,add_option([],option,addingContents)};
        allData.velocity = {struct('x',{time2},'y',{ev(2:end)}), struct('x','time (s)','y','velocity(m/s)'), LgndCrt(["$x$","$y$","$z$"],Ci),add_option([],option,addingContents)};
        allData.t_vx = {struct('x',{time2},'y',{vx}), struct('x','time (s)','y','$v_x$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.t_vy = {struct('x',{time2},'y',{vy}), struct('x','time (s)','y','$v_y$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.t_vz = {struct('x',{time2},'y',{vz}), struct('x','time (s)','y','$v_z$ (m/s)'),Ci,add_option([],option,addingContents)};
        allData.angular_velocity = { struct('x',{time2},'y',{ewi}), struct('x','time (s)','y','angular velocity(rad/s)'), LgndCrt(["$roll$","$pitch$","$yaw$"],Ci),add_option([],option,addingContents)};
        allData.t_wroll = {struct('x',{time2},'y',{wroll}), struct('x','time (s)','y','$w_{roll}$ (rad/s)'),Ci,add_option([],option,addingContents)};
        allData.t_wpitch = {struct('x',{time2},'y',{wpitch}), struct('x','time (s)','y','$w_{pitch}$ (rad/s)'),Ci,add_option([],option,addingContents)};
        allData.t_wyaw = {struct('x',{time2},'y',{wyaw}), struct('x','time (s)','y','$w_{yaw}$ (rad)/s'),Ci,add_option([],option,addingContents)};
        %ペイロード位置も3D入れる
        allData.three_D = {struct('x',{[ex0,epLx,refx0]},'y',{[ey0,epLy,refy0]},'z',{[ez0,epLz,refz0]}), struct('x','$x$ (m)','y','$y$ (m)','z','$z$ (m)'), [C0,Rci],add_option(["aspect","camposition"],option,addingContents)};
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
        allData.mL = {struct('x',{time2},'y',{mLi}), struct('x','time (s)','y','mass (kg)'), Ci,add_option([],option,addingContents)};
        % allData.ai = {struct('x',{time2},'y',{ai}), struct('x','time (s)','y','accele (m/s^2)'), Ci,add_option([],option,addingContents)};
        % allData.mui = {struct('x',{time2},'y',{mui}), struct('x','time (s)','y','tension (N)'), Ci,add_option([],option,addingContents)};
        for i = 1:logNum-1
            %ペイロードと機体!!!
            %全ての状態について作る
            allData.("DronePayload"+string(i)) = {struct('x',{[time(1),time2(i)]},'y',{[ep(1),epLi(i)]}), struct('x','time (s)','y','position (m)'), ["$x_{0}$","$y_{0}$","$z_{0}$",combineLgntI(["$x$","$y$","$z$"],i)] ,add_option([],option,addingContents)};
            t2 = {ones(lt(i+1),3).*time2{i}'};
            allData.("linkDir"+string(i)) = {struct('x',{t2},'y',{{linki(:,:,i)'}}), struct('x','time (s)','y','Unit vector'),combineLgntI(["$x~Link$","$y~Link$","$z~Link$"] ,i),add_option([],option,addingContents)};
            % allData.("linkDir"+string(i)) = {struct('x',{[t2,t2,t2]},'y',{[{muid_units(:,:,i)'},{linki(:,:,i)'},{epTi{i}'}]}), struct('x','time (s)','y','Unit vector'),combineLgntI(["$x~\mu d$","$y~\mu d$","$z~\mu d$","$x~Link$","$y~Link$","$z~Link$","$x~pT$","$y~pT$","$z~pT$"] ,i),add_option([],option,addingContents)};
            allData.("mui"+string(i)) = {struct('x',{t2},'y',{{mui{i}'}}), struct('x','time (s)','y','payload'+string(i)+' tension (N)'),["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("ai"+string(i)) = {struct('x',{t2},'y',{{ai{i}'}}), struct('x','time (s)','y','payload'+string(i) +' acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("aidrn"+string(i)) = {struct('x',{t2},'y',{{aidrn{i}'}}), struct('x','time (s)','y','drone'+string(i)+' acceleration (m/$\mathrm{s^2}$)'), ["$x$","$y$","$z$"],add_option([],option,addingContents)};
            allData.("dwi"+string(i)) = {struct('x',{{time2{i}'}},'y',{{dwi{i}'}}), struct('x','time (s)','y','link'+string(i)+' angular acceleration (rad/$\mathrm{s^2}$)'), ["$roll$","$pitch$","$yaw$"],add_option([],option,addingContents)};
        end
        %二乗誤差平均
        RMSElog(1,1:13) = ["RMSE","x","y","z","vx","vy","vz","roll","pitch","yaw","wroll","wpitch","wyaw"];
        RMSE = zeros(logNum,12);
        
        for i =1:logNum
            RMSE(i,1:3) = rmse(rp{1,i},ep{1,i});
            RMSElog(i+1,1:4) = [C(i),RMSE(i,1:3)];
            fprintf('#%s RMSE\n',C(i));
            % fprintf('  x\t y\t z\t | vx\t vy\t vz\t| roll\t pitch\t yaw\t | wroll\t wpitch\t wyaw \n');
            % fprintf('  %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f \n',RMSElog(i+1,2:13));
            fprintf('  x\t y\t z\t \n');
            fprintf('  %.4f    %.4f    %.4f \n',RMSElog(i+1,2:4));
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
                        h(i) = plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth);
                        % plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
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