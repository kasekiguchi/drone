% % % % %楕円ポテンシャル用
syms obx1 oby1 x y obx2 oby2
d1 = norm([obx1 oby1]-[x y],2);
d2 = norm([obx2 oby2]-[x y],2);
d3 = norm([obx1 oby1]-[obx2 oby2],2);
D = 1/((d1+d2-d3)^2);
ux = diff(D,x);
uy = diff(D,y);
result = [ux;uy];
matlabFunction(result,'file','Cov_Elliptical_potential','Vars',[x y obx1 oby1 obx2 oby2])
%%
ob = [0 0 ;0 10];
 grid_x = -4:0.1:20;
  grid_y = grid_x;
  G_pillar = zeros(length(grid_x),length(grid_y));
  G_bamp = zeros(length(grid_x),length(grid_y));
  G_human = zeros(length(grid_x),length(grid_y));
  [GX,GY] = meshgrid(grid_x,grid_y);
  sizeX=length(GX);
  sizeY=length(GY);
  parfor n =1:sizeX
      for m=1:sizeY
          if GX(n,m)==0||GY(n,m)==0
              continue
          end
          DP = subs(D,[x,y,obx1,oby1,obx2,oby2],[GX(n,m),GY(n,m),ob(1,1),ob(2,1),ob(1,2),ob(2,2)]);
          G_bamp(n,m) = G_bamp(n,m) +DP; 
      end
  end
  Genv =(G_bamp+G_pillar+G_human);
  figure(4)
  surf(GX,GY,Genv,'EdgeColor','none');
            %             contour(GX,GY,Genv);
