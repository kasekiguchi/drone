clear all
N = 20;
base_pos=[0,0];

p = [5;5];
%%

kpos=ceil(sqrt(N));
cpos=floor(N/kpos);
rempos=mod(N,kpos);
[xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
gap=3;
xpos=gap*xpos;
ypos=gap*ypos;
arranged_initial_pos=base_pos-[gap gap]+[reshape(xpos,[N-rempos,1]),reshape(ypos,[N-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];
%むれを分けるかどうか．
if 0
    arranged_initial_pos = separate_flock(Nb,base_pos,fp,Na);
end
save_p =[];
count =1;
for i = 1:0.1:10
flock =vertcat(arranged_initial_pos',zeros(1,N));
n = length(flock);
K = convhull(flock(1:2,1:length(flock))');%外周を構成している点を算出
                    polyin = polyshape(flock(1:2,K)');
                    [x,y] = centroid(polyin);%重心の計算
                    Cog = [x;y];
                    P = Cov_calc_cov(flock,Cog);%%鳥の位置を基にした分散共分散行列を計算

        num_p = P;
    [~, del_P]= eig(num_p(1:2,(1:2)));      
                %固有値の大きい方のインデックスを探す
                if del_P(1,1)>=del_P(2,2)
                    bigind=1;
                else
                    bigind=2;
                end

    k3=0.1*del_P(bigind,bigind);%%固有値の大きいほうが反力のゲインになる．


    %正規分布の微分
    state = p;
    dn= (exp((state(1:n) - tmp(1:n))'*inv(num_p(1:n,1:n))*(state(1:n) - tmp(1:n))/-2)*inv(num_p(1:n,1:n))*(state(1:n) - tmp(1:n)))/((2*pi)^(n/2)*sqrt(norm(num_p(1:n,1:n))));



        if dn==0
            u3 = [dn;0];
        else
            u3 = [dn/norm(dn,2);0] ;
        end
        scatter(p(1),p(2))
        save_p = [save_p p];
p = p+u3;
count =count+1;
end