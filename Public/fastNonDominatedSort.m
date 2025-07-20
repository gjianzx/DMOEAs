function [pRank,SetDominamt,NumDom] = fastNonDominatedSort(A,CompIndex)
% 快速非支配排序：根据比较指示变量CompIndex进行比较
% 参考文献：A fast and elitist multiobjective genetic algorithm:NSGA-II（2002年IEEE）
% 
% 输入参数 CompIndex 的设定原则：（可以不输入，默认是越小越好）
% 如果越小越好(越小的值越排前面),其值设定为1(默认)：即更小的值支配更大的值
% 如果越大越好(越大的值越排前面),其值设定为-1     ：即更大的值支配更小的值
% 
% CompIndex 的值只能是 +1 或 -1
% 如果CompIndex(ii) == 1表示按照从小到大比较（默认）:取 < 号
% 如果CompIndex(ii) == -1表示按照从大到小比较：      取 > 号
%
% pareto级别：pRank(ii)==1表示最高级别，表示没有其他个体支配该个体ii
% 支配集SetDominamt(ii):表示个体ii支配的其他个体（编号）
% NumDom(ii)：表示支配个体ii的其他个体数量，即比个体ii更好的个体数量
%
% 例子：A = [1 8;2 6;3 4;2 5;4 9;4 10]; 
% 如果第一列和第二列都默认是越小越好，则CompIndex = [1 1];
% 执行代码：[pRank,SetDominamt,NumDom] = fastNonDominatedSort(A,CompIndex);
%   或：    [pRank,SetDominamt,NumDom] = fastNonDominatedSort(A);
% 类似地，如果第一列是越小越好，而第二列是越大越好，则CompIndex = [1 -1];
% 执行代码：[pRank,SetDominamt,NumDom] = fastNonDominatedSort(A,CompIndex);
% 
% Input
% A                                          - 数据矩阵，行表示个体或样本，列表示属性或指标
% CompIndex                         - 比较的指示参数，1*size(A,2)，其列数等于A的列数
% 
% Output
% pRank                                   - 所有个体的pareto级别，数值越小级别越高
% SetDominamt                      - 所有个体的支配集，cell型
% NumDom                             - 所有个体被其他支配的数量
%
%  ---------------------------------------------


if (nargin < 2) || (isempty(CompIndex)), CompIndex = ones(1,size(A,2)); end

N = size(A,1);                                             % 个体或样本数目

% SetDominamt(ii)表示第ii个个体所支配的个体（实际存储的所支配个体的编号信息）
SetDominamt = cell(1,N);                         % 所有个体的支配集：论文中的S_p
NumInSetD = zeros(1,N);                          % 所有个体的支配集中的个体数量

NumDominated = zeros(1,N);                       % 所有个体被其他个体所支配的数量:论文中的n_p
pRank = zeros(1,N);                                        % 所有个体所在前沿front的序号：论文中的p_rank

Front1 = [];

for ii = 1:N
    Sp = [];                                       % 临时存储的第ii个个体的支配集(实际为所支配的个体编号集合)
    % NumDominated(ii) = 0;
    % 和其他N-1个个体比较，是支配还是被支配，这里也和自身比较(不增加识别语句)
    for jj = 1:N                                 % 和其他N-1个个体比较，是支配还是被支配
        Index = Dominant2VecMin(A(ii,:),A(jj,:),CompIndex);
        if Index == 1                            % 个体ii支配个体jj
            Sp = [Sp jj];                         % 将个体jj加入其支配集
            NumInSetD(ii) = NumInSetD(ii) + 1;
        elseif Index == -1                       % 个体jj支配个体ii(ii被jj支配)
            NumDominated(ii) = NumDominated(ii) + 1; % ii被支配数量递增1
        end
    end
    % SetDominamt(ii) = Sp;
    SetDominamt{ii} = Sp;
    
    if NumDominated(ii) == 0                     % ii没有被其他个体支配
        pRank(ii) = 1;                              % 个体ii属于第一级前沿：first front
        Front1 = [Front1,ii];                    % 将个体ii加入第一级前沿
    end
end

NumDom = NumDominated;                           % 后面会变化，另存为NumDom以便输出

curFrontID = 1;                                              % 当前处理的前沿编号：论文中的i=1

CurFront = Front1;                                         % 当前处理的前沿：论文中的F_i
NumInFront = length(CurFront);                   % 当前前沿中的个体数量

while NumInFront > 0                             % 当前第curFrontID前沿非空
    Q = [];                                                 % 用来存储下一级前沿所含个体的集合容器
    for ii = 1:NumInFront                        % 对当前前沿F_i中的每一个p进行判别
        pInFront = CurFront(ii);                 % 论文中的 p 属于 F_i
        Sp = cell2mat(SetDominamt(pInFront));    % p的支配集
        for jj = 1:NumInSetD(pInFront)
            qID = Sp(jj);                                        % 论文中的 q 属于 S_p
            NumDominated(qID) = NumDominated(qID) - 1; % 论文中的 n_q = n_q - 1
            if NumDominated(qID) == 0            % q属于下一级前沿
                pRank(qID) = curFrontID + 1;     % 给个体q赋前沿等级值
                Q = [Q,qID];                                 % 将个体q加入下一前沿集
            end
        end
    end
    curFrontID = curFrontID + 1;                 % 给下一级前沿序号赋值
    CurFront = Q;                                         % 确定下一级前沿所含个体(编号)
    NumInFront = length(Q);                      % 当前前沿所含个体数量
end

% end of function fastNonDominatedSort
%%


function Index = Dominant2VecMin(v1,v2,CompIndex)
% 如果不指定CompIndex的值，默认是越小越好
% 输入参数 CompIndex 的设定原则：
% 如果越小越好(越小的值越排前面),其值设定为1(默认)：即更小的值支配更大的值
% 如果越大越好(越大的值越排前面),其值设定为-1     ：即更大的值支配更小的值
% CompIndex 的值只能是 +1 或 -1
% 
% Input
% v1                                       - 个体向量1,1*n或n*1
% v2                                       - 个体向量2,1*n或n*1
% CompIndex                        - 比较的指示参数
% 
% Output
% 返回 Index 的值，0表示相等或没有结果
% Index == 1:  表示 v1 支配 v2 (v1在v2前面, v2在v1后面)
% Index == -1: 表示 v2 支配 v1（v2在v1前面, v1在v2后面）
% 

if (nargin < 3) || (isempty(CompIndex)), CompIndex = ones(size(v1)); end
n = length(v1);

V1 = v1 .* CompIndex;
V2 = v2 .* CompIndex;

num1 = sum(V1 <= V2);
num2 = sum(V1 < V2);
equalNum = num1 - num2;

num3 = sum(V1 > V2);

if (num3 > 0) && ((equalNum + num3) == n)
    Index = -1;
elseif (num2 > 0) && ((equalNum + num2) == n)
    Index = 1;
else
    Index = 0;
end

% end of function Dominant2VecMin
%%

