function out = tform_manual(pt,rot,T)
    for i = 1:length(pt)
        tform = rot * pt(i,:)' + T';
        ptobj_tform(i,1) = tform(1,1);
        ptobj_tform(i,2) = tform(2,1);
        ptobj_tform(i,3) = tform(3,1);
    end
    out=ptobj_tform;
end