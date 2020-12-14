function make_gif(tspan,span,fig,base_fig,varargin)
% tspan : 時間区間 例：0:10 
% span : 注目するエージェント 例： 1:3
% fig(k,span) : 時刻k でのspan分のfig を生成する関数ハンドル
% varargin : init_fig : 初期figure
%                 name : 出力するfile name

    h = figure;
    sizen = 256;
    delaytime = 0;
    
    if isfield(varargin,'name')
        filename= varargin.name;
    else
        filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').gif'),':','_'),' ','_');
    end
    
%     if isfield(varargin,'init_fig')
%         init_fig();
%     end    
    for n=tspan
        h;
        base_fig();
         hold on

        fig(n,span);
        % Write gif
        drawnow;
        frame = getframe(h);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,sizen);
        if n==1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',delaytime);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delaytime);
        end
        hold off;
    end
end