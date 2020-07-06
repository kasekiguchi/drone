function [] = make_animation(kspan,span,fig,base_fig)
%
    h =figure;
    h;
         hold on
for k = kspan
        base_fig();

        fig(k,span);
    % update screen
    drawnow %limitrate
end
hold off
end
%%
% Z = peaks;
% surf(Z)
% axis tight manual
% ax = gca;
% ax.NextPlot = 'replaceChildren';
% 
% loops = 40;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     X = sin(j*pi/10)*Z;
%     surf(X,Z)
%     drawnow
%     F(j) = getframe(gcf);
% end
% fig = figure;
% movie(fig,F,2)

