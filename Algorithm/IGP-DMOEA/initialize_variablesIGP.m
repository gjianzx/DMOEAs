function f = initialize_variablesIGP(N, M, V, min_range, max_range)

% functions = {'FDA4', 'FDA5', 'FDA5_iso', 'FDA5_dec', 'DIMP2', 'dMOP2', ...
%         'dMOP2_iso', 'dMOP2_dec', 'dMOP3', 'HE2', 'HE7', 'HE9'};
% [~, ~, Ft] = getFunc(functions{testfunc});
% CostFunction = @(x)Ft(x, t);

%% function f = initialize_variables(N, M, V, min_tange, max_range) 
% This function initializes the chromosomes. Each chromosome has the
% following at this stage
%       * set of decision variables
%       * objective function values
% 
% where,
% N - Population size
% M - Number of objective functions
% V - Number of decision variables
% min_range - A vector of decimal values which indicate the minimum value
% for each decision variable.
% max_range - Vector of maximum possible values for decision variables.

min = min_range;
max = max_range;

% K is the total number of array elements. For ease of computation decision
% variables and objective functions are concatenated to form a single
% array. For crossover and mutation only the decision variables are used
% while for selection, only the objective variable are utilized.

K = M + V;

%% Initialize each chromosome
% For each chromosome perform the following (N is the population size)
for i = 1 : N
    % Initialize the decision variables based on the minimum and maximum
    % possible values. V is the number of decision variable. A random
    % number is picked between the minimum and maximum possible values for
    % the each decision variable.
    for j = 1 : V
        f(i,j) = min(j) + (max(j) - min(j))*rand(1);
    end
    % For ease of computation and handling data the chromosome also has the
    % vlaue of the objective function concatenated at the end. The elements
    % V + 1 to K has the objective function valued. 
    % The function evaluate_objective takes one chromosome at a time,
    % infact only the decision variables are passed to the function along
    % with information about the number of objective functions which are
    % processed and returns the value for the objective functions. These
    % values are now stored at the end of the chromosome itself.
%     f(i,V + 1: K) = CostFunction(f(i,1:V));
end
