function flag = IsOverlap(x1,x2,x3,x4)
% Determine if line segments overlap
%x1:mesured start point
%x2:mesured end point
%x3:map start point
%x4:map end point
    flag = false(size(x3));
    flag(x1 >= x3 & x1 <= x4) = true;%観測された始点がマップの始点と終点の間
    flag(x1 >= x4 & x1 <= x3) = true;%反対
    flag(x2 >= x3 & x2 <= x4) = true;%観測された終点がマップの始点と終点の間
    flag(x2 >= x4 & x2 <= x3) = true;%反転
    flag(x1 <= x3 & x1 <= x4 & x2 >= x3 & x2 >= x4) = true;%観測された始点と終点がマップを超えている
    flag(x1 >= x3 & x1 >= x4 & x2 <= x3 & x2 <= x4) = true;%反転
    flag(x1 >= x3 & x2 >= x3 & x1 <= x4 & x2 <= x4) = true;%中に入ってる
    flag(x1 <= x3 & x2 <= x3 & x1 >= x4 & x2 >= x4) = true;%反転
end
