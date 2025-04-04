function [U,M,p1,Q,center,D] = DirectionGuidanceModel(Population,number,N,OffspringDec,Iter,p1,Q,U,M,center,D,lower,upper)

    if length(Q)<number
        Q{number} = [];
    end

    U{Iter+1} = [];
    M{Iter+1} = [];

    if Iter==0
        p1 = 0.5;
        % Formula 5
        center{number} = mean(Population(number,:).decs,1);
    else
        rU1 = GetIntersectionSize(Population(number,:).decs,U{Iter})/(size(U{Iter},1)+0.0001);
        rM1 = GetIntersectionSize(Population(number,:).decs,M{Iter})/(size(M{Iter},1)+0.0001);
        if rU1>rM1
            p1 = p1+0.05;
        else
            p1 = p1-0.05;
        end
    end
    if p1>0.3
        [frontNo,~] = NDSort(Population(number,:).objs,N);
        NDS = Population(number,find(frontNo==1)).decs;
        Q{number} = [Q{number};NDS];
        D{number} = Q{number}-center{number};
        for i=1:size(OffspringDec,1)
            if rand<p1
                % Determine the guidance vector
                % Formula 7
                preD = D{number-1};
                [~,iMinIdx] = min(pdist2(preD,OffspringDec(i,:)));
                preXi = preD(iMinIdx,:);
                % Formula 8
                [preFrontNo,~] = NDSort(Population(number-1,:).objs,N);
                preNDS = Population(number-1,find(preFrontNo==1)).decs;
                [~,eMinIdx] = min(pdist2(preXi,preNDS));
                preXe = preNDS(eMinIdx,:);
                % Formula 9
                preVi = preXi-preXe;
    
                % Relocate the offspring individual
                OffspringDec(i,:) = RepairBoundary(OffspringDec(i,:)-preVi,1,lower,upper);
    
                U{Iter+1} = [U{Iter+1};OffspringDec(i,:)];
            else
                M{Iter+1} = [M{Iter+1};OffspringDec(i,:)];
            end
        end
    else
        U{Iter+1} = OffspringDec(1:end/2,:);
        M{Iter+1} = OffspringDec(end/2+1:end,:);
    end

end

