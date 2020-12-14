function updateData(obj,RawData, EstimatedData, ControledData)
	obj.Data.T(:,obj.Count) = RawData.T;
	obj.Data.X(:,obj.Count) = EstimatedData.X;
	obj.Data.Y(:,obj.Count) = EstimatedData.Y;
	obj.Data.Z(:,obj.Count) = EstimatedData.Z;
	obj.Data.qx(:,obj.Count)= EstimatedData.qx;
	obj.Data.qy(:,obj.Count)= EstimatedData.qy;
	obj.Data.qz(:,obj.Count)= EstimatedData.qz;
	obj.Data.qw(:,obj.Count)= EstimatedData.qw;
	obj.Data.roll(:,obj.Count) = EstimatedData.roll;
	obj.Data.pitch(:,obj.Count)= EstimatedData.pitch;
	obj.Data.yaw(:,obj.Count)  = EstimatedData.yaw;
	obj.Data.ComputationTime(:,obj.Count) = ControledData.ComputationTime;
	obj.Data.V(:,obj.Count)     = ControledData.V;
	obj.Data.Omega(1,obj.Count) = (obj.Data.V(1,obj.Count) + obj.Width*obj.Data.V(2,obj.Count))/obj.Wheel;
	obj.Data.Omega(2,obj.Count) = (obj.Data.V(1,obj.Count) - obj.Width*obj.Data.V(2,obj.Count))/obj.Wheel;
    
    if isfield(EstimatedData,'local') == 1 && isfield(ControledData,'local') == 1
        DataCell = [{obj.Data.T(:,obj.Count)}; RawData; struct2cell(EstimatedData.local); struct2cell(ControledData.local)];
        DataName = ["TimeLocal"; "RawData"; fieldnames(EstimatedData.local); fieldnames(ControledData.local)];
        obj.Data.local(:,obj.Count) = cell2struct(DataCell, DataName, 1);
    elseif isfield(EstimatedData,'local') == 0 && isfield(ControledData,'local') == 1
        DataCell = [{obj.Data.T(:,obj.Count)}; RawData; struct2cell(ControledData.local)];
        DataName = ["TimeLocal"; "RawData";  fieldnames(ControledData.local)];
        obj.Data.local(:,obj.Count) = cell2struct(DataCell, DataName, 1);
    elseif isfield(EstimatedData,'local') == 1 && isfield(ControledData,'local') == 0
        DataCell = [{obj.Data.T(:,obj.Count)}; RawData; struct2cell(EstimatedData.local)];
        DataName = ["TimeLocal"; "RawData"; fieldnames(EstimatedData.local)];
        obj.Data.local(:,obj.Count) = cell2struct(DataCell, DataName, 1);
    else
        DataCell = [{obj.Data.T(:,obj.Count)}; RawData];
        DataName = ["TimeLocal"; "RawData"];
        obj.Data.local(:,obj.Count) = cell2struct(DataCell, DataName, 1);
    end
    
	DataSet.V(1,1) = ControledData.V(1,1);
	DataSet.V(2,1) = ControledData.V(2,1);
	sendTopic(obj, DataSet);
end