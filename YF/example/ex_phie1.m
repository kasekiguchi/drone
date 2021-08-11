close all
grid_x =-10:0.5:10;
grid_y =  -5:0.5:5;
node_r = 1;
[GX,GY] = meshgrid(grid_x,grid_y);%%χ
[sizeX,~]=size(GX);
[~,sizeY]=size(GY);
p=[-2;0];
r= 1;
map = zeros(sizeX,sizeY);
xd = [0;4];
thd = atan2(xd(2)-p(2),xd(1)-p(1));

xp = [10;10];
% for i = 1:0.1:100
%     distance = xp-p;
%     F = cross([0;0;1],[distance;0]);
%     xp = xp+0.1*F(1:2);
%         figure(2);hold on
%         scatter(xp(1),xp(2))
% 
% 
% end
for i=1:sizeX
    for j =1:sizeY
        x = GX(i,j);
        y = GY(i,j);
        x1 = norm(p-[x;y],2);
        th_x = x-p(1);
        th_y = y-p(2);
        x2 = atan2(th_y,th_x);
        de1 = f_de(x2);
        re = f_re(x1,r,de1);
        phi = [(re+de1)*cos(x2)-(de1);...
            (re+de1)*sin(x2)];
%         figure(2);hold on
%         scatter3(phi(1),phi(2),10*x2)
%         phi = [x;y];
        de1 = f_de(phi(2));
        de1_hat = 7/((angle(phi(1)+8+phi(2)*i))^2+1);
        se1 = [sqrt((phi(1)+8)^2+phi(2)^2)-1-de1_hat;angle(phi(1)+8+phi(2)*i)];
        if se1(1)<0
            thh = se1(1)*pi/(2*de1);
            if thh >pi/2
                thh = pi/2;
            end
            if thh<-pi/2
                thh = -pi/2;
            end
           se1(1) = [2*de1*tan(thh)/pi];
%            if se1(1)>100
%                se1(1) =100;
%            end
        end
%         figure(2);hold on
%         scatter3(se1(1),se1(2),10*se1(2))


        Ve1 = se1'*[1 0;0 20]*se1;
        if Ve1>100
            Ve1 =100;
        end
        %                  phi = [1*cos(th)-(th);...
        %                         1*sin(th)];
%                          phi = 1/x1;%+(roll_potential(xd(1),xd(2),p(1),p(2),x,y)-1);
        map(i,j) = Ve1;
        %                 map(i,j) = x1+x2;
    end
end
figure(3);
surf(GX,GY,map,'EdgeColor','none');



function result = f_de(x2)
de = 7/(x2^2+1);
result = 1+de;
end
function result = f_re(x1,r,de1)
% if x1>=0
    result =x1;
% else
%     result = 2*(de1-1)*atan(x1*pi/2/(de1-1))/pi;
% end

end
