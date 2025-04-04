function [Q,D] = FirstTimeSaveData(Population,number,Q,center,N)


    [frontNo,~] = NDSort(Population(number,:).objs,N);
    NDS = Population(number,find(frontNo==1)).decs;
    Q{number} = [Q{number};NDS];
    D{number} = Q{number}-center{number};

end

