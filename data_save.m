clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end

files = dir('Data/data1.mat');
for i = 1:length(files)
    % a = files(i).name;
    % str="data"+num2str(i)+".mat";
    % cd Data
    % movefile(a,str);
    % cd ..

end
log = LOGGER("./Data/waypoint.mat");
for j = 1:i
    [~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
    cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
    % cd(cf); close all hidden; clear all; userpath('clear');
    
    mat = Eul2Quat(log.data(1,"q","e")');
    rotmat = for_RodriguesQuaternion(mat);
    p  = log.data(1,"p","e");
    q  = log.data(1,"q","e");
    v  = log.data(1,"v","e");
    w  = log.data(1,"w","e");
    input = cell2mat(log.Data.agent.input);
    
    
    newLog.k = log.k;
    for j = 1:newLog.k
        fieldcell2 = fieldnames(log.Data.agent.controller.result{1, j});
        for j2 = 1:length(fieldcell2)
            S = fieldcell2{j2};%State         
            newLog.controller.(S)(:,j) = log.Data.agent.controller.result{1, j}.(S);
        end
    end
    for j = 1:newLog.k
        fieldcell2 = fieldnames(log.Data.agent.reference.result{1, j}.state);
        for j2 = 1:length(fieldcell2)
            S = fieldcell2{j2};%State         
            newLog.reference.(S)(:,j) = log.Data.agent.reference.result{1, j}.state.(S);
        end
    end
    c=newLog.controller;
    z1=c.z1;
    z2=c.z2;
    z3=c.z3;
    z4=c.z4;
    uHL=c.uHL;
    
    c = newLog.reference;
    Reference = c.xd;
    
    
    clearvars -except p q v w Reference rotmat uHL z1 z2 z3 z4 input
    save("./Data/data_for_Py_mywaypoint")
end

function rotmat = for_RodriguesQuaternion(mat)

    rotmat = zeros(3,3,length(mat));

    for i=1:length(mat)
        rotmat(:,:,i) = RodriguesQuaternion(mat(:, i));
    end
end