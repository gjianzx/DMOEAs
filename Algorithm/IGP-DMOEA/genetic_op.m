function [ind,PP] = genetic_op(subproblems, index, domain, params)
%GENETICOP function implemented the DE operation to generate a new
%individual from a subproblems and its neighbours.

%   subproblems: is all the subproblems.
%   index: the index of the subproblem need to handle.
%   domain: the domain of the origional multiobjective problem.
%   ind: is an individual structure.


si = ones(1,3)*index;
si(1)=index;

delta = 0.1;
if rand < delta
    neighbourindex = subproblems(index).neighbour; 
    %The random draw from the neighbours.
    nsize = length(neighbourindex);
    PP = randperm(nsize);
    si(2)=neighbourindex(PP(1));       
    si(3)=neighbourindex(PP(2));    
else
    N=params.popsize;
    PP = randperm(N);
    si(2)=PP(1);
    si(3)=PP(2);
end
%retrieve the individuals.
points = [subproblems(si).curpoint];
selectpoints = [points.parameter];

oldpoint = subproblems(index).curpoint.parameter;
parDim = size(domain, 1);
jrandom = ceil(rand*parDim);

randomarray = rand(parDim, 1);
deselect = randomarray<params.CR;
deselect(jrandom)=true;
newpoint = selectpoints(:,1)+params.F*(selectpoints(:,2)-selectpoints(:,3));
newpoint(~deselect)=oldpoint(~deselect);

%repair the new value.
newpoint=max(newpoint, domain(:,1));
newpoint=min(newpoint, domain(:,2));

ind = struct('parameter',newpoint,'objective',[], 'estimation',[]);
 ind = polynomial_mutate(ind, domain(:,1)', domain(:,2)');

%clear points selectpoints oldpoint randomarray deselect newpoint neighbourindex si;
end