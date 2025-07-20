function Pareto = RMMEDA( Problem, Generator, NIni, MaxIter, t, init_population)

%%
% Pareto = RMMEDA( Problem, Generator, NIni, MaxIter ) returns a
%   set of nondomianted solutions of Problem.FObj
%
%     Regularity Model based Multiobjective Estimation of Distribution
%     Algorithm (RM-MEDA), see Q. Zhang, A. Zhou, Y. Jin. 'Modelling the
%     Regularity in an Estimation of Distribution Algorithm for Continuous 
%     Multiobjective Optimisation with Variable Linkages'
%     (http://cswww.essex.ac.uk/staff/qzhang/mypublication.htm) for more
%     details.
%
%     Parameters:
%     Problem - define test probelm
%       Problem.FObj - objective functions 
%                      [F, V] = FObj(X)
%                       X is decision vector, 
%                       F is objective vector, 
%                       V = |h1(X)|+ |h2(X)| + ... + |hk(X)| +
%                       max(0,hk+1(X)) + ... + max(0,hp(X) is constraint vialation 
%                    - a mulit-objective problem must be the following fomulas
%                       Min   F(X) = (f1(X),f2(X),...,fm(X))
%                       s.t: hi(X) =  0 , i=1,2,...,k
%                            hj(X) <= 0 , j=k+1,...,p
%       Problem.XLow - lower boundary of search space
%       Problem.XUpp - upper boundary of search space
%       Problem.NObj - number of objectives
%     Generator - method to create new trial solutions
%       Generator.Name - method name
%       Generator.NClu - number of clusters (used only for model based generators)
%       Generator.Iter - trainning steps in generator
%       Generator.Exte - extention ratio
%     NIni      - number of initial population defined by experimental design
%     MaxIter   - maximum iterations
%     Returns:
%     Pareto.X      - Pareto Set
%     Pareto.F      - Pareto Front
%     Pareto.V      - constraint vialation 
%     Pareto.Neva   - number of function evaluations
%
%	Copyright (c) Aimin Zhou (2006)
%     Department of Computer Science
%     University of Essex
%     Colchester, U.K, CO4 3SQ
%     amzhou@gmail.com
%
% History:
%     13/10/2006 create


%% Step 0: define and set algorithm parameters
assert(nargin >= 5);
Pareto.Neva     = 0;                        % function evaluations
DX              = size(Problem.XLow,1);     % dimension of decision variables
PopF            = ones(Problem.NObj, NIni); % population (F)
PopV            = ones(1, NIni);            % constraint vialation
TriF            = ones(Problem.NObj, NIni); % trial population (F)
TriV            = ones(1, NIni);            % constraint vialation
DLat            = Problem.NObj-1;           % dimension of latent variable space
LInd            = ones(DX,NIni);
%% Step 1: initialize population
if nargin == 5
    for i=1:1:DX
        LInd(i,:)   = randperm(NIni);
    end
    PopX    = (LInd - rand(DX,NIni))/NIni .* ((Problem.XUpp-Problem.XLow)*ones(1,NIni)) + Problem.XLow*ones(1,NIni);
    for i=1:1:NIni
        [PopF(:,i),PopV(:,i)] = Problem.FObj(PopX(:,i)',t);
    end
end
if nargin == 6
    if size(init_population,1)< NIni
        newpop = addNoise(init_population, NIni, size(init_population,2));
        PopX = [init_population' newpop'];
    else
        PopX = init_population';
    end
    for i=1:1:size(PopX,2)
        [PopF(:,i),PopV(:,i)] = Problem.FObj(PopX(:,i)',t);
    end    
end

Pareto.Neva    = Pareto.Neva + NIni;
clear LInd;
%% Step 2: main iterations
for iter=1:MaxIter
    % Step 2.1: generate new trial solutions
    TriX = LPCAGenerator(PopX, Problem.XLow, Problem.XUpp, NIni, DX, DLat, Generator.NClu, Generator.Iter, Generator.Exte);   
    % Step 2.2: evaluate new trial solutions
    for i=1:1:NIni
        [TriF(:,i),TriV(:,i)] = Problem.FObj(TriX(:,i)',t);
    end
    Pareto.Neva    = Pareto.Neva + NIni;
    % Step 2.3: selecte some points to be evaluated by the true objective
    F       = [PopF,TriF];
    X       = [PopX,TriX];
    V       = [PopV,TriV];
    [PopF,PopX,PopV]   = MOSelector( F, X, V, NIni ); 
    [Pareto.F,Pareto.X,Pareto.V] = ParetoFilter(PopF,PopX,PopV);
    

end
