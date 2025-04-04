function index = TournamentSelection(K,N,varargin)
%TournamentSelection - Tournament selection.
%
%   P = TournamentSelection(K,N,fitness1,fitness2,...) returns the indices
%   of N solutions by K-tournament selection based on their fitness values.
%   In each selection, the candidate having the MINIMUM fitness1 value will
%   be selected; if more than one candidates have the same minimum value of
%   fitness1, then compare their fitness2 values, and so on.
%
%   Example:
%       P = TournamentSelection(2,100,FrontNo)

% 中文注释
% P = TournamentSelection(K,N,fitness1,fitness2,...) 根据适应度值返回 K 锦标赛选择的 N 个解的索引。
% 在每次选择中，将选择具有最小适应度1值的候选者； 如果多个候选者具有相同的适应度 1 最小值，则比较他们的适应度 2 值，依此类推。

    varargin = cellfun(@(S)reshape(S,[],1),varargin,'UniformOutput',false);
    [~,rank] = sortrows([varargin{:}]);
    [~,rank] = sort(rank);
    Parents  = randi(length(varargin{1}),K,N);
    [~,best] = min(rank(Parents),[],1);
    index    = Parents(best+(0:N-1)*K);
end