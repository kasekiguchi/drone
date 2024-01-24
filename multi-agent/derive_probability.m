th0 = acos((5^(1/2)*29^(1/2))/5 - 2);
[x,y]=egg_shape(1,-pi:0.1:pi,1);
plot(x,y,'.')
daspect([1 1 1]);
[x0,y0]=egg_shape(2,th0,1)

 syms a b th real
 a = 1;
 b = 0.5;
 tmp = solve(diff((b*(1-cos(th))/4-a/2).*sin(th),th)==0,th); % x方向に最小となるth
 thb = double(tmp(2));
 [xb,yb]=egg_shape(1,thb,1)
 solve((b*(1-cos(th))/4-a/2).*(1+cos(th)) + yb*a==0,th)
%%
[~,yM]=egg_shape(1,pi,1);
sigmath=(pi-thb)/3;
[~,y1]=egg_shape(1,sigmath+thb,1)
[~,y2]=egg_shape(1,2*sigmath+thb,1)
[~,yy]=egg_shape(1,thb,1);
d1 = yM*(y1-yy)/(yM-yy);
d2 = yM*(y2-yy)/(yM-yy);
%%
[x,y]=egg_shape(1,-pi:0.1:pi,1);
plot(x,y,[0,0,0,0,0,0],[0,d1,d2,yM,y1,y2],'o')
daspect([1 1 1]);
xn = [-3:.1:3]/3;
yn = normpdf(xn,0,1/3);
yp = normpdf([-1,-2/3,-1/3,0,1/3,2/3,1],0,1/3)
plot(xn,yn,[-1,-2/3,-1/3,0,1/3,2/3,1],yp,'x');
line([[-1,-2/3,-1/3,0,1/3,2/3,1];[-1,-2/3,-1/3,0,1/3,2/3,1]],[0*yp;yp],'Color','k');
%%
[~,yM]=egg_shape(1,pi,1);
[~,yN]=egg_shape(1,0,1);
[xm,ym]=egg_shape(1,0:0.01:thb,1);
[xp,yp]=egg_shape(1,thb:0.01:pi,1);
dp = yM*(yp-yy)/(yM-yy);
dm = yN*(ym-yy)/(yN-yy);
pp = normpdf(((thb:0.01:pi)-thb)/(pi-thb),0,1/3);
pm = normpdf(((0:0.01:thb)-thb)/(thb),0,1/3);

sigmathp=(pi-thb)/3;
[~,y1p]=egg_shape(1,sigmathp+thb,1);
[~,y2p]=egg_shape(1,2*sigmathp+thb,1);
[~,yy]=egg_shape(1,thb,1);
d1p = yM*(y1-yy)/(yM-yy);
d2p = yM*(y2-yy)/(yM-yy);
ppp = normpdf(([thb,sigmathp+thb,2*sigmathp+thb,3*sigmathp+thb]-thb)/(pi-thb),0,1/3);

sigmathn=(thb)/3;
[~,y1n]=egg_shape(1,thb-sigmathn,1);
[~,y2n]=egg_shape(1,thb-2*sigmathn,1);
[~,yy]=egg_shape(1,thb,1);
d1n = yN*(y1n-yy)/(yN-yy);
d2n = yN*(y2n-yy)/(yN-yy);
ppn = normpdf(([thb-sigmathn,thb-2*sigmathn,thb-3*sigmathn]-thb)/(thb),0,1/3);

%%
plot(y,x);
hold on
line([yN,yM],[0,0]);
[xt1,yt1]=egg_shape(d1p/yM,-pi:0.1:pi,1);
plot(yt1,xt1);
[xt2,yt2]=egg_shape(d2p/yM,-pi:0.1:pi,1);
plot(yt2,xt2);
[~,d1n]=egg_shape(d1p/yM,0,1);
[~,d2n]=egg_shape(d2p/yM,0,1);
plot([dm,dp],[pm,pp],[0,d1p,d2p,yM,d1n,d2n,yN],[ppp,ppn],'o')
line([[0,d1p,d2p,yM,d1n,d2n,yN];[0,d1p,d2p,yM,d1n,d2n,yN]],[0*ppp,0*ppn;ppp,ppn],'Color','k')
daspect([1 1 1]);
%%
[~,dddn]=egg_shape(0:0.1:1,0,1);
ppn = normpdf(([thb-sigmathn,thb-2*sigmathn,thb-3*sigmathn]-thb)/(thb),0,1/3);
%%
th = thb:0.01:pi;
normp = normpdf((th-thb)/(pi-thb),0,1/3);
[~,Ya]=egg_shape((th-thb)/(pi-thb),pi,1);
[~,Yb]=egg_shape((th-thb)/(pi-thb),0,1);
Y = [Yb,fliplr(Ya)];
plot(Y,[normp,fliplr(normp)]);
hold on
st = thb + (pi-thb)*[1,2]/3;
normsp = normpdf((st-thb)/(pi-thb),0,1/3);
[~,Ysa]=egg_shape((st-thb)/(pi-thb),pi,1);
[~,Ysb]=egg_shape((st-thb)/(pi-thb),0,1);
Ys = [Ysb,fliplr(Ysa)];
phi = -pi:0.01:pi;
[xt1,yt1]=egg_shape((st(1)-thb)/(pi-thb),phi,1);
po1 = polyshape(yt1,xt1);
plot(po1);
[xt2,yt2]=egg_shape((st(2)-thb)/(pi-thb),phi,1);
po2 = polyshape(yt2,xt2);
plot(po2);
[xt3,yt3]=egg_shape(1,phi,1);
po3 = polyshape(yt3,xt3);
plot(po3);

line([Ys;Ys],[0*[normsp,fliplr(normsp)];[normsp,fliplr(normsp)]],'Color','k');

daspect([1 1 1]);
hold off
P = [0.68,0.95,1];
A =[area(po1),area(po2),area(po3)];
tmp = [P(1)/A(1),(P(2)-P(1))/(A(2)-A(1)),(P(3)-P(2))/(A(3)-A(2))];
w= [tmp(1)-tmp(2)-tmp(3),tmp(2)-tmp(3),tmp(3)];
line([yN,yN,Ys(2),Ys(2),Ys(1),Ys(1),Ys(4),Ys(4),Ys(3),Ys(3),yM,yM],-[0,w(3),w(3),w(2),w(2),w(1),w(1),w(2),w(2),w(3),w(3),0]/20);

function [x,y] = egg_shape(r,th,w)
% egg shape
% https://nyjp07.com/index_egg.html
  a = w*r;
  b = a*0.5;
  x = (b*(1-cos(th))/4-a/2).*sin(th);
  y = (b*(1-cos(th))/4-a/2).*(1+cos(th))+ 0.6*a;%(5*17^(1/2) + 13)*a/64;
  % x最大となる点（最後のaの係数0.5252くらい）が風の影響で少し前になるように0.6と設定
end