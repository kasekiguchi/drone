function B = cellmatfun(fn, C, type, varargin)
% fn : function of matrix, index, varargin
% C : cell array
% type : "cell(default)" or "mat"
% type = "cell"
%    B = {fn(C{1},1,varargin),fn(C{1},2, varargin), ...}
% type = "mat"
%    B = [fn(C{1},1,varargin),fn(C{2},2,varargin), ...]
% Not care about the efficiency.

arguments
    fn
    C
    type = "cell"
end

arguments (Repeating)
    varargin
end

if type == "mat"
    tmp = fn(C{1}, 1, varargin{:});
    syms B [size(tmp, 1) numel(C)] real
    B(:, 1) = tmp;

    for i = 2:numel(C)
        B(:, i) = fn(C{i}, i, varargin{:});
    end

else
    B = cell(1, numel(C));

    for i = 1:numel(C)
        B{i} = fn(C{i}, i, varargin{:});
    end

end

end
