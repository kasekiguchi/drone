function S = smcplace(A,B,P)
[~,Bcol]=size(B);
[~,Acol]=size(A);
A11=A(1:Acol-Bcol,1:Acol-Bcol);
A12=A(1:Acol-Bcol,Acol-Bcol+1:Acol);
S=[place(A11,A12,P) eye(Bcol)];
end