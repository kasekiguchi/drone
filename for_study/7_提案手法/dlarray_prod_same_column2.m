function AB = dlarray_prod_same_column2(A,B,n)
% AB = A*B'
% A and B have the same column
k = size(B,1);
ID = kron(1:k,ones(1,n));
AB = reshape(sum(A.*B(ID,:),2),n,k);
end

