function [predictData,sigma] = AR(timeSeriesData,p)

%   M: time series
%   p: order of auto regression model

    M = length(timeSeriesData);

    trainNum = M-p;

    % form the phi matrix
    phi = zeros(trainNum,p);
    for i = 1:trainNum
        for j = 1:p
            phi(i,j) = timeSeriesData(M-i-j+1);         
        end
    end    
    
    % form the psi vector
    psi = zeros(trainNum , 1);    
    for i = 1:trainNum
        psi(i,1) = timeSeriesData(M-i+1);        
    end
    
    % psi=phi*lambda
    % the least square result of lambda is (phi'*phi)^-1 * phi' * psi    
    lambda = pinv(phi'*phi)*phi'*psi;
    

    % compute sigma through rmse
    sigma = mean((psi-phi*lambda).^2);

    % prediction
    predictData = 0; 
    for i = 1:p    
        predictData = predictData+lambda(i)*timeSeriesData(M-i+1);     
    end

end

