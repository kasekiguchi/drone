function result = separate_flock(N,base_pos,fp,Na)
spone_distance = 60;
area_spone = arrayfun(@(th) fp+(spone_distance+0)*[cos(th);sin(th)],0*pi/180:1*pi/180:360*pi/180,'UniformOutput',false);
base_pos=[100 60];%N=1のagentの場所を指定している．
AA = randsample(length(area_spone),1);
% base_pos=area_spone{AA}';
kpos=ceil(sqrt(N/2));
cpos=floor(N/2/kpos);
rempos=mod(N/2,kpos);
[xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
gap=3;
xpos=gap*xpos;
ypos=gap*ypos;
result_a=base_pos-[gap gap]+[reshape(xpos,[N/2-rempos,1]),reshape(ypos,[N/2-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];

% pth = 30*pi/180;
% th = Cov_vatan2(base_pos,fp);
% if pth+th>pi
% aa = th-pth;
% else
%     aa = th+pth;
% end
%     
% 
% base_pos = 60*[cos(aa) sin(aa)];
spone_distance = 60;
area_spone = arrayfun(@(th) fp+(spone_distance+0)*[cos(th);sin(th)],0*pi/180:1*pi/180:360*pi/180,'UniformOutput',false);
base_pos=[100 30];%N=1のagentの場所を指定している．
AA = randsample(length(area_spone),1);
% base_pos=area_spone{AA}';
kpos=ceil(sqrt(N/2));
cpos=floor(N/2/kpos);
rempos=mod(N/2,kpos);
[xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
gap=3;
xpos=gap*xpos;
ypos=gap*ypos;
result_b=base_pos-[gap gap]+[reshape(xpos,[N/2-rempos,1]),reshape(ypos,[N/2-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];
% base_pos = 60*[cos(aa) sin(aa)];
spone_distance = 60;
area_spone = arrayfun(@(th) fp+(spone_distance+0)*[cos(th);sin(th)],0*pi/180:1*pi/180:360*pi/180,'UniformOutput',false);
% base_pos=[100 60];%N=1のagentの場所を指定している．
AA = randsample(length(area_spone),1);
base_pos=area_spone{AA}';
kpos=ceil(sqrt(Na));
cpos=floor(Na/kpos);
rempos=mod(Na,kpos);
[xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
gap=3;
xpos=gap*xpos;
ypos=gap*ypos;
result_c=base_pos-[gap gap]+[reshape(xpos,[Na-rempos,1]),reshape(ypos,[Na-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];


result = [result_a;result_b;result_c];

end