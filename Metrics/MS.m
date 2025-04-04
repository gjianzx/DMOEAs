function Score = MS(PopObj,PF)
%% Maximum Spread
%% PopObj is the obtained POF, PF is the true POF
    M = size(PF,2);
    PFUp = max(PF,[],1);PFLow = min(PF,[],1);
    PopObjUp = max(PopObj,[],1);PopObjLow = min(PopObj,[],1);
    sums = 0;
    for i = 1:M
        sums = sums+((min(PFUp(i),PopObjUp(i))-max(PFLow(i),PopObjLow(i)))/(PFUp(i)-PFLow(i)))^2;
    end
    Score = sqrt(sums/M);
end