c = [5;5];
mx = 0:0.1:10;
my = 0:0.1:10;
[GX,GY] = meshgrid(mx,my);
map = zeros(length(GX),length(GX));
for i=1:length(GX)
    for j=1:length(GY)
        x=GX(i,j);
        y=GY(i,j);
        v = norm(-(1-(2^3/norm([x;y]-c,2)^3))*([x;y]-c))
        if v>10
            v=10;
        end
        map(i,j) = v;
    end
end
mapmax = 1;
figure(2);surf(GX,GY,map./mapmax,'EdgeColor','none');
