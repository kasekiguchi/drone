% function newLog = simplifyLogger(log)
%         % name = ['new_', inputname(1)];
%         newLog.t = log.Data.t(1:log.k);    
%         newLog.phase = log.Data.phase;
%         newLog.k = log.k;
%         newLog.fExp = log.fExp;
%         N = 2;
%         for ii = 1:N
% 
%         fieldcell = fieldnames(log.Data.agent(ii));
%         j = 1;
%         tic
%         for i = 1:length(fieldcell)
%             if ~isequal(fieldcell{ii},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
%                 fields{j} = fieldcell{i};
%                 j = j+1;
%             end
%         end
%         %状態の格納
%         for i = 1:length(fields)
%             F = fields{i};%Flowing phase
%             for i2 = 1:newLog.k
%                 states = log.Data.agent(ii).(fields{i}).result{1, i2}.state.list;
%                 for i3 = 1:length(states)
%                     S = states(i3);%State
%                     if S ~= "xd"
%                         newLog.(F).(S)(:,i2) = log.Data.agent(ii).(F).result{1, i2}.state.(S);
%                     end
%                 end
%             end
%         end
%         %入力の格納
%         for j = 1:newLog.k
%             fieldcell2 = fieldnames(log.Data.agent(ii).controller.result{1, j});
%             for j2 = 1:length(fieldcell2)
%                 S = fieldcell2{j2};%State         
%                     newLog.controller.(S)(:,j) = log.Data.agent(ii).controller.result{1, j}.(S);
%             end
%         end
%         if log.fExp
%             for j3 = 1:newLog.k
%                 newLog.inner_input(:,j3) = log.Data.agent(ii).inner_input{1, j3}';
%             end
%         end
%         end
%         toc
%         whos 'newLog'
% 
% end

% function newLog = simplifyLogger(log)
%         % name = ['new_', inputname(1)];
%         newLog.t = log.Data.t(1:log.k);    
%         newLog.phase = log.Data.phase;
%         newLog.k = log.k;
%         newLog.fExp = log.fExp;
% 
%         fieldcell = fieldnames(log.Data.agent(1));
%         j = 1;
%         tic
%         for i = 1:length(fieldcell)
%             if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
%                 fields{j} = fieldcell{i};
%                 j = j+1;
%             end
%         end
%         %状態の格納
%         for i = 1:length(fields)
%             F = fields{i};%Flowing phase
%             for i2 = 1:newLog.k
%                 states = log.Data.agent(1).(fields{i}).result{1, i2}.state.list;
%                 for i3 = 1:length(states)
%                     S = states(i3);%State
%                     if S ~= "xd"
%                         newLog.(F).(S)(:,i2) = log.Data.agent(1).(F).result{1, i2}.state.(S);
%                     end
%                 end
%             end
%         end
%         %入力の格納
%         for j = 1:newLog.k
%             fieldcell2 = fieldnames(log.Data.agent(1).controller.result{1, j});
%             for j2 = 1:length(fieldcell2)
%                 S = fieldcell2{j2};%State         
%                     newLog.controller.(S)(:,j) = log.Data.agent(1).controller.result{1, j}.(S);
%             end
%         end
%         if log.fExp
%             for j3 = 1:newLog.k
%                 newLog.inner_input(:,j3) = log.Data.agent(1).inner_input{1, j3}';
%             end
%         end
% 
%         toc
%         whos 'newLog'
% 
% end

function newLog = simplifyLogger(log)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;

        fieldcell = fieldnames(log.Data.agent(2));
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
                states = log.Data.agent(2).(fields{i}).result{1, i2}.state.list;
                for i3 = 1:length(states)
                    S = states(i3);%State
                    if S ~= "xd"
                        newLog.(F).(S)(:,i2) = log.Data.agent(2).(F).result{1, i2}.state.(S);
                    end
                end
            end
        end
        %入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(log.Data.agent(2).controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};%State         
                    newLog.controller.(S)(:,j) = log.Data.agent(2).controller.result{1, j}.(S);
            end
        end
        if log.fExp
            for j3 = 1:newLog.k
                newLog.inner_input(:,j3) = log.Data.agent(2).inner_input{1, j3}';
            end
        end

        toc
        whos 'newLog'

end