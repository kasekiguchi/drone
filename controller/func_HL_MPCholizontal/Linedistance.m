function [Dis] = Linedistance(x1,y1,Sectionpoint,Sectionnumber)
%LINE_CALCULATOR 
%2点を与えると，その2点を結ぶ直線と，2点間の距離を算出して返す．
calc_x = [Sectionpoint(1:Sectionnumber,1);x1];
calc_y = [Sectionpoint(1:Sectionnumber,2);y1];
Diss = arrayfun(@(N) realsqrt((calc_x(N,1)-calc_x(N+1,1))^2 + (calc_y(N,1)-calc_y(N+1,1))^2),1:Sectionnumber,'UniformOutput',true);
Dis = sum(Diss);
end