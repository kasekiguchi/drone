function result = human_plobable_refarence(refarence_point,select_probability)
%人間の目標点をここで作る．確率的に選択するようにしたい
%知名度パラメータみたいなの使って二項定理で目標点を選択させる方針．
[~,m] = size(refarence_point);
sp = zeros(1,m);
sp(1) = select_probability(1);
for i =2:m
sp(i) = sp(i-1)+select_probability(i);
end
if m==3
    y = randsample(100,1) ;
    %確率によるランダム抽選
    if y<=sp(1)*100
        result = refarence_point(:,1);
    elseif y>sp(1)*100&&y<=sp(2)*100
        result = refarence_point(:,2);
    elseif y>sp(2)*100&&y<=sp(3)*100
        result = refarence_point(:,3);
    end
elseif m==4
    y = randsample(100,1) ;
    %確率によるランダム抽選
    if y<=sp(1)*100
        result = refarence_point(:,1);
    elseif y>sp(1)*100&&y<=sp(2)*100
        result = refarence_point(:,2);
    elseif y>sp(2)*100&&y<=sp(3)*100
        result = refarence_point(:,3);
    elseif y>sp(3)*100&&y<=sp(4)*100
        result = refarence_point(:,4);
    end
    elseif m==2
    y = randsample(100,1) ;
    %確率によるランダム抽選
    if y<=sp(1)*100
        result = refarence_point(:,1);
    elseif y>sp(1)*100&&y<=sp(2)*100
        result = refarence_point(:,2);
    end
elseif m==1
    result = refarence_point;
    elseif m==8
    y = randsample(100,1) ;
    %確率によるランダム抽選
    if y<=sp(1)*100
        result = refarence_point(:,1);
    elseif y>sp(1)*100&&y<=sp(2)*100
        result = refarence_point(:,2);
    elseif y>sp(2)*100&&y<=sp(3)*100
        result = refarence_point(:,3);
    elseif y>sp(3)*100&&y<=sp(4)*100
        result = refarence_point(:,4);
            elseif y>sp(4)*100&&y<=sp(5)*100
        result = refarence_point(:,4);
            elseif y>sp(5)*100&&y<=sp(6)*100
        result = refarence_point(:,4);
            elseif y>sp(6)*100&&y<=sp(7)*100
        result = refarence_point(:,4);
            elseif y>sp(7)*100&&y<=sp(8)*100
        result = refarence_point(:,4);
    end
end
end

