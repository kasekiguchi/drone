function pointcloud_out_roi = Pointcloud_manual_roi(ptobj,roi)
    for inc = 1:length(ptobj)
        if roi(1) < ptobj(inc,1) && ptobj(inc,1) < roi(2)
            if roi(3) < ptobj(inc,2) && ptobj(inc,2) < roi(4)
                ptobj(inc,1) = nan;
                ptobj(inc,2) = nan;
                ptobj(inc,3) = nan;
            end
        end
    end
    R = rmmissing(ptobj);
    ptobj_B = R;
    pointcloud_out_roi = ptobj_B;
end