function out1 = CSLC_3_Uvec(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14)
%CSLC_3_Uvec
%    OUT1 = CSLC_3_Uvec(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/07/19 18:47:19

Ri1_1_1 = in7(1);
Ri1_1_2 = in7(10);
Ri1_1_3 = in7(19);
Ri1_2_1 = in7(4);
Ri1_2_2 = in7(13);
Ri1_2_3 = in7(22);
Ri1_3_1 = in7(7);
Ri1_3_2 = in7(16);
Ri1_3_3 = in7(25);
Ri2_1_1 = in7(2);
Ri2_1_2 = in7(11);
Ri2_1_3 = in7(20);
Ri2_2_1 = in7(5);
Ri2_2_2 = in7(14);
Ri2_2_3 = in7(23);
Ri2_3_1 = in7(8);
Ri2_3_2 = in7(17);
Ri2_3_3 = in7(26);
Ri3_1_1 = in7(3);
Ri3_1_2 = in7(12);
Ri3_1_3 = in7(21);
Ri3_2_1 = in7(6);
Ri3_2_2 = in7(15);
Ri3_2_3 = in7(24);
Ri3_3_1 = in7(9);
Ri3_3_2 = in7(18);
Ri3_3_3 = in7(27);
b11_1 = in10(1);
b11_2 = in10(4);
b11_3 = in10(7);
b12_1 = in10(2);
b12_2 = in10(5);
b12_3 = in10(8);
b13_1 = in10(3);
b13_2 = in10(6);
b13_3 = in10(9);
b21_1 = in11(1);
b21_2 = in11(4);
b21_3 = in11(7);
b22_1 = in11(2);
b22_2 = in11(5);
b22_3 = in11(8);
b23_1 = in11(3);
b23_2 = in11(6);
b23_3 = in11(9);
b31_1 = in12(1);
b31_2 = in12(4);
b31_3 = in12(7);
b32_1 = in12(2);
b32_2 = in12(5);
b32_3 = in12(8);
b33_1 = in12(3);
b33_2 = in12(6);
b33_3 = in12(9);
epsilon = in4(:,13);
ji1_1 = in3(:,21);
ji1_2 = in3(:,24);
ji1_3 = in3(:,27);
ji2_1 = in3(:,22);
ji2_2 = in3(:,25);
ji2_3 = in3(:,28);
ji3_1 = in3(:,23);
ji3_2 = in3(:,26);
ji3_3 = in3(:,29);
koi = in4(:,12);
kri = in4(:,11);
oi1_1 = in1(44,:);
oi1_2 = in1(47,:);
oi1_3 = in1(50,:);
oi2_1 = in1(45,:);
oi2_2 = in1(48,:);
oi2_3 = in1(51,:);
oi3_1 = in1(46,:);
oi3_2 = in1(49,:);
oi3_3 = in1(52,:);
ui1_1 = in5(1);
ui1_2 = in5(4);
ui1_3 = in5(7);
ui2_1 = in5(2);
ui2_2 = in5(5);
ui2_3 = in5(8);
ui3_1 = in5(3);
ui3_2 = in5(6);
ui3_3 = in5(9);
t2 = 1.0./epsilon;
t3 = t2.^2;
mt1 = [Ri1_3_1.*ui1_1+Ri2_3_1.*ui2_1+Ri3_3_1.*ui3_1;kri.*t3.*((Ri1_3_1.*b21_1)./2.0-(Ri1_2_1.*b31_1)./2.0+(Ri2_3_1.*b22_1)./2.0-(Ri2_2_1.*b32_1)./2.0+(Ri3_3_1.*b23_1)./2.0-(Ri3_2_1.*b33_1)./2.0)-ji2_1.*oi2_1.*oi3_1+ji3_1.*oi2_1.*oi3_1-koi.*oi1_1.*t2;-kri.*t3.*((Ri1_3_1.*b11_1)./2.0+(Ri2_3_1.*b12_1)./2.0-(Ri1_1_1.*b31_1)./2.0+(Ri3_3_1.*b13_1)./2.0-(Ri2_1_1.*b32_1)./2.0-(Ri3_1_1.*b33_1)./2.0)+ji1_1.*oi1_1.*oi3_1-ji3_1.*oi1_1.*oi3_1-koi.*oi2_1.*t2;kri.*t3.*((Ri1_2_1.*b11_1)./2.0-(Ri1_1_1.*b21_1)./2.0+(Ri2_2_1.*b12_1)./2.0-(Ri2_1_1.*b22_1)./2.0+(Ri3_2_1.*b13_1)./2.0-(Ri3_1_1.*b23_1)./2.0)-ji1_1.*oi1_1.*oi2_1+ji2_1.*oi1_1.*oi2_1-koi.*oi3_1.*t2];
mt2 = [Ri1_3_2.*ui1_2+Ri2_3_2.*ui2_2+Ri3_3_2.*ui3_2;kri.*t3.*((Ri1_3_2.*b21_2)./2.0-(Ri1_2_2.*b31_2)./2.0+(Ri2_3_2.*b22_2)./2.0-(Ri2_2_2.*b32_2)./2.0+(Ri3_3_2.*b23_2)./2.0-(Ri3_2_2.*b33_2)./2.0)-ji2_2.*oi2_2.*oi3_2+ji3_2.*oi2_2.*oi3_2-koi.*oi1_2.*t2;-kri.*t3.*((Ri1_3_2.*b11_2)./2.0+(Ri2_3_2.*b12_2)./2.0-(Ri1_1_2.*b31_2)./2.0+(Ri3_3_2.*b13_2)./2.0-(Ri2_1_2.*b32_2)./2.0-(Ri3_1_2.*b33_2)./2.0)+ji1_2.*oi1_2.*oi3_2-ji3_2.*oi1_2.*oi3_2-koi.*oi2_2.*t2;kri.*t3.*((Ri1_2_2.*b11_2)./2.0-(Ri1_1_2.*b21_2)./2.0+(Ri2_2_2.*b12_2)./2.0-(Ri2_1_2.*b22_2)./2.0+(Ri3_2_2.*b13_2)./2.0-(Ri3_1_2.*b23_2)./2.0)-ji1_2.*oi1_2.*oi2_2+ji2_2.*oi1_2.*oi2_2-koi.*oi3_2.*t2];
mt3 = [Ri1_3_3.*ui1_3+Ri2_3_3.*ui2_3+Ri3_3_3.*ui3_3;kri.*t3.*((Ri1_3_3.*b21_3)./2.0-(Ri1_2_3.*b31_3)./2.0+(Ri2_3_3.*b22_3)./2.0-(Ri2_2_3.*b32_3)./2.0+(Ri3_3_3.*b23_3)./2.0-(Ri3_2_3.*b33_3)./2.0)-ji2_3.*oi2_3.*oi3_3+ji3_3.*oi2_3.*oi3_3-koi.*oi1_3.*t2;-kri.*t3.*((Ri1_3_3.*b11_3)./2.0+(Ri2_3_3.*b12_3)./2.0-(Ri1_1_3.*b31_3)./2.0+(Ri3_3_3.*b13_3)./2.0-(Ri2_1_3.*b32_3)./2.0-(Ri3_1_3.*b33_3)./2.0)+ji1_3.*oi1_3.*oi3_3-ji3_3.*oi1_3.*oi3_3-koi.*oi2_3.*t2;kri.*t3.*((Ri1_2_3.*b11_3)./2.0-(Ri1_1_3.*b21_3)./2.0+(Ri2_2_3.*b12_3)./2.0-(Ri2_1_3.*b22_3)./2.0+(Ri3_2_3.*b13_3)./2.0-(Ri3_1_3.*b23_3)./2.0)-ji1_3.*oi1_3.*oi2_3+ji2_3.*oi1_3.*oi2_3-koi.*oi3_3.*t2];
out1 = [mt1;mt2;mt3];
end
