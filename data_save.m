clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
cd(cf); close all hidden; clear all; userpath('clear');
log = LOGGER('./Data/asteroid_Log(13-Oct-2023_19_26_27).mat');
p  = log.data(1,"p","e");
q  = log.data(1,"q","e");
v  = log.data(1,"v","e");
w  = log.data(1,"w","e");

save("./Data/data7")
