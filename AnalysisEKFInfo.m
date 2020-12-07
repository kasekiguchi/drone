%%%%To express EKF information%%%%%%%
[ErEl_Round] = CalcErrorEllipse(obj.result.P);%Error circle calculation
obj.result.ErEl_Round = ErEl_Round;
obj.result.Entropy = Calc_entropy(obj.result.P);
% obj.result.Entropy = Calc_entropy(obj.Analysis.PrevCov) - Calc_entropy(obj.result.P);
% [~,tmpS,~] = svd(obj.result.P);

%             obj.result.SingP = arrayfun(@(x) tmpS(x,x) , 1:size(tmpS,1));
% obj.result.Eig = eig(obj.result.P);
%             sys = ss(A,B,C,zeros(size(C)),obj.dt);
%             obj.result.gram = gram(sys,'o');
%             TmpDifferEntIndex(1) =  find(association_info.index ==1,1);
%             TmpDifferEntIndex(2) =  find(association_info.index ==2,1);
%             [PartialX,PartialY,PartialTheta,PartialV,PartialW] = differ_entropy(state_count,obj.dt,obj.Q,obj.Map_Q,obj.R,obj.Analysis.P,TmpDifferEntIndex,association_info,line_param,measured,tmpvalue);
%             obj.result.PartialX = PartialX;
%             obj.result.PartialY = PartialY;
%             obj.result.PartialTheta = PartialTheta;
%             obj.result.PartialV = PartialV;
%             obj.result.PartialW = PartialW;
%             obj.result.diffy = G * (measured.ranges(association_available_index)' - Y);
%             obj.Analysis.P = obj.result.P;
%             obj.result.
% [modeltoKFKL] = Kallback_Leibra(P_pre(1:5,1:5),pre_Eststate(1:5)',obj.result.P(1:5,1:5),tmpvalue(1:5));
% obj.result.MtoKF_KL = modeltoKFKL;% Kallback_Leibra divergence of model and KF probability
% obj.Analysis.Gram.SaveSys(A);%for observability matrix
% obj.result.Obs = obj.Analysis.Gram.LOM(C,A,tmpvalue);%Local observability matrix
% obj.Analysis.Gram.SaveP(obj.result.P);
% if obj.Analysis.Gram.step >1
%     obj.result.InFo = obj.Analysis.Gram.InFo;
% else
%     obj.result.InFo = 0;
% end
%             [Obs] = obj.Analysis.Gram.TOM;%total observability matrix
%             [obj.result.Gram,obj.result.GramVec] = obj.Analysis.Gram.Grammian(Obs);%Grammian
%             obj.result.Obs = obj.Analysis.Gram.LinearGram(tmpvalue,measured.angles(association_available_index));
%             [obsetvetoKFKL] = Kallback_Leibra(obj.result.P(1:5,1:5),tmpvalue(1:5,1),system_noise(1:5,1:5),pre_Eststate');
%             obj.result.OtoKF_KL = obsetvetoKFKL;% Kallback_Leibra divergence of observation and KF probability
%%%%%%%%%%%%%%%%%%%
%             obj.result.diffy = measured.ranges(association_available_index)' - Y;
