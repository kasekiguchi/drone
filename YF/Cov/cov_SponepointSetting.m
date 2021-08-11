function result = cov_SponepointSetting(env,num,N)
% disp('結果には，4つの配列を用意してMax X,Min X,Max Y,Min Yの順で入れる')
switch env.txt
    case  '3widths straight'
        if num>N/2
            result(1) = max(env.vertices{1}(:,1));
            result(2) = min(env.vertices{1}(:,1));
            result(3) = (max(env.vertices{1}(:,2))-min(env.vertices{1}(:,2)))/3;
            result(4) = min(env.vertices{1}(:,2));
        else
            result(1) = max(env.vertices{1}(:,1));
            result(2) = min(env.vertices{1}(:,1));
            result(3) = max(env.vertices{1}(:,2));
            result(4) = (max(env.vertices{1}(:,2))-min(env.vertices{1}(:,2)))*2/3;
        end
    otherwise
        result(1) = max(env.poly.Vertices(:,1));
        result(2) = min(env.poly.Vertices(:,1));
        result(3) = max(env.poly.Vertices(:,2));
        result(4) = min(env.poly.Vertices(:,2));
end

end