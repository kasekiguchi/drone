function set_region_callback(src,evt,field,callback)
   evname = evt.EventName;  
   if strcmp(evname,'ROIMoved')
      field.Value = join(string([evt.CurrentPosition(1),", ",evt.CurrentPosition(2)]));
   end
   callback(0);
end