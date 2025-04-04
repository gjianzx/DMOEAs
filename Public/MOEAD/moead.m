function [PopX,Pareto,POF_iter]=moead( Problem,popSize,MaxIt,t,init_pop)
% if isfield(Problem,'FObj')
    CostFunction=Problem.FObj;  % Cost Function  代价函数
% else
    mesh_data = load('./Application/mesh_data/init_mesh.txt'); % 作为环境变化前的初始网格数据
%     CostFunction = @MeshOptimization;  % 网格优化的代价函数
% end
nVar=size(Problem.XLow,1);  % Number of Decision Variables    
VarSize=[nVar 1];           % Decision Variables Matrix Size  
VarMin = Problem.XLow;      % Decision Variables Lower Bound  最小边界值
VarMax = Problem.XUpp;      % Decision Variables Upper Bound  最大边界值
nObj=Problem.NObj;          % 该问题的目标数量

%% MOEA/D Settings

nPop=popSize;               % Population Size (Number of Sub-Problems) 种群大小
nArchive=popSize;
T=max(ceil(0.15*nPop),2);   % Number of Neighbors 
T=min(max(T,2),15);         % 相邻个体的个数，至少保证两个相邻个体，最大15个

GenOperator_params.gamma=0.8;      
GenOperator_params.VarMin=VarMin;
GenOperator_params.VarMax=VarMax;

%% Initialization

% Create Sub-problems
sp=CreateSubProblems(nObj,nPop,T);

% Empty Individual   empty_individual为一个结构体
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.g=[];
empty_individual.IsDominated=[];

% Initialize Goal Point  初始化目标点
%z=inf(nObj,1);
z=zeros(nObj,1);

% Create Initial Population
pop=repmat(empty_individual,nPop,1);  % 创建一个nPop*1的结构体数组

if nargin == 4     % 判断函数输入参数数量，当前为4，即计算种群前两代的位置和适应值
    for i=1:nPop   
        if strcmp(func2str(Problem.FObj), 'MeshOptimization')
           pop(i).Position=mesh_data(:)*rand; 
        else
           pop(i).Position=unifrnd(VarMin,VarMax,VarSize); % unifrnd生成均匀分布的随机数,随机生成种群            
        end                
        pop(i).Cost=CostFunction(pop(i).Position',t);   % 评估种群
        z=min(z,pop(i).Cost);
    end
elseif nargin == 5  % 当前的参数为5，对预测的种群进行评估
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
        pop(i).Cost=CostFunction(pop(i).Position',t);
        z=min(z,pop(i).Cost);
    end
end

for i=1:nPop
    pop(i).g=DecomposedCost(pop(i),z,sp(i).lambda);
end

% Determine Population Domination Status
pop=DetermineDomination(pop);

% Initialize Estimated Pareto Front 初始评估的Pareto前沿
EP=pop(~[pop.IsDominated]);   % 初始的非支配解构成的帕累托前沿

%% Main Loop

for it=1:MaxIt       % 在静态优化器中，算法迭代MaxIt次
    for i=1:nPop
        
        % Reproduction (Crossover)
        K=randsample(T,2);   % 从1到T中无放回随机均匀选择2个值，是一个列向量
        j1=sp(i).Neighbors(K(1));
        p1=pop(j1);
        
        j2=sp(i).Neighbors(K(2));
        p2=pop(j2);
        
        y=empty_individual;  % 取别名
        
        % 执行变异交叉操作
        y.Position = GeneticOperator(p1.Position,p2.Position,GenOperator_params);%SBX
        y.Cost=CostFunction(y.Position',t);
       
        z=min(z,y.Cost);
        for j=sp(i).Neighbors
            y.g=DecomposedCost(y,z,sp(j).lambda);
            if y.g<=pop(j).g
                pop(j)=y;
            end
        end
    end
    
    %Determine Population Domination Status
	pop=DetermineDomination(pop);    % 判断是否为支配解
    ndpop=pop(~[pop.IsDominated]);   % 用于选择非支配解
    EP=[EP
        ndpop]; %#ok      EP 为外部存档
    
    EP=DetermineDomination(EP); % 判断解集中解的类型
    EP=EP(~[EP.IsDominated]);   % 更新非支配解
    
    if numel(EP)>nArchive       % numel:返回数组EP中元素总数
        Extra=numel(EP)-nArchive;   
        ToBeDeleted=randsample(numel(EP),Extra); % 清除外部存档中多余的变量
        EP(ToBeDeleted)=[];
    end
   
    for arcnum=1: size(EP,1)
        pareto(:,arcnum)=EP(arcnum).Cost;    % 从外部存档中提取Pareto最优解作为前沿
    end
   POF_iter{it}=pareto;
end

Pareto.F=[EP.Cost];
Pareto.X=[EP.Position];
PopX = zeros(size(Problem.XLow,1),popSize);  % 种群的表示形式为 决策变量*种群大小（10*100）的矩阵
for i=1:popSize
   PopX(:,i) = pop(i).Position;
end

end
