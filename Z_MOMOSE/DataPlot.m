%　DataPlot
%% set path
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%%
close all
clear t ti k spanIndex tt flightSpan time ref est pp pv pq pw err inp ininp att vel w uHL z1 z2 z3 z4 Trs vf allData
%import
%選択
% fLogN=3;%loggerの数が一つの時１ 2つの時:2, other:3
fLSorFT=3;%LS:1,FT:2,No:>=3
fMul =1;%複数まとめるかレーダーチャートの時は無視される
fspider=10;%レーダーチャート1
fF=10;%flightのみは１

%どの時間の範囲を描画するか指定   
% startTime = 0;
% endTime = 100;
startTime = 0;
endTime = 1E3;

    loggers = {
                % log_saddle,...
                % log_sadlle_FTxy
                % log_circle_FTxy2
                % log_hover
                % log_cricle,log_circle_FTxy2
                % log_saddle,log_sadlle_FTxy
                % log_HL_saddle
                % log_HL_saddle
                % log_EL_saddle
                % log_LS15d3
                % log_FT15d3
                % log_EKF_B_0

                % logger_FB_PP11,logger_FT_PP11
                % log_HLLS_srv_8s2
                % log_HLFT_srv_8s2
                % log_HLLS_srv_8s
                % log_HLaFTC_srv_8s

                % logger_FT_c_09
                % log_FT_HLservo_z,log_FT_servo_z
                % log_FT_Zservo,log_FT_Zservo_gain_n1
                % log_FTonly2
                % log_HL2
                % log_FT
                % log_FT_Zservo_gain_n1,...
                % log_FT2_servo
                % log_HLFT
                % log_HLLS,...
                % log_HLFT
                % log_FTonly
                log_FT


                % gui.logger
        };
    c=[
        % "HL","IOL"
        % "FTservoZ","FTservoZn1"
        % "HLLS"
        % "HLFTservo"
        %,"ELFT","ELLS","ELFT"
           % "HLft"%
           "ELft"
           % "ELft"
        ];
%========================================================================
%図を選ぶ[1:"t_p" 2:"x_y" 3:"t_x" 4:"t_y" 5:"t_z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 
%              11:"three_D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma" a
%               20:"pp" 21:"pv" 22:"pq" 23:"pw" 24:"Trs"];
%========================================================================
%singleFigure
     % n=[1:16,18 20:24];
     % n = [1:17,24];
     % n = [1:11];
     % n=["t_p" ,"x_y" ,"t_x","t_y","t_z","error","input","Trs","attitude","velocity","angular_velocity" ,"three_D"];
     n=["t_errx","t_erry","t_errz","three_D"];
     % n=["t_p","input","u","Trs","attitude","velocity","angular_velocity"];
     % n = "inner_input";
     % n=1;
%========================================================================
% multiFigure

% nM = {["three_D","t_errx","t_erry","t_errz"]};%比較するとき複数まとめる
% multiFigure.layout = {[2,2]};
% multiFigure.title = ["position_error"];%[" state", " subsystem"];%title name

% nM = {["z1","z2","z3","z4"],["F1z1","F2z2","F3z3","F4z4","uHL"]};%比較するとき複数まとめる
% multiFigure.layout = {[2,2],[2,3]};
% multiFigure.title = [" subsystem","vinput poly"];%[" state", " subsystem"];%title name

nM = {["t_p", "velocity", "attitude","angular_velocity","Trs", "three_D"],["input", "Trs","x_y" ,"t_x" ,"t_y" ,"t_z"],["z1","z2","z3","z4"],["input","inner_input","uHL","Trs"]};%複数まとめる
multiFigure.layout = {[2,3],[2,3],[2,2],[2,2]};%{[2,3],[2,3]}
multiFigure.title = [" state1", " state2 and input", " subsystem","input2"];%[" state", " subsystem"];%title name

% nM = {["t_x" ,"t_y" ,"t_z","t_vx" ,"t_vy" ,"t_vz"],["t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw"],["input","inner_input","Trs","x_y","three_D"],["t_errx","t_erry","t_errz"]};%比較するとき複数まとめる
% multiFigure.layout = {[2,3],[2,3],[2,3],[1,3]};%{[2,3],[2,3]}
% multiFigure.title = [" position_velocity", "attitude_angulerVelocity", "input_3D","error"];%[" state", " subsystem"];%title name

% nM = {["t_x" ,"t_y" ,"t_z","t_errx","t_erry","t_errz"],["t_vx" ,"t_vy" ,"t_vz","t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw"],["input","Trs","x_y","three_D","inner_input"]};%比較するとき複数まとめる
% multiFigure.layout = {[2,3],[3,3],[2,3]};%{[2,3],[2,3]}
% multiFigure.title = [" position_error", "v_q_w", "input_3D"];%[" state", " subsystem"];%title name

