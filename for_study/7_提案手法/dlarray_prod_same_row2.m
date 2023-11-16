function AB = dlarray_prod_same_row2(A,B,n)
% AB = A'*B
% A and B have the same row
k = size(B,2);
ID = kron(1:k,ones(1,n));
AB = reshape(sum(A.*B(:,ID),1),n,k);
end

