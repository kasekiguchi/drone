 syms a b th real
 a = 1;
 b = 0.5;
 tmp = solve(diff((b*(1-cos(th))/4-a/2).*sin(th),th)==0,th); % x方向に最小となるth
 thb = double(tmp(2));
 [xb,yb]=egg_shape(1,thb,1)
 solve((b*(1-cos(th))/4-a/2).*(1+cos(th)) + yb*a==0,th)

[~,yM]=egg_shape(1,pi,1);
[~,yN]=egg_shape(1,0,1);
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
%%
[~,aa]=egg_shape(2/3,pi,1)
function [x,y] = egg_shape(r,th,w)
% egg shape
% https://nyjp07.com/index_egg.html
  a = w*r;
  b = a*0.5;
  x = (b*(1-cos(th))/4-a/2).*sin(th);
  y = (b*(1-cos(th))/4-a/2).*(1+cos(th))+ 0.6*a;%(5*17^(1/2) + 13)*a/64;
  % x最大となる点（最後のaの係数0.5252くらい）が風の影響で少し前になるように0.6と設定
end