% nM = {["t_x" ,"t_y" ,"t_z","t_errx","t_erry","t_errz"],["t_vx" ,"t_vy" ,"t_vz","t_qroll" ,"t_qpitch" ,"t_qyaw","t_wroll" ,"t_wpitch" ,"t_wyaw"],["input","Trs","three_D","x_y","x_z","y_z"]};%比較するとき複数まとめる
% multiFigure.layout = {[2,3],[3,3],[2,3]};%{[2,3],[2,3]}
% multiFigure.title = [" position_error", "v_q_w", "input_3D"];%[" state", " subsystem"];%title name


multiFigure.num = length(nM);%figの数
multiFigure.fontSize = 14;
multiFigure.pba = [1,0.78084714548803,0.78084714548803];%各図の縦横比
multiFigure.padding = 'tight';
multiFigure.tileSpacing = 'tight';
multiFigure.f = fMul;

option.lineWidth = 2;%linewidth
option.fontSize = 18;%デフォルト9，フォントサイズ変更
option.legendColumns = 2;
option.aspect = [];
option.camposition = [];
% option.fExp = fExp;

%タイトルの名前を付ける
if fLSorFT==1 %&& fLogN ==1
        option.titleName="LS";
elseif fLSorFT==2 %&& fLogN ==1
        option.titleName="FT";
elseif fLSorFT>2 %||fLogN~=1
        option.titleName=[];
end
LSorFT = option.titleName;
%figごとに追加する場合のもの
addingContents.aspect = [1,1,1];
addingContents.camposition = [-45,-45,60];

