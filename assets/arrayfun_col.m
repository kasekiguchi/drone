function P = arrayfun_col(fn,M)
P = cell(1,size(M,2));
for i = 1:size(M,2)
  P{i} = fn(M(:,i));
end
end