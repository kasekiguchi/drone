% csolve  Solves a custom quadratic program very rapidly.
%
% [vars, status] = csolve(params, settings)
%
% solves the convex optimization problem
%
%   minimize(quad_form(x_0, Q) + quad_form(u_th_0, R1) + quad_form(u_tr_0, R2) + quad_form(x_1, Q) + quad_form(u_th_1, R1) + quad_form(u_tr_1, R2) + quad_form(x_2, Q) + quad_form(u_th_2, R1) + quad_form(u_tr_2, R2) + quad_form(x_3, Q) + quad_form(u_th_3, R1) + quad_form(u_tr_3, R2) + quad_form(x_4, Q) + quad_form(u_th_4, R1) + quad_form(u_tr_4, R2) + quad_form(x_5, Q) + quad_form(u_th_5, R1) + quad_form(u_tr_5, R2) + quad_form(x_6, Q) + quad_form(u_th_6, R1) + quad_form(u_tr_6, R2) + quad_form(x_7, Q) + quad_form(u_th_7, R1) + quad_form(u_tr_7, R2) + quad_form(x_8, Q) + quad_form(u_th_8, R1) + quad_form(u_tr_8, R2) + quad_form(x_9, Q) + quad_form(u_th_9, R1) + quad_form(u_tr_9, R2) + quad_form(x_10, Q) + quad_form(u_th_10, R1) + quad_form(u_tr_10, R2))
%   subject to
%     x_1 == A*x_0 + B1*u_th_0 + B2*u_tr_0
%     x_2 == A*x_1 + B1*u_th_1 + B2*u_tr_1
%     x_3 == A*x_2 + B1*u_th_2 + B2*u_tr_2
%     x_4 == A*x_3 + B1*u_th_3 + B2*u_tr_3
%     x_5 == A*x_4 + B1*u_th_4 + B2*u_tr_4
%     x_6 == A*x_5 + B1*u_th_5 + B2*u_tr_5
%     x_7 == A*x_6 + B1*u_th_6 + B2*u_tr_6
%     x_8 == A*x_7 + B1*u_th_7 + B2*u_tr_7
%     x_9 == A*x_8 + B1*u_th_8 + B2*u_tr_8
%     x_10 == A*x_9 + B1*u_th_9 + B2*u_tr_9
%     x_11 == A*x_10 + B1*u_th_10 + B2*u_tr_10
%     0 <= u_th_0
%     0 <= u_th_1
%     0 <= u_th_2
%     0 <= u_th_3
%     0 <= u_th_4
%     0 <= u_th_5
%     0 <= u_th_6
%     0 <= u_th_7
%     0 <= u_th_8
%     0 <= u_th_9
%     0 <= u_th_10
%     u_th_0 <= 10
%     u_th_1 <= 10
%     u_th_2 <= 10
%     u_th_3 <= 10
%     u_th_4 <= 10
%     u_th_5 <= 10
%     u_th_6 <= 10
%     u_th_7 <= 10
%     u_th_8 <= 10
%     u_th_9 <= 10
%     u_th_10 <= 10
%     -1 <= u_tr_0
%     -1 <= u_tr_1
%     -1 <= u_tr_2
%     -1 <= u_tr_3
%     -1 <= u_tr_4
%     -1 <= u_tr_5
%     -1 <= u_tr_6
%     -1 <= u_tr_7
%     -1 <= u_tr_8
%     -1 <= u_tr_9
%     -1 <= u_tr_10
%     u_tr_0 <= 1
%     u_tr_1 <= 1
%     u_tr_2 <= 1
%     u_tr_3 <= 1
%     u_tr_4 <= 1
%     u_tr_5 <= 1
%     u_tr_6 <= 1
%     u_tr_7 <= 1
%     u_tr_8 <= 1
%     u_tr_9 <= 1
%     u_tr_10 <= 1
%
% with variables
%   u_th_0   1 x 1
%   u_th_1   1 x 1
%   u_th_2   1 x 1
%   u_th_3   1 x 1
%   u_th_4   1 x 1
%   u_th_5   1 x 1
%   u_th_6   1 x 1
%   u_th_7   1 x 1
%   u_th_8   1 x 1
%   u_th_9   1 x 1
%  u_th_10   1 x 1
%   u_tr_0   3 x 1
%   u_tr_1   3 x 1
%   u_tr_2   3 x 1
%   u_tr_3   3 x 1
%   u_tr_4   3 x 1
%   u_tr_5   3 x 1
%   u_tr_6   3 x 1
%   u_tr_7   3 x 1
%   u_tr_8   3 x 1
%   u_tr_9   3 x 1
%  u_tr_10   3 x 1
%      x_1  12 x 1
%      x_2  12 x 1
%      x_3  12 x 1
%      x_4  12 x 1
%      x_5  12 x 1
%      x_6  12 x 1
%      x_7  12 x 1
%      x_8  12 x 1
%      x_9  12 x 1
%     x_10  12 x 1
%     x_11  12 x 1
%
% and parameters
%        A  12 x 12
%       B1  12 x 1
%       B2  12 x 3
%        Q  12 x 12   PSD
%       R1   1 x 1    PSD
%       R2   3 x 3    PSD
%      x_0  12 x 1
%
% Note:
%   - Check status.converged, which will be 1 if optimization succeeded.
%   - You don't have to specify settings if you don't want to.
%   - To hide output, use settings.verbose = 0.
%   - To change iterations, use settings.max_iters = 20.
%   - You may wish to compare with cvxsolve to check the solver is correct.
%
% Specify params.A, ..., params.x_0, then run
%   [vars, status] = csolve(params, settings)
% Produced by CVXGEN, 2024-07-23 04:29:25 -0400.
% CVXGEN is Copyright (C) 2006-2017 Jacob Mattingley, jem@cvxgen.com.
% The code in this file is Copyright (C) 2006-2017 Jacob Mattingley.
% CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial
% applications without prior written permission from Jacob Mattingley.

% Filename: csolve.m.
% Description: Help file for the Matlab solver interface.
