function newPopulation = addNoise(init_population, Nini, n)

%n维数
%对当前群体的个体增加白噪声，讲增加了白噪声的个体和原始个体混合
    newPopNumber = Nini - size(init_population,2);
    newPopulation = zeros(n,newPopNumber);
    for i = 1:newPopNumber
        
        index = randperm(size(init_population,2));
        index2 = randperm(n);
       
        for idx2 = 1:round(n*0.4)      %随机选取一半的位数做局部变化
            temp = init_population(index2(idx2),index(1));
            temp =cauchyrnd(temp,4);
            if temp <0
                temp = 0;
            end
            if temp >1
                temp =1;
            end
            init_population(index2(idx2),index(1)) = temp;
        end
        
        newPopulation(:,i) = init_population(:,index(1));
    end

  %   fprintf("!!!!!!\n");
end