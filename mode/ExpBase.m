if isscalar(agent)
    N=1;
    firstId = 1;
end
for i = firstId:N
    takeoff_ref(i) = TAKEOFF_REFERENCE(agent(i),[]);
    landing_ref(i) = LANDING_REFERENCE(agent(i),dt,0.1);
end