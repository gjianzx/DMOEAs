function [D] = MahalanobisDistance(S1,S2)

    n1 = size(S1,1);
    n2 = size(S2,1);

    S = ((n1-1)*cov(S1)+(n2-1)*cov(S2))/(n1+n2-2);

    meanS1 = mean(S1,1);
    meanS2 = mean(S2,1);

%     D = sqrt((meanS1-meanS2)*pinv(S)*(meanS1-meanS2)');
    D = pdist2(meanS1,meanS2,'mahalanobis',S);

end

