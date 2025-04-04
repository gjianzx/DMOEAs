function Rank=computeRank(PopX,Problem,t)
    for i=1:size(PopX,2)
        [PopF(:,i),PopV(:,i)] = Problem.FObj(PopX(:,i)',t);
    end 
    [Rank,SetDominamt,NumDom] = fastNonDominatedSort(PopF');
    for i=1:size(Rank,2)
        if Rank(i)~=1
           Rank(i)=-1;
        end
    end
end
