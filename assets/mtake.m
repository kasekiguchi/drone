function X = mtake(x,row,col)
arguments
  x
  row
  col = 1:size(x,2)
end
    X = x(row,col);
end