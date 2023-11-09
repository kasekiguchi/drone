function ref = way_point_ref(val,n,fconfirm,fdrowfig)
% time=[0,2,5,12];%time
% point = [0,4,6,2;0,2,-1,4;0,3,5,2];%way points
% n=5;%多項式次数
arguments
    val
    n
    fconfirm
    fdrowfig=1
end
time = val(:,1)';
point = val(:,2:end)';
dtime = diff(time');%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
Sn=length(time(1:end-1)); %求める多項式の数
D(1,:)=ones(1,n+1);

for i = 1:n-1
    D(i+1,:)=[zeros(1,i), 1:n-i+1].*D(i,:);
    % D(i+1,:)=[zeros(1,i), polyder(D(i,i:end))];
end
% D=sort(D,2);

D_ori=D;
D=D./factorial(0:n-1)';

power_dtime=zeros(Sn,n+1);
for i=1:n+1
    power_dtime(:,i) = dtime.^(i-1);
end
%行列でやる
X=zeros((n+1)*Sn);

for i=1:Sn
    dr=(i-1)*2;
    dc=(i-1)*(n+1);
    X(1+dr:2+dr,1+dc:(n+1)+dc) = [1,zeros(1,n);power_dtime(i,:)];
end

poweT = zeros(n-1,n+1);
for i = 1:Sn-1
    for j=1:n-1
        poweT(j,j+1:end) = power_dtime(i,1:end-j) ;
    end
    dr2=(i-1)*(n-1);
    dc2=(i-1)*(n+1);
    X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, 1+dc2 : (n+1)+dc2) = D(2 : end,1:end).*poweT;
    X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, n+3+dc2 : 2*n+1 +dc2) = - eye(n-1);
end
add=(n+1)*Sn - (n-1);
for j=1:n-1
        poweT(j,j+1:end) = power_dtime(end,1:end-j) ;
end

for i = 1:n-2
    dr3=(i-1)*2;
    % X(add+1+dr3,1+i) = 1;%4関数でさいしょの端点で激しくなるか，最後収束しないかでインデックス1,2をへんこう
    % X(add+2+dr3,end-n:end) = D(i+1,:).*poweT(i,:) ;
    X(add+2+dr3,1+i) = 1;%さいしょの端点で激しくなるか，最後収束しないかでインデックス1,2をへんこう
    X(add+1+dr3,end-n:end) = D(i+1,:).*poweT(i,:) ;
end

s=1:(n+1)*Sn;
Xp =X(s,s);

P = zeros(3,n+1,Sn);
for i = 1:3
    Y1 =  reshape(ones(2,Sn+1).*point(i, :),2*(Sn+1),1);
    Y1 = Y1(2:end-1);
    Y = [Y1;zeros((n+1)*Sn-2*Sn,1)];
    P(i,:,:) = reshape(Xp\Y,1,n+1,Sn);
end

co = ["d0","d1","d2","d3"];
index = length(co);
for i = 1:index
    coefficients.(co(i))=zeros(3,n+2-i ,Sn);
end

coefficients.d0 = P;
if length(co) > n 
    index = n;
end
for i = 2:index
    coefficients.(co(i))=coefficients.d0(:,i:end,:).*D_ori(i,i:end);
end
ref.n=n;
ref.coefficients=coefficients;
ref.t=time(2:end);
ref.dt=dtime;


        if fconfirm
            names = fieldnames(ref.coefficients);            
            for i = 1:length(names)
                t_powers.(names{i}) = @(t) (t).^(0:n+1-i)';
            end
                t_ref0=0;
                i=1;
                j=1;
                delta=0.02;
                end_time=time(end)+10;
                % length_time = length(0:delta:end_time);
                for t_f = 0:delta:end_time
                
                    t_ref= t_f - t_ref0;%目標地点が定められた時間からの経過時間
                
                    if round(t_ref,4) >= dtime(i) 
                       i=i+1;
                        if i >length(ref.t) 
                            i = length(ref.t);
                            t_ref = dtime(end);
                            % t_ref=0;
                            %繰り返し用
                            % obj.i = 1;
                            % obj.t_ref0 = round(t_f,4);
                            % obj.t_ref=0;
                        else
                            t_ref0 = round(t_f,4);
                            t_ref=0;
                        end
                    end
                    % for k = 1:3
                        xyz(:,j) = coefficients.(names{1})(:,:,i)*t_powers.(names{1})(t_ref);
                        vxyz(:,j) = coefficients.(names{2})(:,:,i)*t_powers.(names{2})(t_ref);
                        axyz(:,j) = coefficients.(names{3})(:,:,i)*t_powers.(names{3})(t_ref);
                    % end
                    j=j+1;
                end
    ref.xyz=xyz;
    ref.vxyz=vxyz;
    ref.axyz=axyz;
                if fdrowfig
                    close all
                    i=1;
                    figure(i)
                    plot3(xyz(1,:),xyz(2,:),xyz(3,:),"LineWidth",2);
                    hold on
                    plot3(point(1,:),point(2,:),point(3,:),"LineStyle","none","Marker","o","LineWidth",2)
                    grid on
                    xlabel('x [m]','FontSize',18)
                    ylabel('y [m]','FontSize',18)
                    zlabel('z [m]','FontSize',18)
                    hold off
                    i=i+1;
    
                    figure(i)
                    plot(0:delta:end_time,xyz)
                    grid on
                    i=i+1;
    
                    figure(i)
                    % tiledlayout("horizontal")
                    nexttile
                    plot(xyz(1,:),xyz(2,:),"LineWidth",2)
                    xlabel('x [m]','FontSize',18)
                    ylabel('y [m]','FontSize',18)
                    daspect([1,1,1])
                    hold on
                    plot(point(1,:),point(2,:),'Marker','o','LineStyle','none',"LineWidth",2)
                    grid on
                    nexttile
                    plot(xyz(1,:),xyz(3,:),"LineWidth",2)
                    xlabel('x [m]','FontSize',18)
                    ylabel('z [m]','FontSize',18)
                    daspect([1,1,1])
                    hold on
                    plot(point(1,:),point(3,:),'Marker','o','LineStyle','none',"LineWidth",2)
                    grid on
                    nexttile
                    plot(xyz(2,:),xyz(3,:),"LineWidth",2)
                    daspect([1,1,1])
                    hold on
                    plot(point(2,:),point(3,:),'Marker','o','LineStyle','none',"LineWidth",2)
                    xlabel('y [m]','FontSize',18)
                    ylabel('z [m]','FontSize',18)
                    grid on
                    i=i+1;
    
                    figure(i)
                    plot(0:delta:end_time,vxyz)
                    hold on
                    grid on
                    v_norm=sum(vxyz.^2).^0.5;
                    plot(0:delta:end_time,v_norm)
                    i=i+1;
    
                    figure(i)
                    plot(0:delta:end_time,axyz)
                    hold on
                    grid on
                    a_norm=sum(axyz.^2).^0.5;
                    plot(0:delta:end_time,a_norm)
                    i=i+1;
    
                    fprintf("If you confirmed trajectory, push the Enter key.");
                    input("");
                    close all
                end
        end
end
