syms x1(t) x2(t)
f1=diff(x1)==x2;
f2=diff(x2)==-x1-x2;
df=[f1;f2];
c1=x1(0)==6;
c2=x2(0)==10;
c=[c1;c2];
[sx1,sx2]=dsolve(df,c);
sxx1=subs(sx1,t,0:0.1:10);
sxx2=subs(sx2,t,0:0.1:10);
%%
% sx1=subs(sx1,[C1 C2],0);
% sx2=subs(sx2,[C1 C2],[0 1]);
x1c=-10:0.5:10;
x2c=-10:0.5:10;
dx1=x2c;
dx2=-x1c-3*x2c;
x1=[];x2=[];
for i=1:length(x1c)
    x1=[x1;x1c];
    x2=[x2,x2c'];
end
dx1=x2;
dx2=-x1-x2;

ph1=x1+x2;
ph=sxx1+sxx2;
% dph=
% t=0:0.1:10;
% e_t1=exp(-1*t);
% x1=x1c'*e_t1;
% 
% e_t2=exp(-4*t);
% x2=x2c'*e_t2;

% plot(t,x1)
% plot(t,x2)
% plot(x1(1,:),x2(1,:))
quiver(x1,x2,dx1,dx2)
hold on
plot(sxx1,sxx2)
plot3(sxx1,sxx2,ph,'blue')
mesh(x1,x2,ph1,'FaceAlpha','0.1')
% load wind
% X = x(5:10,20:25,6:10);
% Y = y(5:10,20:25,6:10);
% Z = z(5:10,20:25,6:10);
% U = u(5:10,20:25,6:10);
% V = v(5:10,20:25,6:10);
% W = w(5:10,20:25,6:10);
% 
% quiver3(X,Y,Z,U,V,W)
% axis equal

%%
syms x
syms a s
f=sin(pi*x);
f=x;
% s=double(int(sqrt(1+diff(f)^2),0,0.5))
in=int(sqrt(1+diff(f)^2),0,a);
X=solve(in==s,a);
% Y=double(subs(f,x,X))
%%
syms x
syms a 
syms s
f=sin(pi.*x);
% f=x^2;
in=int((1.+diff(f).^2).^0.5,0,a);
X=vpasolve(in==1,a);
s=0:0.2:5;
in=int(sqrt(1+diff(f)^2),0,a);
for i=1:length(s)
tic
X(i)=vpasolve(in==s(i),a);
toc
end
Y=double(subs(f,x,X))
plot(X,Y)
%%
syms f V