function subproblems = evolve(t, subproblems, mop, params)
    global idealpoint;
   
    for i=1:params.iteration%length(subproblems)
        %new point generation using genetic operations, and evaluate it.
        domain=[mop.XUpp,mop.XLow];
        ind = genetic_op(subproblems, i, domain, params);
        ind.objective = mop.FObj(ind.parameter,t);
        %[obj,ind] = evaluate(mop, ind);
        %update the idealpoint.
        idealpoint = min(idealpoint, ind.objective);
        
        %update the neighbours.
        neighbourindex = subproblems(i).neighbour;
        subproblems(neighbourindex) = update(subproblems(neighbourindex),ind, idealpoint);
        %clear ind obj neighbourindex neighbours;        

        clear ind obj neighbourindex;
    end
end

function subp =update(subp, ind, idealpoint)
    global params
    
    newobj=subobjective([subp.weight], ind.objective,  idealpoint, params.dmethod);
    oops = [subp.curpoint]; 
    oldobj=subobjective([subp.weight], [oops.objective], idealpoint, params.dmethod );
    
    C = newobj < oldobj;
    [subp(C).curpoint]= deal(ind);
    clear C newobj oops oldobj;
end