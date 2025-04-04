% MCP_PROBABILISTIC - estimates probabilities using
%                     Algorithm 2 from
%                     "Probability Estimates for Multi-class Classification by Pairwise Coupling", Wu et al. 2004
%
% Syntax: p = mcp_probabilistic(k, pw_probs)
%

function p = mcp_probabilistic(k, pw_probs)


    counter=1;    
    for i=1:k
        for j=i+1:k
            r(i,j)=pw_probs(counter);
            r(j,i)=1-pw_probs(counter);
            counter =counter+1;
        end
    end
 
	iter = 0;
    max_iter=100;
	Q = zeros(k,k);
	Qp = zeros(1,k);
	pQp =0;
    eps=0.005/k;
	
	for t=1:k
		p(t)=1.0/k;  % Valid if k = 1		
		Q(t,t)=0;
		for j=1:t
			Q(t,t) = Q(t,t) + r(j,t)*r(j,t);
			Q(t,j) = Q(j,t);
        end
		for j=t+1:k
			Q(t,t) = Q(t,t) + r(j,t)*r(j,t);
			Q(t,j) = -r(j,t)*r(t,j);
        end
    end
    
    
	for (iter=1:max_iter)
		% stopping condition, recalculate QP,pQP for numerical accuracy
		pQp=0;
		for t=1:k
			Qp(t)=0;
			for (j=1:k)
                Qp(t) = Qp(t) + Q(t,j)*p(j);
            end
			pQp = pQp + p(t)*Qp(t);
        end
		max_error=0;
		for (t=1:k)		
			error = abs(Qp(t)-pQp);
			if (error>max_error)
				max_error=error;
            end
        end
		if (max_error<eps) 
            break;
        end
		
		for (t=1:k)		
			diff=(-Qp(t)+pQp)/Q(t,t);
			p(t) = p(t)+diff;
			pQp=(pQp+diff*(diff*Q(t,t)+2*Qp(t)))/(1+diff)/(1+diff);
			for (j=1:k)
				Qp(j)=(Qp(j)+diff*Q(t,j))/(1+diff);
				p(j)=p(j)/(1+diff);
            end
        end
   end
	if (iter>=max_iter)
		disp('Exceeds max_iter in multiclass_prob');
    end
end