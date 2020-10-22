classdef Logger < handle
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
        i = 1;
        N % agent数
        items
        n
    end
    
    methods
        function obj = Logger(target,row,items)
            % Logger(target,row,items)
            % target : ログを取る対象　agent(1:3)
            % row : 確保するデータサイズ　length(ts:dt:te)
            % items : 保存するデータ ["input","sensor.result.state.p"]
            obj.target = target;
            obj.N = length(target);
            obj.n=length(items)+4;% ,sensor.result, estimator.result, reference.result，input
            obj.Data.t = zeros(row,1); % 時間
            obj.Data.phase = zeros(row,1); % フライトフェーズ　a,t,f,l...
            obj.Data.agent=cell(row,obj.n,obj.N);
            obj.items=items;
        end
        
        function logging(obj,t,FH)
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
              obj.Data.agent{obj.i,obj.n-3,j}=obj.target(j).sensor.result;
              obj.Data.agent{obj.i,obj.n-3,j}.state = state_copy(obj.target(j).sensor.result.state);
              obj.Data.agent{obj.i,obj.n-2,j}=obj.target(j).estimator.result;
              obj.Data.agent{obj.i,obj.n-2,j}.state = state_copy(obj.target(j).estimator.result.state);
              obj.Data.agent{obj.i,obj.n-1,j}=obj.target(j).reference.result;
              obj.Data.agent{obj.i,obj.n-1,j}.state = state_copy(obj.target(j).reference.result.state);
              obj.Data.agent{obj.i,obj.n,j}=obj.target(j).input;
            end
            obj.i=obj.i+1;
        end
        function save(obj)
            % Data = {{log},{info}}
            % log : logging data = field t and agent
            %     agent : {k, itme_num, agent_num}
            %          last four itmes are ;
            %          sensor.result, estimator.result,
            %          reference.result, and input
            % info : {{items},{sensor names},{estimator names},{reference names}}
            % sensor names : {{1st agent's sensor names},{2nd ..},{...}...}
            % i-th agent's sensor names : example {"Motive","RangePos"}
            filename = strrep(strrep(strcat('Data/Log(',datestr(datetime('now')),').mat'),':','_'),' ','_');
            sname = [];
            for i =1:obj.N % 複数台の場合
                isnames = obj.target(i).sensor.name;
                isname = [];
                for j = 1:length(isnames)
                    isname = [isname,obj.target(i).sensor.(isnames(j)).name];
                end
                sname = [sname,{isname}];
            end
            rname = [];
            for i =1:obj.N % 複数台の場合
                irnames = obj.target(i).reference.name;
%                 irname = [];
%                 for j = 1:length(irnames)
%                     irname = [irname,obj.target(i).reference.(irnames(j)).name];
%                 end
                rname = [rname,{irnames}];
            end
            Data={obj.Data,{obj.items,sname,rname}};
            save(filename,'Data');
        end
        function [data]=plot(obj,num,target,varargin)
            % plot(obj,  num, target)
            % num : index of the agent to be plotted
            % target = "p" : variable to be plotted
            data = [];
            plot_length=1:length(obj.Data.t(obj.Data.t~=0))-1;
            fig_num = 1;
            logger_transpose = 0;
            if ~isempty(varargin)
                if isfield(varargin{1},'time')
                    plot_length = 1:find((obj.Data.t-varargin{1}.time)>0,1)-1;
                end
                if isfield(varargin{1},'transpose')
                    logger_transpose=1;
                end
                if isfield(varargin{1},'fig_num')
                    fig_num=varargin{1}.fig_num;
                end
            end
            timeList=obj.Data.t(plot_length);
            fh=figure(fig_num);
            fh.WindowState='maximized';
            frow=ceil(length(target)/3);
            for i = 1:length(target)
                subplot(frow,3,i);
                switch target(i)
                    case {"p","q","v","w"}
                        ch = target(i);
                        plotitem={};
                        plegend=[];
                        if sum(contains(obj.items,strcat('plant.state.',ch)))>0
                              sp=strcmp(obj.items,strcat('plant.state.',ch));
                              tmpp=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plot(timeList,[tmpp{1:end}]');
                              hold on
                              plegend=[plegend,"1p","2p","3p"];
                        end
                        if sum(contains(obj.items,strcat('sensor.result.state.',ch)))>0
                              sp=strcmp(obj.items,strcat('sensor.result.state.',ch));
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plot(timeList,[tmps{1:end}]');
                              hold on
                              plegend=[plegend,"1s","2s","3s"];
                        end
                        if sum(contains(obj.items,strcat('estimator.result.state.',ch)))>0
                              ep=strcmp(obj.items,strcat('estimator.result.state.',ch));
                              tmpe=arrayfun(@(i)obj.Data.agent{i,ep,num}(1:3),plot_length,'UniformOutput',false);
                              plot(timeList,[tmpe{1:end}]','LineWidth',1.5);
                              hold on
                              plegend=[plegend,"1e","2e","3e"];
                        end
                        if sum(contains(obj.items,strcat('reference.result.state.',ch)))>0
                              rp=strcmp(obj.items,strcat('reference.result.state.',ch));
                              tmpr=arrayfun(@(i)obj.Data.agent{i,rp,num}(1:3),plot_length,'UniformOutput',false);
                              plot(timeList,[tmpr{1:end}]','-.');
                              hold on
                              plegend=[plegend,"1r","2r","3r"];
                        end
                        if ch == "p"
                            title("Position p");
                        elseif ch == "q"
                            title(strcat("Attitude q : ",string(obj.target(num).model.state.type)));
                        elseif ch == "v"
                            title("Velocity v");
                        else
                            title("Angular velocity w");
                        end
                        legend(plegend);
                        hold off
                    case "u"
                        if sum(contains(obj.items,'input'))>0
                              sp=strcmp(obj.items,'input');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                        plot(timeList,[tmps{1:end}]')
                        title("Input u");
                        legend(strcat("u",string(1:size(tmps{1},1))));
                       % ylim([500 2200]);
                        else
                             warning("ACSL : logger does not include plot target.");
                        end
                    case "inner_input"
                        if sum(contains(obj.items,'inner_input'))>0
                              sp=strcmp(obj.items,'inner_input');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num}',plot_length,'UniformOutput',false);
                        plot(timeList,[tmps{1:end}]')
                        title("Throttle Input u");
                        legend(strcat("u",string(1:size(tmps{1},1))));
                        ylim([1000 2000]);
                        else
                             warning("ACSL : logger does not include plot target.");
                        end
                    otherwise
                        if sum(contains(obj.items,target(i)))>0
                              sp=strcmp(obj.items,target(i));
                              if logger_transpose==1
                                  tmps=arrayfun(@(i)obj.Data.agent{i,sp,num}',plot_length,'UniformOutput',false);
                              else
                                  tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              end
                            plot(timeList,[tmps{1:end}]')
                              title(target(i));
                              legend(string(1:size(tmps{1},1)));
                       else
                            warning("ACSL : logger does not include plot target.");
                       end
                end
            end
            if ~isempty(plotitem)
                   data = plotitem;
            end
        end
        
    end
end

