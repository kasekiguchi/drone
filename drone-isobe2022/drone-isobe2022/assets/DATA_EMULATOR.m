classdef DATA_EMULATOR
    %UNTITLED2 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        Data
        time
        N % agent number
  %      rdatanames
        te % 
        si
        ei
        ri
        ii
        pi
    end
    
    methods
        function obj = DATA_EMULATOR(data)
            % 実験などで得られたリファレンスデータを使ったシミュレーション用クラス
            if nargin == 0
                tmp1= dir("Data");
                tmp2=arrayfun(@(i) datetime(tmp1(i).date,"InputFormat",'dd-MM-yyyy HH:mm:ss'),3:length(tmp1));
                [~,latest_idx] = max(tmp2);
                obj.Data = load(tmp1(2+latest_idx).name).Data;% 最新のデータを取得
            elseif isstring(data)
                obj.Data = load(data);
            else
                obj.Data = data;
            end
            obj.time = obj.Data{1}.t;
            obj.te=obj.time(find(obj.time,1,'last'));
%             obj.rdatanames=obj.Data{2}{3};
            ids = obj.Data{2}{1};
            obj.si = ids(1);
            obj.ei = ids(2);
            obj.ri = ids(3);
            obj.ii = ids(4);
            if length(ids) == 5
                obj.pi = ids(5);
            else
                obj.pi = obj.si;
            end
        end
        
        function overwrite(obj,str,t,agent,n)
            % overwrite(str,t,agent,n)
            % agent(n).(str).result の情報をData情報で上書き
            tidx = find((obj.time-t)>0,1)-1; % 現在時刻に最も近い過去のデータを参照
            switch str
                case {"plant", "model"}
                    list = agent(n).(str).state.list(contains(agent(n).(str).state.list,obj.Data{1}.agent{tidx,obj.pi,n}.state.list));
                    for i =list
                        agent(n).(str).state.set_state(i,obj.Data{1}.agent{tidx,obj.pi,n}.state.get(i));
                    end
                case "sensor"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,obj.si,n};
                case "estimator"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,obj.ei,n};
                case "reference"
                    agent(n).(str).result = obj.Data{1}.agent{tidx,obj.ri,n};
                case "input"
                    agent(n).input = obj.Data{1}.agent{tidx,obj.ii,n};
            end                    
        end
    end
end

