if isscalar(agent)
    N=1;
    firstId = 1;
end
if ~exist("firstId","var")
    firstId=1;
end
if firstId == 2
    takeoff_ref{1}.do = @(varargin)[];
    takeoff_ref{1}.result.state = STATE_CLASS(struct('state_list',"xd",'num_list',28));
    takeoff_ref{1}.result.state.xd = zeros(28,1);

    landing_ref{1}.do = @(varargin)[];
    landing_ref{1}.result.state = STATE_CLASS(struct('state_list',"xd",'num_list',28));
    landing_ref{1}.result.state.xd = zeros( 28, 1);
    for i = 2:N
        takeoff_ref{i}  = agent(i).reference;
        landing_ref{i}  = agent(i).reference;
    end
else
    for i = firstId:N
        takeoff_ref{i} = TAKEOFF_REFERENCE(agent(i),[]);
        landing_ref{i} = LANDING_REFERENCE(agent(i),dt,0.1);
    end
end

% if firstId == 2
%     takeoff_ref{1}.do = @(varargin)[];
%     takeoff_ref{1}.result.state = STATE_CLASS(struct('state_list',"xd",'num_list',28));
%     takeoff_ref{1}.result.state.xd = zeros(28,1);
% 
%     landing_ref{1}.do = @(varargin)[];
%     landing_ref{1}.result.state = STATE_CLASS(struct('state_list',"xd",'num_list',28));
%     landing_ref{1}.result.state.xd = zeros( 28, 1);
% end
% for i = firstId:N
%     takeoff_ref{i} = TAKEOFF_REFERENCE(agent(i),[]);
%     landing_ref{i} = LANDING_REFERENCE(agent(i),dt,0.1);
% end