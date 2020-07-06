function draw_voronoi(V,span,pos,varargin)
% �yInput�zV : polyshape�Z���z��C span : �ΏۃC���f�b�N�X�C
%  pos : span����"r+","bx","go" �ŕ\��
%   varargin : region : �`��̈�,  text = {pos, text} 
%% �`��
daspect([1 1 1]);
if isfield(varargin,"range")
    region=varargin.range;
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
plot(pos(1,num*(i-1)+1:num*i),pos(2,num*(i-1)+1:num*i),lt(i))
end
if isfield(varargin,"text")
    tvar=varargin.text;
    tpos=tvar{1};
    tval=tvar{2};
for i =span
    text(tpos(1,i),tpos(2,i),strcat('\leftarrow ',num2str(tval{i})));
end
end
hold off
end