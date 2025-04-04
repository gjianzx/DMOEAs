function res=PPS(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
global params idealpoint objDim parDim;
 for T =1:T_parameter(group,3)/T_parameter(group,2)
      %  t=1/T_parameter(group,1)*(T_parameter(group,1)*3/T_parameter(group,2));
         t = 1/T_parameter(group,1)*(T);
        fprintf(' %d',T);
        
        paramIn = {'popsize', popSize, 'niche', 20, 'iteration', MaxIt, 'method', 'te'};
    
        L=0;
        recordcenter=[];
        p=3;
        manifold_old=zeros(size(Problem.XLow,1),200);
                
            
        if T==1
            paramIn = {'popsize', popSize, 'niche', 20, 'iteration', 30, 'method', 'te'};
            [objDim, parDim, idealpoint, params, subproblems]=init(Problem, t, paramIn);
            subproblems = evolve(t, subproblems, Problem, params);
            popsize = length(subproblems);
            pareto = [subproblems.curpoint];
            POF = [pareto.objective];
            POS = [pareto.parameter];
            
%             [~,Pareto,POF_iter] = moead(Problem,popSize,MaxIt,t);              
%             All_POS{T} = Pareto.X;   % pareto解集的位置
%             All_POF{T} = Pareto.F;   % pareto解集的适应值              
        else
%             best = NDSort(POF',1);
%             POF_PPS = POF(:,best==1);
%             POS_PPS = POS(:,best==1);                  
                    
            L = L+1;
            [objDim, parDim, idealpoint, params, subproblems]=init(Problem, t, paramIn);
            popsize = length(subproblems);
            domain = [Problem.XLow  Problem.XUpp];
            lower = domain(:,1)';
            upper = domain(:,2)';
                    
            numbernew = size(POS_PPS,2);
            numberold = size(manifold_old,2);
            center_new=sum(POS_PPS,2)/numbernew;
            manifold_new=POS_PPS-repmat(center_new,1,numbernew);
            Msigama=sigama_manifold(manifold_new, manifold_old, size(Problem.XLow,1), numbernew, numberold);

            srecord=size(recordcenter);
            if srecord<23
               recordcenter=[center_new'; recordcenter];
            else
               recordcenter(23,:)=[];
               recordcenter=[center_new'; recordcenter];
            end
            if L<4
               halfpop=0.5*popsize;
               randpop=initialize_variables(halfpop, Problem.NObj, size(Problem.XLow,1), lower, upper);
               prepop=select_prepop(POS_PPS,halfpop,numbernew);
               newpop=[randpop;prepop'];           
            else 
               predictset=PPS(POS_PPS',recordcenter, Msigama, size(Problem.XLow,1), p, lower, upper, popsize); 
               predictsize =size(predictset,1);
               restpop = popsize - predictsize;
               addpop =[];
               if restpop>0
                   addpop = initialize_variables(restpop, Problem.NObj, size(Problem.XLow,1), lower, upper);
               end
               newpop=[predictset; addpop];             
            end
             manifold_old=manifold_new;
             
%              [objDim, parDim, idealpoint, params, subproblems]=init(Problem, t, paramIn, newpop');
           [PopX,Pareto,POF_iter] = moead( Problem,popSize,MaxIt,t,newpop');
%            subproblems = evolve(t, subproblems, Problem, params);
   
%            POF = POF_iter{end};
%            POS = [PopX.Position];
             All_POS{T} = Pareto.X;
             All_POF{T} = Pareto.F;
        end
        
%         best = NDSort(POF',1);
%         POF_PPS = POF(:,best==1);
%         POS_PPS = POS(:,best==1);                   
  
%         POS_PPS=POS;
%         POF_PPS=POF ;
        
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
%         res{T}.POF_iter=POF_PPS;
%         res{T}.POS=POS_PPS;
        res{T}.POF_iter=POF_iter;
        res{T}.POS=Pareto.X;

        kneef_one=getKnees(Pareto.F);
        res{T}.truekneef=getKnees(res{T}.turePOF');
        res{T}.kneef =getminTokneef(res{T}.truekneef,Pareto.F);% kneef_one;
 end
end

function  res=getminTokneef(truekneef,ParetoF)
for i=1:size(ParetoF,2)
    dis(i)=sqrt(sum((ParetoF(:,i)-truekneef).^2));      
end
[~,index]=min(dis);
res=ParetoF(:,index);
end

function kneeF=getKnees(POF)
boudaryF=getBoundary(POF);
distance=getToHDistance(POF,boudaryF);
[~,index]=max(distance);
kneeF=POF(:,index);
end

function BF=getBoundary(pof)
index=1;
for i=1:size(pof,1)
[~,position]=min(pof(i,:));
BF(:,index)=pof(:,position);
index=index+1;
end
end
