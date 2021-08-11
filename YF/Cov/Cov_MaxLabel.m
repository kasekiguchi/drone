function result = Cov_MaxLabel(Val,flag)
%flagで行と列どっちで選ぶかを決める１は行，２は列
[n,m] = size(Val);
if flag==2
    ValuNorm = zeros(1,m);
    for i = 1:m
        ValuNorm(i) = norm(Val(:,i));
    end
    [~,I] = max(ValuNorm);
else
    ValuNorm = zeros(1,n);
    for i = 1:n
        ValuNorm(i) = norm(Val(i,:));
    end
    [~,I] = max(ValuNorm);
end
    result = I;
end