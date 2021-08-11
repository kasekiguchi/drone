close all
grid_x =-2:0.5:11;
grid_y =  -2:0.5:11;
node_r = 1;
[GX,GY] = meshgrid(grid_x,grid_y);%%χ
[sizeX,~]=size(GX);
[~,sizeY]=size(GY);
p=[5;5];
r= 1;
map = zeros(sizeX,sizeY);
xd = [0;4];
thd = atan2(xd(2)-p(2),xd(1)-p(1));

xp = [10;10];
wall = polyshape([12 11;9 11;9 11.2;12 11.2]);
for i = 1:0.1:10
    distance = xp-p;
    F = cross([0;0;1],[distance;0]);
    xpN = xp+0.1*F(1:2);
    v = (xpN-xp)/0.1;
    pgon = Cov_view_range(xpN,v,120,wall);
    xp=xpN;
        figure(2);hold on
        scatter(xp(1),xp(2))
        quiver(xp(1),xp(2),v(1),v(2));
        polyout = intersect(pgon,wall);
        plot(pgon)
        plot(wall)
        plot(polyout)
axis equal


end