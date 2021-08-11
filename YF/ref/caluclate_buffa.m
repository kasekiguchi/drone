function result = caluclate_buffa(node,xd)
 [~,num_node] = size(node.point);
%ユークリッド距離で目標位置にいちばん近いノードをゴールと仮定
[~,goal_node] = min(arrayfun(@(i) norm(xd-node.point(1:2,i),2) , 1:num_node));


glph_node = [node.s;node.t;node.weights];
glph_node2 = [node.s2;node.t2;node.weights2];
result = zeros(2,num_node);
for i = 1:num_node
%     if i==110
%        disp('a') 
%     end
    P = shortestpath(graph([node.s],[node.t],[node.weights]),goal_node,i);%
    P2 = shortestpath(graph([node.s2],[node.t2],[node.weights2]),goal_node,i);%

    qqq = length(P);%nodeの数算出
    qqq2 = length(P2);%nodeの数算出
    C = zeros(1,qqq-1);
    C2 = zeros(1,qqq2-1);
    result(1,i) = inf;
    result(2,i) = inf;
    if ~isempty(P)
    tmp_dis = norm(node.point(1:2,goal_node)-node.point(1:2,i),2);
    parfor ee = 1:qqq-1
        AA = find(glph_node(1,:)==P(1,ee)&glph_node(2,:)==P(1,ee+1));%nodeのつながり判断
        BB = find(glph_node(2,:)==P(1,ee)&glph_node(1,:)==P(1,ee+1));%nodeのつながり判断

        if ~isempty(AA)%つながりがない場合，逆の組み合わせで距離を算出
            C(1,ee) = node.weights(AA);
        end
        if ~isempty(BB)
            C(1,ee) = node.weights(BB);
        end
    end
    result(1,i) = 1*sum(C);
    end
    %別のノルムで最小射影をしようとした残骸．うまいこと行くようになったら消す
    if ~isempty(P2)
    parfor ee = 1:qqq2-1
        AA = find(glph_node2(1,:)==P2(1,ee)&glph_node2(2,:)==P2(1,ee+1));%nodeのつながり判断
        BB = find(glph_node2(2,:)==P2(1,ee)&glph_node2(1,:)==P2(1,ee+1));%nodeのつながり判断

        if ~isempty(AA)%つながりがない場合，逆の組み合わせで距離を算出
            C2(1,ee) = node.weights2(AA);
        end
        if ~isempty(BB)
            C2(1,ee) = node.weights2(BB);
        end
    end
    result(2,i) = 1*sum(C2);
    end
end

end