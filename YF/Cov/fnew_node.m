function result = fnew_node(node,ob,r,area)
%nodeは障害物と被っている点，obは障害物上の点,rは円盤の半径
result = [];
[~,om] = size(ob);
r2 = r;
d = r/3;
pul = node+[-d;d];
dis = arrayfun(@(ol) norm([pul-ob(:,ol)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    if isinterior(area,pul(1,:),pul(2,:))
        pul = fnew_node_next(pul,ob,r2,area);
    else
        pul=[];
    end
%         [~,nodem] = size(pul);
% rpi = r2*ones(1,nodem);
% pul = vertcat(pul,rpi);
else
    pul = [pul;r2];
end
pur = node+[d;d];
dis = arrayfun(@(ol) norm([pur-ob(:,ol)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    if isinterior(area,pur(1,:),pur(2,:))
    pur = fnew_node_next(pur,ob,r2,area);
    else
        pur=[];
    end
%         [~,nodem] = size(pur);
% rpi = r2*ones(1,nodem);
% pur = vertcat(pur,rpi);
else
    pur = [pur;r2];
end
pbl = node+[-d;-d];
dis = arrayfun(@(ol) norm([pbl-ob(:,ol)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    if isinterior(area,pbl(1,:),pbl(2,:))
    pbl = fnew_node_next(pbl,ob,r2,area);
    else
        pbl =[];
    end
%         [~,nodem] = size(pbl);
% rpi = r2*ones(1,nodem);
% pbl = vertcat(pbl,rpi);
else
    pbl = [pbl;r2];
end
pbr = node+[d;-d];
dis = arrayfun(@(ol) norm([pbr-ob(:,ol)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    if isinterior(area,pbr(1,:),pbr(2,:))
    pbr = fnew_node_next(pbr,ob,r2,area);
    else
        pbr=[];
    end
%     [~,nodem] = size(pbr);
% rpi = r2*ones(1,nodem);
% pbr = vertcat(pbr,rpi);
else
    pbr = [pbr;r2];
end
%再帰関数でどうだろう．
result = [pul pur pbl pbr result];

% end
end