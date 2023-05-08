function [remove_flag, pw, px, pu] = State_Const(Params, pw, px, pu)
%     clear remove_flag
%     clear removeI
%     clear removeFe

    %パラメータの設定
    NP = Params.Particle_num;
%     remove_sizeI =  size(Params.remove_ID,1);
%     
%     %状態の格納から入力制約によるサンプル棄却を実行
%     if remove_sizeI~=0
%         for i = 1 : remove_sizeI
%             px(:,:,(NP - i + 1))=[];
%         end
%     end
    
    %% 状態制約
    removeFe = (px(5,:,:) <= 0); %電力量が0になったらその軌道を棄却
    
%     for i = 1:Params.Particle_num
%        for j = 1:Params.H
%         if px(1,j,i) >= 3 && px(1,j,i) <= 5 && px(2,j,i) <= 1 && px(2,j,i) >= -1
%              removeF(check_num) = (i-1) * Params.H + j;
%              if removeF(check_num) >= (i*Params.H)
%                  removeF(check_num) = (i*Params.H)-1;
%              end
%              check_num = check_num + 1;
%         end   
%        end
%     end

%     removeF = (px(1,:,:) >= 3 && px(1,:,:) <= 5 && px(2,:,:) <= 1 && px(2,:,:) >= -1);

    removeFe_check = fix(find(removeFe)/Params.H)+1;
%     removeF_check = fix(removeF/Params.H)+1

    Fe_size = size(removeFe_check);

    %最後の粒子が制約に引っかかった場合，想定している最大なサンプル番号を超えることがあるのでその部分を修正
    if Fe_size(1) ~=0 
        if Fe_size(2) ~=0
            if removeFe_check(end,1) == (Params.Particle_num + 1)
                removeFe_check(end,1) = Params.Particle_num;
            end
        end
    end

%     removeX = unique([removeFe_check;removeI_check]);
    removeX = unique([removeFe_check]);
    
    %制約違反したサンプルを棄却
    pu(:,:,removeX)=[];
    px(:,:,removeX)=[];
    pw(removeX)=[];
    
    %サンプルを棄却したかどうか確認(デバッグ用)
%     remove_check_data = 0;
    if size(removeX,1) ~=0
        disp('State Constraint Violation!')
%         remove_check_data = 1;
    end
    
    remove_flag = size(pu); %全制約違反による分散リセットを確認するフラグ 
end