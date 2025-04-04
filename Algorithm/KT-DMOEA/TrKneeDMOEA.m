
function res=TrKneeDMOEA(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
    source=[];
    partNum=5;
    for T = 1:T_parameter(group,3)/T_parameter(group,2)
        tic;
        t= 1/T_parameter(group,1)*(T);   
        fprintf(' %d',T);
        
        if T==1 || T==2
            [PopX,Pareto,POF_iter]=moead( Problem,popSize,MaxIt, t);       
            [kneeF,kneeS]=getKneeGroup(Pareto,partNum);
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS);
            kneeArray{T}=kneeS;
        else
   
            kneeS=TPM(kneeArray,T);
 
            [PopX,Pareto,POF_iter]=moead( Problem,popSize,1, t, kneeS);
            Rank=asignRank([PopX kneeS],kneeS);
            PopX=[PopX kneeS];
            testPopX=[generateRandomPoints(PopX,Problem,Algs_name) generateRandomPoints(PopX,Problem,Algs_name)];
            [predictPopX,predTime]=predictPopulationKnee(LastPopX',LastRank',PopX',Rank',testPopX',partNum);
            initPopulation=predictPopX;
            if size(initPopulation,2)>popSize
                initPopulation=initPopulation(:,1:floor(popSize/1.2));
            elseif size(predictPopX,2)==0
                initPopulation=PopX;
                if size(initPopulation,2)>=floor(popSize/1.2)
                    initPopulation=initPopulation(:,1:floor(popSize/1.2));
                else
                    initPopulation=initPopulation(:,end);
                end
            end
%              size(initPopulation)
%             [PopX,Pareto,POF_iter]=moead( Problem,popSize,1, t, initPopulation);     
            [PopX,Pareto,POF_iter]=moead( Problem,popSize,MaxIt, t, initPopulation); 
            [kneeF,kneeS]=getKneeGroup(Pareto,partNum);
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS); 
            kneeArray{T}=kneeS;
            
        end
        res{T}.rt = toc;        
        res{T}.obj=POF_iter{end}';
        res{T}.POF_iter=POF_iter;
        res{T}.POS=Pareto.X;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
    end

end


function [kneeF,kneeS]=getKneeGroup2(PopX,partNum,t,Problem)
for i=1:size(PopX,2)
    [PopF(:,i),~] = Problem.FObj(PopX(:,i)',t);
end 
    [boundaryS,boundaryF]=getBoundary(PopX,PopF);
    [posArr,pofArr]=partition(PopX,PopF,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo});
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);
    kneeF=cell2mat(kneeFArr);
end


function [kneeF,kneeS]=getKneeGroup(Pareto,partNum)
    [boundaryS,boundaryF]=getBoundary(Pareto.X,Pareto.F);
    [posArr,pofArr]=partition(Pareto.X,Pareto.F,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo});
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);
    kneeF=cell2mat(kneeFArr);
end


function Rank=asignRank(PopX,KneeX)
for i=1:size(PopX,2)
    for j=1:size(KneeX,2)
        if isequal(PopX(:,i),KneeX(:,j))==1
            Rank(i)=1;
            break;
        else
            Rank(i)=-1;
        end
    end
end
end
