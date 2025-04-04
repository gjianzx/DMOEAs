
function res=IGP_DMOEA(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
        global nt;  
        mop = Problem;
    %% step 2. Iterate through enviroment parameters
        %% step 3. use the MOEA/D to get a POF at the initial moment with randomly generated population
        nt = T_parameter(group,1);
        paramIn = {'popsize', popSize, 'niche', 10, 'iteration', MaxIt, 'method', 'te'};
        %global variable definition.
        global params idealpoint objDim parDim;
        %set the random generator.      
        for T =1:T_parameter(group,3)/T_parameter(group,2)
            tic;
            fprintf(' %d',T);
            t = 1/T_parameter(group,1)*T;
            if T==1
                 [PopX,Pareto,POF_iter]=moead(Problem, popSize, MaxIt, t); 
            
                  [objDim, parDim, idealpoint, params, subproblems]=init(mop, t, paramIn);
%                 [objDim, parDim, idealpoint, params, subproblems]=init(mop, t, paramIn);
%                 subproblems = evolve(t, subproblems, mop, params);
%                 pareto = [subproblems.curpoint];
            else
                    best = NDSort(POF',1);
                    POF_total = POF(:,best==1);
                    POS_total = POS(:,best==1);
                        
                    finalgen = 1;
                    domain=[mop.XUpp,mop.XLow];
                    upper = domain(:,1)';
                    lower = domain(:,2)';
                    L = 16;
                    predictsize = size(POF_total,2);
                    samply = zeros(predictsize,mop.NObj);
                    
                     for i = 1:ceil(predictsize/2)               % 为什么采用一半种群大小
                         fitness = POF_total(:,i);     
                         direction = abs(fitness - idealpoint +0.01);
                         s = diag(direction);
                         samply(i,:) = mvnrnd(fitness',s);                % 生成采样点
                     end
                     predictpop=  F_reproduction(samply, POS_total', POF_total', finalgen, lower, upper, L); % 产生预测种群
                     predictsize = size(predictpop,1);
                     randsize = popSize - predictsize;        % 产生随机个体的数量
                     randpop = [];
                     if randsize>0           
                         pd=length(mop.XUpp);
                         randpop = initialize_variablesIGP(randsize,mop.NObj,pd,lower,upper);   % 产生随机个体
                     end
%                      if objDim==3
%                           newpop =[ randpop];                    % 此部分存在问题
%                      else
                          newpop =[predictpop; randpop];           % 新环境种群由预测种群和随机种群组成
%                      end
                    
                      [objDim, parDim, idealpoint, params, subproblems]=init(mop, t, paramIn);
%                      [objDim, parDim, idealpoint, params, subproblems]=init(mop, t, paramIn, newpop');
                    
                      [PopX,Pareto,POF_iter]=moead(Problem, popSize, MaxIt, t, newpop'); 
%                     subproblems = evolve(t, subproblems, mop, params);
%                     pareto = [subproblems.curpoint];
             end
               
               POF = Pareto.F;%[pareto.objective];
               POS = PopX;%[pareto.parameter];
               res{T}.rt = toc;
               res{T}.obj=POF';
               res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
               res{T}.POF_iter=POF_iter;
               res{T}.POS=Pareto.X;
        end
end
