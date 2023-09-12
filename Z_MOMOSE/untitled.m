% syms x1(t) x2(t)
% f1=diff(x1)==x2;
% f2=diff(x2)==-x2;
% df=[f1;f2];
% c1=x1(0)==0;
% c2=x2(0)==0;
% c=[c1;c2];
% [sx1,sx2]=dsolve(df,c);

% sx1=subs(sx1,[C1 C2],0);
% sx2=subs(sx2,[C1 C2],[0 1]);

load wind
X = x(5:10,20:25,6:10);
Y = y(5:10,20:25,6:10);
Z = z(5:10,20:25,6:10);
U = u(5:10,20:25,6:10);
V = v(5:10,20:25,6:10);
W = w(5:10,20:25,6:10);

quiver3(X,Y,Z,U,V,W)
axis equal