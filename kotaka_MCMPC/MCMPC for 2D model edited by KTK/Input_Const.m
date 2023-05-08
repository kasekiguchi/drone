function [pu, remove_flag, removeX, remove_check_data] = Input_Const(Params, pu)
    %パラメータ設定
    unorm = zeros(1, Params.H, Params.Particle_num);
    H = Params.H;
    umax = Params.umax;
    
    %入力のユークリッドノルムを計算
    for i = 1:Params.Particle_num 
        for j = 1:H
            
            unorm(1, j, i) = norm(pu(:, j, i));
 
        end
    end
    
    %一つでもmaxを超えたらそのサンプルを棄却
    removeI = (unorm(1,:,:) >= umax);
    removeI_check = fix(find(removeI)/Params.H)+1; %棄却するサンプル番号を算出
    
    %最後の粒子が制約に引っかかった場合，想定している最大なサンプル番号を超えることがあるのでその部分を修正
    I_size = size(removeI_check); 
    if I_size(1) ~=0
        if removeI_check(end,1) == (Params.Particle_num + 1)
            removeI_check(end,1) = Params.Particle_num;
        end
    end
    
    %サンプル番号の重なりをなくす
    removeX = unique(removeI_check);
    
    %制約違反の入力サンプル(入力列)を棄却
    pu(:,:,removeX)=[];
    
    remove_flag = size(pu,3); %全制約違反による分散リセットを確認するフラグ 
    
    %サンプルを棄却したかどうか確認(デバッグ用)
    remove_check_data = 0;
    if size(removeX,1) ~=0
        disp('Input Constraint Violation!')
        remove_check_data = size(removeX,1);
    end
    
%% maxを超えたときにmaxに戻すプログラム
%     for i = 1:Params.Particle_num 
%         for j = 1:H
%             if unorm(1, j, i) > umax
%                 
%                 udis = umax/unorm(1, j, i);
%                 pu(:, j, i) = pu(:, j, i)*udis;
%                 
%             end
%         end
%     end

end