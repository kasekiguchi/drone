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
            fh=figure(fig_num);
            fh.WindowState='maximized';
            frow=ceil(length(target)/3);
            for i = 1:length(target)
                subplot(frow,3,i);
                switch target(i)
                    case "p"
                        plotitem=[];
                        plegend=[];
                        if sum(contains(obj.items,'plant.state.p'))>0
                              sp=strcmp(obj.items,'plant.state.p');
                              tmpp=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpp{1:end}];
                              plegend=[plegend,"1p","2p","3p"];
                        end
                        if sum(contains(obj.items,'sensor.result.state.p'))>0
                              sp=strcmp(obj.items,'sensor.result.state.p');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmps{1:end}];
                              plegend=[plegend,"1s","2s","3s"];
                        end
                        if sum(contains(obj.items,'estimator.result.state.p'))>0
                              ep=strcmp(obj.items,'estimator.result.state.p');
                              tmpe=arrayfun(@(i)obj.Data.agent{i,ep,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpe{1:end}];
                              plegend=[plegend,"1e","2e","3e"];
                        end
                        if sum(contains(obj.items,'reference.result.state.p'))>0
                              rp=strcmp(obj.items,'reference.result.state.p');
                              tmpr=arrayfun(@(i)obj.Data.agent{i,rp,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpr{1:end}];
                              plegend=[plegend,"1r","2r","3r"];
                        end
                        plot([plotitem]')
                        title("Position p");
                        legend(plegend);
                    case "q"
                        plotitem=[];
                        plegend=[];
                        if sum(contains(obj.items,'plant.state.q'))>0
                              sp=strcmp(obj.items,'plant.state.q');
                              tmpp=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpp{1:end}];
                               if obj.Data.agent{1,sp,num}==4
                              plegend=[plegend,"1p","2p","3p","4p"];
                               else
                              plegend=[plegend,"1p","2p","3p"];
                               end
                        end
                        if sum(contains(obj.items,'sensor.result.state.q'))>0
                              sp=strcmp(obj.items,'sensor.result.state.q');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmps{1:end}];
                               if obj.Data.agent{1,sp,num}==4
                              plegend=[plegend,"1s","2s","3s","4s"];
                               else
                              plegend=[plegend,"1s","2s","3s"];
                               end
                        end
                        if sum(contains(obj.items,'estimator.result.state.q'))>0
                              ep=strcmp(obj.items,'estimator.result.state.q');
                              tmpe=arrayfun(@(i)obj.Data.agent{i,ep,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpe{1:end}];
                               if obj.Data.agent{1,sp,num}==4
                              plegend=[plegend,"1e","2e","3e","4e"];
                               else
                              plegend=[plegend,"1e","2e","3e"];
                               end
                        end
                        plot([plotitem]')
                        legend(plegend);
                        title(strcat("Attitude q : ",string(obj.target(num).model.state.type)));
                    case "v"
                        plotitem=[];
                        plegend=[];
                                                if sum(contains(obj.items,'plant.state.v'))>0
                              sp=strcmp(obj.items,'plant.state.v');
                              tmpp=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpp{1:end}];
                              plegend=[plegend,"1p","2p","3p"];
                        end

                        if sum(contains(obj.items,'sensor.result.state.v'))>0
                              sp=strcmp(obj.items,'sensor.result.state.v');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmps{1:end}];
                              plegend=[plegend,"1s","2s","3s"];
                        end
                        if sum(contains(obj.items,'estimator.result.state.v'))>0
                              ep=strcmp(obj.items,'estimator.result.state.v');
                              tmpe=arrayfun(@(i)obj.Data.agent{i,ep,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpe{1:end}];
                              plegend=[plegend,"1e","2e","3e"];
                        end
                        plot([plotitem]')
                        legend(plegend);
                        title("Velocity v");
                    case "w"
                        plotitem=[];
                        plegend=[];
                                                if sum(contains(obj.items,'plant.state.w'))>0
                              sp=strcmp(obj.items,'plant.state.w');
                              tmpp=arrayfun(@(i)obj.Data.agent{i,sp,num}(1:3),plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpp{1:end}];
                              plegend=[plegend,"1p","2p","3p"];
                                                end
                        if sum(contains(obj.items,'sensor.result.state.w'))>0
                              sp=strcmp(obj.items,'sensor.result.state.w');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmps{1:end}];
                              plegend=[plegend,"1s","2s","3s"];
                        end
                        if sum(contains(obj.items,'estimator.result.state.w'))>0
                              ep=strcmp(obj.items,'estimator.result.state.w');
                              tmpe=arrayfun(@(i)obj.Data.agent{i,ep,num},plot_length,'UniformOutput',false);
                              plotitem=[plotitem;tmpe{1:end}];
                              plegend=[plegend,"1e","2e","3e"];
                        end
                        plot([plotitem]')
                        legend(plegend);
                        title("Angular velocity w");
                    case "u"
                        if sum(contains(obj.items,'input'))>0
                              sp=strcmp(obj.items,'input');
                              tmps=arrayfun(@(i)obj.Data.agent{i,sp,num},plot_length,'UniformOutput',false);
                              plotitem=[tmps{1:end}];
                        plot(plotitem')
                        title("Input u");
                        legend(strcat("u",string(1:size(plotitem,1))));
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
                              plotitem=[tmps{1:end}];
                              plot([plotitem]')
                              title(target(i));
                              legend(string(1:min(size(plotitem))));
                       else
                            warning("ACSL : logger does not include plot target.");
                       end
                end
            end
            if ~isemtpy(plotitem)
                   data = plotitem;
            end
        end
        
    end
end

