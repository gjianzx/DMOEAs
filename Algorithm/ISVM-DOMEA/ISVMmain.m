%population size*dim
function res=ISVMmain(Problem,popSize,MaxIt,T_parameter,group)
    for T =1:T_parameter(group,3)/T_parameter(group,2)
        t = 1/T_parameter(group,1)*(T);
        fprintf(' %d',T);

        if T==1 
            offsubpop = RMMEDA( Problem, popSize, MaxIt, t);
        else
            newE=[testdata;E;E];
            if size(E,1)>popSize
                init_population.pop=newE(1:popSize,:); 
                
            else
                init_population.pop=newE;
            end
            
            init_population.subpopsize=popSize;
            offsubpop = RMMEDA( Problem, popSize, MaxIt, t,init_population);
        end
        PoptX=offsubpop.pop';
        E=(PoptX(:,1:(popSize-popSize)))';
        POF = offsubpop.obj';
                POS = offsubpop.pop';
                [POFrow ,POFcolume]  = size(POF);
                [POSrow ,POScolume]  = size(POS);
                A=POS(1:POSrow,:);
%                 sample=SMOTE(A',POSrow*5,5);
                N_p=[];
%                 N_p=[sample';A];
                N_p=[A];
                N_p_size=size(N_p,1);
                C=ones(N_p_size,1);
                N_n=rand(N_p_size,POScolume);% range of decision vector is in (0,1)
                D=-ones(N_p_size,1);
                traindata=[N_p;N_n];
                trainlabeldata=[C;D];
                
                % ISVM update
                if T==1
%                     [bestacc,bestc,bestg] = SVMcg(trainlabeldata,traindata,-5,5,-5,5,5,1,1,1.5);
                    mcp_svmtrain(traindata,trainlabeldata,1,5,1);
                else
                    mcp_svmtrain_next(traindata,trainlabeldata,1);
                end
                
               E=offsubpop.pop(1:50,:);
                testdata=rand(300,POScolume);% range of decision vector is in (0,1)
                [pred_cl pred_probs] = mcp_svmpredict(testdata);
                  testdata=rand(50,10);% range of decision vector is in (0,1)
                indgood=find(pred_cl==1);
                testdata=testdata(indgood,:);         
%                 E=[E;testdata'];
                    
                
                
        res{T}.obj=offsubpop.obj;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
    end       
 end
    



      