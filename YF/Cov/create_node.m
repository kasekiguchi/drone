function result = create_node(initial_node,node_r,ob,area)
[n,m]= size(initial_node);
[~,om]= size(ob);
ok_node = [];
parfor i = 1:n
    for j = 1:m
        if ~isempty(initial_node{i,j})
            %         for ok = 1:on
            %         for ol = 1:om
            %             disp(initial_node{i,j});
            %         for k=1:om
            dis = arrayfun(@(ol) norm([initial_node{i,j}-ob(:,ol)'],2),1:om);
            %             dis = norm([initial_node{i,j}-ob(:,i)'],2);
            aa = dis<node_r;
            if sum(aa) ==0&&isinterior(area,initial_node{i,j}(:,1),initial_node{i,j}(:,2))
                ok_node = [ok_node,[initial_node{i,j}';node_r]];
%                                 break;
            else%こっちで4個の円盤を作成．
                mini_disc = fnew_node_next(initial_node{i,j}',ob,node_r,area);
                ok_node = [ok_node mini_disc];
%                                 break;

            end
        end
    end
    
end
result = ok_node;
end