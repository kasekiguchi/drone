classdef WSLogger < handle
    % データ保存用クラス
    % obj = Logger(target,row,items)
    % target : agent
    % row : size(ts:dt:te,2)
    % items : [    "plant.state.p",    "model.state.p"  ...]
    % At every logging, logger gathers the data listed in items from target
    % obj.Data.t : time
    % obj.Data.agent = {row, item_id, target_id}
    properties
        Data
        target
        i = 1; % time index for logging
        N % agent数
        items
        SubFuncitems
        n
        si
        ei
        ri
        ii
        pi
    end
    
    methods
        function obj = WSLogger(target,row,items,subfunc)
            % Logger(target,row,items)
            % target : ログを取る対象　agent(1:3)
            % row : 確保するデータサイズ　length(ts:dt:te)
            % items : 保存するデータ ["input","sensor.result.state.p"]
            obj.target = target;
            obj.N = length(target); % agent number
            obj.Data.t = zeros(row,1); % 時間
            obj.Data.phase = zeros(row,1); % フライトフェーズ　a,t,f,l...
            obj.items=items;
            obj.si = length(items)+1;
            obj.ei = obj.si + 1;
            obj.ri = obj.ei + 1;
            obj.ii = obj.ri + 1;
            if isempty(target(1).plant.state)
                obj.n=length(items)+4;% ,sensor.result, estimator.result, reference.result，input
            else
                obj.pi = obj.ii +1;
                obj.n=length(items)+5;% ,sensor.result, estimator.result, reference.result，input
            end
            obj.Data.agent=cell(row,obj.n,obj.N);
            %---subfunc system setup---%
            obj.SubFuncitems = subfunc;
            obj.Data.SubFuncData = cell(row,length(subfunc) +1);%+1 equal time logging column
            %--------------------------%
        end
        
        function logging(obj,t,FH,doSubFuncFlag)
            % logging(t,FH)
            % t : current time
            % FH : figure handle for keyboard input
            obj.Data.t(obj.i)=t;
            cha = get(FH, 'currentcharacter');
            obj.Data.phase(obj.i)=cha;
            for j = 1:obj.N
                
                for k = 1:length(obj.items)
                    str=strsplit(obj.items{k},'.');
                    tmp=obj.target(j);
                    for l = 1:length(str)-1
                        tmp= tmp.(str{l});
                    end
                    obj.Data.agent{obj.i,k,j}=tmp.(str{end});
                end

                if ~isempty(obj.pi)
                    obj.Data.agent{obj.i,obj.pi,j}.state = state_copy(obj.target(j).plant.state);
                end
                
            end
            if doSubFuncFlag
                doSubFunc(obj,t)
            end
            obj.i=obj.i+1;
        end
        
        function doSubFunc(obj,t)
            %t:current time
            % FH : figure handle for keyboard input
            obj.Data.SubFuncData{obj.i,1} = t;
            for FuncColmn = 1:length(obj.SubFuncitems)
                SubFuncHandle = str2func(obj.SubFuncitems(FuncColmn));
                obj.Data.SubFuncData{obj.i,FuncColmn+1} = SubFuncHandle(obj);
            end
            
        end
    end
    
    methods(Access =private)
        eval = ContEval(obj)
        
        
    end
end
