function probabilistic()
%% Algorithm taken from    
%  "A note on Platt's Probabilistic Outputs for Support Vector Machines", Lin et al. 2007    

global model;

deci= svmeval(model.X);
label=model.y;


prior1 = length(find(model.y==1));
prior0 = length(find(model.y==-1));

%Parameter setting
maxiter=100; %Maximum number of iterations
minstep=1e-10; %Minimum step taken in line search
sigma=1e-12; %Set to any value > 0

%Construct initial values: target support in array t,

% initial function value in fval
hiTarget=(prior1+1.0)/(prior1+2.0);
loTarget=1/(prior0+2.0);
len=prior1+prior0; % Total number of data
for i = 1:len 
    if (label(i) > 0)
        t(i)=hiTarget;
    else
        t(i)=loTarget;
    end
end
A=0.0;
B=log((prior0+1.0)/(prior1+1.0));
fval=0.0;

for i = 1:len 
    fApB=deci(i)*A+B;
    if (fApB >= 0)
        fval = fval + t(i)*fApB+log(1+exp(-fApB));
    else
        fval = fval + (t(i)-1)*fApB+log(1+exp(fApB));
    end
end

for it = 1:maxiter 
    %Update Gradient and Hessian (use H� = H + sigma I)
    h11=sigma;
    h22=sigma;
    h21= 0.0;
    g1=0.0;
    g2=0.0;
    for i = 1:len 
        fApB=deci(i)*A+B;
        if (fApB >= 0)
            p=exp(-fApB)/(1.0+exp(-fApB));
            q=1.0/(1.0+exp(-fApB));
        else
            p=1.0/(1.0+exp(fApB));
            q=exp(fApB)/(1.0+exp(fApB));
        end
        d2=p*q;
        h11 = h11 + deci(i)*deci(i)*d2;
        h22 = h22+ d2;
        h21 = h21+ deci(i)*d2;
        d1=t(i)-p;
        g1 = g1 + deci(i)*d1;
        g2 = g2+ d1;
    end
    if (abs(g1)<1e-5 && abs(g2)<1e-5) %Stopping criteria
        break
    end
    %Compute modified Newton directions
    det = h11*h22-h21*h21;
    dA = -(h22*g1-h21*g2)/det;
    dB = -(-h21*g1+h11*g2)/det;
    gd=g1*dA+g2*dB;
    stepsize=1;
    newA=A;
    newB=B;
    while (stepsize >= minstep) %Line search
        newA=A+stepsize*dA;
        newB=B+stepsize*dB; 
        newf=0.0;
        for i = 1:len 
            fApB=deci(i)*newA+newB;            
            if (fApB >= 0)
                newf = newf+ t(i)*fApB+log(1+exp(-fApB));
            else
                newf = newf+(t(i)-1)*fApB+log(1+exp(fApB));
            end
        end
        if (newf<fval+0.0001*stepsize*gd)
            A=newA; B=newB; fval=newf;
            break %Sufficient decrease satisfied        
        else
            stepsize = stepsize/ 2.0;
        end
    end
    if (stepsize < minstep)
        disp('Line search fails');
        break
    end
end
if (it >= maxiter)
    disp('Reaching maximum iterations');
end
model.probA = A;
model.probB = B;
end