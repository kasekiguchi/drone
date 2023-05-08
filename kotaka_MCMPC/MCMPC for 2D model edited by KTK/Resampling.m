function [px,pw,pv] = Resampling(params,ppu,pw)
    %RESAMPLING この関数の概要をここに記述
    NP = params.Particle_num;
    
    %減った分のパーティクルの数を分だけ一番最後のパーティクルの値を複製
    %ただし重みは0とし加重平均では考慮されないものとする．
    pw_size = size(pw,2);
    ppu_size = size(ppu,3);
    if pw_size ~= params.Particle_num
        size_diff = NP - pw_size;
        pw(1,(NP - size_diff + 1):NP) = zeros(1,size_diff);
        ppu(:,:,(NP - size_diff + 1):NP) = repmat(ppu(:,:,pw_size),1,1,size_diff);
    end
    
    if ppu_size ~= params.Particle_num
        size_diff = NP - ppu_size;
        pw(1,(NP - size_diff + 1):NP) = zeros(1,size_diff);
        ppu(:,:,(NP - size_diff + 1):NP) = repmat(ppu(:,:,ppu_size),1,1,size_diff);
    end
        
    px = reshape(ppu(2,:,:), [], NP);
    v  = reshape(ppu(1,:,:), [], NP);
      %px:パーティクル，pw:重み
        %リサンプリングを実施する関数
        %アルゴリズムはLow Variance Sampling
        wcum=cumsum(pw);
        base=cumsum(pw*0+1/NP)-1/NP;%乱数を加える前のbase
        resampleID=base+rand/NP;%ルーレットを乱数分増やす
        ppx=px;%データ格納用
        pv = v;
        ind=1;%新しいID
        for ip=1:NP
            while(resampleID(ip)>wcum(ind))
                ind=ind+1;
            end
            px(1:end,ip)= [ppx(2:end,ind);ppx(end,ind)];%LVSで選ばれたパーティクルに置き換え
            pv(1:end,ip)= [v(2:end,ind);v(end,ind)];
            pw(ip)=1/NP;%尤度は初期化
        end



end