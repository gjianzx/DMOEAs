%% A Mahalanobis Distance-Based Approach for Dynamic Multiobjective Optimization With Stochastic Changes 2024 %%
function Population = MDA(Problem,Population,boundary,N,maxgen,ft,nt,preEvolution)

    %% Initialization
    gen = 1;
    number = 1;
    clusters = 5;      % clusters
    lower = boundary.lower;
    upper = boundary.upper;
    D = length(lower);

    %% MOEAD parameter
    delta = 0.9;
    nr = 2;
    DEparameter.CR = 1;         DEparameter.F = 0.5;
    DEparameter.proM = 1;       DEparameter.disM = 20;
    % Generate the weight vectors
    M = size(Population(number,:).objs,2);
    [W,N] = UniformPoint(N,M);
    T = ceil(N/10);
    % Detect the neighbours of each solution
    B = pdist2(W,W);
    [~,B] = sort(B,2);
    B = B(:,1:T);
    Z = min(Population(number,:).objs,[],1);
    EvaParameter.Problem = Problem;
    EvaParameter.ft = ft;
    EvaParameter.nt = nt;
    EvaParameter.preEvolution = preEvolution;

    %% MOEADDE
    Population(number,:) = MOEAD(Population(number,:),delta,nr,W,N,B,Z,DEparameter,boundary,EvaParameter,gen);


    historicalInformation = {};
    detectorsDec = rand(floor(N*0.1),D).*(upper-lower)+lower;
    [detectors,~] = Individual(Problem,ft,nt,gen,[],preEvolution,detectorsDec);
    information.time = number;
    information.H = detectors.objs;
    information.V = [];
    historicalInformation{number} = information;


    %% Optimization
    while maxgen > gen
        % change detection
        change = ChangeDetection(Population(number,:),Problem,ft,nt,gen,preEvolution);
        if change > 1e-20
            fprintf(' %d',number);

            % Reevaluate the objective of detectors and save to H
            [detectors,~] = Individual(Problem,ft,nt,gen,[],preEvolution,detectorsDec);
            information.time = number+1;
            information.H = detectors.objs;
            information.V = [];
            curHLength = length(historicalInformation);
            historicalInformation{curHLength+1} = information;
            [frontNo,~] = NDSort(Population(number,:).objs,N);
            historicalInformation{curHLength}.V = Population(number,find(frontNo==1)).decs;

            if number==1
                [Population(number+1,:),~] = Individual(Problem,ft,nt,gen,[],preEvolution,Population(number,:).decs);
            else
                % The Pre-estimation based on MD
                [historicalInformation,OMatrix,GMatrix] = PreEstimation(historicalInformation,curHLength);
                % Dynamic strategy based on Pre-estimation
                Population(number+1,:) = DynamicStrategy(OMatrix,GMatrix,N,D,lower,upper,Problem,ft,nt,gen,preEvolution);
            end
            % Add new population of next environment
            number = number+1;
        end
        % SMOEA
        Population(number,:) = MOEAD(Population(number,:),delta,nr,W,N,B,Z,DEparameter,boundary,EvaParameter,gen);
        gen = gen + 1;
    end
end