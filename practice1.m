clear
clc

%dos1,2,3,4のqiがqihatに変更
%ro追加 omegahat^2(oh02)を変更
syms ddx0 [3 1] real ; syms dol0 [3 1] real;
syms dos1 [3 1] real; syms dos2 [3 1] real; syms dos3 [3 1] real; syms dos4 [3 1] real;
syms dol1 [3 1] real; syms dol2 [3 1] real; syms dol3 [3 1] real; syms dol4 [3 1] real;
syms A [3,3] real; syms B [3,3] real; syms C [3,3] real
syms P1 [3,1] real; syms P2 [3,1] real
syms J0 [3,3] real; syms J1 [3,3] real; syms J2 [3,3] real; syms J3 [3,3] real; syms J4 [3,3] real; 
syms l1 real; syms l2 real; syms l3 real; syms l4 real; %スカラー
syms q1 [3,1] real; syms q2 [3,1] real; syms q3 [3,1] real; syms q4 [3,1] real

%syms q1hat [3,3] real; syms q2hat [3,3] real; syms q3hat [3,3] real; syms q4hat [3,3] real; 
syms ol1 [3,1] real;syms ol2 [3,1] real;syms ol3 [3,1] real;syms ol4 [3,1] real;
syms u1p [3,1] real; syms u2p [3,1] real; syms u3p [3,1] real; syms u4p [3,1] real; 
syms u1v [3,1] real; syms u2v [3,1] real; syms u3v [3,1] real; syms u4v [3,1] real; 
%yms ro1hat [3,3] real; syms ro2hat [3,3] real; syms ro3hat [3,3] real; syms ro4hat [3,3] real;
syms R0 [3,3] real; syms ro1 [3,1] real; syms ro2 [3,1] real; syms ro3 [3,1] real; syms ro4 [3,1] real;
syms ge3 [3,1] real; syms oh02 [3,3] real
syms m0 real;syms m1 real;syms m2 real;syms m3 real;syms m4 real
syms M1 real;syms M2 real;syms M3 real;syms M4 real
q1hat = [0, -q1(3,1), q1(2,1);
        q1(3,1), 0, -q1(1,1);
        -q1(2,1), q1(1,1), 0];
q2hat = [0, -q2(3,1), q2(2,1);
        q2(3,1), 0, -q2(1,1);
        -q2(2,1), q2(1,1), 0];
q3hat = [0, -q3(3,1), q3(2,1);
        q3(3,1), 0, -q3(1,1);
        -q3(2,1), q3(1,1), 0];
q4hat = [0, -q4(3,1), q4(2,1);
        q4(3,1), 0, -q4(1,1);
        -q4(2,1), q4(1,1), 0];

ro1hat = [0, -ro1(3,1), ro1(2,1);
        ro1(3,1), 0, -ro1(1,1);
        -ro1(2,1), ro1(1,1), 0];
ro2hat = [0, -ro2(3,1), ro2(2,1);
        ro2(3,1), 0, -ro2(1,1);
        -ro2(2,1), ro2(1,1), 0];
ro3hat = [0, -ro3(3,1), ro3(2,1);
        ro3(3,1), 0, -ro3(1,1);
        -ro3(2,1), ro3(1,1), 0];
ro4hat = [0, -ro4(3,1), ro4(2,1);
        ro4(3,1), 0, -ro4(1,1);
        -ro4(2,1), ro4(1,1), 0];

mq = m0*eye(3) + m1*(q1*q1') + m2*(q2*q2') + m3*(q3*q3') + m4*(q4*q4');


%%
enq1 = ddx0 == A*dol0 + P1;
enq2 = B*dol0 == -C*ddx0 + P2;

ddx0 = A*dol0 + P1;
dol0 = simplifyFraction (B\(-C*ddx0 + P2));
ddx0_2 = simplifyFraction (A*dol0 + P1);
dos1 = q1hat*(ddx0_2-ge3-R0*ro1hat*dol0+R0*oh02*ro1)/l1 - q1hat*u1p/(m1*l1);
dos2 = q2hat*(ddx0_2-ge3-R0*ro2hat*dol0+R0*oh02*ro2)/l2 - q2hat*u2p/(m2*l2);
dos3 = q3hat*(ddx0_2-ge3-R0*ro3hat*dol0+R0*oh02*ro3)/l3 - q3hat*u3p/(m3*l3);
dos4 = q4hat*(ddx0_2-ge3-R0*ro4hat*dol0+R0*oh02*ro4)/l4 - q3hat*u4p/(m4*l4);


AA = mq\(m1*(q1*q1')*R0*ro1hat +m2*(q2*q2')*R0*ro2hat +m3*(q3*q3')*R0*ro3hat +m4*(q4*q4')*R0*ro4hat);
BB = J0 - m1*ro1hat*R0'*(q1*q1')*R0*ro1hat - m2*ro2hat*R0'*(q2*q2')*R0*ro2hat - m3*ro3hat*R0'*(q3*q3')*R0*ro3hat - m4*ro4hat*R0'*q4*q4'*R0*ro4hat;
CC = m1*ro1hat*R0'*(q1*q1') +m2*ro2hat*R0'*(q2*q2') +m3*ro3hat*R0'*(q3*q3') +m4*ro4hat*R0'*(q4*q4');
% P1_new = mq\(1);
% P2_new=0;
% S = subs(dos1,[A,B,C],[AA,BB,CC]);
ddx0_new = subs(ddx0_2,[A,B,C],[AA,BB,CC]);
dol0_new = subs(dol0,[A,B,C],[AA,BB,CC]);
dos1_new = subs(dos1,[A,B,C],[AA,BB,CC]);
dos2_new = subs(dos2,[A,B,C],[AA,BB,CC]);
dos3_new = subs(dos3,[A,B,C],[AA,BB,CC]);

dos4_new = subs(dos4,[A,B,C],[AA,BB,CC]);
dol1 = J1\(M1-cross(ol1,J1*ol1));
dol2 = J2\(M2-cross(ol2,J2*ol2));
dol3 = J3\(M3-cross(ol3,J3*ol3));
dol4 = J4\(M4-cross(ol4,J4*ol4));
