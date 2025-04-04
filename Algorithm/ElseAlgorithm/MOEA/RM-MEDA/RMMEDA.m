function [Offspring] = RMMEDA(Problem,ft,nt,gen,preEvolution,Population,K,boundary)

    OffspringDec  = Operator(Population,K);
    % repair data boundary
    N = length(Population);
    lower = repmat(boundary.lower,N,1);
    upper = repmat(boundary.upper,N,1);
    xmax = max(OffspringDec,[],1);
    xmin = min(OffspringDec,[],1);
    boundaryScale = (OffspringDec-xmin)./repmat(xmax-xmin,N,1);
    scaleDecTemp = boundaryScale.*(upper-lower)+lower;
    invalid = OffspringDec<lower|OffspringDec>upper;
    OffspringDec(invalid) = scaleDecTemp(invalid);

    [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,OffspringDec);

    Offspring = RMMEDAEnvironmentalSelection([Population,Offspring],N);
end

