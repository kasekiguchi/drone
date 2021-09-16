function [F] = make_animation(kspan,span,fig,base_fig,output,FileName,FH)
% animation 表示用
% kspan : 描画する離散時間配列
% span :  描画対象とするagentのインデックス配列
% fig : 各時刻の描画を行う関数
%   fig(k,span)
%   k : 時刻
% base_fig : 背景描画を行う関数
arguments
    kspan (:,:) double
    span {mustBeInteger}
    fig
    base_fig
    output = 0
    FileName = strrep(strrep(strcat('Movie(',datestr(datetime('now')),')'),':','_'),' ','_');
    FH = figure;
end
switch output
    case 1
        % File name (data)
        % .avi
        % v=VideoWriter(FileName);
        % .mp4
        v=VideoWriter(FileName,'MPEG-4');
        
        % Video object
        v.Quality=100; % Quality of graphic
        
        open(v);
        F=[];
        %FH.Visible= 'off';
    case 2
        F(kspan) =  struct('cdata',[],'colormap',[]);
        %FH.Visible= 'off';
    otherwise
        F=[];
end
hold on
for k = kspan
    base_fig();
    
    fig(k,span);
    title(strcat("Time : ",string(k)));
    % update screen
    drawnow %limitrate
    switch output
        case 1
            frame=getframe(gcf);
            writeVideo(v,frame);
        case 2
            F(k) = getframe(gcf);
    end
end
hold off
switch output
    case 1
        close(v);
    case 2
%         fig = figure;
%         movie(fig,F,2)
end
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

