A=[1 2 3;4 5 6];
R=[2 3;4 5];
P=[];
for i=1:size(A,2)
    P(:,i)=R*A(:,i)
end

% A = [1 0 0 0;0 -1 0 1;0 0 -1 0;2 0 -1 -1];
% B = [-1;1;0;-1];
% C = [1 0 1 0];
% Mc = ctrb(A,B);
% Mo = obsv(A,C);
% Xc = null(Mc,"rational");
% Xo = null(Mo,"rational");
% sys =ss(A,B,C,0);
% csys = canon(sys)
% [T,Abar,Bbar,Cbar]=Kalman_Decomposition(A,B,C)
% function [T,Abar,Bbar,Cbar]=Kalman_Decomposition(A,B,C) 
%     [n1,n2]=size(A);
%     [n3,m]=size(B);
%     [p,n4]=size(C);
%     if (n1==n2 && n2==n3 && n3==n4)
%         n=n1;
%     else
%         disp("Invalid matrix dimensions, please try again: ");
%     end
%     while (n<0 || m<0 || p<0 || n<=max(p,m)) % Checking whether matrix dimensions are satisfying the required condition or not.
%         disp("Invalid matrix dimensions, please try again: ");
%     end
%     CM = Ctrb_matrix(A,B); % To find the Controllability Matrix
%     OM = Obsv_Matrix(A,C); % To find the Observability Matrix
%     if (rank(A)==n && rank(CM)==n && rank(OM)==n) % Checking whether given system is already in controllable as well as observable or not.
%         disp("The system of equation is already Controllable and Observable.");
%         Abar=A;
%         Bbar=B;
%         Cbar=C;
%         T="Null";
%     else
%         RS=Range_Space(CM);  %To find the Range Space of Controllability Matrix or the Reachable Space.
%         US=null(OM); % To find the null space of Observability Matrix or the Unobservable Space.
%         CbU=intsection_of(RS,US); % To find the basis of Controllable but Unobservable Matrix.
%         ONCbU = null(CbU'); % To find the basis of Orthonormal completemt of Controllable but Unobservable Matrix.
%         CaO=intsection_of(RS,ONCbU); % To find the basis of Controllable and Observable Matrix
%         UaU=intsection_of(US,ONCbU); % To find the basis of Uncontrollable and Unobservable Matrix
%         U=[CbU CaO UaU]; % Concatenating Matrix of basis of Controllable but Unobservable Matrix, Controllable & Observable Matrix and Uncontrollable & Unobservable Matrix
%         UbO=null(U'); % taking null space of transpose of union matrix to find Uncontrollable but Observable Matrix
%         T=[CbU CaO UaU UbO]; % Concatenation of all 4 basis vectors to find the transformation matrix
%         Abar = T\A*T; % To find the Modified State Matrix (inverse(T)*A*T)
%         Bbar = T\B; % To find the Modified Input Matrix (inverse(T)*B)
%         Cbar = C*T; % To find the Modified Output Matrix
%     end
% function x = Range_Space(y) % Function to find the Range Space of a matrix
%     [r,p]=rref(y); % To find the redecued row echelon form of a mtrix (r) and the independent columns numbers (p)
%     x=y(:,p); % To create a matrix x from the given matrix that have those columns which are linearly independent
% end
% function x=intsection_of(f,g) % Function to find the Intersection between two matrices
%     r=rank(f); % Taking the rank of first matrix and store it as r
%     c=null([f g]); % Taking the null space of direct sum of the given two matrices
%     d=c(1:r,:); % From the C matric taking the first r number of rows and store it as d
%     x=f*d; % multiplying d with the first matrix to find the intersection between given two matrices
% end
% function x=Ctrb_matrix(f,g) % Function to find Controllablity Matrix
%     k=f*g; % Multiplying given two matrices for the first time and store it as k (first iteration)
%     x=[g k]; % Making a matrix with second matrix and K as its columns
%     for i=1:(min(size(f))-2) % Repeating the same thing again (n-2) times to form the actual Controllability matrix (Where n is dimension of first square matrix)
%         k=f*k;
%         x=[x k];
%     end
% end
% function x = Obsv_Matrix(f,g) % Function to find Observability Matrix
%     k=g*f; % Multiplying given two matrices for the first time and store it as k (first iteration)
%     x=[g;k]; % Making a matrix with second matrix and K as its rows
%     for i=1:(min(size(f))-2) % Repeating the same thing again (n-2) times to form the actual Observability matrix (Where n is dimension of first square matrix)
%         k=k*f;
%         x=[x;k];
%     end
% end
% end