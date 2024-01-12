%% performance
function O = performance(V,minV,I,X)
% V > 1
% I : burning cell = 1
% X : focused cell = 1
N = size(V,1);
xi = find(I & X);
x = find(X);
O = 0;
for i = 1:length(x)
    if intersect(x(i),xi)
        O(i,1) = 1-V(intersect(x(i),xi));% 1 - V(x(i));
    else
        O(i,1) = 1-minV;
    end
end
end