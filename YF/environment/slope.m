cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\YF\environment'
% cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\YF\environment'
%%symsで変数定義
syms symx symy a b c d e f g
%%関数の作成，あんまり複雑なのは無理だと思う．確認したことないけど．
kkk = 1;
symVp = a*symx+b*symy+c+...
        kkk*tan(pi/4*(tanh(5*(d-symx).*(e-symx))+1))+...
        kkk*tan(pi/4*(tanh(5*(f-symy).*(g-symy))+1));
diffx = diff(symVp,symx);
diffy = diff(symVp,symy);
%%mファイルの作成，（関数，'file'，名前，'vars'，[変数]）で，ここに書いた順番で変数をいれればいい．
matlabFunction(symVp,'file','Cov_slope.m','vars',[symx symy a b c d e f g])
matlabFunction(diff(symVp,symx),'file','Cov_diffx_slope.m','vars',[symx symy a b c d e f g])
matlabFunction(diff(symVp,symy),'file','Cov_diffy_slope.m','vars',[symx symy a b c d e f g])