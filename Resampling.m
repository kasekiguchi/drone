function [ppu1, ppu2, ppu3, ppu4, pw] = Resampling(Params,ppu,pw)
    %RESAMPLING この関数の概要をここに記述
    NP = Params.Particle_num   % パーティクル数
    
    %減った分のパーティクルの数の分だけ一番最後のパーティクルの値を複製
    %ただし重みは0とし加重平均では考慮されないものとする．
    %尤度と閾値を比較
    %柴田先輩卒論p.16-18
    pw_size = size(pw,2);       % L_norm のサイズ
    ppu_size = size(ppu,3);     % particle
    if pw_size ~= Params.Particle_num
        size_diff = NP - pw_size;
        pw(1,(NP - size_diff + 1):NP) = zeros(1,size_diff);
        ppu(:,:,(NP - size_diff + 1):NP) = repmat(ppu(:,:,pw_size),1,1,size_diff);
    end
    
    if ppu_size ~= Params.Particle_num
        size_diff = NP - ppu_size;
        pw(1,(NP - size_diff + 1):NP) = zeros(1,size_diff);
        ppu(:,:,(NP - size_diff + 1):NP) = repmat(ppu(:,:,ppu_size),1,1,size_diff);
    end
        
%     px = reshape(ppu(2,:,:), [], NP);
%     v  = reshape(ppu(1,:,:), [], NP);
    
    ppu1 = reshape(ppu(1,:,:), [], NP);
    ppu2 = reshape(ppu(2,:,:), [], NP);
    ppu3 = reshape(ppu(3,:,:), [], NP);
    ppu4 = reshape(ppu(4,:,:), [], NP);
      %px:パーティクル，pw:重み
        %リサンプリングを実施する関数
        %アルゴリズムはLow Variance Sampling
        wcum=cumsum(pw);
        base=cumsum(pw*0+1/NP)-1/NP;%乱数を加える前のbase
        resampleID=base+rand/NP;%ルーレットを乱数分増やす
        ppp1 = ppu1;%データ格納用
        ppp2 = ppu2;
        ppp3 = ppu3;
        ppp4 = ppu4;
        ind=1;%新しいID
        for ip=1:NP
            while(resampleID(ip)>wcum(ind))
                ind=ind+1;
            end
            ppu1(1:end,ip)= [ppp1(2:end,ind);ppp1(end,ind)];%LVSで選ばれたパーティクルに置き換え
            ppu2(1:end,ip)= [ppp2(2:end,ind);ppp2(end,ind)];
            ppu3(1:end,ip)= [ppp3(2:end,ind);ppp3(end,ind)];
            ppu4(1:end,ip)= [ppp4(2:end,ind);ppp4(end,ind)];
            pw(ip)=1/NP;%尤度は初期化
        end
end
