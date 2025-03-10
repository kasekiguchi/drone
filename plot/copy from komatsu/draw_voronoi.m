function draw_voronoi(V,pos,region,text,ax)
% 【Input】V : polyshapeセル配列
%  pos = [sx1 sy1 sz1 sx2 sy2 sz2 ....;
%         rx1 ry1 rz1 rx2 ry2 rz2 ....;...]
% : 各行の位置を"r+","bx","go" で表示
%  region(optional) : 描画領域,
%  text(optional) = {pos, text}　で　posの位置に <=text を表示
%% 描画
arguments
    V
    pos
    region = []
    text = []
    ax = []
end
daspect(ax,[1 1 1]);
if ~isempty(region)
    xlim(ax,[min(region(:,1)),max(region(:,1))]);
    ylim(ax,[min(region(:,2)),max(region(:,2))]);
end
hold(ax,"on");
num=length(V);
for i = 1:num
    if isa(V{i},'polyshape')
        plot(ax,V{i});
    else
        %if area(V{i}) > 0
        plot(ax,polyshape(V{i}));
        %end
    end
end
lt = ["r+","bx","go"];
if iscell(pos)
    pos = [pos{1,:}];
end
for i =1: size(pos,1)
    plot(ax,pos(i,1:3:end),pos(i,2:3:end),lt(i))
end
if ~isempty(text)
    tvar=text;
    tpos=tvar{1};
    tval=tvar{2};
    for i =1:num
        text(ax,tpos(1,i),tpos(2,i),strcat('\leftarrow ',num2str(tval{i})));
    end
end
hold(ax,"off");
end