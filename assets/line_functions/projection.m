function p = projection(l,XY)
% return projection point from point XY to line l
% XY = [x1,y1;x2 y2; ...]
x = XY(:,1);
y = XY(:,2);
a = l(1);
b = l(2);
c = l(3);
d = a^2+b^2;
p = [b^2*x-a*b*y-a*c,-a*b*x+a^2*y-b*c]/d;
end