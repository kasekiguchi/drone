function AB = dlarray_prod_same_row(A,B)
% AB = A'*B
% A and B have the same row

n = size(A,2);
k = size(B,2);
ID = kron(1:k,ones(1,n));
AB = reshape(sum(repmat(A,1,k).*B(:,ID),1),n,k);

end

