% log= 'log_FT3_EL_ME_lx10_ly30_mass50';
% eval(['simple_',log,'= changeLogger(',log,');']);
function newLog = simplifyLogger(log)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        
        fieldcell = fieldnames(log.Data.agent);
        j = 1;
        j2 = 1;
        tic
        for i = 1:length(fieldcell)
            if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
                fields{j} = fieldcell{i};
                j = j+1;
            elseif ~isequal(fieldcell{i},'input')
                fields2{j2} = fieldcell{i};
                j2 = j2+1;
            end
        end
     
        %状態の格納
        for i = 1:length(fields)
            states = log.Data.agent.(fields{i}).result{1, 1}.state.list;
            for i2 = 1:newLog.k
                for i3 = 1:length(states)
                    F = fields{i};%Flowing phase
                    S = states(i3);%State
                    newLog.(F).(S)(:,i2) = log.Data.agent.(F).result{1, i2}.state.(S);
                end
            end
        end
        %入力の格納
        for j = 1:length(fields2)
            fieldcell2 = fieldnames(log.Data.agent.(fields2{j}).result{1, 1});
            for j2 = 1:newLog.k
                for j3 = 1:length(fieldcell2)
                    F = fields2{j};%Flowing phase
                    S = fieldcell2{j3};%State
                    newLog.(F).(S)(:,j2) = log.Data.agent.(F).result{1, j2}.(S);
                end
            end
        end
        if log.fExp
            for j2 = 1:newLog.k
                newLog.inner_input(:,j2) = log.Data.agent.inner_input{1, j2}';
            end
        end
        toc
        whos 'newLog'
end