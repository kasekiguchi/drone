function L = DA2L(D,A)
% line parameter (d,alpha)
% d : distance to line
% alpha : angle of perpedicular to line
% D = [d1;d2;...];  A = [alpha1;alpha2;...];
% L : line (a,b,c) such that ax+by+c = 0
% refer to readme.md 1 and 2
I = D<=0;
A(I) = A(I)+pi;
D(I) = -D(I);
L = [cos(A),sin(A),-D];
end