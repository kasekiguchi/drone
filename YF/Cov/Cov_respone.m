function result = Cov_respone(agent)
%エリアを指定してランダムに場所指定
ref_name = agent.reference.name{1};
    xd = agent.reference.(ref_name).xd;
    tmp = agent.reference.(ref_name).param{1};
    idx = tmp(1,:)==xd(1)&tmp(2,:)==xd(2);
    other_goal = unique(tmp(:,~idx)','rows')';
    if isempty(other_goal)
        result = [0 0];
    else
        [~,m] = size(other_goal);
        rp = (100)/m;
        r = randi([0 100],1,1);
        for j=1:m
            aaa = j*rp;
            if r<=aaa
                resupone_point = other_goal(:,j);
                break;
            end
        end
        if m==1
            resupone_point = other_goal;
        end
        while 1
            r = -1+(1+1).*rand(2,1);
            result= resupone_point+1*r;
            if isinterior(agent.env.huma_load.param.spone_area,result(1),result(2))
                break
            end
        end
    end

