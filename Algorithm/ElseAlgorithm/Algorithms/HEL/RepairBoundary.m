function [newPopulationDec] = RepairBoundary(PopulationDec,N,lower,upper)
    
    newPopulationDec = max(min(PopulationDec,repmat(upper,N,1)),repmat(lower,N,1));
    
end

