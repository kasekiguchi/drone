function [A, B, C] = AB_transfer(A, B, C, dt, controller_dt)
    try
        ssmodel = ss(A, B, C, zeros(size(C,1), size(B,2)), dt); % サンプリングタイムの変更
        % args = d2d(ssmodel, controller_dt, 'tustin');
        args = d2d(ssmodel, controller_dt, 'zoh');
        A = args.A;
        B = args.B;
        C = args.C;
    catch
        disp('Skip processing. Use the matrix as it is.');
    end
end