function[xr] = Reference (t, Params)
    time = t;
    xr = zeros(2, Params.H);
        
    for i = 1:Params.H
        time_true = time + (i-1) * Params.PredStep(i);
        xr(1, i) = Params.x0(1, 1) + 0.2 * time_true;
        xr(2, i) = Params.x0(2, 1) + 0.0;
    end
       
%     if Params.flag ==1      
%         for i = 1:Params.H
%             time_true = time + (i-1) * Params.dt; 
%             if time_true >= 4
%                 xr(1,i) = Params.x0(1, 1) + 0.5 * time_true;
%                 xr(2,i) = 1;
%                 xr(3,i) = 0.5;
%                 xr(4,i) = 0;
%             else     
%                 xr(1,i) = Params.x0(1, 1) + 0.5 * time_true;
%                 xr(2,i) = 0;
%                 xr(3,i) = 0.5;
%                 xr(4,i) = 0;
%             end
% 
%             if time_true>=12
%             xr(1,i) = Params.x0(1,1) + 0.5*12;
%             xr(2,i) = 1;
%             xr(3,i) = 0;
%             xr(4,i) = 0;
%             end
%         end
%     else
%         for i = 1:Params.H
%             time_true = time + (i-1)*Params.dt; 
%             if time_true>=4
%                 xr(1,i) = Params.x0(1,1) + 0.5*time_true;
%                 xr(2,i) = 0;
%                 xr(3,i) = 0.5;
%                 xr(4,i) = 0;
%             else     
%                 xr(1,i) = Params.x0(1,1) + 0.5*time_true;
%                 xr(2,i) = 0;
%                 xr(3,i) = 0.5;
%                 xr(4,i) = 0;
%             end
% 
%             if time_true>=12
%                 xr(1,i) = Params.x0(1,1) + 0.5*12;
%                 xr(2,i) = 0;
%                 xr(3,i) = 0;
%                 xr(4,i) = 0;
%             end
%         end
%     end
end
