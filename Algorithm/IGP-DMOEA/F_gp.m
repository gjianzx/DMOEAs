function [sampley] = F_gp(x_tr, y_tr, popsize, finalgen, x_tt)

%function to train and sample a GP model

%input: trdata - training data
%       popsize - number of sample data
%       finalgen - sign to check if it is the final generation
%       lb - lower sampling boundary
%       rb - uppper sampling boundary
%output: sampled data

    %training data for GP
    ns = size(x_tt,1);
 
    %parameters for GP
    meanfunc = @meanZero; 
    covfunc =  @covLIN; 
    likfunc = @likGauss; 
    hyp.mean = [];   
    hyp.cov = [];
    hyp.lik = log(0.01);
    

    %calculate mean and variance
    %gp() is a function in the gpml toolbox
    [m s2] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x_tr, y_tr, x_tt);
    
    
    %sample with mean and variance
    if(finalgen == 1)
        %if it is the final generation, only use mean to sample
        y_tt = m;
    else
        y_tt = m + rand()*1.0*sqrt(s2).*normrnd(0,1, [ns 1]);
    end
  
    %output the sampled data
    samplex = x_tt;
    sampley = y_tt;

end