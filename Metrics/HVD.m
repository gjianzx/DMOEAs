function Score = HVD(PopObj,PF)
%% PopObj is the obtained PFO, PF is the true POF
    r = max(PF)+0.5;
    Score = hypervolume(PF,r) - hypervolume(PopObj,r);
end