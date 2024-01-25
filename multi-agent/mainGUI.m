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
warning('off','MATLAB:table:ModifiedAndSavedVarnames');
%%
clc
if exist("gui","var")
  delete(gui);
end
wind_data = 'data_ito.csv';
shape_data = '20160401/20160401-建築物の外周線.shp';
W_data = './LOG/W_20160401--20160401-建築物の外周線.shp_670,230,300,300,0.2094395';
%W_data = [];
flag.wind_average = 0;
flag.debug = 0;
flag.ns = [1]; % gains for speading fire : to be 80 m/h under 10 m/s wind 
flag.nf = [1,1,0.0001]; % gains for flying fire
unum = 1;
step_end = 240;
shape_opts.start_point = [670,230]; % マップ左下から見た位置 [m,m]
shape_opts.map_size = [300,300]; % north_dir で回転した後の start_pointからの領域 [m m]
shape_opts.data_type = "m";
shape_opts.north_dir = -12*(pi/180); % rad
%shape_opts.fire_point = [54;   8];
wind_data = ["南",10];
W_data = ones(100,100);
shape_opts.north_dir = 0;
gui = FireSimulator(flag,shape_data,shape_opts,W_data,unum,step_end,wind_data);