function V=void_voronoi(V00,VOID,span)
% �yInput�zV00 : polyshape �Z���CVOID : void ���C span : �Ώۂ̃C���f�b�N�X
% �yOutput�zpolyshape�Z��
% ���_A�CB�CC����Ȃ�Q�ӂɂ��ĊpABC�̔��p��theta�Ƃ����
% sin(theta) = sqrt(1- (e,E(BA))^2/|e|^2)
% e �F e13 = E(BA)+E(BC) : �pABC�̓񓙕��������̃x�N�g��
% E(BA) : �P��BA�x�N�g���CE(BC)�����l
% VOID�̈�k�߂�B�_�̍X�V�_��
% B' = B + (VOID/sin(theta)) e/|e|
% V00�̊epolyshape V�ɑ΂��ā@polybuffer(V,-void) ������Ă���̂Ɠ���
V={V00{span}};
for i = span
    V0 = V00{i}.Vertices;
    V1 = V0;
    for j = 1:size(V0,1)
        if j==1
            p2=V0(1,:);
            p21=V0(end,:)-p2;
            p23=V0(2,:)-p2;
        elseif j == size(V0,1)
            p2=V0(end,:);
            p21=V0(end-1,:)-p2;
            p23=V0(1,:)-p2;
        else
            p2=V0(j,:);
            p21=V0(j-1,:)-p2;
            p23=V0(j+1,:)-p2;
        end
        ep21=p21/norm(p21);
        e13 = ep21+p23/norm(p23);
        V1(j,:)=p2+VOID*e13/sqrt(norm(e13)^2-(e13*ep21')^2);
    end
    V{i}=simplify(polyshape(V1));
end
end