classdef LOGGER < handle % handleクラスにしないとmethodの中で値を変えられない
    % データ保存用クラス
    % obj = LOGGER(target,row,items)
    % target : 保存対象の agent indices : example 2:4 : default 1:N
    % row : size(ts:dt:te,2)
    % items : [    "plant.state.p",    "model.state.p"  ...]
    % At every logging, LOGGER gathers the data listed in items from target
    % obj.Data.t : time
    % obj.Data.agent = {row, item_id, target_id}
    properties
        Data
        k;          % time index for logging
        target      % 保存対象の agent indices : example 2:4 : default 1:N
        items       % 追加で保存するアイテム名
        item_num    % 追加保存のアイテム数
        agent_items % result以外で追加保存するagent内の変数
        fExp
        sname = "sensor";
        ename = "estimator";
        rname = "reference";
    end

    methods
        function obj = LOGGER(target, number, fExp, items, agent_items)
            % LOGGER(target,row,items)
            % target : ログを取る対象　example 1:3, usage agent(obj.target)
            % number : 確保するデータサイズ　length(ts:dt:te)
            % agent_items : default以外で保存するデータ ["inner_input"]
            % items  : agent 以外で保存するデータの名前
            %         以下のように名前と保存するものの対応が取れていなくても可
            %         LOGGER=LOGGER(~,~,"innerInput",~);
            %         LOGGER.logging(t,FH,agent,motive);
            obj.k = 0;
            obj.target = target;
            obj.Data.t = zeros(number, 1);     % 時間
            obj.Data.phase = zeros(number, 1); % フライトフェーズ　a,t,f,l...
            obj.fExp = fExp;
            obj.items = items;
            obj.item_num = length(items);
            obj.agent_items = agent_items;
            obj.Data.agent = struct();
        end

        function logging(obj, t, FH, agent, items)
            % logging(t,FH)
            % t : current time
            % FH : figure handle for keyboard input
            arguments
                obj
                t
                FH
                agent
            end
            arguments (Repeating)
                items
            end
            obj.k = obj.k + 1;
            obj.Data.t(obj.k) = t;
            cha = get(FH, 'currentcharacter');
            obj.Data.phase(obj.k) = cha;
            % TODO : activate warning
            %            if isempty(items{1}) | length(items) ~= length(obj.items)
            %                 warning("ACSL : number of logging data is wrong");
            %             end
            for i = obj.items
                obj.Data.(obj.items(i))(obj.k, :) = items{i};
                % 注：サイズの固定されている数値データだけ保存可能
            end
            for n = obj.target
                for i = 1:length(obj.agent_items) % sensor,estimator,reference以外のみ
                    str = strsplit(obj.agent_items(i), '.');
                    tmp = agent(n);
                    obj.Data.agent(n).(str{1}){obj.k} = tmp.(str{1});
                end
                obj.Data.agent(n).sensor.result{obj.k} = agent(n).sensor.result;
                obj.Data.agent(n).estimator.result{obj.k} = agent(n).estimator.result;
                obj.Data.agent(n).reference.result{obj.k} = agent(n).reference.result;

                obj.Data.agent(n).sensor.result{obj.k}.state = state_copy(agent(n).sensor.result.state);
                obj.Data.agent(n).estimator.result{obj.k}.state = state_copy(agent(n).estimator.result.state);
                obj.Data.agent(n).reference.result{obj.k}.state = state_copy(agent(n).reference.result.state);
                obj.Data.agent(n).input{obj.k} = agent(n).input;

                if obj.fExp
                    obj.Data.agent(n).inner_input{obj.k} = agent(n).inner_input;
                else
                    obj.Data.agent(n).plant.result{obj.k}.state = state_copy(agent(n).plant.state);
                end
            end
        end
        function save(obj)
            % TODO : need to modify to be compatible with the change on
            % 2021/12/26
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
            filename = strrep(strrep(strcat('Data/Log(', datestr(datetime('now')), ').mat'), ':', '_'), ' ', '_');
            sname = [];
            for i = obj.target % 複数台の場合
                isnames = obj.target(i).sensor.name;
                isname = [];
                for j = 1:length(isnames)
                    isname = [isname, obj.target(i).sensor.(isnames(j)).name];
                end
                sname = [sname, {isname}];
            end
            rname = [];
            for i = obj.target % 複数台の場合
                irnames = obj.target(i).reference.name;
                %                 irname = [];
                %                 for j = 1:length(irnames)
                %                     irname = [irname,obj.target(i).reference.(irnames(j)).name];
                %                 end
                rname = [rname, {irnames}];
            end
            Data = {obj.Data, {[obj.si, obj.ei, obj.ri, obj.ki, obj.pi], obj.items, sname, rname}};
            save(filename, 'Data');
        end
        function [data, vrange] = data(obj, n, variable, attribute, option)
            % n : agent index
            % variable : var name or path to var from agent
            %            or path from result if attribute is set.
            % attribute : "s","e","r","p","i"
            % option time : time range
            % Examples
            % time : data('t',[],[])
            % state : data(1,"p","e")                      : agent1's estimated position
            %         data(2,"state.xd","r")               : agent2's reference xd
            %         data(1,"sensor.result.state.q",[])       : agent1's measured attitude
            % input : data(1,[],"i") or data(1,"input",[]) : agent1's input data
            % data(1,"p","r","time",[0,2])                 : take the data in time span [0 2]
            % PROBLEM : data(0,'t','') does not work
            arguments
                obj
                n
                variable string = "p"
                attribute string = "e"
                option.time (1, 2) double = [0 obj.Data.t(obj.k)]
            end
            [variable, vrange] = obj.full_var_name(variable, attribute);
            attribute = "";
            data_range = find((obj.Data.t - option.time(1)) > 0, 1):find((obj.Data.t - option.time(2)) >= 0, 1);
            if sum(strcmp(n, {'time', 't'}))     % 時間軸データ
                data = obj.Data.t(data_range);
            elseif n == 0                        % n : agent number.  n=0 => obj.itmesのデータ
                variable = split(variable, '.'); % member毎に分割
                data = [obj.Data.(variable{1})];
                for j = 2:length(variable)
                    data = [data.(variable{j})];
                end
                data = [data{1, data_range}]';
            else                                 % agentに関するデータ
                variable = split(variable, '.'); % member毎に分割
                data = [obj.Data.agent(n)];
                switch variable
                    case "inner_input" % 横ベクトルの場合
                        data = [data.(variable)];
                        data = [data{1, data_range}];
                        data = reshape(data, [8, length(data) / 8])';
                    otherwise
                        for j = 1:length(variable)
                            data = [data.(variable{j})];
                            if iscell(data) % 時間方向はcell配列
                                data = [data{1, data_range}]';
                                data = obj.return_state_prop(variable(j + 1:end), data);
                                break
                            end
                        end
                end
            end
            if ~isempty(vrange)
                data = obj.mtake(data, [], vrange);
            end
        end
        function data = return_state_prop(obj, variable, data)
            for j = 1:length(variable)
                data = [data.(variable(j))];
                if strcmp(variable(j), 'state')
                    for k = 1:length(data)
                        ndata(k, :) = data(k).(variable(j + 1));
                    end
                    data = ndata;
                    break % WRN : stateから更に深い構造には対応していない
                end
            end
        end
        function plot(obj, list, option)
            % list : setting for subplot
            % option : setting for all figure
            %
            % list consists of cell array
            %   each cell has agent id, plot target or state, and attribute
            % example {2,"p","es"}
            %         agent id = 2       : plot 2nd agent data
            %         plot target = "p"  : position
            %         attribute = "es"   : estimator and sensor data
            %
            % plot target allows following form
            %         p : position, q : attitude,
            %         v : velocity, w : angular velocity
            %         p1 : first element of p, p1:2 : first two elements
            %         p1-p2 : phase plot p1 vs p2
            %         p1-p2-p3 : 3D phase plot p1, p2, p3
            % attribute consists of
            %         s : sensor, e : estimator, r : reference,
            %         p : plant (only simulation)
            % option
            %         time : time span
            %         fig_num : figure number
            %         row_col : row and column number of subplot
            %
            % usage plot({1,"p1:2:3","ser"},{2,"input",""},{1,"q","e"},
            %               {2,"p1-p2"},"time",[4 10], "fig_num",2,"row_col",[2 2])
            %       fig1 = agent1's p1,p3 data w.r.t sensor, estimator and reference
            %       fig2 = agent2's input
            %       fig3 = agent1's estimator q
            %       fig4 = agent2's phase plot
            %       In figure window 2, figures are aligned "[fig1, fig2; fig3, fig4]"
            %       order in one row. Each figure has time span [4 10].s
            arguments
                obj
            end
            arguments (Repeating)
                list
            end
            arguments
                option.time (1, 2) double = [0 obj.Data.t(obj.k)]
                option.fig_num {mustBeNumeric} = 1
                option.row_col (1, 2) {mustBeNumeric} = [ceil(length(list) / min(length(list), 3)) min(length(list), 3)]
                option.color {mustBeNumeric} = 1
                option.hold {mustBeNumeric} = 0
            end
            trange = option.time;                      % time range
            fig_num = option.fig_num;                  % figure number
            frow = option.row_col(1);                  % subfigure row number
            fcol = option.row_col(2);                  % subfigure col number
            fcolor = option.color;                     % on/off flag for phase coloring
            fhold = option.hold;                       % on/off flag for holding (only active to last subfigure)

            t = obj.data("t", '', '', "time", trange); % time data
            fh = figure(fig_num);
            fh.WindowState = 'maximized';
            switch frow
                case 1
                    yoffset = 0.05;
                case 2
                    yoffset = 0.1;
                otherwise
                    yoffset = 0;
            end

            for fi = 1:length(list)      % fi : 図番号
                spfi = subplot(frow, fcol, fi);
                plegend = [];
                N = list{fi}{1};         % indices of variable drones. example : [1 2]
                param = list{fi}{2};     % p,q,v,w, etc
                attribute = list{fi}{3}; % e,s,r,p
                if strcmp(attribute, ""); attribute = " "; end
                for n = N
                    for a = 1:strlength(attribute)
                        ps = split(param, '-'); % 「-」区切りで分割
                        att = extract(attribute, a);
                        switch length(ps)
                            case 1 % 時間応答（時間を省略）
                                tmpx = t;
                                [tmpy, vrange] = obj.data(n, ps, att, "time", trange);
                            case 2 % 縦横軸明記
                                tmpx = obj.data(n, ps(1), att, "time", trange);
                                tmpy = obj.data(n, ps(2), att, "time", trange);
                            case 3 % ３次元プロット
                                tmpx = obj.data(n, ps(1), att, "time", trange);
                                tmpy = obj.data(n, ps(2), att, "time", trange);
                                tmpz = obj.data(n, ps(3), att, "time", trange);
                        end

                        % plot
                        if length(ps) == 3
                            plot3(tmpx, tmpy, tmpz);
                        else
                            plot(tmpx, tmpy);
                        end
                        hold on

                        switch length(ps)
                            case 3
                                yoffset =- 1.2;
                        end

                        % set title label legend
                        if length(ps) == 1
                            ps = ["t", ps];
                            xlabel("Time [s]");
                        else
                            xlabel(ps(1));
                        end
                        switch ps(2)
                            case "p"
                                title(strcat("Position p of agent", string(n)));
                            case "q"
                                title(strcat("Attitude q of agent", string(n)));
                            case "v"
                                title(strcat("Velocity v of agent", string(n)));
                            case "w"
                                title(strcat("Angular velocity w of agent", string(n)));
                            case "input"
                                title(strcat("Input u of agent", string(n)));
                            otherwise
                                title(ps(2));
                        end
                        if ps(1) ~= "t"
                            title(strcat("phase plot : ", string(param)));
                            switch att
                                case "s"
                                    plegend = [plegend, "sensor"];
                                case "e"
                                    plegend = [plegend, "estimator"];
                                case "r"
                                    plegend = [plegend, "reference"];
                                case "p"
                                    plegend = [plegend, "plant"];
                                otherwise
                                    plegend = [plegend, att];
                            end
                            daspect([1 1 1]);
                        else
                            if isempty(vrange)
                                vrange = string(1:size(tmpy, 2));
                            else
                                vrange = string(vrange);
                            end
                            plegend = [plegend, append(vrange, att)];
                        end
                        ylabel(ps(2));
                        if length(ps) == 3; zlabel(ps(3)); end
                    end
                end
                lgd = legend(plegend);
                if ~fhold
                    hold off
                end
                if fcolor
                    txt = {''};
                    if length([find(obj.Data.phase == 116, 1), find(obj.Data.phase == 116, 1, 'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase == 116, 1), find(obj.Data.phase == 116, 1, 'last')])); % take off phase
                        %                        txt = {txt{:},'{\color{yellow}■} :Take off phase'};
                        txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
                    end
                    if length([find(obj.Data.phase == 102, 1), find(obj.Data.phase == 102, 1, 'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase == 102, 1), find(obj.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0]); % flight phase
                        txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
                    end
                    if length([find(obj.Data.phase == 108, 1), find(obj.Data.phase == 108, 1, 'last')]) == 2
                        Square_coloring(obj.Data.t([find(obj.Data.phase == 108, 1), find(obj.Data.phase == 108, 1, 'last')]), [1.0 0.9 1.0]); % landing phase
                        txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
                    end

                    text(spfi.XLim(2) - (spfi.XLim(2) - spfi.XLim(1)) * 0.25, spfi.YLim(2) + (spfi.YLim(2) - spfi.YLim(1)) * yoffset, txt);
                end
            end
        end
        function [name, vrange] = full_var_name(obj, var, att)
            switch att
                case 's' % sensor
                    name = "sensor.result";
                case 'e' % estimator
                    name = "estimator.result";
                case 'r' % reference
                    name = "reference.result";
                case 'p' % plant
                    name = "plant.result";
                case 'i' %
                    name = "input";
                otherwise
                    name = "";
            end
            variable = regexprep(var, "[0-9:]", "");
            vrange = regexp(var, "[0-9:]", 'match');
            if ~isempty(vrange)
                vrange = str2num(strjoin(vrange));
            end
            switch variable
                case 'p'
                    name = strcat(name, ".state.p");
                case 'q'
                    name = strcat(name, ".state.q");
                case 'v'
                    name = strcat(name, ".state.v");
                case 'w'
                    name = strcat(name, ".state.w");
                case 'input'
                    name = "input";
                otherwise
                    if ~isempty(variable)
                        if ~contains(variable, "result") & name ~= "" % attribute が指定されている場合
                            name = strcat(name, '.', variable);
                        else
                            name = variable;
                        end
                    end
            end
        end
        function X = mtake(obj, x, row, col)
            if isempty(row)
                X = x(:, col);
            else
                X = x(row, col);
            end
        end
    end
end
