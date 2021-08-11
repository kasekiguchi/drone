for j =1:10
    a{j} = [j,j];
    
end
b = [2.2,2.2];
bamp1=0;
parfor i = 1:length(a)
    % Genelate of wall force
    bamp1 = bamp1-(a{i}-b)/norm(a{i}-b,2);
    
end
disp(bamp1);
