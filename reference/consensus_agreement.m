function [tc2,xc2,uc2] = consensus_agreement(t0,t1,x0)
    disp("NowSimulating");
    tc2 = t0;
    xc2 = x0;
    uc2 = situation.u_hold;
    
    %------------------------計算-------------------------
    for t = t0 : +situation.h : t1
        %入力値の計算
%   各エージェントへの入力値を計算

    %-------シミュレーションの進み具合を表示--------
    if rem(t,1) < 1.e-3  
        disp('.') 
    end	
   
    %オフセットを入れる場合はコメントアウトを外す
%     X = X+situation.offset;
    
    %---------------入力の算出------------------
    %合意制御:ui=-k((xi-oi)-(xj-oj))
    k=0.3;
    Ux = -k * situation.L * X(1:4:4*situation.AgentNumber) - X(2:4:4*situation.AgentNumber);
    Uy = -k * situation.L * X(3:4:4*situation.AgentNumber) - X(4:4:4*situation.AgentNumber);
%     Ux(1)=-k*(X(1)-7);
%     Uy(1)=-k*(X(3)-8);
    U = [Ux,Uy];

         U = link_eqs(t,x0);
         sol = ode45(@(t,X) diff_eqs(t,X,U),[t,t+situation.h],x0);

         tc = linspace(t,t+situation.h,100);
         xc = deval(tc,sol);
         uc = repmat(U,1,100);


    %--------------TC,XC,UCの行列を構成--------------
         tc2 = [tc2,tc(:,end)];
         xc2 = [xc2,xc(:,end)];
         uc2 = [uc2,uc(:,end)];
     
    %--------------エージェントの状態の更新-------------
         x0 = xc(:,end);

    end
end