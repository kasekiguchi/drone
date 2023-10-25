function C = cellrepmat(A,row,col)
C = mat2cell(repmat(A,row,col),ones(1,row)*size(A,1),ones(1,col)*size(A,2));
end