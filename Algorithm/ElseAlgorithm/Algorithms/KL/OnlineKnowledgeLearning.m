function [predicPopDec] = OnlineKnowledgeLearning(preG,preTaut,curG,N,lower,upper)

    X = [preG';ones(1,N)];
    Y = [preTaut';ones(1,N)];
    M1 = (Y*X')\(X*X');
    X_ = tanh(M1*X);
    M2 = (Y*X_')\(X_*X_');
    predicPopDec = M2*tanh(M1*[curG';ones(1,N)]);
    predicPopDec(end,:) = [];

    predicPopDec = max(min(predicPopDec',repmat(upper,N,1)),repmat(lower,N,1));
end

