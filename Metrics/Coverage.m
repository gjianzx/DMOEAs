function Score = Coverage(PopObj,PF)
% <metric> <min>
% Coverage

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    Domi = false(1,size(PopObj,1));
    for i = 1 : size(PF,1)
        Domi(sum(repmat(PF(i,:),size(PopObj,1),1)-PopObj<=0,2)==size(PopObj,2)) = true;
    end
    Score = sum(Domi) / size(PopObj,1);
end