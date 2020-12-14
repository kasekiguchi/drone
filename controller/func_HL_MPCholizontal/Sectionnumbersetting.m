function [Section_change] = Sectionnumbersetting(sectionnumber,Limit)
% Section_changeがとる値の制約
    params.S=[sectionnumber-1,sectionnumber,sectionnumber+1,sectionnumber+2];
    if params.S(1)<1
        params.S(1) = 1;
    end
    if params.S(3) > Limit
        params.S(3) = Limit;
    end
    if params.S(4) > Limit
        params.S(4) = Limit;
    end
    Section_change = params.S;
end