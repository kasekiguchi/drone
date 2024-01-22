function [wind,wind_time] = gen_wind_effect(obj,file_name,opts)
% wind : [angle, speed]
%   angle : 0:南 45:南西 90:西 135:北西 180:北 225:北東 270:東 315:南東
%   speed : m/s
% wind_time : wind(wind_time(k),:) is wind info at time k
arguments
  obj
  file_name
  opts.wind_time_tics = 1 % 
end
%% 風向配列生成
winddata = readtable(file_name);   % csvの読み込み

wspeed_col = 2; % column number of wind speed in csv data
wdir_col = 4; %  column number of wind direction in csv data    % 使うcsv(気象情報)の何行目に風速や風向の情報が入っているかによって可変

wdir = string(table2cell(winddata(5:end,wdir_col))); % wind direction data
wind(:,2) = table2array(winddata(5:end,wspeed_col));
wdir_base= ["南微西","南南西","南西微南","南西","南西微西","西南西","西微南","西","西微北","西北西","北西微西","北西","北西微北","北北西","北微西","北","北微東","北北東","北東微北","北東","北東微東","東北東","東微北","東","東微南","東南東","南東微東","南東","南東微南","南南東","南微東","南"];
for i = 1:length(wdir_base)
  wind(wdir == wdir_base(i),1) = (pi/180)*rem(i,32)*360/32 - obj.shape_opts.north_dir; % wind direction : 0 = 'south', 90 = 'west'
end

wind_time = kron((1:size(wind,1))',ones(hours(table2array(winddata(end,1)-winddata(end-1,1)))*obj.time_scale,1));

end
