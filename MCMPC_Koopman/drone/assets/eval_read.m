function eval_read(filename)
% fileの中身を一行ずつ実行するための関数
% test.m の中身が以下とすると
% k = 1;
% for i = 1:5; k=k*i; end
% k
% eval_read(filename)  =>  120
% for 文などは１行に書く必要がある．
fileID = fopen(filename);
% C = textscan(fileID,'%s %s %f32 %d8 %u %f %f %s %f');
test=textscan(fileID,"%s",'Delimiter',{'\n'});
fclose(fileID);
for i = 1:length(test{1})
    evalin('caller',test{1}{i});
end
end