%==================================================================================
%data setting
%図:[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
figName=["t_p" "x_y" "t_x" "t_y" "t_z" "error" "input" "attitude" "velocity" "angular_velocity" "three_D" "uHL" "z1" "z2" "z3" "z4" "inner_input" "vf" "sigma" "pp" "pv" "pq" "pw" "Trs"];
[allData,RMSE] = dataSummarize(loggers, c, option, addingContents, fF, startTime, endTime);
% for i =1:2
%     zm1(i)=max(abs(allData.z1{1, 1}.y{1, 1}(i,:)));
%     zm4(i)=max(abs(allData.z4{1, 1}.y{1, 1}(i,:)));
%     um1(i)=max(abs(allData.F1z1{1, 1}.y{1, 1}(i,:)));
%     um4(i)=max(abs(allData.F4z4{1, 1}.y{1, 1}(i,:)));
% end
% for i =1:4
%     zm2(i)=max(abs(allData.z2{1, 1}.y{1, 1}(i,:)));
%     zm3(i)=max(abs(allData.z3{1, 1}.y{1, 1}(i,:)));
%     um2(i)=max(abs(allData.F2z2{1, 1}.y{1, 1}(i,:)));
%     um3(i)=max(abs(allData.F3z3{1, 1}.y{1, 1}(i,:)));
% end
% zm1 = double(zm1)
% zm2 = double(zm2)
% zm3 = double(zm3)
% zm4 = double(zm4)
% um1 = double(um1)
% um2 = double(um2)
% um3 = double(um3)
% um4 = double(um4)
% allData.figName : (data, label, legendLabels, option)   
%option : titleName, lineWidth, fontSize, legend, aspect, campositon
%=====================================================
% allData.example = {struct('x',{{time1,time2}},'y',{{data1,data2,data3}}),...
%                                 struct('x','xlabel [dim]','y','ylabel [dim]','z','zlabel [dim]'),...
%                                 {'$xleg$','$yleg$','$zleg$'},...
%                                 add_option(["aspect","camposition"],option,addingContents)};
%=====================================================

%plot
if multiFigure.f == 1 && fspider ~=1%multiFigure
    for mfn = 1: multiFigure.num
        f(mfn)=figure('name',multiFigure.title(mfn));
        f(mfn).WindowState = 'maximized';
        tpolt = tiledlayout(multiFigure.layout{1,mfn}(1), multiFigure.layout{1,mfn}(2));
        tpolt.Padding = multiFigure.padding;%'tight'; %'compact';
        tpolt.TileSpacing = multiFigure.tileSpacing;%tight';%  'compact';
        % nMT = nM{mfn}';    
        for fN = 1:length(nM{mfn}) 
                nexttile
                % plot_data_multi(allData.(figName(nM{mfn}(fN))), multiFigure);
                plot_data_multi(allData.(nM{mfn}(fN)), multiFigure);
                % plot_data_multi(allData.(nMT(fN)), multiFigure);
        end
        % copygraphics(f(mfn))
        if ~isempty(LSorFT)
            title(tpolt,option.titleName+ multiFigure.title(1,mfn));
            option.titleName = LSorFT;
        end
    end
elseif multiFigure.f ~= 1&&fspider ~=1 %singleFigure
     for fN = 1:length(n) 
         % f(n(fN))  = figure('Name',figName(n(fN)));
          % plot_data_single(fN, figName(n(fN)), allData.(figName(n(fN))));
          % f(n(fN))  = figure('Name',n(fN));
          f(fN)  = figure('Name',n(fN));
          plot_data_single(fN, n(fN), allData.(n(fN)));
          % plot_data_single(fN, figName(n(fN)), allData.(n(fN)));
     end
elseif fspider ==1
    %x,dx,ddx,dddx,rmse
    %ang(roll pitch yaw),angver(roll pitch yaw)
    %inp:x,dx,ddx,dddxに加えられたとき
    figName = ["subsystem_x","angle_angleVel","angle_vel","err_RMSE","p","velocity","p_vel","subsystem_y","uHL","input","qw_RMSE","pv_RMSE"];%%
%     figName = ["angle_angleVel","angle_vel","pv","input","qw_RMSE","pv_RMSE"];%%
    %legend
    AL={{'$x$', '$dx$', '$ddx$', '$dddx$'},...
         {'$\theta_{roll}$ [rad]', '$\theta_{pitch}$ [rad]', '$\theta_{yaw}$ [rad]','$w_{roll}$ [rad/s]', '$w_{pitch}$ [rad/s]', '$w_{yaw}$ [rad/s]'},...
         {'$w_{roll}$ [rad/s]', '$w_{pitch}$ [rad/s]', '$w_{yaw}$ [rad/s]'},...
         {'$error_x$ [m]','$error_y$ [m]','$error_z$ [m]','$x$ RMSE [m]','$y$ RMSE [m]','$z$ RMSE [m]'},...
         {'$x$ [m]','$y$ [m]','$z$ [m]'}, ...
         {'$v_x$ [m/s]','$v_y$ [m/s]','$v_z$ [m/s]'}, ...
         {'$x$ [m]','$y$ [m]','$z$ [m]','$v_x$ [m/s]','$v_y$ [m/s]','$v_z$ [m/s]'},...
         {'$y$', '$dy$', '$ddy$', '$dddy$'},...
         {'$z$', '$x$', '$y$', '$yaw$'},...
         {'rotor$1$ [N]', 'rotor$2$ [N]', 'rotor$3$ [N]', 'rotor$4$ [N]'},...
         {'$\theta_{roll}$  [rad]','$\theta_{pitch}$  [rad]','$\theta_{yaw}$  [rad]'},...%          {'$\theta_{roll}$  [rad]','$\theta_{pitch}$  [rad]','$\theta_{yaw}$  [rad]','$w_{roll}$  [rad/s]','$w_{pitch}$  [rad/s]','$w_{yaw}$  [rad/s]'},...
         {'$x$  [m]','$y$  [m]','$z$  [m]'}};%{'$x$  [m]','$y$  [m]','$z$  [m]','$v_x$  [m/s]','$v_y$  [m/s]','$v_z$  [m/s]'}
    legend_str = c;
    lengthFN=length(figName);
    P =cell(1,lengthFN);
    D = cell(1,lengthFN);
     for i = 1:logNum
        D{1} = [z2{i}(1,end),z2{i}(2,end),z2{i}(3,end),z2{i}(4,end)];
        D{2} = [att{i}(1:3,end)',w{i}(1:3,end)'];
        D{3} = w{i}(1:3,end)';
        D{4} = [err{i}(1:3,end)',RMSE(i,1:3)];
        D{5} = est{i}(1:3,end)';
        D{6} = vel{i}(1:3,end)';
        D{7} = [est{i}(1:3,end)',vel{i}(1:3,end)'];
        D{8} = [z3{i}(1,end),z3{i}(2,end),z3{i}(3,end),z3{i}(4,end)];
        D{9} = uHL{i}(1:4,end)';
        D{10} = inp{i}(1:4,end)';
        D{11} = RMSE(i,7:9);%7:12
        D{12} = RMSE(i,1:3);%1:3
         for nFN = 1:lengthFN
            P{nFN} = abs([P{nFN}; D{nFN}]);
         end
     end
        nFN = 1;
        for nFN = 1:lengthFN
           ALmax(nFN) = max(max(P{nFN},[],2));
%            ALmin(nFN) = min(min(P{nFN},[],2));
           ALmin(nFN) = 0;
        end

     for fN = 1:lengthFN
            lAL = length(AL{fN});
            f(fN)  = figure('Name',figName(fN));
            axes_precision = 2;
            FS=26;
            if ALmax(fN)>0.1
                spider_plot(P{fN},...
                    'AxesLabels', AL{fN},...
                    'AxesInterval', 4,...
                    'AxesDisplay', 'one',...
                    'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...
                    'AxesInterpreter','latex',...
                    'AxesPrecision', axes_precision,...
                    'FillOption', 'on',...
                    'FillTransparency',0.1, ...
                    'LineWidth', 3,...
                    'AxesFontSize', FS,...
                    'LabelFontSize', FS,...
                    'AxesLabelsOffset', 0.24,...
                    'BackgroundColor','white',...
                    'AxesLabelsEdge', 'none',...
                    'MaxUnderEn1',0);
            else
                 spider_plot(P{fN},...
                    'AxesLabels', AL{fN},...
                    'AxesInterval', 4,...
                    'AxesDisplay', 'one',...
                    'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...
                    'AxesInterpreter','latex',...
                    'AxesPrecision', 1,...
                    'FillOption', 'on',...
                    'FillTransparency',0.1, ...
                    'LineWidth', 3,...
                    'AxesFontSize', FS,...
                    'LabelFontSize', FS,...
                    'AxesLabelsOffset', 0.24,...
                    'BackgroundColor','white',...
                    'AxesLabelsEdge', 'none',...
                    'MaxUnderEn1',1);
            end
%             'AxesDisplay', 'data'
%             legend_str = {'D1', 'D2','D3'};
            legend(legend_str,'Interpreter','latex','Location','northeast');
%             legend(legend_str,'Interpreter','latex','Position',[0.2 0.6 0.1 0.2]);
            set(gca,'FontSize',FS)
     end
end

%             'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...


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
    ExpSimName='demoooo';%実験,シミュレーション名
    % contents='FT_apx_max';%実験,シミュレーション内容
    contents='demo';%実験,シミュレーション内容
%==========================================================
FolderNameD=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
FolderNameR=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName));%保存先のpath
FolderNameF=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath

