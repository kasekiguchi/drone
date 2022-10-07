function L = make_standard_line(L)
% L : field a,b,c : ax+by+c = 0 という直線
% [a,b]の大きさ1，c <= 0 を満たすように変形
    N = (L.a.^2+L.b.^2);
    I = (L.c>0) - (L.c<=0);
    L.a = I.*L.a/N;
    L.b = I.*L.b/N;
    L.c = I.*L.c/N;
end