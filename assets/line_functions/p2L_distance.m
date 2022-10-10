function d = p2L_distance(p,ls)
% distance from point to line
% refer to readme.md

a = ls.a;
b = ls.b;
c = ls.c;
d = (-c - p(1)*a - p(2)*b)./(a.^2+b.^2);
end