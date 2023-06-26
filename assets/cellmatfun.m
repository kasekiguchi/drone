function B = cellmatfun(fn, C, varargin)
B = cell(1,numel(C));
for i = 1:numel(C)
 B{i} = fn(C{i},varargin{:});
end
end