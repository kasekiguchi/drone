function R=v2R(v)
    %R = reshape(v,[3,3])'; % 最後に転置が必要な点に注意
    R = [v(1),v(2),v(3);v(4),v(5),v(6);v(7),v(8),v(9)];
end
