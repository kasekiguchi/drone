% Make video
% SAVE:structure of simulation result
function MakeVideo(SAVE)
    
    NumberofAgents = length(SAVE);
    te = length(SAVE{1}.State(1,:));
    PlotColor=['r';'b';'g';'m';'c';'y'];
    
    figure;
    figure1 = figure;
    axes1=axes('Parent',figure1);
    
    % File name (data)
    % .avi
    % FileName = strrep(strrep(strcat('Movie(',datestr(datetime('now')),')'),':','_'),' ','_');
    % v=VideoWriter(FileName);
    % .mp4
    FileName = strrep(strrep(strcat('Movie(',datestr(datetime('now')),')'),':','_'),' ','_');
    
    % Video object
    v=VideoWriter(FileName,'MPEG-4');
    v.Quality=100; % Quality of graphic
    
    open(v);
    for vz=1:1:te

        for k=1:NumberofAgents
            plot(SAVE{k,1}.State(2,vz),SAVE{k,1}.State(4,vz),'.','Color',PlotColor(k),'MarkerSize',10);
            hold on;
        end

        % Axis setting
        set(axes1,'FontName','Times New Roman','FontSize',24);
        axis equal;
        axis([-1 11 -1 11]);
        grid on;
        xlabel('x');
        ylabel('y');

        frame=getframe(gcf);
        writeVideo(v,frame);
        hold off;
    end
    close(v);
end
