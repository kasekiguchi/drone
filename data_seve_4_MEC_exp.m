clear;clc;
cf = pwd;
close all
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end
j2 = 40;
j = j2;


% 保存する変数を初期化
z1 = [];
z2 = [];
z3 = [];
z4 = [];
input = [];
q = [];
p = [];
v = [];
w = [];
ref_q = [];
ref_p = [];
ref_v = [];


% .mat ファイルを読み込み
log = load("Data\OriginalData\exp_4_MEC\exp_test_saddle.mat");
logger = simplifyLogger(log.log);
data = DataStructure(logger);

F = find(logger.phase==102); %flight_index

input = data.input(:,F(1):F(end));
delta_u = data.delta_u(:,F(1):F(end));
p = data.p(:,F(1):F(end));
q = data.q(:,F(1):F(end));
v = data.v(:,F(1):F(end));
w = data.w(:,F(1):F(end));

clearvars -except p q v w delta_u input
save('Data\data_saddle.mat')

function data = DataStructure(logger)
    
    % NN_xi=c.xi_log;
    data.input = logger.controller.input;
    data.delta_u = logger.controller.delta_u;

    data.q = logger.estimator.q;
    data.p = logger.estimator.p;
    data.v = logger.estimator.v;
    data.w = logger.estimator.w;
    
    % ref_w = c.w; wのリファレンスは存在しません
end


function newLog = simplifyLogger(log)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        
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
        for i = 1:length(fields)
            F = fields{i};%Flowing phase
            for i2 = 1:newLog.k
                states = log.Data.agent.(fields{i}).result{1, i2}.state.list;
                for i3 = 1:length(states)
                    S = states(i3);%State
                    if S ~= "xd"
                        newLog.(F).(S)(:,i2) = log.Data.agent.(F).result{1, i2}.state.(S);
                    end
                end
            end
        end
        %入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(log.Data.agent.controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};%State         
                    newLog.controller.(S)(:,j) = log.Data.agent.controller.result{1, j}.(S);
            end
        end
        if log.fExp
            for j3 = 1:newLog.k
                newLog.inner_input(:,j3) = log.Data.agent.inner_input{1, j3}';
            end
        end
        toc
        whos 'newLog'

        
end

