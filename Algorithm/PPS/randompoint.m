function ind = randompoint(Problem, n)
%RANDOMNEW to generate n new point randomly from the mop problem given.

if (nargin==1)
    n=1;
end

randarray = rand(size(Problem.XLow,1), n);
Problem.domain=[Problem.XLow Problem.XUpp];
lowend = Problem.domain(:,1);
span = Problem.domain(:,2)-lowend;
point = randarray.*(span(:,ones(1, n)))+ lowend(:,ones(1,n));
cellpoints = num2cell(point, 1);

indiv = struct('parameter',[],'objective',[], 'estimation', []);
ind = repmat(indiv, 1, n);
[ind.parameter] = cellpoints{:};

% estimation = struct('obj', NaN ,'std', NaN);
% [ind.estimation] = deal(repmat(estimation, Problem.od, 1));
end
