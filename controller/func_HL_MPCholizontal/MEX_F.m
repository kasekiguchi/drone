%フォロワー機のfminconのMATLABCoderを用いた高速化のためのスクリプト

MPCparam.H = 10;
MPCparam.dt = 0.2;
MPCparam.N = 6;
MPCparam.P = [0.235500000000000,0.0750000000000000,0.00223756800000000,0.00298523600000000,0.00480374000000000,9.81000000000000,0.0301068588469185,0.0301068588469185,0.0301068588469185,0.0301068588469185,8.04800000000000e-06,8.04800000000000e-06,8.04800000000000e-06,8.04800000000000e-06];
MPCparam.F1 = [2.421279283357814,2.329982382662451];
MPCparam.F2 = [6.045617959609237,10.382246611924892,8.612526937296090,3.978517829591304];
MPCparam.F3 = [6.045617959609237,10.382246611924892,8.612526937296090,3.978517829591304];
MPCparam.F4 = [6.361854038909374,3.623318913088196];
MPCparam.input_size = 2;
MPCparam.state_size = 8;
MPCparam.total_size = 10;
MPCparam.Num = 11;
MPCparam.V = [10,0;0,10];
MPCparam.Qm = 10;
MPCparam.Qmf = 10;
MPCparam.Qt = 40;
MPCparam.Qtf = 50;
MPCparam.R = [1,0;0,1];
MPCparam.W_s = 40;
MPCparam.W_r = 20;
MPCparam.Slew = 0.100000000000000;
MPCparam.D_lim = [3,0.100000000000000];
MPCparam.r_limit = [0.300000000000000,0.600000000000000];
MPCparam.A = [1,0.200000000000000,0.0200000000000000,0.00133333333333333,0,0,0,0;0,1,0.200000000000000,0.0200000000000000,0,0,0,0;0,0,1,0.200000000000000,0,0,0,0;0,0,0,1,0,0,0,0;0,0,0,0,1,0.200000000000000,0.0200000000000000,0.00133333333333333;0,0,0,0,0,1,0.200000000000000,0.0200000000000000;0,0,0,0,0,0,1,0.200000000000000;0,0,0,0,0,0,0,1];
MPCparam.B = [6.66666666666667e-05,0;0.00133333333333333,0;0.0200000000000000,0;0.200000000000000,0;0,6.66666666666667e-05;0,0.00133333333333333;0,0.0200000000000000;0,0.200000000000000];
MPCparam.P_chips = [0,0.433333333333333,0.866666666666667,1.30000000000000,1.73333333333333,2.16666666666667,2.60000000000000,3.03333333333333,3.46666666666667,3.90000000000000,3.91111111111111,3.92222222222222,3.93333333333333,3.94444444444444,3.95555555555556,3.96666666666667,3.97777777777778,3.98888888888889,4;0,0,0,0,0,0,0,0,0,0,0.277777777777778,0.555555555555556,0.833333333333333,1.11111111111111,1.38888888888889,1.66666666666667,1.94444444444444,2.22222222222222,2.50000000000000];
MPCparam.wall_width_y = [-0.600000000000000,0.600000000000000;-0.600000000000000,3];
MPCparam.wall_width_x = [0,4.500000000000000;3.400000000000000,4.600000000000000];
MPCparam.sectionpoint = [0,0;4,0;4,2.500000000000000];
MPCparam.sectionnumber = 1;
MPCparam.Section_change = [1,1,2,3];
MPCparam.Sectionconect = zeros(11,2);
MPCparam.wall_width_xx = zeros(11,2);
MPCparam.wall_width_yy = zeros(11,2);
MPCparam.Cdis = zeros(1,11);
MPCparam.Line_Y = zeros(1,11);
MPCparam.S_front = [1,1,2,3];
MPCparam.front = [3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000;0,0,0,0,0,0,0,0,0,0,0];
MPCparam.behind = [2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000,2.10000000000000;0,0,0,0,0,0,0,0,0,0,0];
MPCparam.X0 = [2.800000000000000;0;0;0;0;0;0;0];
MPCparam.Xd = [0;0;0.500000000000000;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
MPCparam.frontSN = 1;
MPCparam.behindSN = 1;
MPCparam.FLD = [3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000,3.50000000000000];
MPCparam.BLD = 2.100000000000000;
MPCparam.agent = 0;


MPCprevious_variables = [2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000,2.80000000000000;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0,0];


MPCslack = zeros(2,11);


funcresult = F_HL_MPCfunc(MPCparam,MPCprevious_variables,MPCslack);

