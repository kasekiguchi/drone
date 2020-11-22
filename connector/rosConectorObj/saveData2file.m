function saveData2file(obj, Datadir)
	disp('End processing in progress...');
	endExperiment(obj);
    
	disp('Export data.');
    FileNameState = strcat(Datadir, '/state.mat');
    FileNameUser  = strcat(Datadir, '/userLocal.mat');

    if isfield(obj.Data,'local') == 1
		obj.Data.local(1) = [];
        Names = fieldnames(obj.Data.local);
        for L = 1:length(Names)  
           USER.(Names{L}) = eval([ 'transpose([obj.Data.local.', Names{L} ,']);' ]);
        end
        DATA = rmfield(structfun(@(X) transpose(X), obj.Data, 'UniformOutput', false), 'local');
        save(FileNameUser,  'USER', '-v7.3');
        save(FileNameState, 'DATA', '-v7.3');
    else
        DATA = structfun(@(X) transpose(X), obj.Data, 'UniformOutput', false);
        save(FileNameState, 'DATA', '-v7.3');
    end
end