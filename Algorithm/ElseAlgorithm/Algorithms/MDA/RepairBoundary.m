function [newPopulationDec] = RepairBoundary(PopulationDec,N,lower,upper)
    
    [popNum,D] = size(PopulationDec);
    if popNum<N
        randPopDec = rand(N-popNum,D).*(upper-lower)+lower;
        PopulationDec = [PopulationDec;randPopDec];
    elseif popNum>N
        PopulationDec(randperm(popNum,popNum-N),:) = [];
    end
    newPopulationDec = max(min(PopulationDec,repmat(upper,N,1)),repmat(lower,N,1));
    
end

