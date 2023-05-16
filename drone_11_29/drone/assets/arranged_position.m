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

