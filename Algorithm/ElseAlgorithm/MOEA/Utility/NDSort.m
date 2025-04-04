function [FrontNo,MaxFNo] = NDSort(varargin)
%NDSort - Do non-dominated sorting by efficient non-dominated sort.
%
%   FrontNo = NDSort(F,s) does non-dominated sorting on F, where F is the
%   matrix of objective values of a set of individuals, and s is the number
%   of individuals to be sorted at least. FrontNo(i) denotes the front
%   number of the i-th individual. The individuals have not been sorted are
%   assigned a front number of inf.
%
%   FrontNo = NDSort(F,C,s) does non-dominated sorting based on constrained
%   domination, where C is the matrix of constraint values of the
%   individuals. In this case, feasible solutions always dominate
%   infeasible solutions, and one infeasible solution dominates another
%   infeasible solution if the former has a smaller overall constraint
%   violation than the latter.
%
%   In particular, s = 1 indicates finding only the first non-dominated
%   front, s = size(F,1)/2 indicates sorting only half the population
%   (which is often used in the algorithm), and s = inf indicates sorting
%   the whole population.
%
%   [FrontNo,K] = NDSort(...) also returns the maximum front number besides
%   inf.
%
%   Example:
%       [FrontNo,MaxFNo] = NDSort(PopObj,1)
%       [FrontNo,MaxFNo] = NDSort(PopObj,PopCon,inf)

% 中文注释
% NDSort - 通过高效的非支配排序进行非支配排序。
% FrontNo = NDSort(F,s) 对F进行非支配排序，其中F是一组个体的目标值矩阵，s是至少要排序的个体数。 
% FrontNo(i)表示第i个个体的前面编号。 尚未排序的个体被分配一个前序号 inf。
%
% 我的研究方向对这个用法涉及不到
% FrontNo = NDSort(F,C,s) 基于约束支配进行非支配排序，其中 C 是个体的约束值矩阵。 
% 在这种情况下，可行解总是支配不可行解，并且如果一个不可行解比后者具有更小的总体约束违规，则一个不可行解支配另一个不可行解。

% 
% 特别地，s = 1 表示仅查找第一个非支配前沿，s = size(F,1)/2 表示仅对一半总体进行排序（算法中经常使用），s = inf 表示对整个种群进行排序。
% [FrontNo,K] = NDSort(...) 还返回除 inf 之外的最大前面编号。
% 例子：
%     [FrontNo,MaxFNo] = NDSort(PopObj,1)
%     [FrontNo,MaxFNo] = NDSort(PopObj,PopCon,inf)

    PopObj = varargin{1};
    [N,M]  = size(PopObj);
    if nargin == 2
        nSort  = varargin{2};
    else
        PopCon = varargin{2};
        nSort  = varargin{3};
        Infeasible           = any(PopCon>0,2);
        PopObj(Infeasible,:) = repmat(max(PopObj,[],1),sum(Infeasible),1) + repmat(sum(max(0,PopCon(Infeasible,:)),2),1,M);
    end
    if M < 5 || N < 500
        % Use efficient non-dominated sort with sequential search (ENS-SS)
        [FrontNo,MaxFNo] = ENS_SS(PopObj,nSort);
    else
        % Use tree-based efficient non-dominated sort (T-ENS)
        [FrontNo,MaxFNo] = T_ENS(PopObj,nSort);
    end
end

