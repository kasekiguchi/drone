function p = aster(c,t,E,F,G,w1,w2)
% a star algorithm
% p : path indices from c to t
% c : current position index
% t : target position index
% E : unweighted edge graph
% F : distance function
% G : performance function
% w1, w2 : weights for F and G
a=[];
ke = 10*F(t,c);% 10倍遠回りするような経路の場合は強制終了
N = size(E,2);
i = 1;
p(i,1) = c;% path 初期値
tmp=sparse(c,1,1,N,1);
while p(i)~=t & i < ke
    A=(E*sparse(p(i,1),1,1,N,1))&~tmp; % 次の位置候補点（既にpathに選ばれている点は除く）
    a = find(A);
    if a
        [~,I]=min(w1*F(t,a)+w2*G(A));% a の中で最適なインデックス
    else
       A = (E*sparse(p(i,1),1,1,N,1));
       a = find(A); %Aの非ゼロ要素を検出
       [~,I]=min(w1*F(t,a));% 目標値tに最も近い点を選ぶ
    end
    i = i+1;
    p(i,1) = a(I);
    tmp(a(I),1) = 1;
end

end

