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
        i = 1; % time index for logging
        N % agent数
        items
        n
        si
        ei
        ri
        ii
        pi
    end
    
    methods
        function obj = Logger(target,row,items)
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
                obj.Data.agent{obj.i,obj.si,j}=obj.target(j).sensor.result;
                obj.Data.agent{obj.i,obj.si,j}.state = state_copy(obj.target(j).sensor.result.state);
                obj.Data.agent{obj.i,obj.ei,j}=obj.target(j).estimator.result;
                obj.Data.agent{obj.i,obj.ei,j}.state = state_copy(obj.target(j).estimator.result.state);
                obj.Data.agent{obj.i,obj.ri,j}=obj.target(j).reference.result;
                obj.Data.agent{obj.i,obj.ri,j}.state = state_copy(obj.target(j).reference.result.state);
                obj.Data.agent{obj.i,obj.ii,j}=obj.target(j).input;
                if ~isempty(obj.pi)
                    obj.Data.agent{obj.i,obj.pi,j}.state = state_copy(obj.target(j).plant.state);
                end
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
            % info : {{indices},{items},{sensor names},{estimator names},{reference names}}
            % indices = [si,ei,ri,ii,pi];
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
            Data={obj.Data,{[obj.si,obj.ei,obj.ri,obj.ii,obj.pi],obj.items,sname,rname}};
            save(filename,'Data');
        end
        function [data]=plot(obj,N,target,option,varargin)
            % plot(obj, agent ids, target string, options,varargin)
            % agent ids : indices of the agent to be plotted
            % target string : ["p1","input","q"] : variable to be plotted
            % options : ["ser","","er"], struct("time",10, "fig_num",2,"row_col",[1 2])
            % fig1 = sensor p1, estimator p1 and reference p1
            % fig2 = estimator q and reference q
            data = [];
            plot_length=1:length(obj.Data.t(obj.Data.t~=0))-1;
            fig_num = 1;
            fcol=3;
            frow=ceil(length(target)/fcol);
            fcolor = 1;
            if ~isempty(varargin)
            if isstruct(varargin{1})
                if isfield(varargin{1},'time') && ~isempty(varargin{1}.time)% set end time
                    plot_length = 1:find((obj.Data.t-varargin{1}.time)>0,1)-1;
                end
                if isfield(varargin{1},'fig_num')
                    fig_num=varargin{1}.fig_num;
                end
                if isfield(varargin{1},'row_col')
                    frow = varargin{1}.row_col(1);
                    fcol = varargin{1}.row_col(2);
                end
                if isfield(varargin{1},'nocolor')
                    fcolor = 0;
                end
            end
            end
            timeList=obj.Data.t(plot_length);
            fh=figure(fig_num);
            fh.WindowState='maximized';
            for i = 1:length(target)% i : 図番号
                subplot(frow,fcol,i);
                %Square_coloring([find(obj.Data.phase==97,1),find(obj.Data.phase==97,1,'last')]);
                if ~strcmp(option(i),"") %contains(option(i),["e","s","r","p"])>0
                    t1=split(target(i),'-');
                    if strcmp(option(i),":")
                        s2 = "serp";
                    else
                        s2 = option(i);
                    end
                    if length(t1) == 1 % 時間応答
                        s1 = regexprep(t1,"[0-9:]","");
                        eli =  str2num(strjoin(regexp(t1,"[0-9:]",'match'))); % set element index
                        if isempty(eli)
                            eli = ':';
                        end
                        plegend = [];
                        for s = ["s","e","r","p"]
                            if contains(s2,s) && sum(contains(obj.Data.agent{1,obj.(append(s,"i")),N}.state.list,s1))>0
                                tmpdata=arrayfun(@(i)obj.Data.agent{i,obj.(append(s,"i")),N}.state.(s1)(eli),plot_length,'UniformOutput',false);
                                if strcmp(s,"e")
                                    plot(timeList,cell2mat(tmpdata)','LineWidth',1.5)
                                else
                                    plot(timeList,cell2mat(tmpdata)')
                                end
                                hold on
                                if strcmp(eli,':')
                                    plegend=[plegend,append(string(1:length(tmpdata{1})),s)];
                                else
                                    plegend=[plegend,append(string(eli),s)];
                                end
                            end
                        end
                        if s1 == "p"
                            title("Position p");
                        elseif s1 == "q"
                            title(strcat("Attitude q (type : ",string(obj.target(N).model.state.type),")"));
                        elseif s1 == "v"
                            title("Velocity v");
                        elseif s1 == "w"
                            title("Angular velocity w");
                        else
                            title(s1);
                        end
                        xlabel("Time [s]");
                        legend(plegend);
                        hold off
                    elseif length(t1) == 2 || length(t1) == 3 % 平面軌跡 or 立体軌跡
                        s1 = regexprep(t1,"[0-9:]","");
                        eli =  regexp(t1,"[0-9:]",'match');
                        plegend = [];
                        for s = ["s","e","r","p"]
                            if contains(s2,s) && ~isempty(obj.(append(s,"i"))) && sum(contains(obj.Data.agent{1,obj.(append(s,"i")),N}.state.list,s1(1))) && sum(contains(obj.Data.agent{1,obj.(append(s,"i")),N}.state.list,s1(2)))
                                tmp1data=arrayfun(@(i)obj.Data.agent{i,obj.(append(s,"i")),N}.state.(s1(1))(str2num(eli{1})),plot_length,'UniformOutput',false);
                                tmp2data=arrayfun(@(i)obj.Data.agent{i,obj.(append(s,"i")),N}.state.(s1(2))(str2num(eli{2})),plot_length,'UniformOutput',false);
                                if length(t1)==3
                                    if sum(contains(obj.Data.agent{1,obj.(append(s,"i")),N}.state.list,s1(3))) 
                                        tmp3data=arrayfun(@(i)obj.Data.agent{i,obj.(append(s,"i")),N}.state.(s1(3))(str2num(eli{3})),plot_length,'UniformOutput',false);
                                    end
                                    if strcmp(s,"e")
                                        plot3(cell2mat(tmp1data)',cell2mat(tmp2data)',cell2mat(tmp3data)','LineWidth',1.5);
                                    else
                                        plot3(cell2mat(tmp1data)',cell2mat(tmp2data)',cell2mat(tmp3data)');
                                    end
                                else
                                    if strcmp(s,"e")
                                        plot(cell2mat(tmp1data)',cell2mat(tmp2data)','LineWidth',1.5)
                                    else
                                        plot(cell2mat(tmp1data)',cell2mat(tmp2data)')
                                    end
                                end
                                hold on
                                if s == "s"
                                    plegend=[plegend,"sensor"];
                                elseif s == "e"
                                    plegend=[plegend,"estimator"];
                                elseif s == "r"
                                    plegend=[plegend,"reference"];
                                elseif s == "p"
                                    plegend=[plegend,"plant"];
                                else
                                    plegend=[plegend,s];
                                end
                            end
                        end
                        title(strcat("phase plot : ",string(target(i))));
                        xlabel(t1{1});
                        ylabel(t1{2});
                        if length(t1)==3; zlabel(t1{3});end
                        legend(plegend);
                        daspect([1 1 1]);
                        hold off
                    end
                else
                    switch target(i)
                        case {"u", "input"}
                            tmpdata=arrayfun(@(i)obj.Data.agent{i,obj.ii,N},plot_length,'UniformOutput',false);
                            plot(timeList,[tmpdata{1:end}]')
                            title("Input u");
                            xlabel("Time [s]");
                            legend(strcat("u",string(1:size(tmpdata{1},1))));
                        case "inner_input"
                            if sum(contains(obj.items,'inner_input'))>0
                                sp=strcmp(obj.items,'inner_input');
                                tmps=arrayfun(@(i)obj.Data.agent{i,sp,N},plot_length,'UniformOutput',false);
                                plot(timeList,[tmps{1:end}]')
                                title("Throttle Input u");
                                legend(strcat("u",string(1:size(tmps{1},1))));
                                xlabel("Time [s]");
                                %ylim([1000 2000]);
                            else
                                warning("ACSL : logger does not include plot target.");
                            end
                        otherwise
                            if sum(contains(obj.items,target(i)))>0
                                sp=strcmp(obj.items,target(i));
                                tmps=arrayfun(@(i)obj.Data.agent{i,sp,N},plot_length,'UniformOutput',false);
                                plot(timeList,[tmps{1:end}]')
                                title(target(i));
                                xlabel("Time [s]");
                                legend(string(1:size(tmps{1},1)));
                            else
                                warning("ACSL : logger does not include plot target.");
                            end
                    end
                end
                if fcolor
                    if length([find(obj.Data.phase==116,1),find(obj.Data.phase==116,1,'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase==116,1),find(obj.Data.phase==116,1,'last')])); % take off phase
                    end
                    if length([find(obj.Data.phase==102,1),find(obj.Data.phase==102,1,'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase==102,1),find(obj.Data.phase==102,1,'last')]),[0.9 1.0 1.0]); % flight phase
                    end
                    if length([find(obj.Data.phase==108,1),find(obj.Data.phase==108,1,'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase==108,1),find(obj.Data.phase==108,1,'last')]),[1.0 0.9 1.0]); % landing phase
                    end
                end
            end
        end
    end
end