%フォルダができてないとき
    addpath(genpath(ExportFolder));
    mkdir(FolderNameD);
    mkdir(FolderNameF);
%フォルダをrmる
%     rmpath(genpath(ExportFolder))
%% save 
% n=[2,7,10,11];%spider
if fMul==1
    % nn=string(1:length(nM));
    nn=multiFigure.title ;
else
    nn=n;
end
nf=length(nn);
SaveTitle=strings(1,nf);
%保存する図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
for i=1:nf
%     SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',figName(n(i)));
    SaveTitle(i)=strcat(contents,'_',nn(i));
%     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'jpg');
    saveas(f(i), fullfile(FolderNameF, SaveTitle(i)),'fig');
%     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'eps');
end

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

%% functions
function [allData,RMSElog]=dataSummarize(loggers, c, option, addingContents, fF, startTime, endTime)
        if fF==1
            logNum = length(loggers);
            for i = 1:logNum
                t{i} = loggers{i}.Data.t';
                k(i)=loggers{i}.k;
                ti{i}=t{i}(1:k(i));
                % kf(i)=find(loggers{i}.Data.phase == 102,1,'first')+1;
                % ke(i)=find(loggers{i}.Data.phase == 102,1,'last');
                kf(i)=find(loggers{i}.Data.phase == 116,1,'first')+1;
                ke(i)=find(loggers{i}.Data.phase == 116,1,'last');
        
                sTime(i) = ti{i}(kf(i)) + startTime;
                eTime(i) = ti{i}(kf(i)) + endTime;
                ti{i} = ti{i}(1:ke(i));
                spanIndex{i} = find(ti{i} <= eTime(i) & ti{i} >= sTime(i) );
                kf(i) = min(spanIndex{i});
                ke(i) = max(spanIndex{i});
        
                tt(i)=ti{i}(kf(i));
                flightSpan(i)=ke(i)-kf(i);
            end
            %表示する時間を最小のものに合わせる
            minSpan = min(flightSpan);
            for i = 1:logNum
                ke(i) = kf(i) + minSpan;
            end
    else 
        %flite のみでない場合
        logNum = length(loggers);
        for i = 1:logNum
            t{i} = loggers{i}.Data.t';
            k(i)=loggers{i}.k;
            ti{i}=t{i}(1:k(i));
            sTime(i) = ti{i}(1) + startTime;
            eTime(i) = ti{i}(1) + endTime;
            spanIndex{i} = find(ti{i} <= eTime(i) & ti{i} >= sTime(i) );
            kf(i) = min(spanIndex{i});
            ke(i) = max(spanIndex{i});
            tt(i)=0;
        end
    end
        for i = 1:logNum
            lt(i)=ke(i)-kf(i) + 1;
            time{i}=zeros(1,lt(i));
            ref{i}=zeros(3,lt(i));
            est{i}=zeros(3,lt(i));
            pp{i}=zeros(3,lt(i));
            pv{i}=zeros(3,lt(i));
            pq{i}=zeros(3,lt(i));
            pw{i}=zeros(3,lt(i));
            err{i}=zeros(3,lt(i));
            % if fExp ==1
                inp{i}=zeros(4,lt(i));
                u{i}=zeros(4,lt(i));
            % else
            %     inp{i}=zeros(,lt(i));
            % end
            ininp{i}=zeros(8,lt(i));
            att{i}=zeros(3,lt(i)); 
            vel{i}=zeros(3,lt(i));
            w{i}=zeros(3,lt(i));
            uHL{i}=zeros(4,lt(i)); 
            Trs{i}=zeros(3,lt(i));
            if loggers{i}.fExp
                tindex(i)=find(loggers{i}.Data.phase == 116,1,'first');
                if isfield(loggers{i}.Data.agent.controller.result{1, tindex(i)},'z1') 
                    if  length(loggers{i}.Data.agent.controller.result{1, tindex(i)}.z1)==2 
                        z1{i}=zeros(2,lt(i));
                        fexpandS=0;
                    else
                        z1{i}=zeros(4,lt(i));
                        Trs{i}=zeros(2,lt(i));
                        fexpandS=1;
                    end
                else
                    z1{i}=zeros(2,lt(i));
                        fexpandS=0;
                end
            else
                tindex(i)=1;
                if length(loggers{i}.Data.agent.controller.result{1, 1}.z1)==2
                    z1{i}=zeros(2,lt(i));
                    F1z1{i}=zeros(2,lt(i));
                    fexpandS=0;
                else
                    z1{i}=zeros(4,lt(i));
                    F1z1{i}=zeros(4,lt(i));
                    fexpandS=1;
                end
            end
            z2{i}=zeros(4,lt(i));
            z3{i}=zeros(4,lt(i));
            z4{i}=zeros(2,lt(i));
            vf{i}=zeros(4,lt(i));
            F2z2{i}=zeros(4,lt(i));
            F3z3{i}=zeros(4,lt(i));
            F4z4{i}=zeros(2,lt(i));
            j=1;
            if loggers{i}.fExp
                    for i2=kf(i):1:ke(i)
                        time{i}(j)=ti{i}(i2)-tt(i);
                        ref{i}(:,j)=loggers{i}.Data.agent.reference.result{1,i2}.state.p(1:3);
                        est{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.p(1:3);
                        err{i}(:,j)=est{i}(:,j)-ref{i}(:,j);%誤差        
                        inp{i}(:,j)=loggers{i}.Data.agent.input{1,i2}(1:4);
                        % u{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.u;
                        ininp{i}(:,j)=loggers{i}.Data.agent.inner_input{1,i2};
                        att{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.q(1:3);
                        vel{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.v(1:3);
                        w{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.w(1:3);
                        j=j+1;
                    end
                    if isfield(loggers{i}.Data.agent.controller.result{1, tindex(i)},'z1') 
                         j=1;
                        if fF ==1
                            for i2 = kf(i):ke(i)
                                uHL{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.uHL;
                                z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z1;
                                z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z2;
                                z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z3;
                                z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z4;
                                % F1z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F1z1;
                                % F2z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F2z2;
                                % F3z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F3z3;
                                % F4z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F4z4;
                                j=j+1;
                            end
                        else 
                            for j = tindex(i):ke(i)
                                uHL{i}(:,j)=loggers{i}.Data.agent.controller.result{1, j}.uHL;
                                z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, j}.z1;
                                z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, j}.z2;
                                z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, j}.z3;
                                z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, j}.z4;
                                % F1z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F1z1;
                                % F2z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F2z2;
                                % F3z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F3z3;
                                % F4z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F4z4;
                            end
                        end
                        
                    end
            else 
                    for i2=kf(i):1:ke(i)
                    time{i}(j)=ti{i}(i2)-tt(i);
                    ref{i}(:,j)=loggers{i}.Data.agent.reference.result{1,i2}.state.p(1:3);
                    est{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.p(1:3);
                    pp{i}(:,j)=loggers{i}.Data.agent.plant.result{1,i2}.state.p(1:3);
                    pv{i}(:,j)=loggers{i}.Data.agent.plant.result{1,i2}.state.v(1:3);
                    pq{i}(:,j)=loggers{i}.Data.agent.plant.result{1,i2}.state.q(1:3);
                    pw{i}(:,j)=loggers{i}.Data.agent.plant.result{1,i2}.state.w(1:3);
                    err{i}(:,j)=est{i}(:,j)-ref{i}(:,j);%誤差        
                    inp{i}(:,j)=loggers{i}.Data.agent.input{1,i2}(1:4);
                    att{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.q(1:3);
                    vel{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.v(1:3);
                    w{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.w(1:3);
                    uHL{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.uHL;
                    u{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.u;
                    % u{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.input;
                    z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z1;
                    z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z2;
                    z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z3;
                    z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z4;
                    F1z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F1z1;
                    F2z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F2z2;
                    F3z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F3z3;
                    F4z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.F4z4;
                    j=j+1;
                    end
            end
            j=1;
            if isprop(loggers{i}.Data.agent.estimator.result{1, 1}.state,'Trs')
                for i2=kf(i):1:ke(i)
                    Trs{i}(1:2,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.Trs(1:2);
                    Trs{i}(3,j)=loggers{i}.Data.agent.controller.result{1, i2}.u(1);
                    j=j+1;
                end
            else
                if isfield(loggers{i}.Data.agent.controller.result{1, tindex(i)},'z1') 
                    % for i2=kf(i):1:ke(i)
                    %     vf{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.vf;
                    %     j=j+1;
                    % end
                end
            end
        end
        %plotする為の構造体を作成する
        % allData.figName : (data, label, legendLabels, option)   
        %option : titleName, lineWidth, fontSize, legend, aspect, campositon
        %=====================================================
        % allData.example = {struct('x',{{time1,time2}},'y',{{data1,data2,data3}}),...
        %                                 struct('x','xlabel [dim]','y','ylabel [dim]','z','zlabel [dim]'),...
        %                                 {'$xleg$','$yleg$','$zleg$'},...
        %                                 add_option(["aspect","camposition"],option,addingContents)};
        %=====================================================
        refx = ref{1}(1,:);
        refy = ref{1}(2,:);
        refz = ref{1}(3,:);
        for i = 1:logNum
            estx{i} = est{i}(1,:);
            esty{i} = est{i}(2,:);
            estz{i} = est{i}(3,:);
            errx{i} = err{i}(1,:);
            erry{i} = err{i}(2,:);
            errz{i} = err{i}(3,:);
            vx{i} = vel{i}(1,:);
            vy{i} = vel{i}(2,:);
            vz{i} = vel{i}(3,:);
            qroll{i} = att{i}(1,:);
            qpitch{i} = att{i}(2,:);
            qyaw{i} = att{i}(3,:);
            wroll{i} = w{i}(1,:);
            wpitch{i} = w{i}(2,:);
            wyaw{i} = w{i}(3,:);
        end
        if length(c)==1
            Rc = ["Reference","Estimator"]; 
        else
            Rc = ["Reference",c];
        end
        % Rc = mat2cell(Rc,1,ones(1,length(Rc)));
        Rc = num2cell(Rc);
        CC = num2cell(c);
        allData.t_p = {struct('x',{[time{1},time]},'y',{[ref,est]}), struct('x','time [s]','y','position [m]'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ Estimator','$y$ Estimator','$z$ Estimator'},add_option([],option,addingContents)};
        allData.x_y = {struct('x',{[refx,estx]},'y',{[refy,esty]}), struct('x','$x$ [m]','y','$y$ [m]'),Rc,add_option(["aspect"],option,addingContents)};
        allData.x_z = {struct('x',{[refx,estx]},'y',{[refz,estz]}), struct('x','$x$ [m]','y','$z$ [m]'),Rc,add_option(["aspect"],option,addingContents)};
        allData.y_z = {struct('x',{[refy,esty]},'y',{[refz,estz]}), struct('x','$x$ [m]','y','$z$ [m]'),Rc,add_option(["aspect"],option,addingContents)};
        allData.t_x = {struct('x',{[time{1},time]},'y',{[refx,estx]}), struct('x','time [s]','y','$x$ [m]'),Rc,add_option([],option,addingContents)};
        allData.t_y = {struct('x',{[time{1},time]},'y',{[refy,esty]}), struct('x','time [s]','y','$y$ [m]'),Rc,add_option([],option,addingContents)};
        allData.t_z = {struct('x',{[time{1},time]},'y',{[refz,estz]}), struct('x','time [s]','y','$z$ [m]'),Rc,add_option([],option,addingContents)};
        allData.error = { struct('x',{time},'y',{err}), struct('x','time [s]','y','error [m]'), LgndCrt(["$x$","$y$","$z$"],c),add_option([],option,addingContents)};
        allData.t_errx = {struct('x',{time},'y',{errx}), struct('x','time [s]','y','error $x$ [m]'),CC,add_option([],option,addingContents)};
        allData.t_erry = {struct('x',{time},'y',{erry}), struct('x','time [s]','y','error $y$ [m]'),CC,add_option([],option,addingContents)};
        allData.t_errz = {struct('x',{time},'y',{errz}), struct('x','time [s]','y','error $z$ [m]'),CC,add_option([],option,addingContents)};
      
         % if fExp ==1
            allData.input = { struct('x',{time},'y',{inp}), struct('x','time [s]','y','input [N]'), LgndCrt(["1","2 ","3 ","4"],c),add_option([],option,addingContents)};
            allData.u = { struct('x',{time},'y',{u}), struct('x','time [s]','y','input [N]'), LgndCrt(["1","2 ","3 ","4"],c),add_option([],option,addingContents)};
        % else
        %     allData.input = { struct('x',{time},'y',{inp}), struct('x','time [s]','y','input [N]'), LgndCrt(["1 ","2 ","3 ","4","dst"],c),add_option([],option,addingContents)};
        % end
        allData.inner_input = { struct('x',{time},'y',{ininp}), struct('x','time [s]','y','inner input'), LgndCrt(["roll", "pitch", "thrst", "yaw", "5", "6", "7", "8"],c),add_option([],option,addingContents)};
        allData.attitude = {struct('x',{time},'y',{att}), struct('x','time [s]','y','attitude [rad]'), LgndCrt(["$roll$","$pitch$","$yaw$"],c),add_option([],option,addingContents)};
        allData.t_qroll = {struct('x',{time},'y',{qroll}), struct('x','time [s]','y','$q_{roll}$ [rad]'),CC,add_option([],option,addingContents)};
        allData.t_qpitch = {struct('x',{time},'y',{qpitch}), struct('x','time [s]','y','$q_{pitch}$ [rad]'),CC,add_option([],option,addingContents)};
        allData.t_qyaw = {struct('x',{time},'y',{qyaw}), struct('x','time [s]','y','$q_{yaw}$ [rad]'),CC,add_option([],option,addingContents)};
        allData.velocity = {struct('x',{time},'y',{vel}), struct('x','time [s]','y','velocity[m/s]'), LgndCrt(["$x$","$y$","$z$"],c),add_option([],option,addingContents)};
        allData.t_vx = {struct('x',{time},'y',{vx}), struct('x','time [s]','y','$v_x$ [m/s]'),CC,add_option([],option,addingContents)};
        allData.t_vy = {struct('x',{time},'y',{vy}), struct('x','time [s]','y','$v_y$ [m/s]'),CC,add_option([],option,addingContents)};
        allData.t_vz = {struct('x',{time},'y',{vz}), struct('x','time [s]','y','$v_z$ [m/s]'),CC,add_option([],option,addingContents)};
        allData.angular_velocity = { struct('x',{time},'y',{w}), struct('x','time [s]','y','angular velocity[rad/s]'), LgndCrt(["$roll$","$pitch$","$yaw$"],c),add_option([],option,addingContents)};
        allData.t_wroll = {struct('x',{time},'y',{wroll}), struct('x','time [s]','y','$w_{roll}$ [rad/s]'),CC,add_option([],option,addingContents)};
        allData.t_wpitch = {struct('x',{time},'y',{wpitch}), struct('x','time [s]','y','$w_{pitch}$ [rad/s]'),CC,add_option([],option,addingContents)};
        allData.t_wyaw = {struct('x',{time},'y',{wyaw}), struct('x','time [s]','y','$w_{yaw}$ [rad]/s'),CC,add_option([],option,addingContents)};
        allData.three_D = {struct('x',{[refx,estx]},'y',{[refy,esty]},'z',{[refz,estz]}), struct('x','$x$ [m]','y','$y$ [m]','z','$z$ [m]'), Rc,add_option(["aspect","camposition"],option,addingContents)};
        allData.uHL = { struct('x',{time},'y',{uHL}), struct('x','time [s]','y','inputHL'), LgndCrt(["$z$ ","$x$ ","$y$ ","$\psi$"],c),add_option([],option,addingContents)};
        allData.Trs = {struct('x',{time},'y',{Trs}), struct('x','time [s]','y','Tr [N] dTr [N/s] ddTr [N/$\rm{s^2}$]'), LgndCrt(["$Tr$","$dTr$"],c),add_option([],option,addingContents)};
        if fexpandS
            allData.z1 = {struct('x',{time},'y',{z1}), struct('x','time [s]','y','z1'), LgndCrt(["$z$","$dz$","$ddz$","$dddz$"],c),add_option([],option,addingContents)};
            % allData.F1z1 = {struct('x',{time},'y',{F1z1}), struct('x','time [s]','y','z1'), LgndCrt(["$z$","$dz$","$ddz$","$dddz$"],c),add_option([],option,addingContents)};
        else
            allData.z1 = {struct('x',{time},'y',{z1}), struct('x','time [s]','y','z1'), LgndCrt(["$z$","$dz$"],c),add_option([],option,addingContents)};
            % allData.F1z1 = {struct('x',{time},'y',{F1z1}), struct('x','time [s]','y','F1z1'), LgndCrt(["$z$","$dz$"],c),add_option([],option,addingContents)};
        end
        allData.z2 = {struct('x',{time},'y',{z2}), struct('x','time [s]','y','z2'), LgndCrt(["$x$","$dx$","$ddx$","$dddx$"],c),add_option([],option,addingContents)};
        allData.z3 = {struct('x',{time},'y',{z3}), struct('x','time [s]','y','z3'), LgndCrt(["$y$","$dy$","$ddy$","$dddy$"],c),add_option([],option,addingContents)};
        allData.z4 = {struct('x',{time},'y',{z4}), struct('x','time [s]','y','z4'), LgndCrt(["$\psi$","d$\psi$"],c),add_option([],option,addingContents)};
        allData.F2z2 = {struct('x',{time},'y',{F2z2}), struct('x','time [s]','y','F2z2'), LgndCrt(["$x$","$dx$","$ddx$","$dddx$"],c),add_option([],option,addingContents)};
        allData.F3z3 = {struct('x',{time},'y',{F3z3}), struct('x','time [s]','y','F3z3'), LgndCrt(["$y$","$dy$","$ddy$","$dddy$"],c),add_option([],option,addingContents)};
        allData.F4z4 = {struct('x',{time},'y',{F4z4}), struct('x','time [s]','y','F4z4'), LgndCrt(["$\psi$","d$\psi$"],c),add_option([],option,addingContents)};
        allData.vf = {struct('x',{time},'y',{vf}), struct('x','time [s]','y','vrtual input of first layer'), LgndCrt(["$vf$","$dvf$","$ddvf$","$dddvf$"],c),add_option([],option,addingContents)};         
        allData.pp = {struct('x',{time},'y',{[est,pp]}), struct('x','time [s]','y','position [m]'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],c),add_option([],option,addingContents)};
        allData.pv = {struct('x',{time},'y',{[vel,pv]}), struct('x','time [s]','y','velocity [m/s]'), LgndCrt(["$x$ est","$y$ est","$z$ est","$x$ plant","$y$ plant","$z$ plant"],c),add_option([],option,addingContents)};
        allData.pq = {struct('x',{time},'y',{[att,pq]}), struct('x','time [s]','y','attitude [rad]'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],c),add_option([],option,addingContents)};
        allData.pw = {struct('x',{time},'y',{[w,pw]}), struct('x','time [s]','y','angular velocity [rad/s]'), LgndCrt(["$roll$ est","$pitch$ est","$yaw$ est","$roll$ plant","$pitch$ plant","$yaw$ plant"],c),add_option([],option,addingContents)};
    
        %二乗誤差平均
        if isempty(c)
            c = string(1:logNum);
        end
        RMSElog(1,1:13) = ["RMSE","x","y","z","vx","vy","vz","roll","pitch","yaw","wroll","wpitch","wyaw"];
        RMSE = zeros(logNum,12);
        for i =1:logNum
            refs = zeros(3,lt(i));%kはtimeの長さ
            RMSE(i,1:12) = [rmse(ref{1,i},est{1,i}),rmse(refs,vel{1,i}),rmse(refs,att{1,i}),rmse(refs,w{1,i})];
            RMSElog(i+1,1:13) = [c(i),RMSE(i,1:12)];
            fprintf('#%s RMSE\n',c(i));
            % fprintf('  x\t y\t z\t | vx\t vy\t vz\t| roll\t pitch\t yaw\t | wroll\t wpitch\t wyaw \n');
            % fprintf('  %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f \n',RMSElog(i+1,2:13));
            fprintf('  x\t y\t z\t \n');
            fprintf('  %.4f    %.4f    %.4f \n',RMSElog(i+1,2:4));
        
        end
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
        RMSE_x=sqrt(sum(((ref(1,:)-est(1,:)).^2)));
        RMSE_y=sqrt(sum(((ref(2,:)-est(2,:)).^2)));
        RMSE_z=sqrt(sum(((ref(3,:)-est(3,:)).^2)));
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
%                 f(figureNumber) = figure('Name',figName);
                hold on
                if length(data.x) ~= length(data.y)
                    for i = 1:plotNum 
                        plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                else
                    for i = 1:plotNum 
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                title(option.titleName)
                set(gca,'FontSize',option.fontSize,"TickLabelInterpreter","latex")
                grid on
                hold off

        else
%                 f(figureNumber) = figure('Name',figName);
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
                title(option.titleName)
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
                else
                    for i = 1:plotNum 
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
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
    %         logger,...
%         logger_ft_lx_001,...
%         logger_ls_lx_001,...
%         logger_ft_ly_001,...
%         logger_ls_ly_001,...
%         logger_ls_saddle
%         logger_ft_saddle
%         logger_LS_lxy10,...
%         logger_FT_lxy10,...
%         logger_LS_lxy30,...
%         logger_FT_lxy30,...
%         logger_LS_lxy50,...
%         logger_FT_lxy50,...
%         logger_LS_lxy100,...
%         logger_FT_lxy100,...
% logger_LS_massn10,...
% logger_FT_massn10,...
% logger_LS_massn30,...
% logger_FT_massn30,...
% logger_LS_massn40,...
% logger_FT_massn40,...
% logger_LS_mass40,...
% logger_FT_mass40,...
% logger_LS_massn50,...
% logger_FT_massn50,...
%Jxyz
% logger_LS_jxyn70,...
% logger_FT_jxyn70,...
% logger_LS_jxy50,...
% logger_FT_jxy50,...
% logger_LS_jxy150,...
% logger_FT_jxy150,...
% logger_LS_jzn85,...
% logger_LS_jz50,...
% logger_LS_jz150,...
% logger_LS_jz300,...
% logger_LS_km1_n50,...
% logger_LS_km1_500,...
% logger_LS_km1_1000,...
% logger_LS_km1_1500,...
% logger_FT_09,...
% logger_FT_085

%         "lxFinit time settling",...
%         "lxLinear state FB",...
%         "lyFinit time settling",...
%         "lyLinear state FB"
%         "Linear state FB001",...
%         "Finit time settling001",...
% COG
%         "LS 10\%",...
%         "FT 10\%",...
%         "LS 30\%",...
%         "FT 30\%",...
%         "LS 50\%",...
%         "FT 50\%",...
%         "LS 100\%",...
%         "FT 100\%",...
%mass
%         "FS 90\%",...
%         "FT 90\%",...
%         "FS 70\%",...
%         "FT 70\%",...
%         "FS 60\%",...
%         "FT 60\%",...
%jxyz
%         "FS 30\%",...
%         "FT 30\%",...
%         "FS 150\%",...
%         "FT 150\%",...
%         "FS 250\%",...
%         "FT 250\%",...
        % "FS 50\%",...
        % "FS 600\%",...
        % "FS 1100\%",...
        % "FS 1600\%",...
%         "Linear state FBm40",...
%         "Finit time settlingm40",...
%         "Linear state FBmn50",...
%         "Finit time settlingmn540",...
%         "Linear state FBmn10",...
%         "Finit time settling mn10",...
%         "Linear state FBmn30",...
%         "Finit time settlingmn30",...
%         "Linear state FBj50",...
%         "Finit time settlingj50",...
%         "Linear state FBj100",...
%         "Finit time settlingj100",...
%         "Linear state FBj150",...
        % "Finit time settlingj150",...