function result = cpu2gpu(data)
    result.cost = gpuArray(data.cost);
    result.bestcost = gpuArray(data.bestcost);
    result.idx = gpuArray(data.idx);
    result.sigma = gpuArray(data.sigma);
    result.u = gpuArray(data.u);
    result.data = gpuArray(data.data);
    % result.P = gpuArray(data.P);
    % result.style = gpuArray(data.style);
end