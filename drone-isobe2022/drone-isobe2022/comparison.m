function est = KoopmanLinearByData(flg,F,Data)
% flg : flag struct 
%   .bilinear : 1 :on
%   .fileSave : 1 :on
% F   : Observables
% loading filename : 
% targetpath : save file name

%% Koopman linear
disp('now estimating')
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    est = KL(Data.X,Data.U,Data.Y,F);
end
est.observable = F;
disp('Estimating finish')