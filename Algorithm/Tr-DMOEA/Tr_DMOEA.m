%%
% <html><h2>Main function for Tr-NSGA-II</h2></html>
function res=Tr_DMOEA(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
    Generator.Name  = 'LPCA';           % name of generator
    Generator.NClu  = 5;                % parameter of generator, the number of clusters(default)
    Generator.Iter  = 50;               % maximum trainning steps in LPCA
    Generator.Exte  = 0.25;             % parameter of generator, extension rate(default)
   % clearvars -except functions testfunc
    %% step 1. Initialize objective functions
    n=size(Problem.XLow,1);
    Ft=Problem.FObj;
    %% step 2. Iterate through enviroment parameters
    t = 0;       %the initial moment   
    %% step 3. use RM-MEDA to get a POF at the initial moment with randomly generated population
%     Pareto = RMMEDA( Problem,Generator,popSize,MaxIt, t);
    [~,Pareto,POF_iter] = moead(Problem,popSize,MaxIt,t);  
    POF = Pareto.F';
    for T = 1:T_parameter(group,3)/T_parameter(group,2)
        tic
        %% step 4. use TCA to get the initial population at the next moment
        fprintf(' %d',T);
        % Initialize random populations
        sampleN = 30;
        Xs = rand(sampleN, n);
        for i=1:1:sampleN

            [Fs(:,i),~] = Problem.FObj(Xs(i,:),t);
        end
        t= 1/T_parameter(group,1)*(T-1);    % next moment
        F = @(x)Ft(x, t);
        Xt = rand(sampleN, n);
        for i=1:1:sampleN
            [Fa(:,i),~] = Problem.FObj(Xt(i,:),t);
        end

        % Find the latent space of domain adaptation
        mu = 0.1;
        lambda = 'unused';
        dim = 20;
        kind = 'Gaussian';
        p1 = 1;
        p2 = 'unused';
        p3 = 'unused';
        W = getW(Fs, Fa, mu, lambda, dim, kind, p1, p2, p3);
        POF_deduced = getNewY(Fs, Fa, POF', W, kind, p1, p2, p3);

        % Get initial population by POF_deduced
        dis_px = @(p, x)sum((getNewY(Fs, Fa, F(x)', W, kind, p1, p2, p3) - p).^2);
        initn = size(POF_deduced, 2);
       % init_population = zeros(initn, n);
        for i = 1:ceil(initn)
            p=POF_deduced(:,i);
            init_population(i,:) = fmincon(@(x)disnormF(Problem,Fs,Fa,W,x, kind, p1, p2, p3,p,t), rand(1,n), ...
                [], [], [], [], zeros(1,n), ones(1,n), [], optimset('display', 'off'));
        end
        
        %% step 5. use RM-MEDA to get the POF at every moment with the initial population
       % TruePOF = getBenchmarkPOF(testfunc,group,T);
%        size(init_population')
      % Pareto = RMMEDA( Problem,Generator,popSize,MaxIt, t, init_population');
      [~,Pareto,POF_iter] = moead(Problem,popSize,MaxIt,t,init_population'); 
%       Pareto = RMMEDA( Problem,Generator,popSize,MaxIt, t, init_population);
      %  Pareto = RMMEDA( Problem, Generator, popSize, MaxIt, t, testfunc, group, T, TruePOF, init_population);
        
        POF = Pareto.F';
        res{T}.rt=toc;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
        res{T}.POF_iter=POF_iter;
        res{T}.POS=Pareto.X;
    end
end


function res=disnormF(Problem,Fs,Fa,W,y, kind, p1, p2, p3,p,t)
    y=Problem.FObj(y,t);
    res=sum((getNewY(Fs, Fa, y(2), W, kind, p1, p2, p3) - p).^2);
end
