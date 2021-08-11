function agentstate = save_all_times(yasui)
%nan刻みでエージェントの位置情報を再定義．
    N = length(yasui.save.agent);
    for i=1:N
        TF = ismissing(yasui.save.agent{i}.state);
        num_end = length(yasui.save.agent{i}.state);
        nan_num = find(TF(1,:));
        nan_num = [1,nan_num,num_end];
        nan_count = length(nan_num);
        for tt =2:nan_count
            agentstate{i,tt-1} = yasui.save.agent{i}.state(:,nan_num(tt-1):nan_num(tt));
            
        end
    end
end