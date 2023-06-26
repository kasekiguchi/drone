function B = cellmatfun(fn, C, type, varargin)
% B = {fn(C{1},varargin),fn(C{1},varargin), ...}
arguments
  fn
  C
  type = "cell"
end
arguments  (Repeating)
    varargin 
end
if type == "mat"
tmp = fn(C{1},varargin{:});
syms B [size(tmp,1) numel(C)] real
B(:,1) = tmp;
for i = 2:numel(C)
 B(:,i) = fn(C{i},varargin{:});
end
else
B = cell(1,numel(C));
for i = 1:numel(C)
 B{i} = fn(C{i},varargin{:});
end
end
end