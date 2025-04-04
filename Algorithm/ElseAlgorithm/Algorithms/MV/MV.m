%% Evolutionary Search with Multi-View Prediction for Dynamic Multi-objective Optimization (MV-MOPSO) 2022 %% 
function Population = MV(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

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

                Nl = floor(N/2);


                %% Learn the Matrix

                % decision space
                P = Population(number-1,:).decs;
                Q = Population(number,:).decs;
                Pk = Q*KernelMatrix('rbf',P,P)';
                Qk = KernelMatrix('rbf',P,P)*KernelMatrix('rbf',P,P)';
                Mk = Pk*pinv(Qk);
                IPS = Mk*KernelMatrix('rbf',P,Q);
                randIndex = randperm(N,N);
                IPS = IPS(randIndex(1:Nl),:);
                IPS = max(min(IPS,repmat(boundary.upper,Nl,1)),repmat(boundary.lower,Nl,1));

                % objective space
                P = Population(number-1,:).objs;
                Q = Population(number,:).objs;
                Pk = Q*KernelMatrix('rbf',P,P);
                Qk = KernelMatrix('rbf',P,P)*KernelMatrix('rbf',P,P)';
                Mk = Pk*pinv(Qk);
                IPF = Mk*KernelMatrix('rbf',P,Q);
                IPF = IPF(randIndex(Nl+1:end),:);

                minimumEulerDis = @(dec,obj)sqrt(sum((Individual(Problem,ft,nt,gen,[],preEvolution,dec).objs-obj).^2));
                IPF2S  = zeros(Nl,D);
                for i = 1:Nl
                    IPF2S(i,:) = fmincon(@(dec)minimumEulerDis(dec,IPF(i,:)), rand(1,D), ...
                        [], [], [], [], boundary.lower, boundary.upper, [], optimset('display', 'off'));
                end


                %% Merge all population
                newPopulation = Individual(Problem,ft,nt,gen,[],preEvolution,[IPS;IPF2S]);

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