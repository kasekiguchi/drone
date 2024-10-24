%%
function state = input_state(param,mode)
%一定推力を印加したときの状態遷移
    thrust = param{5};
    torque = param{6};
    step = param{4};
    % U = repmat([thrust; torque], 1, step);
    U = [thrust; torque];

    A = param{1};
    B = param{2};
    C = param{3};

    % X = zeros(12,1);
    % Z = quaternions_all(X);

    % Z = quaternions_all(param{7}); % ある区間の始めの状態
    if mode == 1
        Z = obs1(param{7});
    elseif mode == 2
        Z = obs2(param{7});
    end

    try
        for i = 1:step
            Z(:,i+1) = A * Z(:,i) + B * U(:,i);
        end
        state = C * Z; 
    catch
        open('quaternions_all.m');
        error('観測量の次元が一致しません');
    end
end

function z1 = obs1(x)
P1 = x(1,1);
P2 = x(2,1);
P3 = x(3,1);
Q1 = x(4,1); % roll
Q2 = x(5,1); % pitch
Q3 = x(6,1); % yaw
V1 = x(7,1);
V2 = x(8,1);
V3 = x(9,1);
W1 = x(10,1);
W2 = x(11,1);
W3 = x(12,1);
R13 = ( 2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)) + 2.*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)));
R23 = (-2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)) - 2.*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)));
R33 = (cos(Q2).*cos(Q1));
common_z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33;
            1];
isobe_z = [W1*W2;
            W2*W3;
            W3*W1;
            W2*cos(Q1);
            W3*sin(Q1);
            W1*cos(Q2)/cos(Q1);
            W2*sin(Q1)/cos(Q2);
            W3*cos(Q1)/cos(Q2);
            W2*sin(Q1)*sin(Q2)/cos(Q1);
            W3*cos(Q1)*sin(Q2)/cos(Q1)
            ];
z1 = [common_z; isobe_z];
end

function z2 = obs2(x)
Q1 = x(1,1); % roll
Q2 = x(2,1); % pitch
Q3 = x(3,1); % yaw
V1 = x(4,1);
V2 = x(5,1);
V3 = x(6,1);
W1 = x(7,1);
W2 = x(8,1);
W3 = x(9,1);
R13 = ( 2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)) + 2.*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)));
R23 = (-2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)) - 2.*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)));
R33 = (cos(Q2).*cos(Q1));
common_except_pos_z = [Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33;
            1]; % 位置を除いたcommon_z
isobe_z = [W1*W2;
            W2*W3;
            W3*W1;
            W2*cos(Q1);
            W3*sin(Q1);
            W1*cos(Q2)/cos(Q1);
            W2*sin(Q1)/cos(Q2);
            W3*cos(Q1)/cos(Q2);
            W2*sin(Q1)*sin(Q2)/cos(Q1);
            W3*cos(Q1)*sin(Q2)/cos(Q1)
            ];
z2 = [common_except_pos_z; isobe_z];
end