%%
% <html><h2>Main function for Tr-NSGA-II</h2></html>
function res=TrNSGA(Problem,popSize,MaxIt,T_parameter,group)

   % clearvars -except functions testfunc
    %% step 1. Initialize objective functions
    n=size(Problem.XLow,1);
    evoluIter=MaxIt;
    Ft=Problem.FObj;
    %% step 2. Iterate through enviroment parameters
    t = 0;       %the initial moment    
    %% step 3. use RM-MEDA to get a POF at the initial moment with randomly generated population
   [PopX,POF_iter,runTime] =nsga2(Problem, popSize, MaxIt, t,1);
    POF = POF_iter{end}';
    for T = 1:T_parameter(group,3)/T_parameter(group,2)
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
        mu = 0.5;
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
      [PopX,POF_iter,runTime] =nsga2(Problem, popSize, evoluIter, t,1,init_population'); 
       
      %  Pareto = RMMEDA( Problem, Generator, popSize, MaxIt, t, testfunc, group, T, TruePOF, init_population);
        POF = POF_iter{end}';
        res{T}.POF_iter=POF_iter;
        res{T}.POS=PopX;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
    end
end


function res=disnormF(Problem,Fs,Fa,W,y, kind, p1, p2, p3,p,t)
    y=Problem.FObj(y,t);
    res=sum((getNewY(Fs, Fa, y(2), W, kind, p1, p2, p3) - p).^2);
end
