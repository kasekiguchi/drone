function distance = Cov_distance(agent1,agent2,flag)
%距離計算プログラム．[x;y]で与えて
%後ろー＞前のベクトルが出る
N1 = length(agent1);
N2 = length(agent2);

if N1==2||N2==2
        dx = agent1(1,1)-agent2(1,1);
        dy = agent1(2,1)-agent2(2,1);
        result = sqrt(dx^2+dy^2);

elseif N1==3&&N2==3
        dx = agent1(1,1)-agent2(1,1);
        dy =agent1(2,1)-agent2(2,1);
        dz =agent1(3,1)-agent2(3,1);
        result = sqrt(dx^2+...
                      dy^2+...
                      dz^2);
end

if flag ==1
distance.result = result;
distance.dx = dx;
distance.dy = dy;
else
    distance = result;
end

end