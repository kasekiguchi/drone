function result = dog_input(agent,fp,P,other,Cog,xd,other_agent,num,Na)
%入力の変更，目標位置への入力をそのまま出す．sheep様
n = 2;%次元数
k1=0.5;%%重心への移動
k2=0.05;%畑への吸引力
k3=0.01;%目標からの反力
k4= 0.1;%他機体からの反力
k5= 0.1;%鳥からの反力
tmp = Cog;%どこを正規分布の基準とするか
state = agent.p;%自己位置
xd = [xd;state(3)];
clas_num = length(Cog);
[~,Ns] = size(other);
% k1 = k1/Cog2state;
for i=1:clas_num
        num_p = P{i};
    [~, del_P]= eig(num_p(1:2,(1:2)));      
                %固有値の大きい方のインデックスを探す
                if del_P(1,1)>=del_P(2,2)
                    bigind=1;
                else
                    bigind=2;
                end

    k3=k3*del_P(bigind,bigind);%%固有値の大きいほうが反力のゲインになる．
    % u4 = R*u4(1:2);
    % figure(3)
    % quiver(0,0,u4(1),u4(2))

    %正規分布の微分
    % gauss = Cov_gauss(state(1:n),tmp(1:n),cog_state.P(1:n,1:n));
    dn{i}= (exp((state(1:n) - tmp{i}(1:n))'*inv(num_p(1:n,1:n))*(state(1:n) - tmp{i}(1:n))/-2)*inv(num_p(1:n,1:n))*(state(1:n) - tmp{i}(1:n)))/((2*pi)^(n/2)*sqrt(norm(num_p(1:n,1:n))));

    % u3 = (state - xd)/norm(state - xd);

    %正規分布の見える化をしている．
    numx=1;
    % for nunx=0:1:10
    %     numy=1;
    %     for nuny = 0:1:10
    % %         temp_point(numx,numy) = (exp(([nunx;nuny] - tmp(1:2))'*inv(eye(2))*([nunx;nuny] - tmp(1:2))/-2))/((2*pi)^(2/2)*sqrt(norm(eye(2))));
    %         
    %         point(numx,numy) = (exp(([nunx;nuny] - tmp(1:2))'*inv(cog_state.P(1:2,1:2))*([nunx;nuny] - tmp(1:2))/-2))/((2*pi)^(2/2)*sqrt(norm(cog_state.P(1:2,1:2))));
    %         numy=numy+1;
    %     end
    %     numx=numx+1;
    % end
    % figure(2)
    % contour(point);
    % hold on
        if dn{i}==0
            u3{i} = [dn{i};0];
        else
            u3{i} = [dn{i}/norm(dn{i},2);0] ;
        end
end
u1 = (xd - state)/norm(xd - state,2);
u2 = (fp - state)/norm(fp - state,2);
KK = arrayfun(@(i) Cov_distance(state,other_agent(:,i),1),1:Na);%ドローン間の反力
tmp = struct2cell(KK);
distance = cell2mat(tmp);
away=zeros(3,Na);
for i=1:Na
    away(:,i) = [distance(2:3,:,i);0]/norm(distance(2:3,:,i),2)^2;
end
away(:,num)=[];%自身だと無限に入力がかかるから削除

sheep = arrayfun(@(i) Cov_distance(state,other(:,i),1),1:Ns);%鳥とその他ドローンの距離計算
tmp = struct2cell(sheep);
distance_sheep = cell2mat(tmp);
aways=zeros(3,Ns);
for i=1:Ns
    aways(:,i) = [distance_sheep(2:3,:,i);0]/norm(distance_sheep(2:3,:,i),2)^2;
end
% k1=k1*1/norm(xd - [fp;0]);


% if k3*u3(1,1)>10
%     pause;
% end
% if norm([fp;0] - xd)<15
%     result =k1*u1 + k2*u2 + k3*u3 + 0.*u4;
% else
%     result = -(state-[fp+[1;1];0])/norm(state-[fp;0]);
% end
% %%%%%%%%%%%%%%%%%%%%%%%入力の一部取り出すよう．mainのほうもONにする%%%%%%%%%%%%%%%%%%%%%5
if norm(fp - xd,2)<100
    result.result =k1*u1 + k2*u2 + k3*sum(cell2mat(u3),2)+k4*sum(away,2)+k5*sum(aways,2)/Ns ;
%     result.result =[0;0;0] ;

else
    result.result = -(state-[fp+[1;1;0]])/norm(state-fp);
end
result.tmp1 = [k1*u1;
                k2*u2;
                k3*sum(cell2mat(u3),2);
                k4*sum(away,2);
                k5*sum(aways,2)/Ns];
result.tmp2 = del_P(bigind,bigind);


end