%% A Framework Based on Historical Evolution Learning for Dynamic Multiobjective Optimization 2024 %%
function Population = HEL(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

    %% Initialization
    gen = 1;
    number = 1;
    lower = boundary.lower;
    upper = boundary.upper;


    %% NSGA
    [~,FrontNo,CrowdDis] = DNSGAIIEnvironment(Population,N);
    MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
    Offdec  = GA(Population(number,MatingPool).decs,boundary);
    [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Offdec);
    % ---------------------------------------------------------------------
    Iter = 0;
    p1 = 0.5;
    p2 = 1;
    Q{number} = [];
    center{number} = [];
    U = {};
    M = {};
    center{number} = mean(Population(number,:).decs,1);
    [Q,D] = FirstTimeSaveData(Population,number,Q,center,N);
    % ---------------------------------------------------------------------
    [Population(number,:),~,~] = DNSGAIIEnvironment([Population(number,:),Offspring],N);
    

    %% Optimization
    while maxgen > gen
        % change detection
        change = ChangeDetection(Population(number,:),Problem,ft,nt,gen,preEvolution);
        if change > 1e-20
            fprintf(' %d',number);

            Iter = 0;
            % Change Response Mechanism
            % DA: 
            % A classical diversity based algorithm. The strategy is 
            % extracted from DNSGA-II, where 20% of individuals are 
            % randomly reinitialized when change happens. This simple yet 
            % effective mechanism can be adopted into any type of DMOPs and
            % get satisfactory performance.
            newPopulationDec = Population(number,:).decs;
            remainNum = floor(N*0.8);
            newPopulationDec(1:remainNum,:) = newPopulationDec(randperm(N,remainNum),:);
            newPopulationDec(remainNum+1:end,:) = lower+(upper-lower).*rand(N-remainNum,size(newPopulationDec,2));

            % Add new population of next environment
            [newPopulation,~] = Individual(Problem,ft,nt,gen,[],preEvolution,newPopulationDec);
            Population(number+1,:) = RMMEDAEnvironmentalSelection(newPopulation,N);
            number = number+1;
        end
        % SMOEA
        MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
        Offdec  = GA(Population(number,MatingPool).decs,boundary);
        % -----------------------------------------------------------------
        if number<2
            [Q,D] = FirstTimeSaveData(Population,number,Q,center,N);
            [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Offdec);
        else
            % Algorithm 2:Direction Guidance Model
            [U,M,p1,Q,center,D] = DirectionGuidanceModel(Population,number,N,Offdec,Iter,p1,Q,U,M,center,D,lower,upper);
            [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,[U{Iter+1};M{Iter+1}]);
        end
        % -----------------------------------------------------------------
        [Population(number,:),FrontNo,CrowdDis] = DNSGAIIEnvironment([Population(number,:),Offspring],N);
        % -----------------------------------------------------------------
        if number>=2
            % Algorithm 3:Manifold Revise Model
            [Population,p2] = ManifoldReviseModel(Population,number,N,Iter,p2,lower,upper,Problem,ft,nt,gen,preEvolution);
        end
        Iter = Iter+1;
        % -----------------------------------------------------------------
        gen = gen + 1;
    end
end