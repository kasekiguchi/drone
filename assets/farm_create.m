function fp = farm_create(n)
z=1;
if n==1
    fp{1}=[60;60;z];
elseif n==2
    fp{1}=[45;60;z];
    fp{2}=[75;60;z];
elseif n==3
    fp{1}=[45;60;z];
    fp{2}=[60;60;z];
    fp{3}=[75;60;z];
elseif n==4
    fp{1}=[45;75;z];
    fp{2}=[45;45;z];
    fp{3}=[75;45;z];
    fp{4}=[75;75;z];
elseif n==5
    fp{1}=[45;75;z];
    fp{2}=[45;45;z];
    fp{3}=[75;45;z];
    fp{4}=[75;75;z];
    fp{5}=[60;60;z];
elseif n==6
    fp{1}=[45;75;z];
    fp{2}=[45;60;z];
    fp{3}=[45;45;z];
    fp{4}=[75;45;z];
    fp{5}=[75;60;z];
    fp{6}=[75;75;z];
elseif n==7
    fp{1}=[45;75;z];
    fp{2}=[45;60;z];
    fp{3}=[45;45;z];
    fp{4}=[75;45;z];
    fp{5}=[75;60;z];
    fp{6}=[75;75;z];
    fp{7}=[60;60;z];
elseif n==8
    fp{1}=[45;75;z];
    fp{2}=[45;60;z];
    fp{3}=[45;45;z];
    fp{4}=[60;45;z];
    fp{5}=[75;45;z];
    fp{6}=[75;60;z];
    fp{7}=[75;75;z];
    fp{8}=[60;75;z];
else
    fp{1}=[45;75;z];
    fp{2}=[45;60;z];
    fp{3}=[45;45;z];
    fp{4}=[60;45;z];
    fp{5}=[75;45;z];
    fp{6}=[75;60;z];
    fp{7}=[75;75;z];
    fp{8}=[60;75;z];
    fp{9}=[60;60;z];
end
end
