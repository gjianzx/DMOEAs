function Score = SP(PopObj,PF)
    %% Schott's Spacing Metric
    Distance = pdist2(PopObj,PopObj,'euclidean');
    Distance(logical(eye(size(Distance,1)))) = inf;
    D = min(Distance);
    NPop = size(PopObj,1);
    Score = sqrt(sum((D-mean(D)).^2)/(NPop-1));
end