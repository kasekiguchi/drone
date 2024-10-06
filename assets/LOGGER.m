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
    k; % time index for logging
    target % 保存対象の agent indices : example 2:4 : default 1:N
    items % 追加で保存するアイテム名
    item_num % 追加保存のアイテム数
    agent_items % result以外で追加保存するagent内の変数
    fExp
    overwrite_target = ["all"];
  end

  methods

    function obj = LOGGER(target, number, fExp, items, agent_items, option)
      % LOGGER(target,row,items)
      % target : ログを取る対象　example 1:3, usage agent(obj.target)
      % number : 確保するデータサイズ　length(ts:dt:te)
      % agent_items : default以外で保存するデータ ["inner_input"]
      % items  : agent 以外で保存するデータの名前
      %         以下のように名前と保存するものの対応が取れていなくても可
      %         LOGGER=LOGGER(~,~,"innerInput",~);
      %         LOGGER.logging(t,FH,agent,motive);
      % 【ログの呼び出し】
      % LOGGER.saveで保存したデータを呼び出してloggerとして登録することができる．
      % logger=LOGGER("Data/filename.mat")
      % logger=LOGGER("Data/dirname");
      arguments
        target
        number = []
        fExp = []
        items = []
        agent_items = []
        option.overwrite_target = []
      end

      if isstring(target) || ischar(target) % save で保存されたデータを呼び出す場合

        if ~contains(target, ".mat") % separate で保存された場合

          if contains(target, "Data.mat")
            target = erase(target, "/Data.mat");
          end

          tmp = load(target + "/Data.mat");
          fn = fieldnames(obj);

          
          
          for i = fn'
            obj.(i{1}) = tmp.log.(i{1});
          end

          tmp = load(target + "/sensor.mat");
          obj.Data.agent.sensor = tmp.sensor;
          tmp = load(target + "/estimator.mat");
          obj.Data.agent.estimator = tmp.estimator;
          tmp = load(target + "/reference.mat");
          obj.Data.agent.reference = tmp.reference;
          tmp = load(target + "/input.mat");
          obj.Data.agent.input = tmp.input;
          tmp = load(target + "/controller.mat");
          obj.Data.agent.controller = tmp.controller;
          tmp = load(target + "/plant.mat");
          obj.Data.agent.plant = tmp.plant;
        else % 一つのファイルとして保存した場合
          tmp = load(target);
          log = tmp.log;
          fn = fieldnames(log);

          for i = fn'
            obj.(i{1}) = log.(i{1});
          end

        end

        if ~isempty(number)
          obj.overwrite_target = option.overwrite_target;
        end

      else
        obj.k = 0;
        obj.target = target;
        obj.Data.t = zeros(number, 1); % 時間
        obj.Data.phase = zeros(number, 1); % フライトフェーズ　a,t,f,l...
        obj.fExp = fExp;
        obj.items = items;

        if ~isempty(items)

          for i = items
            obj.Data.(i) = {};
          end

        end

        obj.agent_items = agent_items;
        obj.Data.agent = struct();
      end

    end

    function logging(obj, time, cha, agent, items)
      % logging(t,FH)
      % t : current time
      % FH : figure handle for keyboard input
      arguments
        obj
        time
        cha
        agent
      end
      arguments (Repeating)
        items
      end

      t = time.t;
      if isempty(cha)
        %                error("ACSL : FH is empty");
        cha = obj.Data.phase(obj.k);
      end
      % if t == 0 %初期値
      %   obj.k = 1;
      %   obj.Data.t(obj.k) = t;
      %   obj.Data.phase(obj.k) = cha;
      %   for n = obj.target
      %     obj.Data.agent(n).estimator.result{1}.state = state_copy(agent(n).estimator.result.state);
      %     obj.Data.agent(n).plant.result{1}.state = state_copy(agent(n).plant.state);
      %   end
      % else
        obj.k = obj.k + 1;
        obj.Data.t(obj.k) = t;
        obj.Data.phase(obj.k) = cha;

        for i = 1:length(obj.items)
          obj.Data.(obj.items(i)){obj.k} = items{i};
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
          obj.Data.agent(n).controller.result{obj.k} = agent(n).controller.result;

          if isfield(agent(n).sensor.result, "state")
            obj.Data.agent(n).sensor.result{obj.k}.state = state_copy(agent(n).sensor.result.state);
          end

          obj.Data.agent(n).estimator.result{obj.k}.state = state_copy(agent(n).estimator.result.state);
          obj.Data.agent(n).reference.result{obj.k}.state = state_copy(agent(n).reference.result.state);
          obj.Data.agent(n).input{obj.k} = agent(n).controller.result.input;

          if obj.fExp
            obj.Data.agent(n).inner_input{obj.k} = agent(n).input_transform.result;
          else
            obj.Data.agent(n).plant.result{obj.k}.state = state_copy(agent(n).plant.state);
          end

        end
      %end

    end

    function save(obj, name, opt)
      % save log.Data keeping its structure as a file Data/Log(datetime).mat
      % retrieve it by logger = LOGGER("./Data/file.mat");
      arguments
        obj
        name = []
        opt.range = 1:length(obj.Data.phase); %find(obj.Data.phase,1,'last');
        opt.separate = false;
      end

      drange = opt.range;

      if isempty(name)
        tmpname = strrep(strrep(strcat('Log(', datestr(datetime('now')), ')'), ':', '_'), ' ', '_');
      else
        tmpname = strrep(strrep(strcat('', name, '_Log(', datestr(datetime('now')), ')'), ':', '_'), ' ', '_');
      end

      if opt.separate
        dirname = "Data/" + tmpname;
        mkdir(dirname);
        filename = dirname + "/Data.mat";
        Data.t = obj.Data.t;
        Data.phase = obj.Data.phase;
        fn = fieldnames(obj);

        for i = fn'

          if ~strcmp(i{1}, "Data")
            log.(i{1}) = obj.(i{1});
          end

        end

        log.Data = Data;
        fn = fieldnames(obj.Data);

        for i = fn'

          if ~strcmp(i{1}, "t") & ~strcmp(i{1}, "phase") & ~strcmp(i{1}, "agent")
            log.Data.(i{1}) = obj.Data.(i{1});
          end

        end

        save(filename, "log");
        sensor = obj.Data.agent.sensor;
        save(dirname + "/sensor.mat", "sensor");
        estimator = obj.Data.agent.estimator;
        save(dirname + "/estimator.mat", "estimator", "-v7.3");
        reference = obj.Data.agent.reference;
        save(dirname + "/reference.mat", "reference");
        input = obj.Data.agent.input;
        save(dirname + "/input.mat", "input");
        controller = obj.Data.agent.controller;
        save(dirname + "/controller.mat", "controller");
        plant = obj.Data.agent.plant;
        save(dirname + "/plant.mat", "plant");
      else
        filename = tmpname;
        list = "Data/" + filename + ".mat";
        log.Data = obj.Data;
        fn = fieldnames(obj);

        for i = fn'

          if ~strcmp(i{1}, "Data")
            log.(i{1}) = obj.(i{1});
          end

        end

        save(list, 'log');
      end

    end

    function overwrite(obj, str, t, agent, n)
      % overwrite(str,t,agent,n)
      % agent(n).(str).result の情報をData情報で上書き
      if sum(contains(obj.overwrite_target, str) + strcmp(obj.overwrite_target, "all")) > 0
        %tidx = find((obj.Data.t-t)>=0,1); % 現在時刻に最も近い過去のデータを参照
        [~, tidx] = min(abs(obj.Data.t - t)); % 現在時刻に最も近い過去のデータを参照

        switch str
          case "sensor"
            agent(n).sensor.result = obj.Data.agent(n).sensor.result{tidx};
            agent(n).sensor.result.state = state_copy(obj.Data.agent(n).sensor.result{tidx}.state);
          case "estimator"
            agent(n).estimator.result = obj.Data.agent(n).estimator.result{tidx};
            agent(n).estimator.result.state = state_copy(obj.Data.agent(n).estimator.result{tidx}.state);
          case "reference"
            agent(n).reference.result = obj.Data.agent(n).reference.result{tidx};
            agent(n).reference.result.state = state_copy(obj.Data.agent(n).reference.result{tidx}.state);
          case "controller"
            agent(n).controller.result = obj.Data.agent(n).controller.result{tidx};
            agent(n).input = obj.Data.agent(n).input{tidx};
          case "plant"
            agent(n).plant.state = state_copy(obj.Data.agent(n).plant.result{tidx}.state);
        end

      end

    end

    function [data, vrange] = data(obj, target, variable, attribute, option)
      % target : agent indices
      % variable : var name or path to var from agent
      %            or path from result if attribute is set.
      % attribute : "s","e","r","p","i"
      % option ranget : time range
      % Examples
      % time : data(0,'t',[])
      % state : data(1,"p","e")                      : agent1's estimated position
      %         data(2,"state.xd","r")               : agent2's reference xd
      %         data(1,"sensor.result.state.q",[])   : agent1's measured attitude
      % input : data(1,[],"i") or data(1,"input",[]) : agent1's input data
      % items : data(0,"item_name",[])               : items which
      %               does not depend on agent requires first input 0
      % data(1,"p","r","ranget",[0,2])               : take the data in time span [0 2]
      arguments
        obj
        target
        variable string = "p"
        attribute string = "e"
        option.ranget (1, 2) double = [0 0]
      end
      if obj.k == 0
        data = [];
        vrange = [];
      else
        if option.ranget(2) ==0
          option.ranget(2) = obj.Data.t(obj.k);
        end
        if sum(strcmp(target, {'time', 't'}))
          data = obj.data_org(0, 't', '', "ranget", option.ranget);
        elseif target == 0
          data = obj.data_org(0, variable, attribute, "ranget", option.ranget);
        else
          data = cell2mat(arrayfun(@(i) obj.data_org(i, variable, attribute, "ranget", option.ranget), target, 'UniformOutput', false));
        end

        [~, vrange] = obj.full_var_name(variable, attribute);
      end
    end

    function [data, vrange] = data_org(obj, n, variable, attribute, option)
      % n : agent index
      arguments
        obj
        n
        variable string = "p"
        attribute string = "e"
        option.ranget (1, 2) double = [0 obj.Data.t(obj.k)]
      end

      [variable, vrange] = obj.full_var_name(variable, attribute);
      attribute = "";
      data_range = find((obj.Data.t - option.ranget(1)) > 0, 1) - 1:find((obj.Data.t - option.ranget(2)) >= 0, 1);
      if isempty(data_range)
        data_range = [1];
      end
      if sum(strcmp(n, {'time', 't'})) % 時間軸データ
        data = obj.Data.t(data_range);
      elseif n == 0 % n : agent number.  n=0 => obj.itmesのデータ
        variable = split(variable, '.'); % member毎に分割
        data = [obj.Data.(variable{1})];

        for j = 2:length(variable)
          data = [data.(variable{j})];
        end

        data = data(data_range);
      else % agentに関するデータ
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
      % function for data_org
      for j = 1:length(variable)
        fn = fieldnames(data); % フィールド名に数字を含む場合のケア
        %data = [data.(variable(j))];
        data = vertcat(data.(fn{contains(fn,variable(j))}));

        if strcmp(variable(j), 'state')

          for k = 1:length(data)
            %ndata(k, :, :) = data(k).(variable(j + 1))(1:data(k).num_list(strcmp(data(k).list, variable(j + 1))), :);
            ndata(k, :, :) = data(k).(variable(j + 1));
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
      %         trange : time span
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
        option.FH = [];
        option.ax = [];
        option.xrange = [];
        option.yrange = [];
        option.zrange = [];
      end

      ranget = option.time; % time range
      fig_num = option.fig_num; % figure number
      frow = option.row_col(1); % subfigure row number
      fcol = option.row_col(2); % subfigure col number
      fcolor = option.color; % on/off flag for phase coloring
      fhold = option.hold; % on/off flag for holding (only active to last subfigure)

      t = obj.data(0, "t", [], "ranget", ranget); % time data
      if isempty(option.ax)
        fh = figure(fig_num);
        %fh.WindowState = 'maximized';
        ax = gca;
      else
        ax = option.ax;
      end
      switch frow
        case 1
          yoffset = 0.05;
        case 2
          yoffset = 0.1;
        otherwise
          yoffset = 0;
      end

      for fi = 1:length(list) % fi : 図番号
        if length(list) == 1
          spfi = ax;
        else
          ax = subplot(frow, fcol, fi);
        end
        plegend = [];
        N = list{fi}{1}; % indices of variable drones. example : [1 2]
        param = list{fi}{2}; % p,q,v,w, etc
        attribute = list{fi}{3}; % e,s,r,p
        if strcmp(attribute, ""); attribute = " "; end

        for n = N

          for a = 1:strlength(attribute)
            ps = split(param, '-'); % separate by '-', each in {p q v w}
            att = extract(attribute, a); % attribute {s e r p}

            switch length(ps)
              case 1 % 時間応答（時間を省略）
                tmpx = t;
                [tmpy, vrange] = obj.data(n, ps, att, "ranget", ranget);
              case 2 % 縦横軸明記
                tmpx = obj.data(n, ps(1), att, "ranget", ranget);
                tmpy = obj.data(n, ps(2), att, "ranget", ranget);
              case 3 % ３次元プロット
                tmpx = obj.data(n, ps(1), att, "ranget", ranget);
                tmpy = obj.data(n, ps(2), att, "ranget", ranget);
                tmpz = obj.data(n, ps(3), att, "ranget", ranget);
            end

            % plot
            switch att % set line type
              case 'r'
                lt = '--'; % dashed
              case 's'
                lt = ':'; % dotted
              otherwise
                lt = '-'; % line
            end
            if length(ps) == 3
              plot3(ax,tmpx, tmpy, tmpz,LineStyle=lt);
            else
              plot(ax,tmpx, tmpy(:, :, 1),LineStyle=lt); % tmpy(1:size(tmpx,1),:,1)
              if option.xrange
                xlim(ax,option.xrange);
              else
                xlim(ax,[min(tmpx), max(tmpx)]);
              end
              ylim(ax,[min(tmpy,[],'all'), max(tmpy,[],'all')+0.01]);
            end

            hold(ax, "on");
            grid(ax, "on");

            switch length(ps)
              case 3
                yoffset =- 1.2;
            end

            % set title label legend
            if length(ps) == 1
              ps = ["t", ps];
              xlabel(ax,"Time [s]");
            else
              xlabel(ax,ps(1));
            end

            switch ps(2)
              case "p"
                title(ax,strcat("Position p of agent", string(n)));
              case "q"
                title(ax,strcat("Attitude q of agent", string(n)));
              case "v"
                title(ax,strcat("Velocity v of agent", string(n)));
              case "w"
                title(ax,strcat("Angular velocity w of agent", string(n)));
              case "z"
                title(ax,strcat("Position error integration of agent", string(n)));
              case "input"
                title(ax,strcat("Input u of agent", string(n)));
              otherwise
                title(ax,ps(2));
            end

            if ps(1) ~= "t"
              title(ax,strcat("phase plot : ", string(param)));

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

              daspect(ax,[1 1 1]);
            else

              if isempty(vrange)
                vrange = string(1:size(tmpy, 2));
              else
                vrange = string(vrange);
              end

              plegend = [plegend, append(vrange, att)];
            end

            ylabel(ax, ps(2));
            if length(ps) == 3; zlabel(ax, ps(3)); end
          end

        end

        lgd = legend(ax,plegend);

        if ~fhold
          hold(ax,"off");
        end

        if fcolor
          txt = {''};

          if length([find(obj.Data.phase == 116, 1), find(obj.Data.phase == 116, 1, 'last')]) == 2
            Square_coloring(obj.Data.t([find(obj.Data.phase == 116, 1), find(obj.Data.phase == 116, 1, 'last')]),[],[],[],ax); % take off phase
            %                        txt = {txt{:},'{\color{yellow}■} :Take off phase'};
            txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
          end

          if length([find(obj.Data.phase == 102, 1), find(obj.Data.phase == 102, 1, 'last')]) == 2
            Square_coloring(obj.Data.t([find(obj.Data.phase == 102, 1), find(obj.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],ax); % flight phase
            txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
          end

          if length([find(obj.Data.phase == 108, 1), find(obj.Data.phase == 108, 1, 'last')]) == 2
            Square_coloring(obj.Data.t([find(obj.Data.phase == 108, 1), find(obj.Data.phase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],ax); % landing phase
            txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
          end

          text(ax,ax.XLim(2) - (ax.XLim(2) - ax.XLim(1)) * 0.25, ax.YLim(2) + (ax.YLim(2) - ax.YLim(1)) * yoffset, txt);
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
      % variable = var;
      % vrange = [];
      switch variable
        case 'p'
          name = strcat(name, ".state.p");
        case 'q'
          name = strcat(name, ".state.q");
        case 'v'
          name = strcat(name, ".state.v");
        case 'w'
          name = strcat(name, ".state.w");
        case 'z'
          name = strcat(name, ".state.z");
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
