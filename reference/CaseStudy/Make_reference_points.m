function [r,flag] = Make_reference_points(lists,agent,flag,eps)
% 【inputs】
%  lists : 3xN matrix : N = number of reference points
%  agent : agent class instance
%  flag  : = n : indicates n-th points in lists
%  eps   : option : arrival radius 
% 【outputs】
%  r     : reference point
%  flag  : flag
    arguments
        lists
        agent
        flag
        eps = 0.3
    end
    if isempty(agent.reference.result)
        flag = 1;
        r = lists(:,1);
    else
        error = agent.reference.result.state.p - agent.plant.state.p;
        if norm(error(1:2)) <= eps
            if flag == size(lists,2)
                flag = 1;
            else
                flag = flag + 1;
            end
            r = lists(:,flag);
        else
            r = agent.reference.result.state.p;
        end        
    end
end