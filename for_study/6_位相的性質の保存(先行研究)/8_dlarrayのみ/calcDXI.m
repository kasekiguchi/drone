function dxi = calcDXI(xi,al)
%CALCDXI この関数の概要をここに記述
%   xi：内部状態xi(x → phi → xi)
%   al：正のスカラー関数alpha

s = size(xi);
for i = 1:s(3)
    for j = 1:s(2)
        v1 = xi(2,j,i) + xi(1,j,i) .* (1 - xi(2,j,i)^2);
        v2 = - xi(1,j,i);
        v = [v1;v2];
        dxi(:,j,i) = al(:,j,i) .* v;
    end
end

% dxi = dlarray(dxi,'CBT');

end

