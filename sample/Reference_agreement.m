function Reference = Reference_agreement(N)
    %% reference class demo
    % 合意制御の目標隊列
    % reference property をReference classのインスタンス配列として定義
    % 返し値は配置したい隊列
    clear Reference
    Reference.type=["consensus_agreement"];
    Reference.name=["agreement"];
    pos = linspace(0,2*pi,N); %円形に配置
    Reference.param = zeros(3,N);
    r = 0.5; %隊列の半径
    for i=1:N
        Reference.param(:,i)=[r*cos(pos(i));r*sin(pos(i));1.0];
    end
%     l = 5;
%     pos = linspace(0,l,N); %左向きV字
%     Reference.param = zeros(3,N);
%     theta = pi/6;
%     Reference.param(:,1) = [-pos(1)*cos(theta);pos(1)*sin(theta);0.0];
%     for i=2:N
%         if mod(i,2)==0
%             Reference.param(:,i)=[-pos(i)*cos(theta);pos(i)*sin(theta);0.0];
%         else
%             Reference.param(:,i)=[-pos(i-1)*cos(theta);pos(i-1)*-sin(theta);0.0];
%         end
%     end
%     l = 5;
%     pos = linspace(0,l,N); %右向きV字
%     Reference.param = zeros(3,N);
%     theta = pi/6;
%     for i=1:N
%         if mod(i,2)==0
%             Reference.param(:,i)=[pos(i)*cos(theta);pos(i)*sin(theta);0.0];
%         else
%             Reference.param(:,i)=[pos(i)*cos(theta);pos(i)*-sin(theta);0.0];
%         end
%     end
end
