function v = R2v(R)
    % convert rotation matrix to vector form
    
%   v = reshape(R',[9 1]); % Rに転置が必要な点に注意
v=[R(1,1);R(1,2);R(1,3);R(2,1);R(2,2);R(2,3);R(3,1);R(3,2);R(3,3)];% faster than reshape
end
