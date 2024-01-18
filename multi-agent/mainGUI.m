 %% Initialize settings
% set path
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear ; clc;
userpath('clear');
%%
clc
wind_data = 'data_ito.csv';
shape_data = '20160401/20160401-建築物の外周線.shp';
W_data = [];
flag.wind_average = 1;
flag.debug = 0;
flag.ns = [0.07,0.3,2.4];
flag.nf = [0.075,1.2,1.5];
unum = 1;
step_end = 240;
shape_opts.start_point = [670,230]; % マップ左下から見た位置 [m,m]
shape_opts.map_size = [300,300]; % north_dir で回転した後の start_pointからの領域 [m m]
shape_opts.data_type = "m";
shape_opts.north_dir = -12*(pi/180); % rad
gui = FireSimulation(flag,shape_data,shape_opts,W_data,unum,step_end,wind_data);