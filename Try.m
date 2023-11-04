% flag = 0;
% for i  = 1:20
%     if flag == 1
%         disp("whileの外に出て、for文が再び回ってます")
%         flag = 0;
%         pause(5);
%     end
%     te = 0;
%     while te < 100
%         if flag == 1
%             disp('whileの中で再び回ってます')
%             pause(5);
%         end
%         weight = diag([randi(10) randi(10) randi(10)])
%         te = te + 1
%         if weight(1,1) > 8
%             flag = 1;
%             fprintf("条件を満たしました. i: %d \n",i)
%             break;
%         end
%     end
% end
%% 
clc
clear all
while true
    test.i = [randi(200); randi(200); randi(200); randi(200)];
    test.j = 100;
    
    if test.i(1,1) > 190 && test.i(2,1) > 190 && test.i(3,1) > 190 && test.i(4,1) > 190
        disp('条件を満たしました')
        i = 1;
        j = num2str(i);
        test.i
        save(strcat('Data\11_4__',j,'.mat'),'test')
        return;
    end
end
% disp('プログラム終了')
