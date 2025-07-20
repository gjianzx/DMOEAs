function resPop=getRandomPoints(Problem,popSize)
    nVar=size(Problem.XLow,1);     % Number of Decision Variables
    VarSize=[nVar 1];              % Decision Variables Matrix Size
    VarMin = Problem.XLow;         % Decision Variables Lower Bound
    VarMax = Problem.XUpp;         % Decision Variables Upper Bound
    for i=1:popSize
            resPop(:,i)=unifrnd(VarMin,VarMax,VarSize);
    end
end