%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA124
% Project Title: Implementation of MOEA/D
% Muti-Objective Evolutionary Algorithm based on Decomposition
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function y=M_Crossover(x1,x2,params)

    gamma=params.gamma;
    VarMin=params.VarMin;
    VarMax=params.VarMax;
    alpha=unifrnd(-gamma,1+gamma,size(x1));
    y=alpha.*x1+(1-alpha).*x2;
    for i=1:size(x1)
        y(i) = min(max(y(i),VarMin(i)), VarMax(i));
    end
    %y=min(max(y,VarMin),VarMax);
    
end