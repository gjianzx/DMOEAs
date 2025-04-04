function [PopX,Pareto,POF_iter]=moead( Problem,popSize,MaxIt, t,init_pop)

% if isfield(Problem,'FObj')
    CostFunction=Problem.FObj;  % Cost Function  代价函数
% else
     mesh_data = load('./Application/mesh_data/init_mesh.txt'); % 作为环境变化前的初始网格数据
%     CostFunction = @MeshOptimization;  % 网格优化的代价函数
% end

nVar=size(Problem.XLow,1);             % Number of Decision Variables
VarSize=[nVar 1];   % Decision Variables Matrix Size
VarMin = 0;         % Decision Variables Lower Bound
VarMax = 1;         % Decision Variables Upper Bound
nObj=Problem.NObj;


%% MOEA/D Settings


nPop=popSize;    % Population Size (Number of Sub-Problems)
nArchive=50;
T=max(ceil(0.15*nPop),2);    % Number of Neighbors
T=min(max(T,2),15);

crossover_params.gamma=0.8;
crossover_params.VarMin=VarMin;
crossover_params.VarMax=VarMax;

%% Initialization

% Create Sub-problems
sp=CreateSubProblems(nObj,nPop,T);

% Empty Individual
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.g=[];
empty_individual.IsDominated=[];

% Initialize Goal Point
%z=inf(nObj,1);
z=zeros(nObj,1);

% Create Initial Population
pop=repmat(empty_individual,nPop,1);
if nargin == 4
    for i=1:nPop
        if strcmp(func2str(Problem.FObj), 'MeshOptimization')
           pop(i).Position=mesh_data(:)*rand; 
        else
           pop(i).Position=unifrnd(VarMin,VarMax,VarSize); % unifrnd生成均匀分布的随机数,随机生成种群            
        end 
        % pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
        pop(i).Cost=CostFunction(pop(i).Position',t);
        z=min(z,pop(i).Cost);
    end
elseif nargin == 5
    
    for i=1:size(init_pop,2)
        pop(i).Position=init_pop(:,i);
        pop(i).Cost=CostFunction(pop(i).Position',t);
        z=min(z,pop(i).Cost);
    end
    
    for i=size(init_pop,2)+1:nPop
        if strcmp(func2str(Problem.FObj), 'MeshOptimization')
           pop(i).Position=mesh_data(:)*rand; 
        else
           pop(i).Position=unifrnd(VarMin,VarMax,VarSize); % unifrnd生成均匀分布的随机数,随机生成种群            
        end 
        % pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
        pop(i).Cost=CostFunction(pop(i).Position',t);
        z=min(z,pop(i).Cost);
    end
end

for i=1:nPop
    pop(i).g=DecomposedCost(pop(i),z,sp(i).lambda);
end

% Determine Population Domination Status
pop=DetermineDomination(pop);

% Initialize Estimated Pareto Front
EP=pop(~[pop.IsDominated]);

%% Main Loop

for it=1:MaxIt
    for i=1:nPop
        
        % Reproduction (Crossover)
        K=randsample(T,2);
        
        j1=sp(i).Neighbors(K(1));
        p1=pop(j1);
        
        j2=sp(i).Neighbors(K(2));
        p2=pop(j2);
        
        y=empty_individual;
        y.Position=M_Crossover(p1.Position,p2.Position,crossover_params);
 
        y.Cost=CostFunction(y.Position',t);
        
        z=min(z,y.Cost);
        
        for j=sp(i).Neighbors
            y.g=DecomposedCost(y,z,sp(j).lambda);
            if y.g<=pop(j).g
                pop(j)=y;
            end
        end
        
    end
    
    % Determine Population Domination Status
	pop=DetermineDomination(pop);
    
    ndpop=pop(~[pop.IsDominated]);
    
    EP=[EP
        ndpop]; %#ok
    
    EP=DetermineDomination(EP);
    EP=EP(~[EP.IsDominated]);
    
    if numel(EP)>nArchive
        Extra=numel(EP)-nArchive;
        ToBeDeleted=randsample(numel(EP),Extra);
        EP(ToBeDeleted)=[];
    end
    
    % Plot EP
%     figure(1);
%     PlotCosts(EP);
%     pause(0.01);
    for arcnum=1: size(EP,1)
        pareto(:,arcnum)=EP(arcnum).Cost; 
    end
   POF_iter{it}=pareto;
    % Display Iteration Information
%     disp(['Iteration ' num2str(it) ': Number of Pareto Solutions = ' num2str(numel(EP))]);
    
end
%Pareto.F=POF_iter{end};
Pareto.F=[EP.Cost];
Pareto.X=[EP.Position];
PopX=Pareto.X;
%% Reults


end
