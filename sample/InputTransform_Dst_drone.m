function dst =InputTransform_Dst_drone(varargin)
           te=varargin{1, 1}.te;
           dt=varargin{1, 1}.dt;
           dst =zeros(te/dt+1,6); %[x y z roll pitch roll] 加速度，角加速度
           ndst = "p";
           switch ndst
               case "p"
                 % 平均b、標準偏差aのガウスノイズ
                      rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                      a = 1;%標準偏差
                      b = 0;%平均
                      c = te/dt +1 ;%ループ数を計算param{2}はシミュレーション時間
                      pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                      dst(:,3) = pdst(:,1);
                      dst(:,4) = pdst(:,2);
                      dst(:,5) = pdst(:,3);
               case "tmp"
                                       %一時的な外乱
%         t = param{1};
%         dst = 0;
%                     if t>=2 && t<=5.33
%                             dst= 0.6;
%                     end
               case "pp"
                           %特定の位置で外乱を与える
     
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
           end
           dst = dst';
end