% 常用的测试函数主要也就是在这个函数上进行操作
function [FrontNo,MaxFNo] = ENS_SS(PopObj,nSort)
    [PopObj,~,Loc] = unique(PopObj,'rows');  % 去除重复的个体，并获取唯一的个体及其位置
    Table   = hist(Loc,1:max(Loc));          % 统计每个唯一个体的出现次数
    [N,M]   = size(PopObj);                  % 获取个体数量和目标维度
    FrontNo = inf(1,N);                      % 初始化每个个体的非支配层级为无穷大
    MaxFNo  = 0;                             % 初始化最大非支配层级为0
    % 当前非支配排序的个体数量 小于 指定数量或唯一个体的数量时，进行排序
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        MaxFNo = MaxFNo + 1; % 非支配解层级更新
        % 遍历种群
        for i = 1 : N
            if FrontNo(i) == inf
                Dominated = false;
                % 与i前面已经分配层级的进行比较
                for j = i-1 : -1 : 1
                    if FrontNo(j) == MaxFNo
                        m = 2;
                        % 检查个体i是否被个体j支配
                        while m <= M && PopObj(i,m) >= PopObj(j,m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated || M == 2
                            break;
                        end
                    end
                end
                if ~Dominated
                    FrontNo(i) = MaxFNo;  % 如果个体i不被其他个体支配，则分配非支配层级
                end
            end
        end
    end
    FrontNo = FrontNo(:,Loc);  % 根据唯一个体的位置重排非支配层级
end

function [FrontNo,MaxFNo] = T_ENS(PopObj,nSort)
    [PopObj,~,Loc] = unique(PopObj,'rows');  % 去除重复的个体，并获取唯一的个体及其位置
    Table     = hist(Loc,1:max(Loc));  % 统计每个唯一个体的出现次数
	[N,M]     = size(PopObj);  % 获取个体数量和目标维度
    FrontNo   = inf(1,N);  % 初始化每个个体的非支配层级为无穷大
    MaxFNo    = 0;  % 初始化最大非支配层级为0
    Forest    = zeros(1,N);  % 初始化每个非支配层级的根节点
    Children  = zeros(N,M-1);  % 初始化每个节点的子节点
    LeftChild = zeros(1,N) + M;  % 初始化每个节点的左子节点
    Father    = zeros(1,N);  % 初始化每个节点的父节点
    Brother   = zeros(1,N) + M;  % 初始化每个节点的兄弟节点
    [~,ORank] = sort(PopObj(:,2:M),2,'descend');  % 根据目标值排序获取排序后的索引
    ORank     = ORank + 1;  % 将排序后的索引加1，以匹配Matlab的索引从1开始
    % 当前非支配排序的个体数量小于等于指定数量或唯一个体的数量时，进行排序
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        MaxFNo = MaxFNo + 1;  % 非支配层级递增
        root   = find(FrontNo==inf,1);  % 找到一个未分配非支配层级的根节点
        Forest(MaxFNo) = root;  % 将根节点加入当前非支配层级的树中
        FrontNo(root)  = MaxFNo;  % 分配非支配层级给根节点
        for p = 1 : N
            % 对尚未分配非支配层级的个体进行处理
            if FrontNo(p) == inf
                Pruning = zeros(1,N);  % 初始化修剪向量
                q = Forest(MaxFNo);  % 从当前非支配层级的树中选择一个节点
                while true
                    m = 1;
                    while m < M && PopObj(p,ORank(q,m)) >= PopObj(q,ORank(q,m))
                        m = m + 1;
                    end
                    if m == M
                        break;
                    else
                        Pruning(q) = m;
                        if LeftChild(q) <= Pruning(q)
                            q = Children(q,LeftChild(q));
                        else
                            while Father(q) && Brother(q) > Pruning(Father(q))
                                q = Father(q);
                            end
                            if Father(q)
                                q = Children(Father(q),Brother(q));
                            else
                                break;
                            end
                        end
                    end
                end
                if m < M
                    FrontNo(p) = MaxFNo;  % 分配非支配层级给个体
                    q = Forest(MaxFNo);
                    while Children(q,Pruning(q))
                        q = Children(q,Pruning(q));
                    end
                    Children(q,Pruning(q)) = p;  % 将个体添加为当前节点的子节点
                    Father(p) = q;  % 设置个体的父节点
                    if LeftChild(q) > Pruning(q)
                        Brother(p)   = LeftChild(q);
                        LeftChild(q) = Pruning(q);
                    else
                        bro = Children(q,LeftChild(q));
                        while Brother(bro) < Pruning(q)
                            bro = Children(q,Brother(bro));
                        end
                        Brother(p)   = Brother(bro);
                        Brother(bro) = Pruning(q);
                    end
                end
            end
        end
    end
    FrontNo = FrontNo(:,Loc);  % 根据唯一个体的位置重排非支配层级
end