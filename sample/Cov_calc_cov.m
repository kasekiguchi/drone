function result = Cov_calc_cov(x,xd)
%%共分散行列を計算するやつ
[n,m] = size(x);
X=x(1:n-1,1:3);
% [n,~]=size(X);
error = cell2mat(arrayfun(@(i) x(:,i) - [xd;0],1:m,'UniformOutput',false));
covxy=0;covzx=0;covyz=0;
covx=0;covy=0;covz=0;
for i = 1:m
    covx = covx+error(1,i)^2;
    covy = covy+error(2,i)^2;
    
    
    covxy =covxy+ error(1,i)*error(2,i);
    if n>=3
        covz = covz+error(3,i)^2;
        covyz =covyz+ error(2,i)*error(3,i);
        covzx =covzx+ error(1,i)*error(3,i);

    end
end
tmp=[covx,covxy,covzx;...
     covxy ,covy,covyz;...
     covzx ,covyz , covz]./m;
numx=1;
% for nunx=0:0.1:10
%     numy=1;
%     for nuny = 0:0.1:10
%         temp_point(numx,numy) = (exp(([nunx;nuny] - xd(1:2)')'*inv(eye(2))*([nunx;nuny] - xd(1:2)')/-2))/((2*pi)^(2/2)*sqrt(norm(eye(2))));
%         
%         point(numx,numy) = (exp(([nunx;nuny] - xd(1:2)')'*inv(tmp(1:2,1:2))*([nunx;nuny] - xd(1:2)')/-2))/((2*pi)^(2/2)*sqrt(norm(tmp(1:2,1:2))));
%         numy=numy+1;
%     end
%     numx=numx+1;
% end
result = tmp;
end