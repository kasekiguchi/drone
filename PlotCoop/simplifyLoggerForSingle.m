function newLog = simplifyLoggerForSingle(log,agentNum)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        agenti = log.Data.agent(agentNum);

        fieldcell = fieldnames(agenti);
        j = 1;
        tic
        for i = 1:length(fieldcell)
            if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
                fields{j} = fieldcell{i};
                j = j+1;
            end
        end
        %状態の格納
        for i = 1:length(fields)
            F = fields{i};%Flowing phase
            for i2 = 1:newLog.k
                states = agenti.(fields{i}).result{1, i2}.state.list;
                for i3 = 1:length(states)
                    S = states(i3);%State
                    reult = agenti.(F).result{1, i2}.state.(S);
                    if ~isempty(reult)
                        % if (F)== "reference"
                        %     if S == "xd"%||S == "yaw"
                        %         xd = agenti.(F).result{1, i2}.state.(S);
                        %         newLog.(F).(S)(:,i2) = [xd;zeros(28-length(xd),1)];
                        %     % elseif S == "yaw"
                        %     %     newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                        %     end
                        % else
                        %     newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                        % end
                        if (F)+(S) ~= "referenceq"
                            if F + S == "referencexd"
                                xd = agenti.(F).result{1, i2}.state.(S);
                                newLog.(F).(S)(:,i2) = [xd;zeros(28-length(xd),1)];
                            else
                                newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                            end
                        end
                        % if (F)+(S) ~= "referenceq"
                        %     if F + S == "referencexd"
                        %         xd = agenti.(F).result{1, i2}.state.(S);
                        %         newLog.(F).(S)(:,i2) = [xd;zeros(28-length(xd),1)];
                        %     else
                        %         newLog.(F).(S)(:,i2) = agenti.(F).result{1, i2}.state.(S);
                        %     end
                        % else
                        %     newLog.(F).(S)(:,i2) = zeros(28,1);
                        % end
                    % else
                    %     newLog.(F).(S)(:,i2) = zeros(28,1);
                    end
                end
            end
        end
        %入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(agenti.controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};%State
                reult = agenti.controller.result{1, i2}.(S);
                if ~isempty(reult)
                    newLog.controller.(S)(:,j) = agenti.controller.result{1, j}.(S);
                end
            end
        end
        if log.fExp
            for j3 = 1:newLog.k
                reult = agenti.inner_input{1,j3};
                if ~isempty(reult)
                    newLog.inner_input(:,j3) = agenti.inner_input{1, j3}';
                else
                    newLog.inner_input(:,j3) = zeros(8,1);
                end
            end
        end
        toc
        whos 'newLog'
end