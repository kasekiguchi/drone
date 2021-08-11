close all
clear all
grid_x =-5:0.1:5;
grid_y =  -2:0.1:2;
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
        if x1>r
            rpolar=x1+p(1);
        else
            rpolar=2*(p(1)-r)*atan(pi*(x1)/(2*(p(1)-r)))/pi+p(1);
        end
        phi = [(rpolar)*cos(x2)-(p(1));...
            (rpolar)*sin(x2)];
        vvv = (phi(1)^2+phi(2)^2)/2;
%         figure(2);hold on
%         scatter3(phi(1),phi(2),10*x2)
%         phi = [x;y];
%         phi=[phi(2);phi(1)];
        
        d = sqrt((phi(1)+p(1))^2+phi(2)^2);
        if p(1)<=d
            rm = d - p(1);
        elseif r<d&&d<p(1)
            tan_th = pi*(d-p(1))/(2*(p(1)-r));
            if tan_th>pi/2
                tan_th = pi/2;
            elseif tan_th<-pi/2
                tan_th = -pi/2;
            end
            rm = 2*tan(tan_th)/pi;
        else
            disp('a')
        end
        phim = atan2(phi(2),phi(1)+p(1));
        Ve1 = (phim^2+rm^2)/2; 

        if ~isreal(Ve1)
           disp('a') 
        end
%         Ve1 = se1'*[1 0;0 20]*se1;
        if Ve1>10
            Ve1 =10;
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
if x1>=r
    result =x1;
else
    result =100000;
end

end
