function arranged_pos = arranged_position(base_pos,N,gap,z)
    % arranged_position(base_pos,N,gap,z)
    % base_pos を基準にgap 間隔でx-yに整列した初期値を生成
    % 高さはzで一定
    kpos=ceil(sqrt(N));
    cpos=floor(N/kpos);
    rempos=mod(N,kpos);
    [xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
    xpos=gap*xpos;
    ypos=gap*ypos;
    arranged_pos=base_pos-[gap gap]+[reshape(xpos,[N-rempos,1]),reshape(ypos,[N-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];
    arranged_pos= [arranged_pos';z*ones(1,size(arranged_pos,1))];
end
%追加
function arranged_pos_2p = arranged_position_2p(base_pos_2p,N_2p,gap_2p,z_2p)
    % arranged_position(base_pos,N,gap,z)
    % base_pos を基準にgap 間隔でx-yに整列した初期値を生成
    % 高さはzで一定
    kpos_2p=ceil(sqrt(N_2p));
    cpos_2p=floor(N_2p/kpos_2p);
    rempos_2p=mod(N_2p,kpos_2p);
    [xpos_2p,ypos_2p]=meshgrid(1-floor(kpos_2p/2):ceil(kpos_2p/2),1-floor(cpos_2p/2):ceil(cpos_2p/2));
    xpos_2p=gap_2p*xpos_2p;
    ypos_2p=gap_2p*ypos_2p;
    arranged_pos_2p=base_pos_2p-[gap_2p gap_2p]+[reshape(xpos_2p,[N_2p-rempos_2p,1]),reshape(ypos_2p,[N_2p-rempos_2p,1]);(1:rempos_2p)'*[gap_2p,0]+[0 gap_2p]*(ceil(cpos_2p/2)+1)];
    arranged_pos_2p= [arranged_pos_2p';z_2p*ones(1,size(arranged_pos_2p,1))];
end
%
