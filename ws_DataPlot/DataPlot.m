classdef DataPlot<handle
    %DATAPLOT this class do dataplot
    %
    
    properties
        logger
        SavePath
        SaveDateStr
        Condition
    end
    
    properties(Constant)
        %         style = 'equal';
        %         grid = 'on';
        %         box = 'on';
        FontSize = 15;
        FontName = 'TimesNewRoman'
        FontWeight = 'normal';
        FuncNames = [%     "XYZTureAndEst",
%     "AttitudesTureAndEst",
%     "TrackMPCEval",
%     "MapAndVehicleTrueAndEst",
%     "Eval",
%     "Covxv",
    "MapMovie",
%     "MapAndPreMapMovie",
%     "Entropy",
    "RMSE",
    "AllTureAndEst",
    "VWTureAndEst",
    "AllSquareError",
%     "ContEval",
%     "TrajectoryRMSE",
%     "ObserveSubFIM"
    ]
    end
    
    methods
        
        function obj = DataPlot(Logger,SaveOnOff)
            %DATAPLOT
            %   constructer for obj and path generate
            obj.logger = Logger;% Data file
            %             obj.Condition = Condition;% Non logger data and simulation condition
            %% makedir
            SaveDate = datetime('now');
            SaveDateStr= datestr(SaveDate,'yyyy_mm_dd');
            if exist(SaveDateStr,'file')
                tmpPath = pwd;
                tmpPathY = strcat(tmpPath,'\ws_Saves','\',SaveDateStr);
                SaveDateStrD= datestr(SaveDate,'HH_MM_SS');%日付の文字作成
                mkdir(tmpPathY,SaveDateStrD);%ディレクトリ作成
                dataFilePath = genpath(strcat(tmpPathY,'\',SaveDateStrD));
                addpath(dataFilePath);
            else
                tmpPath = pwd;
                tmpPathY = strcat(tmpPath,'\ws_Saves');
                mkdir(tmpPathY,SaveDateStr);%年月日のディレクトリ
                dataFilePath = genpath(strcat(tmpPathY,'\',SaveDateStr));
                addpath(dataFilePath);%add path of year directry
                tmpPathD = strcat(tmpPathY,'\',SaveDateStr);
                SaveDateStrD= datestr(SaveDate,'HH_MM_SS');
                mkdir(tmpPathD,SaveDateStrD);%日付と時間のディレクトリ
                dataFilePath = genpath(strcat(tmpPathD,'\',SaveDateStrD));
                addpath(dataFilePath);
            end
            obj.SavePath = dataFilePath;
            obj.SaveDateStr = strcat('ws_Saves\',SaveDateStr,'\',SaveDateStrD);
            
            %% Save data
            if SaveOnOff
                save(strcat('Logger',SaveDateStrD,'.mat'),'Logger');
                movefile(strcat('Logger',SaveDateStrD,'.mat'),obj.SaveDateStr);
            end
            %% Plot Data
            do(obj);
            %             AutoPPt(result);
            
        end
        
    end
    
    methods(Access = protected)
        
        function do(obj)
            %Num = plot figure numbers
            Figi = 1;
            FigNum = 1;
            while Figi<= length(obj.FuncNames)
                FuncName = obj.FuncNames(Figi);%we decide function name in the loop of this step.
                FuncHandleName = strcat('PlotFunc_',FuncName);
                FuncHandle = str2func(FuncHandleName);
                [FigNum] = FuncHandle(obj,FigNum);
                Figi = Figi+1;
            end
        end
        
    end
end

