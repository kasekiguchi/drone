classdef INPUT_DATA_EMULATOR
    %UNTITLED2 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        Data
        time
        N % agent number
        te % 
    end
    
    methods
        function obj = INPUT_DATA_EMULATOR(data)
            % 実験などで得られたリファレンスデータを使ったシミュレーション用クラス
            if isstring(data)
                obj.Data = load(data);
            else
                obj.Data = data;
            end
            obj.time = obj.Data{1}.t;
            obj.te=obj.time(find(obj.time,1,'last'));
            obj.N=length(obj.Data{2}{2});
        end
        
        function do(obj,t,agent,n)
            % do(t,agent,n)
            % agent(n) のセンサー情報(sensor.result)をData情報で上書き
            tidx = find((obj.time-t)>0,1)-1; % 現在時刻に最も近い過去のデータを参照
            agent(n).input = obj.Data{1}.agent{tidx,end,n};
        end
    end
end

