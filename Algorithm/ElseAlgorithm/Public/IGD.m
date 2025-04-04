function Score = IGD(PopObj,PF)
% <metric> <min>
% Inverted generational distance

    Distance = min(pdist2(PF,PopObj),[],2);
    Score    = mean(Distance);
end