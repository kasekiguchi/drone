classdef DATA_EMULATOR
    %UNTITLED2 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        Data
        time
        N % agent number
  %      rdatanames
        te % 
    end
    
    methods
        function obj = DATA_EMULATOR(data)
            % 実験などで得られたリファレンスデータを使ったシミュレーション用クラス
            if isstring(data)
                obj.Data = load(data);
            elseif isempty(data)
                tmp = dir('Data');
                obj.Data = load(tmp(end).name);% 最新のデータを取得
            else
                obj.Data = data;
            end
            obj.time = obj.Data{1}.t;
            obj.te=obj.time(find(obj.time,1,'last'));
%             obj.rdatanames=obj.Data{2}{3};
            obj.N=length(obj.Data{2}{2});
        end
        
        function overwrite(obj,str,t,agent,n)
            % overwrite(str,t,agent,n)
            % agent(n).(str).result の情報をData情報で上書き
            tidx = find((obj.time-t)>0,1)-1; % 現在時刻に最も近い過去のデータを参照
            switch str
                case "sensor"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,end-3,n};
                case "estimator"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,end-2,n};
                case "reference"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,end-1,n};
                case "input"
                    agent(n).input = obj.Data{1}.agent{tidx,end,n};
            end                    
        end
    end
end

