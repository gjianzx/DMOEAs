%% Evolutionary Dynamic Multiobjective Optimization via Learning From Historical Search Process 2021 %%
function Population = KL(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

    %% Initialization
    gen = 1;
    number = 1;
    lower = boundary.lower;
    upper = boundary.upper;
    D = length(lower);

    G = 1;
    K = 0;
    Q = [];
    
    %% NSGA
    [~,FrontNo,CrowdDis] = DNSGAIIEnvironment(Population,N);
    MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
    Offdec  = GA(Population(number,MatingPool).decs,boundary);
    [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Offdec);
    [Population(number,:),~,~] = DNSGAIIEnvironment([Population(number,:),Offspring],N);

    historyDec = cell(1,ft-1);
    %% Optimization
    while maxgen > gen
        % change detection
        change = ChangeDetection(Population(number,:),Problem,ft,nt,gen,preEvolution);
        if change > 1e-6
            fprintf(' %d',number);
            G = 1;
            K = K+1;
            newPopulationDec = Reinitialization(Population(number,:).decs,N,D,lower,upper);
            % Add new population of next environment
            [newPopulation,~] = Individual(Problem,ft,nt,gen,[],preEvolution,newPopulationDec);
            [Population(number+1,:),FrontNo,CrowdDis] = DNSGAIIEnvironment(newPopulation,N);
            number = number+1;
        end
        % SMOEA
        MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
        Offdec  = GA(Population(number,MatingPool).decs,boundary);
        [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Offdec);
        Q = [];
        if K>0 && G<ft
            predicPopDec = OnlineKnowledgeLearning(historyDec{G},Population(number-1,:).decs,Population(number,MatingPool).decs,N,lower,upper);
            [predicPop,~] = Individual(Problem,ft,nt,gen,[],preEvolution,predicPopDec);
            Q = [Offspring,predicPop];
        end
        [Population(number,:),FrontNo,CrowdDis] = DNSGAIIEnvironment([Population(number,:),Q],N);
        %
        if gen-preEvolution+ft>0 && gen<preEvolution
            historyDec{gen-preEvolution+ft} = Population(number,:).decs;
        elseif gen>=preEvolution
            historyDec{mod((gen-preEvolution),ft)+1} = Population(number,:).decs;
        end
        gen = gen + 1;
    end
end