%% 最小射影の多層バージョン
clear all
close all
grid_x = 0:0.1:8;
grid_y = 0:0.1:8;
grid_z = grid_y;
[GX,GY] = meshgrid(grid_x,grid_y);%%χ
[sizeX,~]=size(GX);
[~,sizeY]=size(GY);
node = [3,2;3,3;4,2]';
[~,num_node] = size(node);
syms symx symy
O =10;

%nodeごとのポテンシャル関数
%%
% parfor k=1:sizeX
%     for j=1:sizeY
%         x = GX(k,j);
%         y = GY(k,j);
% % %         for i=1:num_node
% %             V = cell2mat(arrayfun(@(i) ([x;y]-node(:,i))'*eye(2)*([x;y]-node(:,i))+O*i,1:num_node,'uniformoutput',false));
%        V = cell2mat(arrayfun(@(i)([x;y]-node(:,i))'*eye(2)*([x;y]-node(:,i))+2.8^(5*(x-(node(1,i)+1)))+(0.3)^(3*(x-(node(1,i)-1)))+2.8^(2*(y-(node(2,i)+1)))+(0.3)^(4*(y-(node(2,i)-1)))+O*i,1:num_node,'uniformoutput',false));
% 
% % %         end
% % %         for i=1:num_node-1
%            vl= arrayfun(@(i) Vl(x,y,node(:,i),node(:,i+1),O*i,O*(i+1)),1:num_node-1);
%            FFF = cell2mat(arrayfun(@(i) vl(i).V,1:length(vl),'uniformoutput',false));
% %         end
%         DDD = horzcat(V,FFF);
%         M = min(DDD);
%         map(k,j) = M;
% %         qq = cell2mat(arrayfun(@(i) 2.8^(5*(x-(node(1,i)+1)))+(0.3)^(3*(x-(node(1,i)-1)))+2.8^(2*(y-(node(2,i)+1)))+(0.3)^(4*(y-(node(2,i)-1))),1:1,'uniformoutput',false));
%         
% %         qq = cell2mat(arrayfun(@(i)([x;y]-node(:,i))'*eye(2)*([x;y]-node(:,i))+2.8^(5*(x-(node(1,i)+1)))+(0.3)^(3*(x-(node(1,i)-1)))+2.8^(2*(y-(node(2,i)+1)))+(0.3)^(4*(y-(node(2,i)-1)))+O*i,1:num_node,'uniformoutput',false));
% %         QQQ = min((qq));
% % %         if QQQ > 1000
% % %             QQQ = 1000
% % %         end
% %         M = (QQQ);
% %                 mapq(k,j) = M;
%     end
% %     if k>=2
% %     mesh(mapq)
% %     end
% end
% mesh(map)
% zlim([0 100])
%%
p = [-2;5];
diffV = cell2sym(arrayfun(@(i) [diff(([symx;symy]-node(:,i))'*eye(2)*([symx;symy]-node(:,i))+2*i,symx);diff(([symx;symy]-node(:,i))'*eye(2)*([symx;symy]-node(:,i))+2*i,symy)],1:num_node,'uniformoutput',false));
% symvl= arrayfun(@(i) Vl(symx,symy,node(:,i),node(:,i+1),2*i,2*(i+1)),1:num_node-1);
% FFF = cell2mat(arrayfun(@(i) vl(i).V,1:length(vl),'uniformoutput',false));
save=[];
for k=1:0.1:30%シミュレーションタイム

        x = p(1);
        y = p(2);
            V = cell2mat(arrayfun(@(i) ([x;y]-node(:,i))'*eye(2)*([x;y]-node(:,i))+O*i,1:num_node,'uniformoutput',false));
            vl= arrayfun(@(i) Vl(x,y,node(:,i),node(:,i+1),O*i,O*(i+1)),1:num_node-1);
           FFF = cell2mat(arrayfun(@(i) vl(i).V,1:length(vl),'uniformoutput',false));
           tmp = cell2sym(arrayfun(@(i) vl(i).symV,1:length(vl),'uniformoutput',false));
           diffVl = cell2sym(arrayfun(@(i) [diff(tmp(i),symx);diff(tmp(i),symy)],1:length(tmp),'uniformoutput',false));
        DDD = horzcat(V,FFF);
        [~,num] = min(DDD);
        TTT = horzcat(diffV,diffVl);
        use_V = [TTT(1,num);TTT(2,num)];
        u = -double(vpa(subs(use_V,[symx symy],[x,y])))
        p = eye(2)*p + 0.1*eye(2)*u;
        save = [save,p];
        
end


%%
close all
figure(4)
surf(GX,GY,map,'EdgeColor','none');
% contour(map)
hold on
z = 30*ones(1,length(save));
        scatter3(save(1,:),save(2,:),z(:),'r')
%                 scatter3(save(1,:)*10+20,save(2,:)*10,z(:),'r')

      axis equal;
      grid on
      view(2)
%%

function result = Vl(x,y,node0,node1,i,i1)
xds = (-node0+node1);
Ads = eye(2);
syms s
eqn = 3*s^2*(xds'*Ads*xds)+s*((-4*xds'*Ads*([x;y]-node0)+2*xds'*eye(2)*xds))-2*(xds'*Ads*xds)+(([x;y]-node0)'*eye(2)*([x;y]-node0))-i+i1;
sols =  double(solve(eqn, s));
if xds'*Ads*xds == 0&&(-4*xds'*Ads*([x;y]-node0)+2*xds'*eye(2)*xds)==0
    s1=0;
    s2=1;
elseif xds'*Ads*xds == 0&&sols<=1&&sols>=0
    s1 =sols;
    s2=2;
elseif ((-4*xds'*Ads*([x;y]-node0)+2*xds'*eye(2)*xds))^2-4*(xds'*Ads*xds)*(-2*(xds'*Ads*xds)+(([x;y]-node0)'*eye(2)*([x;y]-node0))-i+i1)<0
    s1=0;
    s2 =1;
elseif ((-4*xds'*Ads*([x;y]-node0)+2*xds'*eye(2)*xds))^2-4*(xds'*Ads*xds)*(-2*(xds'*Ads*xds)+(([x;y]-node0)'*eye(2)*([x;y]-node0))-i+i1)>=0
    if sols(1,1)>1
        sols(1,1)=1;
    elseif sols(1,1)<0
        sols(1,1)=0;
    end
    if sols(2,1)>1
        sols(2,1)=1;
    elseif sols(2,1)<0
        sols(2,1)=0;
    end
    if sols(1)<sols(2)
        s1 = sols(1);
        s2 = sols(2);
    else
        s1 = sols(2);
        s2 = sols(1);
    end
end
%%%xlとかを作る．
syms symx symy
xl1 = s1*xds + node0;
Al1 = s1*Ads + eye(2);
Ol1 = s1*(-i+i1)+i;
result.V(1) = ([x;y]-xl1)'*Al1*([x;y]-xl1)+Ol1;
result.symV(1) = ([symx;symy]-xl1)'*Al1*([symx;symy]-xl1)+Ol1;
xl2 = s2*xds + node0;
Al2 = s2*Ads + eye(2);
Ol2 = s2*(-i+i1)+i;
result.V(2) = ([x;y]-xl2)'*Al2*([x;y]-xl1)+Ol2;
result.symV(2) = ([symx;symy]-xl2)'*Al2*([symx;symy]-xl1)+Ol2;

end