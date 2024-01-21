function map_rotation_CCW(app,event)
      value = double(string(app.MaprotationCCWEditField.Value));
      view(app.original_data_ax,atan(tan(-value*pi/180)*app.shape_ratio)*180/pi,90);
      north_dir = value*pi/180; % rad
      app.NorthdirectionGauge.Value = -north_dir;
      dlist = [];
      for i = 1:length(app.original_data_ax.Children)
        if strcmp(class(app.original_data_ax.Children(i)),'matlab.graphics.primitive.Patch')
          dlist = [dlist, i];
        end
      end
      delete(app.original_data_ax.Children(dlist));
      cn = cos(-north_dir);
      sn = sin(-north_dir);
      sp0 = app.roibl.Position';
      sp2 = app.roitr.Position';
      lxy = [cn sn;-sn cn]*(sp2-sp0);
      sp1 = sp0 + lxy(1)*[cn;sn];
      sp3 = sp0 + lxy(2)*[-sn;cn];
      app.ps = [sp0';sp1';sp2';sp3'];
      patch(app.original_data_ax,'Faces',[1,2,3,4],'Vertices',app.ps,...
        'EdgeColor','green','FaceColor','none','LineWidth',2);
      app.original_data_ax.Children(end+1) = app.original_data_ax.Children(1);
end