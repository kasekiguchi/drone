function eval_read(filename)
% file�̒��g����s�����s���邽�߂̊֐�
% test.m �̒��g���ȉ��Ƃ����
% k = 1;
% for i = 1:5; k=k*i; end
% k
% eval_read(filename)  =>  120
% for ���Ȃǂ͂P�s�ɏ����K�v������D
fileID = fopen(filename);
% C = textscan(fileID,'%s %s %f32 %d8 %u %f %f %s %f');
test=textscan(fileID,"%s",'Delimiter',{'\n'});
fclose(fileID);
for i = 1:length(test{1})
    evalin('caller',test{1}{i});
end
end