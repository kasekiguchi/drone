function dst =InputTransform_Dst_drone(varargin)
%時間によって外乱付与
%位置に対してはできない
           te=varargin{1, 1}.te;
           dt=varargin{1, 1}.dt;
           index = te/dt+1;
           dst =zeros(index ,6); %[x y z roll pitch roll] 加速度，角加速度
           ndst = "p";
           switch ndst
               case "p"
                 % 平均b、標準偏差aのガウスノイズ
                      rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                      a = 1;%標準偏差
                      b = 0;%平均
                      c = index ;%ループ数を計算param{2}はシミュレーション時間
                      pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                      dst(:,3) = pdst(:,1);
                      dst(:,4) = pdst(:,2);
                      dst(:,5) = pdst(:,3);

               case "tmp"
                                       %一時的な外乱
                         i=1;
                        for t = 0:dt:te
                                if t>=2 && t<=15
                                        dst(i ,:)= [0.1,0,0,0,0,0];
                                end
                                i = i +1;
                        end
                        
           end
           dst = dst';
end
