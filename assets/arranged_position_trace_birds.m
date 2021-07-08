function arranged_pos = arranged_position_trace_birds(fp,N,Na,Nb,z)
    spone_distance = 60;
    area_spone = arrayfun(@(th) fp+(spone_distance+0)*[cos(th);sin(th)],0*pi/180:1*pi/180:360*pi/180,'UniformOutput',false);
    % base_pos=[100 60];%N=1‚Ìagent‚ÌêŠ‚ğw’è‚µ‚Ä‚¢‚éD
    AA = randsample(length(area_spone),1);
    base_pos=area_spone{AA}';

    kpos=ceil(sqrt(N));
    cpos=floor(N/kpos);
    rempos=mod(N,kpos);
    [xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
    gap=3;
    xpos=gap*xpos;
    ypos=gap*ypos;
    origin=base_pos-[gap gap]+[reshape(xpos,[N-rempos,1]),reshape(ypos,[N-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];
    arranged_pos = zeros(3,N);
    for i=1:N
        arranged_pos(:,i) = [origin(i,:)';z];
    end
    
    %‚Ş‚ê‚ğ•ª‚¯‚é‚©‚Ç‚¤‚©D
    if 0
        arranged_pos = separate_flock(Nb,base_pos,fp,Na);
    end
end

