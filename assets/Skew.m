function Om = Skew(o)
% % Skew : Skew symmetric matrix
o  = o(:);
o1 = o(1);
o2 = o(2);
o3 = o(3);
Om = [  0,-o3, o2;
    o3,  0,-o1;
    -o2, o1,  0];
end
