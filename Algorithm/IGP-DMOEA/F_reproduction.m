function [offspring] = F_reproduction(samply, pop, fitness, finalgen, lower, upper,  L)
%function to peform GP based reproduction
%input:     pop - the current subpopulation
%           fitness - the function values of the current subpopulation
%           finalgen - sign to check if it is the final generation
%           lower - the lower boundary of the decision variables
%           upper - the upper oundary of the decision variables
%           L - random group size
%output:    offspring - the offspring population

M = size(fitness,2);
n = size(pop,2);
N = size(pop,1);
%training and sampling, if training data is sufficient
%a minal number of training data in each group (M in total) is 2
%therefore, the minal traning data size (i.e., the population size) is 2*M
if(N >= 2*M)
    
    tlower = min(pop, [], 1);
    tupper = max(pop, [], 1);
    newpop = [];
    %sample data
    PSsample = zeros(N,n);
    samplesize = N;
    if(finalgen == 1)
    %random group size if n if it is the final generation
         subsize = n;
    else
         subsize = L;
    end
    %perform random grouping based GP training and sampling
    randidx = randperm(n);
    for ii = 1 : subsize
        %generate training data
        i = randidx(ii);
        trdata = [fitness pop(:,i)];  
        [PSsample(:,i)] = F_gp(fitness, pop(:,i), samplesize, finalgen, samply);
        outidx1 = find(PSsample(:,i) < lower(i));
        outidx2 = find(PSsample(:,i) > upper(i));
        PSsample(outidx1,i) = lower(i);
        PSsample(outidx2,i) = upper(i);
    end
        newpop = [newpop; PSsample];
   
else
    newpop = pop;
end

offspring = newpop;

end




