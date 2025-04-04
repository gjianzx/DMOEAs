function [Population,p2] = ManifoldReviseModel(Population,number,N,Iter,p2,lower,upper,Problem,ft,nt,gen,preEvolution)

    [preFrontNo,~] = NDSort(Population(number-1,:).decs,N);
    prePOS = Population(number-1,find(preFrontNo==1)).decs;
    if Iter==0
        p2 = 1;
    else
        if p2>0.3
            % Sort Population via nondominated sorting and
            % crowding-distance assignment
            [curFrontNo,~] = NDSort(Population(number,:).objs,N);
            curCrowdDis = CrowdingDistance(Population(number,:).objs,curFrontNo);
            [~,sortedIdx] = sortrows([curFrontNo;curCrowdDis]', [1,2]);
            % Identify the less potential solutions LPS and more
            % potential solutions MPS
            LPSNum = floor(N*0.1);
            LPS = Population(number,sortedIdx(1:LPSNum)).decs;
            MPS = Population(number,sortedIdx(LPSNum+1:end)).decs;
            RS = [];
            for i=1:LPSNum
                % Determine the neighboring potential solution
                % Formula 11
                [~,curNeighborMinIdx] = min(pdist2(LPS(i,:),MPS));
                curXneighbor = MPS(curNeighborMinIdx,:);
                % Relocate the corresponding solutions
                % Formula 12
                [~,preXMinIdx] = min(pdist2(LPS(i,:),prePOS));
                preX = prePOS(preXMinIdx,:);
                [~,preNeighborMinIdx] = min(pdist2(curXneighbor,prePOS));
                preNeighbor = prePOS(preNeighborMinIdx,:);
                % Calculate the relative position
                % Formula 13
                vector = preNeighbor-preX;
                % Produce the revised solution
                % Formula 14
                newX = RepairBoundary(curXneighbor-vector,1,lower,upper);
                RS = [RS;newX];
            end
            % Select the best c*N solutions from RS and LPS
            [RSLPS,~] = Individual(Problem,ft,nt,gen,[],preEvolution,[RS;LPS]);
            [bestLPS,~,~] = DNSGAIIEnvironment(RSLPS,LPSNum);
            % Replace LPS from Population by the identified best
            % solutions
            Population(number,sortedIdx(1:LPSNum)) = bestLPS;
            % Calculate the effective rate of p2
            % Formula 15
            RU2 = GetIntersectionSize(Population(number,:).decs,RS)/(size(RS,1)+0.0001);
            % Formula 16
            RM2 = GetIntersectionSize(Population(number,:).decs,LPS)/(size(LPS,1)+0.0001);
            % Formula 17
            p2 = RU2/(RU2+RM2+0.0001);
        end
    end

end

