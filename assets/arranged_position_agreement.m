function arranged_pos = arranged_position_agreement(base_pos,N,z)
    % arranged_position(base_pos,N,z)
    % base_pos を基準に指定の範囲内でランダムに配置
    % 高さはzで一定
    arranged_pos = zeros(3,N);
    spone_area = [-4 4];
    for i=1:N
        arranged_pos(:,i) = [(base_pos+randi(spone_area,1,2))';z];
    end
end