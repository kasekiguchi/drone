function DA = L2DA(L,flag)
% convert line=(a,b,c) to (d,alpha) parameter
arguments
    L
    flag = 1 % 前提を満たす直線なら1
end

if ~flag
    L = make_standard_line(L);
end

DA.d = -(L.c); % readme.md : 2
DA.alpha = atan2(L.b,L.a); % readme.md : 1
end
