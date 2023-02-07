function line_plot3(l,opts)
% l : pl, e
arguments
    l
    opts.xlim = [-5,5];
    opts.ylim = [-5,5];
    opts.zlim = [-5,5];
    opts.FH = 1;
end
area=[opts.xlim;opts.ylim;opts.zlim];
L = vecnorm(area(:,2)-area(:,1)); % max length of plot area
figure(opts.FH);
perp = l.pl(1:3);
range = -L:0.01:L;
XYZ=(range.*l.e(:)-l.pl(4)*perp(:))';
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3));
xlim(opts.xlim);
ylim(opts.ylim);
zlim(opts.zlim);

end