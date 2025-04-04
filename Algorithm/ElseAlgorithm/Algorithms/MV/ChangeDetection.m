function change = ChangeDetection(Population,Problem,ft,nt,gen,preEvolution)
% Dectect the change

    Dec = Population.decs;
    [Current,~] = Individual(Problem,ft,nt,gen,[],preEvolution,Dec);
    obj1 = Population.objs;
    obj2 = Current.objs;
    change = mean(sum(abs(obj1-obj2),2));
end