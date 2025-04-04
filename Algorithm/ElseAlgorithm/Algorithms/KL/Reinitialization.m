function [newPopulationDec] = Reinitialization(dec,N,D,lower,upper)
    
    newPopulationDec = zeros(N,D);
    remain = floor(N*0.8);
    newPopulationDec(1:remain,:) = dec(randperm(N,remain),:);

    newPopulationDec(remain+1:end,:) = rand(N-remain,D).*repmat(upper-lower,N-remain,1)+lower;
end

