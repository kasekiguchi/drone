function dst =InputTransform_Disturbance_drone(varargin)
%各時刻に与える外乱を事前に生成する関数
%外乱は各加速度，角加速度の6つに与えられる.1:ax, 2:ay, 3:az, 4:aroll, 5:apitch, 6:ayaw
%シミュレーション時間の長さと刻み時間を受け取って各時刻に与える外乱をまとめた配列を返す
           te=varargin{1, 1}.te;%シミュレーション時間の長さ
           dt=varargin{1, 1}.dt;%刻み時間
           index = te/dt+1;
           dst =zeros(index ,6); %必要な配列を生成[x y z roll pitch roll] 加速度，角加速度
           ndst = "p";%どの外乱を使うのかを指定する
           switch ndst
               case "p"
                 % 平均b、標準偏差aのガウスノイズ
                      rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                      a = 1;%標準偏差
                      b = 0;%平均
                      c = index ;%ループ数を計算param{2}はシミュレーション時間
                      pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                      %z, roll, pitchの加速度, 角加速度に外乱を付与
                      % dst(:,3) = [0.5;0.5*ones(c/4,1);-0.5*ones(c/4,1);0.5*ones(c/4,1);-0.5*ones(c/4,1)];
                      % dst(:,3) = 0.3*sin(2*pi/20*[0:dt:te]');
                      % aa=0:dt:te;
                      % dst(:,3) = 0.02*aa;
                      % dst(:,1) = 3*ones(c,1);
                      % dst(:,2) = 3*ones(c,1);
                      % dst(:,3) = 0*ones(c,1);
                      % dst(:,4) = 0*ones(c,1);
                      % dst(:,5) = 1.2*ones(c,1);
                      
                      %入力用
                      dst(:,3) = 2*pdst(:,1);
                      dst(:,4) = 2*pdst(:,2);
                      dst(:,5) = 2*pdst(:,3);
                      % dst(:,3) = 1.8*sin(2*pi/0.5*(0:dt:te)');
                      % dst(:,4) = 1.8*sin(2*pi/0.5*(0:dt:te)'+pi/3);
                      % dst(:,5) = 1.8*sin(2*pi/0.5*(0:dt:te)'+pi*2/3);

               case "tmp"
                 %外乱の大きさと付与する時刻を指定
                 %x方向の加速度に0.1m/s^sの外乱を2~15秒の間に付与
                         i=1;
                        for t = 0:dt:te
                                if t>=2 && t<=15
                                        dst(i ,:)= [0,0,1,0,0,0];
                                end
                                i = i +1;
                        end
                        
           end
           dst = dst';
end
