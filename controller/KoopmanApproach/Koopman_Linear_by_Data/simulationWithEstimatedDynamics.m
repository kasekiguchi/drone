function simResult = simulationWithEstimatedDynamics(flg,F,est, ReferenceData)
%% SIMULATIONWITHESTIMATEDDYNAMICS Simulation by Estimated model
% flg
%   .bilinear : 1 :on
%
disp('Simulation Start')

simResult.reference = ImportFromExpData(ReferenceData);

simResult.Z(:,1) = F(simResult.reference.X(:,1));
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U(:,1:end);
simResult.T = simResult.reference.T(1:end);

if flg.bilinear == 1     
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.ABE'*[simResult.Z(:,i);simResult.U(:,i);reshape(kron(simResult.Z(:,i),simResult.U(:,i)),[],1)];
    end
else
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i);
    end
end
simResult.Xhat = est.C * simResult.Z;

%% Save Estimation Result
if size(simResult.Xhat(:,1),1)==13
    simResult.state.p = simResult.Xhat(1:3,:);
    simResult.state.q = simResult.Xhat(4:7,:);
    simResult.state.v = simResult.Xhat(8:10,:);
    simResult.state.w = simResult.Xhat(11:13,:);
else
    simResult.state.p = simResult.Xhat(1:3,:);
    simResult.state.q = simResult.Xhat(4:6,:);
    simResult.state.v = simResult.Xhat(7:9,:);
    simResult.state.w = simResult.Xhat(10:12,:);
end
simResult.state.N = simResult.reference.N-1;

disp('Simulation Finished')
end

