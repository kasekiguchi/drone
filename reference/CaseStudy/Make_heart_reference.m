function [Make_reference,flag] = Make_heart_reference(i,Make_reference,agent,flag)
    switch i 
        case 1
            if flag == 1
                Make_reference(i,:) = [0;-1;1.0];
            end
            error = Make_reference(i,:) - agent(i).state.p';
            if -0.3<=error(1) &&  error(1)<=0.3 && -0.3<=error(2) &&  error(2)<=0.3%目標値の許容範囲 % && -0.3<=error(3) && error(3) <= 0.3 
                    if flag == 2
                        Make_reference(i,:) = [2;1;1.0];%[x;y;z]の値を変化させる
                    end
                    if flag == 3
                        Make_reference(i,:) = [1;2;1.0];
                    end
                    if flag == 4
                        Make_reference(i,:) = [0;1;1.0];
                    end
                    if flag == 5
                        Make_reference(i,:) = [-1;2;1.0];
                    end
                    if flag == 6
                        Make_reference(i,:) = [-2;1;1.0];
                    end
                    if flag == 7
                        Make_reference(i,:) = [0;-1;1.0];
                    end
                    
                    flag = flag + 1;
            end
        
        case 2
                    if flag == 1
                Make_reference(i,:) = [1;0;1.5];
            end
            error = Make_reference(i,:) - agent(i).state.p';
            if -0.1<error(1) &&  error(1)<0.1 && -0.1<error(2) &&  error(2)<0.1 && -0.1<error(3) && error(3) < 0.1
                    if flag == 2
                        Make_reference(i,:) = [1;1;1.5];
                    end
%                     if flag == 3
%                         Make_reference(i,:) = [2;2;0.5];
%                     end
%                     if flag == 4
%                         Make_reference(i,:) = [0;2;1.5];
%                     end
%                     if flag == 5
%                         Make_reference(i,:) = [0;0;1.5];
%                     end
                    flag = flag + 1;
            end
        
        case 3
        Make_reference(i,:) = [3;1;2];
        case 4
        Make_reference(i,:) = [4;1;2];
        case 5
        Make_reference(i,:) = [5;1;2];
        case 6
        Make_reference(i,:) = [6;1;2];
        case 7
        Make_reference(i,:) = [7;1;2];
        case 8
        Make_reference(i,:) = [8;1;2];
        case 9
        Make_reference(i,:) = [9;1;2];
        case 10
        Make_reference(i,:) = [10;1;2];
    end



end