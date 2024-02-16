clc;close all

% f = @(t) plot(logger.Data.agent.estimator.result{1,t}.state.p(1), ...
%     logger.Data.agent.estimator.result{1,t}.state.p(2),'r*');
% fanimator(f)


% plot(logger.Data.agent.estimator.result{1,3}.state.p(1), ...
%     logger.Data.agent.estimator.result{1,3}.state.p(2),'r*');


ax=gca;
v = VideoWriter("newfile.avi");
v.Quality=100;
v.FrameRate=5;
% Duration
open(v)
for j = 1:logger.k
    
    scatter(agent.estimator.fixedSeg.Location(:,1),agent.estimator.fixedSeg.Location(:,2),10,"filled")
    hold(ax,"on")    
    pr_x(j) = logger.Data.agent.reference.result{1,j}.state.p(1,1);
    pr_y(j) = logger.Data.agent.reference.result{1,j}.state.p(2,1);
    plot(pr_x,pr_y,"pentagram","MarkerSize",20)
    % ndtpc=logger.Data.agent.estimator.result{1,j}.ndtPCdata.Location * ...
    %         logger.Data.agent.estimator.result{1,j}.tform.R + ...
    %         logger.Data.agent.estimator.result{1,j}.tform.Translation; 
    ndtpc=pctransform(logger.Data.agent.estimator.result{1,j}.ndtPCdata, ...
        logger.Data.agent.estimator.result{1,j}.tform);
    scatter(ndtpc.Location(:,1),ndtpc.Location(:,2),1,"filled");
    scatter(logger.Data.agent.estimator.result{1,j}.state.p(1), ...
        logger.Data.agent.estimator.result{1,j}.state.p(2) ...
        ,'MarkerFaceColor',[1 0 0]);
    drawnow    
    frame=getframe(ax);
    writeVideo(v,frame);
    hold(ax,"off")
end
close(v)