function newLog = simplifyLoggerForCoop(log,agentNum)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        agenti = log.Data.agent(agentNum);

        fieldcell = fieldnames(log.Data.agent);
        j = 1;
        tic
        for i = 1:length(fieldcell)
            if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
                fields{j} = fieldcell{i};
                j = j+1;
            end
        end
        %状態の格納
        nf = length(fields);
        % if newLog.fExp
        %     nf = nf-1;
        % end
        for i = 1:nf
            F = fields{i};%Flowing phase
            for i2 = 1:newLog.k
                states = agenti.(fields{i}).result{1, i2}.state.list;
                for i3 = 1:length(states)
                    S = states(i3);%State
                    reult = agenti.(F).result{1, i2}.state.(S);
                    if ~isempty(reult)
                        if (F)+(S) ~= "referenceq"
                            if F + S == "referencexd"
                                xd = agenti.(F).result{1, i2}.state.(S);
                                newLog.(F).(S)(:,i2) = [xd;zeros(28-length(xd),1)];
                            else
                                newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                            end
                        end
                    end
                end
            end
        end
        %入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(agenti.controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};%State
                if S == "mui"
                    newLog.controller.(S)(6*j-5:6*j,:) = agenti.controller.result{1, j}.(S);
                else
                    newLog.controller.(S)(:,j) = agenti.controller.result{1, j}.(S);
                end
            end
        end
        if log.fExp
            for j3 = 1:newLog.k
                newLog.inner_input(:,j3) = agenti.inner_input{1, j3}';
            end
        end
        toc
        whos 'newLog'
end