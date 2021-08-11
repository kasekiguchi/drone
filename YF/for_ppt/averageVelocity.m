%平均速度と密度の関係を出す．
close all;
[~,m] = size(yasui.save.agent{1, 1}.v);
[~,dm] = size(yasui.save.DencityInoutLabels);
N = length(yasui.save.agent);
AllVelocity = zeros(N,m);
TimeFlowDencity = zeros(1,dm);
AveV = zeros(1,dm);
for i=1:N
   for j = 1:m-2
       if isnan(yasui.save.agent{i}.v(:,j))
           continue
       else
       AllVelocity(i,j) = norm(yasui.save.agent{i}.v(:,j));
%        if AllVelocity(i,j)<0.1
%            AllVelocity(i,j) =0.1;
%        end
       end
   end
end
AverageVelocity = sum(AllVelocity,'all')/(N*m)
dencity = N/area(yasui.save.env);
plomeV = 1.269*(10^(dencity*-0.222))
% vvv = 1.248-0.475*dencity
for k = 1:dm-2
    InAgent = find(yasui.save.DencityInoutLabels(:,k));
    if InAgent ~=0
        SumV = 0;
        for ppp = 1:length(InAgent)
            SumV = SumV + norm(yasui.save.agent{InAgent(ppp)}.v(:,k));
        end
        AveV(1,k) = (SumV/length(InAgent));
    end
    TimeFlowDencity(1,k) = sum(yasui.save.DencityInoutLabels(:,k))/area(polyshape([0 6;0 8;4 8;4 6]));
end
GGG = find(TimeFlowDencity);
TimeFlowDencity = TimeFlowDencity(1,GGG);
PPP = find(AveV);
AveV = AveV(1,GGG);
F = @(x,xdata) x(1)*xdata.^3+x(2)*xdata.^2+x(3)*xdata+x(4)
x0 = [0,0,0,0.9];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,TimeFlowDencity,AveV)
scatter(TimeFlowDencity(:),AveV(:))
hold on
plot(TimeFlowDencity,F(x,TimeFlowDencity))
% plot(f,TimeFlowDencity,AveV)
% hold on
% 
% scatter(TimeFlowDencity(1,:),AveV(1,:))
xlabel('両方向密度')
ylabel('観測領域内平均速度')
disp('end')

fun = @(x,xdata)x(1)*10.^(x(2)*xdata);
x0=[0,0.5];
x=lsqcurvefit(fun,x0,TimeFlowDencity',AveV')
