function arranged_pos = arranged_position_agreement(base_pos,N,z)
    % arranged_position(base_pos,N,gap,z)
    % base_pos を基準にgap 間隔でx-yに整列した初期値を生成
    % 高さはzで一定
    arranged_pos = zeros(3,N);
    a=-3;
    b=3;
    for i=1:N
        arranged_pos(:,i) = [(base_pos+(a+(b-a)*rand(1,2)))';z];
    end
end