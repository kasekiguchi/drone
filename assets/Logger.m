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
            obj.target = target;
            obj.N = length(target);
            obj.n=length(items);
            obj.Data.t = zeros(row,1); % 時間
            obj.Data.agent=cell(row,obj.n,obj.N);
            obj.items=items;
        end
        
        function logging(obj,t)
            obj.Data.t(obj.i)=t;
            for j = 1:obj.N
              for k = 1:length(obj.items)
                str=strsplit(obj.items{k},'.');
                tmp=obj.target(j);
                for l = 1:length(str)-1
                   tmp= tmp.(str{l});
                end
          %      obj.Data.agent{j}{obj.i,k}=tmp.(str{end});
                obj.Data.agent{obj.i,k,j}=tmp.(str{end});
              end
            end
            obj.i=obj.i+1;
        end
        function save(obj)
            filename = strrep(strrep(strcat('Data/Log(',datestr(datetime('now')),').mat'),':','_'),' ','_');
            Data=obj.Data;
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
                    plot_length = 1:varargin{1}.time-1;
                end
                if isfield(varargin{1},'transpose')
                    logger_transpose=1;
                end
                if isfield(varargin{1},'fig_num')
                    fig_num=varargin{1}.fig_num;
                end
            end
            timeList=obj.Data.t(1:length(plot_length));
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

