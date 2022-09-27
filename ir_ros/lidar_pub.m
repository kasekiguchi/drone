clear all ;
clc;
test1 = ros2node("/test1",30);

for i = 1:10
    scandata_Sub = ros2subscriber(test1,"/Robot_1/pose",...
        "History","keepall","Reliability","besteffort");
%     scandata_Sub2 = ros2subscriber(test2,"/Robot_2/pose",...
%         "History","keepall","Reliability","besteffort");
    scandata(i) = receive(scandata_Sub,2);
end



%% plot
% 
% for i = 1:1
% 
% %     X = (scandata(i).angle_max-scandata(i).angle_min)/scandata(i).angle_increment;
%     X = length(scandata(i).ranges);
%     y = [];
%     A = fillmissing(scandata(i).ranges,'previous');
%     angles = linspace(scandata(i).angle_min,scandata(i).angle_max,numel(scandata(i).ranges));
%     angles = angles';
% 
% %     for j = 1:X
% %         y.agent(j,1) = scandata(i).angle_min + scandata(i).angle_increment;
% %         if j >= 2
% %             y.agent(j,1) = y.agent(j-1,1) + scandata(i).angle_min + scandata(i).angle_increment;
% %         end
% %     endangles = linspace(-pi/2,pi/2,numel(ranges));
%         scan(i,1) = lidarScan(A,angles);
%         plot(scan(i,1))
% end
% 
% %%
% % run("ros1.m")
