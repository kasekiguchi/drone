function L = DA2L(D,A,type)
% line parameter (d,alpha)
% d : distance to line
% alpha : angle of perpedicular to line
% D = [d1;d2;...];  A = [alpha1;alpha2;...];
% L : line (a,b,c) such that ax+by+c = 0
% refer to readme.md 1 and 2
% 前提：[a,b]の大きさ1，c <= 0
arguments
    D
    A
    type = "row"
end
I = D<=0;
A(I) = A(I)+pi;
D(I) = -D(I);
if strcmp(type,"struct")
    L.a = cos(A);
    L.b = sin(A);
    L.c = -D;
else
    L = [cos(A),sin(A),-D];
end
end