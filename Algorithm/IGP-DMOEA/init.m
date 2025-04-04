function [objDim, parDim, idealp, params, subproblems]=init(mop, t, propertyArgIn, newpop)
%Set up the initial setting for the MOEA/D.
    objDim=mop.NObj;
    parDim=length(mop.XUpp);    
    idealp=ones(objDim,1)*inf;
    
    %the default values for the parameters.
   % params.popsize=200;params.niche=20;params.iteration=50;
   % params.dmethod='te';
    params.F = 0.1;
    params.CR = 1;
    
    %handle the parameters, mainly about the popsize
    while length(propertyArgIn)>=2
        prop = propertyArgIn{1};
        val=propertyArgIn{2};
        propertyArgIn=propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize=val;            
            case 'niche'
                params.niche=val;
            case 'iteration'
                params.iteration=val;
            case 'method'
                params.dmethod=val;
            otherwise
                warning('moea doesnot support the given parameters name');
        end
    end
    
    subproblems = init_weights(params.popsize, params.niche, objDim);
    params.popsize = length(subproblems);
    
    %initial the subproblem's initital state.
   if nargin==3
    %CostFunction = mop.func(x, t0);
    inds = randompoint(mop, params.popsize);
   else
    indv = struct('parameter',[],'objective',[], 'estimation', []);
    inds = repmat(indv, 1, params.popsize);
    cellpoints = num2cell(newpop, 1);
    [inds.parameter] = cellpoints{:};
   end
    v=[];
    for i=1:params.popsize
        inds(i).objective = mop.FObj(inds(i).parameter,t);
        v = [v inds(i).objective];
       [subproblems(i).curpoint] = inds(i) ;
    end
    
    idealp = min(idealp, min(v,[],2));
    
    clear inds indcells;
end