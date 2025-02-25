function newLog = simplifyLogger(log,agentNum)
        % log:対象のlog, agentNum:logに含まれる機体数
        newLog.t        = log.Data.t(1:log.k);          % 時間の配列
        newLog.phase    = log.Data.phase;               % take offやflightなどの情報が入っている配列
        newLog.k        = log.k;                        % 結果の配列数
        newLog.fExp     = log.fExp;                     % 実験かシミュレーションかのフラグ
        agenti          = log.Data.agent(agentNum);     % 結果の情報

        fieldcell = fieldnames(log.Data.agent);         % agent内のフィールド名を取得(sensor,estimator,controllerなど)
        j = 1;
        tic
        % controller, input, inner_input以外のフィールド名を格納
        for i = 1:length(fieldcell)
            if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
                fields{j} = fieldcell{i};
                j = j+1;
            end
        end
        % 状態の格納(sensor, estimator, reference)
        for i = 1:length(fields)
            F = fields{i};
            for i2 = 1:newLog.k
                states = agenti.(fields{i}).result{1, i2}.state.list;   % stateに格納されている配列の名前
                for i3 = 1:length(states)
                    S = states(i3);                                     % State
                    reult = agenti.(F).result{1, i2}.state.(S);         % 保存されているデータ
                    if ~isempty(reult)
                        if F + S == "referencexd"                       % reference.xdは28列に統一
                            xd = agenti.(F).result{1, i2}.state.(S);
                            newLog.(F).(S)(:,i2) = [xd;zeros(28-length(xd),1)];
                        else
                            newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                        end
                    end
                end
            end
        end
        % 入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(agenti.controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};                                     %State
                if S == "mui"                                           % 張力muiをシミュレーションで保存している場合（もう使わないと思う）
                    newLog.controller.(S)(6*j-5:6*j,:) = agenti.controller.result{1, j}.(S);
                else
                    newLog.controller.(S)(:,j) = agenti.controller.result{1, j}.(S);
                end
            end
        end
        % 実験の場合はinner_input(プロポに送る値)を格納
        if log.fExp
            for j3 = 1:newLog.k
                newLog.inner_input(:,j3) = agenti.inner_input{1, j3}';
            end
        end
        toc
        whos 'newLog' %newLog内の容量を表示する
end