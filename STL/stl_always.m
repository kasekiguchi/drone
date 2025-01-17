%%%% data: data interval you want to deal with time: whole time 
% varargin:varargin 1 :the min time(or called start time) 2: the max time
% (or called endtime) 3: the condition you want to set 
% for example  the prosess in [0s,10s]  and you want the speed always
% smaller than 3m/s in the time period of [3s,5s]
% set  data=[you get from the estimator or the predict state]
% time=[0,10],varargin={3,5,3} result return the value of bool(true=1,false=0)


function result = stl_always(data,time,varargin)

if varargin(1)<time(1) || varargin{2}>time(length(time))
    error('the time is out of the limit');
else
    startIdx = find(time >= varargin(1), 1);
    endIdx = find(time <= varargin(2), 1, 'last');
    result = all(data(startIdx:endIdx) > varargin(3));
end

end

%%%%%% the situation is always staisfied this 