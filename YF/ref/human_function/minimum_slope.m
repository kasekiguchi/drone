function id = minimum_slope(env,x,y,obj)
%四隅情報と平面の方程式の
            num_slope = length(env.vertices);
            Vp = zeros(1,num_slope);
            parfor i = 1:num_slope
               P1 = obj.ret{i};
               coef1 = env.coeficient{i}
               Vp(i) = Cov_slope(x,y,coef1(1),coef1(2),coef1(3),P1(1,1),P1(3,1),P1(1,2),P1(3,2));
            end
            [~,id]= min(Vp);


end

