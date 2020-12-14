function [ref] = calcreference(h2,h3,Num,Pdata,dt)
    ref=zeros(8,Num);
    refx = h2(1)*ones(1,Num);
    refy = h3(1)*ones(1,Num);
    [s,~] = size(Pdata.Target);
    %セクションの端点
    if Pdata.flag+1 > s
         EndX = [Pdata.Target(Pdata.flag,1),Pdata.Target(Pdata.flag ,1)];
         EndY = [Pdata.Target(Pdata.flag,2),Pdata.Target(Pdata.flag ,2)];
    else
         EndX = [Pdata.Target(Pdata.flag,1),Pdata.Target(Pdata.flag + 1,1)];
         EndY = [Pdata.Target(Pdata.flag,2),Pdata.Target(Pdata.flag + 1,2)];
    end
    f = 1;%最初はセクションの終端が自セクションの終端
    %x,yから終点へ向かって点を打つ
    for i=1:Num-1
        deltax = EndX(f) - refx(i);
        deltay = EndY(f) - refy(i);
        theta = atan2(deltay,deltax);
        refx(i+1) = refx(i) + Pdata.v*dt*cos(theta);
        refy(i+1) = refy(i) + Pdata.v*dt*sin(theta);
        if sqrt((refx(i) - EndX(f))^2 + (refy(i) - EndY(f))^2) < sqrt((refx(i) - refx(i+1) )^2 + (refy(i) - refy(i+1))^2)%最終セクションかどうかの判別
            if Pdata.flag+1 > s
                refx(i+1:Num) = EndX(f);
                refy(i+1:Num) = EndY(f);
                break;
            else
                f = 2;
            end
        end
    end
    ref(1,:) = refx;
    ref(5,:) = refy;
    %点が終点を超えた場合
%     次セクションへ向かって打つ
        end