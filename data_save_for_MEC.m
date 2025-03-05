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

% 繰り返し文でデータを読み込み、連結
for i = 1:j
    i
    % .mat ファイルを読み込み
    log = load(strcat("Data\learning_data\data", num2str(i), ".mat"));
    logger = simplifyLogger(log.logger(1,1));
    Pn = DataStructure(logger);
    
    % データを連結
    z1 = [z1 Pn.z1];
    z2 = [z2 Pn.z2];
    z3 = [z3 Pn.z3];
    z4 = [z4 Pn.z4];
    input = [input Pn.input];
    q = [q Pn.q];
    p = [p Pn.p];
    v = [v Pn.v];
    w = [w Pn.w];
    ref_q = [ref_q Pn.q];
    ref_p = [ref_p Pn.p];
    ref_v = [ref_v Pn.v];
end

clearvars -except p q v w Reference rotmat uHL z1 z2 z3 z4 input
save('Data\data_Pn_07.mat')

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

j2 = 40;
j = j2;
% 繰り返し文でデータを読み込み、連結
for i = 1:j
    i
    % .mat ファイルを読み込み
    log = load(strcat("Data\learning_data\data", num2str(i), ".mat"));
    logger = simplifyLogger(log.logger(1,2));
    Pn = DataStructure(logger);
    
    % データを連結
    z1 = [z1 Pn.z1];
    z2 = [z2 Pn.z2];
    z3 = [z3 Pn.z3];
    z4 = [z4 Pn.z4];
    input = [input Pn.input];
    q = [q Pn.q];
    p = [p Pn.p];
    v = [v Pn.v];
    w = [w Pn.w];
    ref_q = [ref_q Pn.q];
    ref_p = [ref_p Pn.p];
    ref_v = [ref_v Pn.v];
end

clearvars -except p q v w Reference rotmat uHL z1 z2 z3 z4 input
save('Data\data_Pa_07.mat')

function data = DataStructure(logger)
    c=logger.controller;
    data.z1=c.z1;
    data.z2=c.z2;
    data.z3=c.z3;
    data.z4=c.z4;
    % NN_xi=c.xi_log;
    data.input = c.input;
        
    c = logger.plant;
    data.q = c.q;
    data.p = c.p;
    data.v = c.v;
    data.w = c.w;
    
    c2 = logger.reference;
    data.ref_q = c2.q;
    data.ref_p = c2.p;
    data.ref_v = c2.v;
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

