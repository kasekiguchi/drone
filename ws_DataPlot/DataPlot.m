classdef DataPlot<handle
    %DATAPLOT this class do dataplot
    %   
    
    properties(Access = private)
        Logger
        SavePath
        SaveName
    end
    
    properties(Constant)
        style = 'equal';
        grid = 'on';
        box = 'on';
        FontSize = 15;
        Fontname = 'TimesNewRoman'
        FontWeight = 'normal';
    end
    
    methods
        function obj = DataPlot(Logger)
            %DATAPLOT
            %   constructer for obj and path generate
            obj.Logger = Logger;
            %makedir
            SaveDate = datetime('now');
            SaveDateStr= datestr(SaveDate,'yyyymmdd');
            if exist(SaveDateStr,'file')
                tmpPath = pwd;
                tmpPathY = strcat(tmpPath,'\Saves_W','\',SaveDateStr);
                SaveDateStrD= datestr(SaveDate,'HHMMSS');%日付の文字作成
                mkdir(tmpPathY,SaveDateStrD);%ディレクトリ作成
                dataFilePath = genpath(strcat(tmpPathY,'\',SaveDateStrD));
                addpath(dataFilePath);
            else
                tmpPath = pwd;
                tmpPathY = strcat(tmpPath,'\Saves_W');
                mkdir(tmpPathY,SaveDateStr);%年月日のディレクトリ
                tmpPathD = strcat(tmpPathY,'\',SaveDateStr);
                SaveDateStrD= datestr(SaveDate,'HHMMSS');
                mkdir(tmpPathD,SaveDateStrD);%日付と時間のディレクトリ
                dataFilePath = genpath(strcat(tmpPathD,'\',SaveDateStrD));
                addpath(dataFilePath);
            end
            obj.SavePath = dataFilePath;
        end
        
        function [] = do(obj,Num)
            %Num = plot figure numbers
            i = 0;
            while i<=Num
                
                
            end
            obj.Logger
            
        end
    end
    
    methods(Access = protected)
        
    end
end

