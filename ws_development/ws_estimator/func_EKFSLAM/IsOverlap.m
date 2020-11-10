% Determine if line segments overlap
function flag = IsOverlap(x1, x2, x3, x4)
    flag = false(size(x3));
    flag(x1 >= x3 & x1 <= x4) = true;
    flag(x1 >= x4 & x1 <= x3) = true;
    flag(x2 >= x3 & x2 <= x4) = true;
    flag(x2 >= x4 & x2 <= x3) = true;
    flag(x1 <= x3 & x1 <= x4 & x2 >= x3 & x2 >= x4) = true;
    flag(x1 >= x3 & x1 >= x4 & x2 <= x3 & x2 <= x4) = true;
    flag(x1 >= x3 & x2 >= x3 & x1 <= x4 & x2 <= x4) = true;
    flag(x1 <= x3 & x2 <= x3 & x1 >= x4 & x2 >= x4) = true;
end
