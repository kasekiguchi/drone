function plane_plot3(pl,opts)
% pl = (a,b,c,d)
arguments
    pl
    opts.xlim = [-5,5];
    opts.ylim = [-5,5];
    opts.zlim = [-5,5];
    opts.FH = 1;
end
figure(opts.FH);
hold on
if isvector(pl)
    pl = pl(:)';
end
area=[opts.xlim;opts.ylim];
middle = (area(:,2)+area(:,1))/2;
L = vecnorm(area(:,2)-area(:,1)); % max length of plot area
[X,Y] = meshgrid(opts.xlim,opts.ylim);
for i = 1:size(pl,1)
    a = pl(i,1);
    b = pl(i,2);
    c = pl(i,3);
    d = pl(i,4);
    if c
        z = (-a*X-b*Y-d*ones(size(X)))/c;
        surf(X,Y,z,'FaceAlpha',0.3);
    else
        perp = pl(i,1:3)';
        e = cross([0;0;1],perp);
        vert = ([L,-L]/2 + e'*[middle;0]).*e -d*perp;
        vert = [vert+[0;0;opts.zlim(1)],vert+[0;0;opts.zlim(2)]]';
        patch('Vertices',vert,'Faces',[1 2 4 3],'FaceVertexCData',hsv(1),'FaceAlpha',0.3,'FaceColor','flat');
    end
end
xlim(opts.xlim);
ylim(opts.ylim);
zlim(opts.zlim);
xlabel("x");
ylabel("y");
zlabel("z");
hold off
end