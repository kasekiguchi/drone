function out = minimum_projection(num_node,x,y,node,buffa_c)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述
            Vp = zeros(1,num_node);
            parfor i = 1:num_node                
               Vp(i) = 0.1*Cov_Vp(x,y,node.point(1,i),node.point(2,i),node.point(3,i))+1*buffa_c(i);
            end
            [~,index]= min(Vp);
            vx = Cov_diffx_Vp(x,y,node.point(1,index),node.point(2,index),node.point(3,index));
            vy = Cov_diffy_Vp(x,y,node.point(1,index),node.point(2,index),node.point(3,index));

            
            
            dx= (x-node.point(1,index));
            dy = (y-node.point(2,index));
            dth = pi*sqrt(dx^2+dy^2)/(2*node.point(3,index));
            tvx = dx/(cos(dth)^2*sqrt(dx^2+dy^2));
            tvy = dy/(cos(dth)^2*sqrt(dx^2+dy^2));
            if tvx-vx>0.1||tvy-vy>0.1
               disp([tvx-vx;tvy-vy]) 
            end
            out = Vp;
end

