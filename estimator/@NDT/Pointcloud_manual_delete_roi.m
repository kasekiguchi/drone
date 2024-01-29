function pointcloud_out_roi = Pointcloud_manual_delete_roi(pd,roi)
% extract data from pd within ROI
% [Input]
% pd : point data : N x 3
% roi : 
% [Output]
% 
ids = roi(1) < pd(inc,1) && pd(inc,1) < roi(2) && roi(1) < pd(inc,1) && pd(inc,1) < roi(2);
pd(ids,:) = [];
pointcloud_out_roi = pd;
    % for inc = 1:length(pd)
    %     if roi(1) < pd(inc,1) && pd(inc,1) < roi(2)
    %         if roi(3) < pd(inc,2) && pd(inc,2) < roi(4)
    %             pd(inc,1) = nan;
    %             pd(inc,2) = nan;
    %             pd(inc,3) = nan;
    %         end
    %     end
    % end
    % R = rmmissing(pd);
    % pd_B = R;
    % pointcloud_out_roi = pd_B;
end