function [V1,Vi]= gen_boundary_p(Infp,ccp,ccpidc,V0num,region)
% �̈�Ɣ������@ccp- Infp �̌�_ V1 �ƒǉ������_��ccp �_�̑Ή���Vi�ɂ܂ƂߕԂ��֐�
% Infp : Inf�_
% ccp : �Ή��_
% ccpidc : ccp��V0�̒��ł̃C���f�b�N�X�Z���z��
% region : ��`�̈�̒��_���W
% �������(x,y)���c�ɕ��ׂ�����
% V1 �FV�ɒǉ�����_�̍��W
% Vi �F[ccp�̃C���f�b�N�X, V1��V���ł̃C���f�b�N�X]

%%cv ��S�Ɋ܂܂�Ă��Ȃ��Ă��l����K�v������Inf�_�͂���D
%%in = inpolygon(cv(:,1),cv(:,2),S(:,1),S(:,2)); % cv�̂���S���̃C���f�b�N�X
tmpnum = [1:V0num]';
V1=[];
Vi=[];
for i = 1:size(ccp,1)
tmpid=tmpnum(ccpidc{i});
for j = 1:size(tmpid,1)
    vnumtmp=size(V1,1);
    vtmp=[intersection_ray_segment([ccp(i,:);Infp(i,:);region([1,2],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([2,3],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([3,4],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([4,1],:)])];
    if ~isempty(vtmp)
        V1=[V1;vtmp];
        Vi=[Vi;tmpid(j)*[1 0]+[0 1].*(V0num+vnumtmp+[1:size(vtmp,1)]')];
    end
end
end
end

function v = intersection_ray_segment(X)
% X = [A;B;C;D]
%A = [a1 b1]�F�������̋N�_
%B = [a2 b2]�F�������̕������K�肷��_
%C = [x1 y1]�F�Ώې����̒[�_�P
%D = [x2 y2]�F�Ώې����̒[�_�Q
a1=X(1,1);
b1=X(1,2);
a2=X(2,1);
b2=X(2,2);
x1=X(3,1);
y1=X(3,2);
x2=X(4,1);
y2=X(4,2);
A=[a1 b1];
v = [a2 b2]-A;
if (a1*y1 - b1*x1 - a1*y2 - a2*y1 + b1*x2 + b2*x1 + a2*y2 - b2*x2)==0 %  ��_�����݂��邽�߂ɂ͂��̒l�����
    v=[];
else
    t = (a1*y1 - b1*x1 - a1*y2 + b1*x2 + x1*y2 - x2*y1)/(a1*y1 - b1*x1 - a1*y2 - a2*y1 + b1*x2 + b2*x1 + a2*y2 - b2*x2);
    if t <0
        v=[];
    else
        B = A+t*v;
        C=[x1 y1];
        D=[x2 y2];
        BC=C-B;
        BD=D-B;
        CD=D-C;
        if BC*CD'<=0 && BD*CD'>0 %�������Ɍ�_��������
            v = B;
        else
            v=[];
        end
    end
end
end