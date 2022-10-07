function I = extract_in_range_wall_index(S,R,p)
% R内に線分を含むSのインデックスを返す．
% S : segment structure : (a,b,c), (x,y) : 端点 S.x = [xs, xe], S.y = [ys,ye]
% R : sensor range
% p : position [x;y]
% I : index in S
Ir = find(abs([S.a,S.b,S.c]*[p;1]) <= R); % in range indices
FX = S.x(Ir,:);
FY = S.y(Ir,:); % focused line edges

rx = FX - p(1);% reIrtive x
ry = FY - p(2);% reIrtive y
[L,Ic]=min(rx.^2 + ry.^2,[],2); % closer edge ec's index
I = Ir(L<=R);
la = find(L>R); % logic array
indc = sub2ind(size(FX),la,Ic(la));
cp = p'-[FX(indc),FY(indc)]; % vector ec to p 
If = mod(Ic(la),2)+1; % farther edge ef's index
indf = sub2ind(size(FX),la,If);
cf = [FX(indf),FY(indf)]-[FX(indc),FY(indc)]; % vector ec to the far edge ef

% 図を書いて確認すること
% ~la : 近い点ec がR 内
% sum(cp.*cf,2) >= 0 : ecからp，遠い点efまでの2本のベクトルが鋭角でR内なら線分がR内に存在

I = [I;Ir(la(sum(cp.*cf,2) >= 0))]; 
end