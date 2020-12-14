function sensor_obj = sensor_selector(type,param)
% 無用な関数
%   詳細説明をここに記述
switch type
    case "LiDAR_sim"
        sensor_obj = LiDAR_sim(param);
    case "LiDAR_exp"
    case "Prime"
    case "Position"
    case "none_sense"
    otherwise
        disp("Unknown sensor! Let's implement it.");
end

end

