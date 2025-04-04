%% Solving Dynamic Multiobjective Problem via Autoencoding Evolutionary Search 2022 %%
function Population = AE(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

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
            
            newPopulation = [];
            if number>1
                [preFrontNo,~] = NDSort(Population(number-1,:).objs,1);
                preNDS = Population(number-1,find(preFrontNo==1));
                [curFrontNo,~] = NDSort(Population(number,:).objs,1);
                curNDS = Population(number,find(curFrontNo==1));

                %% Rank solutions using crowd distance
                preCrowdDis = CrowdingDistance(preNDS.objs);
                [~,preIndex] = sort(preCrowdDis,'ascend');
                curCrowdDis = CrowdingDistance(curNDS.objs);
                [~,curIndex] = sort(curCrowdDis,'ascend');


                %% Configure P and Q
                Nl = min(length(preNDS),length(curNDS));
                P = preNDS(preIndex(1:Nl)).decs';
                Q = curNDS(curIndex(1:Nl)).decs';


                %% Obtain the matrix M
                M = (Q*P')*pinv(P*P');


                %% Calculate the predicted POS solutions
                predicPopulationDec = (M*Q)';
                predicPopulationDec = max(min(repmat(boundary.upper,Nl,1),predicPopulationDec),repmat(boundary.lower,Nl,1));


                %% High-Quality solution preservation
                if length(curNDS)>N/2
                    hqPopulationIndex = randperm(length(curNDS),floor(N/2));
                    hqPopulationDec = curNDS(hqPopulationIndex).decs;
                else
                    hqPopulationDec = curNDS.decs;
                end


                %% Generate random population
                numTemp = size([predicPopulationDec;hqPopulationDec],1);
                randomPopulationDec = zeros(N-numTemp,D);
                for i = 1:N-numTemp
                    randomPopulationDec(i,:) = (boundary.upper-boundary.lower).*randn(1,D)+boundary.lower;
                end


                %% Merge all population
                newPopulation = Individual(Problem,ft,nt,gen,[],preEvolution,[predicPopulationDec;hqPopulationDec;randomPopulationDec]);

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