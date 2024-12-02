if isscalar(agent)
    N=1;
    firstId = 1;
end
if firstId == 2
    takeoff_ref{1} = @nothing_do;
    landing_ref{1} = @nothing_do;
end
for i = firstId:N
    takeoff_ref{i} = TAKEOFF_REFERENCE(agent(i),[]);
    landing_ref{i} = LANDING_REFERENCE(agent(i),dt,0.1);
end