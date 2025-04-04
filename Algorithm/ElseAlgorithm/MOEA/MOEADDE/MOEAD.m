function Population = MOEAD(Population,delta,nr,W,N,B,Z,DEparameter,boundary,EvaParameter,gen)  

    Problem = EvaParameter.Problem;
    ft = EvaParameter.ft;
    nt = EvaParameter.nt;
    preEvolution = EvaParameter.preEvolution;

    %% Optimization
    % For each solution
    for i = 1:N
        % Choose the parents
        if rand < delta
            P = B(i,randperm(end));
        else
            P = randperm(N);
        end

        % Generate an offspring
        OffspringDec = OperatorDE(Population(i),Population(P(1)),Population(P(2)),DEparameter,boundary);
        [Offspring,~] = Individual(Problem,ft,nt,gen,[],preEvolution,OffspringDec);

        % Update the ideal point
        Z = min(Z,Offspring.obj);

        % Update the solutions in P by Tchebycheff approach
        g_old = max(abs(Population(P).objs-repmat(Z,length(P),1)).*W(P,:),[],2);
        g_new = max(repmat(abs(Offspring.obj-Z),length(P),1).*W(P,:),[],2);
        Population(P(find(g_old>=g_new,nr))) = Offspring;
    end

end

