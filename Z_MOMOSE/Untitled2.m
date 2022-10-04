%% smc
dt=0.025;
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
A11=diag([1,1],1);
    A12=[0;0;1];
    K = lqrd(A11,A12,diag([1,1,1]),1,dt);
    S=[K 1];
    SA=S*Ac4;
    SB=S*Bc4; 
    q=10;
    e=-1:0.01:1;
    s=length(e);
    u=zeros(1,s);
    for i=1:s
        u(i)=-inv(SB)*(SA*e(i)+q*tanh(S*e(i)));
        
    end
    plot(e,u);