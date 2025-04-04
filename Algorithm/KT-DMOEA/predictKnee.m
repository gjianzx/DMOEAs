function initPop=predictKnee(w,individualsX,num)
    
    bw=0.05*ones(size(individualsX,2),1);
    p = kde(individualsX', bw,w');
   
    initPop = sample(p,num)';    
    
end





