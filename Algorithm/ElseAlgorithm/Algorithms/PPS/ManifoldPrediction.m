function [sigma] = ManifoldPrediction(preManifold,curMainfold)

    
    [N,D] = size(preManifold);
    allDistance = 0;
    for i = 1:N
        distance = sqrt(sum((repmat(curMainfold(i,:),N,1)-preManifold).^2,2));
        allDistance = allDistance + min(distance);
    end
    DAB = (allDistance/N);

    % compute sigma
    sigma = repmat(DAB^2/D,1,D);

end

