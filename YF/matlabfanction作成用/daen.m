%%symsで変数定義
cd 'C:\Users\owner\OneDrive - tcu.ac.jp\work2020\work\YF\matlabfanction作成用'
syms symx symy symnodex symnodey symnoder 
syms obx1 oby1 obx1r oby1r 
syms obx2 oby2 obx2r oby2r
syms obx3 oby3 obx3r oby3r
syms obx4 oby4 obx4r oby4r
%%関数の作成，あんまり複雑なのは無理だと思う．確認したことないけど．
% symVp = 0.1*exp(1.0*(norm([symx;symy]-[symnodex;symnodey])/symnoder));
p1=1/(norm([symx;symy]-[obx1;oby1],2)+norm([symx;symy]-[obx1r;oby1r],2)+norm([obx1;oby1]-[obx1r;oby1r],2))^2;
p2=1/(norm([symx;symy]-[obx2;oby2],2)+norm([symx;symy]-[obx2r;oby2r],2)+norm([obx2;oby2]-[obx2r;oby2r],2))^2;
p3=1/(norm([symx;symy]-[obx3;oby3],2)+norm([symx;symy]-[obx3r;oby3r],2)+norm([obx3;oby3]-[obx3r;oby3r],2))^2;
p4=1/(norm([symx;symy]-[obx4;oby4],2)+norm([symx;symy]-[obx4r;oby4r],2)+norm([obx4;oby4]-[obx4r;oby4r],2))^2;




symVp = 0.1*exp(1.0*(norm([symx;symy]-[symnodex;symnodey])/symnoder))+5*(p1+p2+p3);

diffx = diff(symVp,symx);
diffy = diff(symVp,symy);
%%mファイルの作成，（関数，'file'，名前，'vars'，[変数]）で，ここに書いた順番で変数をいれればいい．
matlabFunction(symVp,'file','Cov_Vp2.m','vars',[symx symy symnodex symnodey symnoder obx1 oby1 obx1r oby1r obx2 oby2 obx2r oby2r obx3 oby3 obx3r oby3r])
matlabFunction(diff(symVp,symx),'file','Cov_diffx_Vp2.m','vars',[symx symy symnodex symnodey symnoder obx1 oby1 obx1r oby1r obx2 oby2 obx2r oby2r obx3 oby3 obx3r oby3r])
matlabFunction(diff(symVp,symy),'file','Cov_diffy_Vp2.m','vars',[symx symy symnodex symnodey symnoder obx1 oby1 obx1r oby1r obx2 oby2 obx2r oby2r obx3 oby3 obx3r oby3r])