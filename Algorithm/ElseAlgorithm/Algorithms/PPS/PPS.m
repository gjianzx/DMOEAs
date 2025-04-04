%% A Population Prediction Strategy for Evolutionary Dynamic Multiobjective Optimization 2014 %% 
function Population = PPS(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

    %% Initialization
    gen = 1;
    number = 1;
    clusters = 5;      % clusters
    [~,D] = size(Population.decs);


    %% RMMEDA
    Population(number,:) = RMMEDA(Problem,ft,nt,gen,preEvolution,Population(number,:),clusters,boundary);

    %% Optimization
    while maxgen > gen
        % change detection
        change = ChangeDetection(Population(number,:),Problem,ft,nt,gen,preEvolution);
        if change > 1e-6
            fprintf(' %d',number);
            
            p = 3;
            M = min(number,23);
            
            newPopulation = [];
            centroids(number,:) = mean(Population(number,:).decs, 1);
            manifolds{number} = Population(number,:).decs;

            if number>=2*p
                %% PS Center Prediction
                newCentroid = zeros(1,D);
                centroidSigma = zeros(1,D);
                for i = 1:D
                    timeSeries = centroids(number-M+1:number,i);
                    [newCentroid(i),centroidSigma(i)] = AR(timeSeries,p);
                end


                %% PS Manifold Estimation
                preManifold = manifolds{number-1};
                curMainfold = manifolds{number};
                manifoldSigma = ManifoldPrediction(preManifold,curMainfold);


                %% Solution Generation
                sigma = zeros(1,D);
                for i = 1:D
                    sigma(i) = sqrt(centroidSigma(i)+manifoldSigma(i));
                end
                newPopulationDec = repmat(newCentroid,N,1)+curMainfold+ ...
                                    repmat(sigma,N,1).*randn(N,D);


                %% PPS Procedure
                lower = boundary.lower;
                upper = boundary.upper;
                for i = 1:N
                    for j = 1:D
                        if newPopulationDec(i,j)<lower(j)
                            newPopulationDec(i,j) = 0.5*(lower(j)+curMainfold(i,j));
                        elseif newPopulationDec(i,j)>upper(j)
                            newPopulationDec(i,j) = 0.5*(upper(j)+curMainfold(i,j));
                        end
                    end
                end
                [newPopulation,~] = Individual(Problem,ft,nt,gen,[],preEvolution,newPopulationDec);
            end

            % Add new population of next environment
            [curPopulation,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Population(number,:).decs);
            Population(number+1,:) = RMMEDAEnvironmentalSelection([curPopulation,newPopulation],N);
            number = number+1;
        end
        
        % SMOEA
        Population(number,:) = RMMEDA(Problem,ft,nt,gen,preEvolution,Population(number,:),clusters,boundary);
        gen = gen + 1;
    end
end