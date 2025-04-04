function pop=getFbyPopSize(PopX,Problem,t,popSize)
    for i=1:size(PopX,1)
        [PopF(i,:),~] = Problem.FObj(PopX(i,:),t);
    end 
    [Rank,SetDominamt,NumDom] = fastNonDominatedSort(PopF);
    pop=[];
    num=1;
    for Fno=1:max(Rank)
        [~,index]=find(Rank==Fno);
        for in=1:length(index)
            pop(num,:)=PopX(index(in),:);
            num=num+1;
            if size(pop,1)>=popSize
             return;
            end
        end
    end
end