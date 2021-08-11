function  result = ObjectInitialize(num,FieldType,Nob,Nh)
switch FieldType
    case '3widths straight'
        tmp = linspace(0,20,Nob+2);
        result = [2;tmp(1+(num-Nh))];
    case 'straight'
        tmp = linspace(0,8,Nob+2);
        result = [3;tmp(1+(num-Nh))];
    otherwise
        tmp = linspace(0,20,Nob+2);
        result = [8 8];
end
% disp('a');
end 