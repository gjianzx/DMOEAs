function newPopulation = addNoise(init_population, Nini, n)
    Num = size(init_population,1);
    newPopNumber = Nini - Num;
    newPopulation = zeros(newPopNumber,n);
    
    for i = 1:newPopNumber
        %对这些个体进行局部变异
        index = randperm(Num,1);
        newPopulation(i,:) = init_population(index,:);
        index2 = randperm(n,round(n*0.3));%取单个决策变量的30%做突变
        temp = init_population(index,index2) + normrnd(0,0.5,[1 n]);
        upp = temp>1;
        loww = temp<0;
        temp(upp) = (init_population(index,upp)+1)/2;
        temp(loww) = (init_population(index,loww)-0)/2;
        newPopulation(i,index2) = temp;
    end
end