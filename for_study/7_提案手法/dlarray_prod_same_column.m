function AB = dlarray_prod_same_column(A,B)
% AB = A*B'
% A and B have the same column
% Bは転置して引数に渡す

n = size(A,1);
k = size(B,1);
ID = kron(1:k,ones(1,n));
AB = reshape(sum(repmat(A,k,1).*B(ID,:),2),n,k);

end

