function time_response(Logger,xi)
% 特定のLOGのS,I,R遷移を出力
% xi = 1  %Logの番号
kre2 = size(Logger(xi).I); kre2 = kre2(1,2);  %シミュレーションの最終ステップ数
tmpS3 = 0;
tmpI3 = 0;
tmpR3 = 0;
I2.I = logical (Logger(xi).I);
for i = 1:kre2
    tmpS3(i)=sum(Logger(xi).S(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    tmpI3(i)=sum(I2.I(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    tmpR3(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
end
damage_cell = tmpR3(kre2)+tmpI3(kre2)

figure(2)
plot(1:kre2,tmpS3,'-g','LineWidth',2);  %Iだけならコメントアウト
hold on 
plot(1:kre2,tmpI3,'-b','LineWidth',2);
plot(1:kre2,tmpR3,'-r','LineWidth',2);  %Iだけならコメントアウト
legend('S','I','R');  %Iだけならコメントアウト
% legend('I');        %Iだけならコメント解除
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 kre2]);
%ylim([0 nx_app * ny_app * 1.0]);
hold off

disp('Plot ended')
end