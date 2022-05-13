function draw_voronoi(V,span,pos,region,text)
% 【Input】V : polyshapeセル配列， span : 対象インデックス，
%  pos : span毎に"r+","bx","go" で表示
%  region : 描画領域,
%  text = {pos, text}　で　posの位置に <=text を表示
%% 描画
arguments
    V
    span
    pos
    region = []
    text = []
end
daspect([1 1 1]);
if ~isempty(region)
    xlim([min(region(:,1)),max(region(:,1))]);
    ylim([min(region(:,2)),max(region(:,2))]);
end
hold on
for i = span
    if isa(V{i},'polyshape')
        plot(V{i});
    else
        %if area(V{i}) > 0
        plot(polyshape(V{i}));
        %end
    end
end
num=length(span);
lt = ["r+","bx","go"];
if iscell(pos)
    pos = [pos{1,:}];
end
for i =1: round(size(pos,2)/size(span,2),0)
    plot(pos(1,1:num:end),pos(1,2:num:end),lt(i))
end
if ~isempty(text)
    tvar=text;
    tpos=tvar{1};
    tval=tvar{2};
    for i =span
        text(tpos(1,i),tpos(2,i),strcat('\leftarrow ',num2str(tval{i})));
    end
end
hold off
end