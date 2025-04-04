% SVMTRAIN - Trains a support vector machine incrementally
%            using the L1 soft margin approach developed by
%            Cauwenberghs for two-class problems.
%
% Syntax: [a,b,g,ind,uind,X_mer,y_mer,Rs,Q] = svmtrain(X,y,C,type,scale)
%         [a,b,g,ind,uind,X_mer,y_mer,Rs,Q] = svmtrain(X,y,C,type,scale,uind)
%         (trains a new SVM on the given examples)
%
%         [a,b,g,ind,uind,X_mer,y_mer,Rs,Q] = svmtrain(X,y,C)
%         [a,b,g,ind,uind,X_mer,y_mar,Rs,Q] = svmtrain(X,y,C,uind)
%         (trains the current SVM in memory on the given examples)
%
%      a: alpha coefficients
%      b: bias
%      g: partial derivatives of cost function w.r.t. alpha coefficients
%    ind: cell array containing indices of margin, error and reserve vectors
%         ind{1}: indices of margin vectors
%         ind{2}: indices of error vectors
%         ind{3}: indices of reserve vectors
%   uind: column vector of user-defined example indices (used for unlearning specified examples)
%  X_mer: matrix of margin, error and reserve vectors stored columnwise
%  y_mer: column vector of class labels (-1/+1) for margin, error and reserve vectors
%     Rs: inverse of extended kernel matrix for margin vectors
%      Q: extended kernel matrix for all vectors
%      X: matrix of training vectors stored columnwise
%      y: column vector of class labels (-1/+1) for training vectors
%      C: soft-margin regularization parameter(s)
%         dimensionality of C       assumption
%         1-dimensional vector      universal regularization parameter
%         2-dimensional vector      class-conditional regularization parameters (-1/+1)
%         n-dimensional vector      regularization parameter per example
%         (where n = # of examples)
%   type: kernel type
%           1: linear kernel        K(x,y) = x'*y
%         2-4: polynomial kernel    K(x,y) = (scale*x'*y + 1)^type
%           5: Gaussian kernel with variance 1/(2*scale)
%  scale: kernel scale
%

function [model] = svmtrain(X_new,y_new,C_new,varargin)

% flags for example state
MARGIN    = 1;
ERROR     = 2;
RESERVE   = 3;
UNLEARNED = 4;

% create a vector containing the regularization parameter 
% for each example if necessary
if (length(C_new) == 1)              % same regularization parameter for all examples
   C_new = C_new*ones(size(y_new));    
elseif (length(C_new) == 2)          % class-conditional regularization parameters
   flags = (y_new == -1);
   C_new = C_new(1)*flags + C_new(2)*(~flags);
end;

if (nargin >= 5 && ~isempty(varargin{1}) && ~isempty(varargin{2}))
   
   % define arguments      
   type_new = varargin{1};
   scale_new = varargin{2};
   if (nargin == 6)
      uind_new = varargin(3);
   else
      uind_new = zeros(size(y_new));
   end;
         
   new_model = 1;   
else
   
   % define arguments
   if (nargin >= 4 && ~isempty(varargin(1)))
      uind_new = varargin(1);
   else
      uind_new = zeros(size(y_new));
   end;      
      
   new_model = 0;   
end;

% % define global variables 
% global a;                     % alpha coefficients
% global b;                     % bias
% global C;                     % regularization parameters 
% global deps;                  % jitter factor in kernel matrix
% global g;                     % partial derivatives of cost function w.r.t. alpha coefficients
% global ind;                   % cell array containing indices of margin, error, reserve and unlearned vectors
% global kernel_evals;          % kernel evaluations
% global max_reserve_vectors;   % maximum number of reserve vectors stored
% global perturbations;         % number of perturbations
% global Q;                     % extended kernel matrix for all vectors
% global Rs;                    % inverse of extended kernel matrix for margin vectors   
% global scale;                 % kernel scale
% global type;                  % kernel type
% global uind;                  % user-defined example indices
% global X;                     % matrix of margin, error, reserve and unlearned vectors stored columnwise
% global y;                     % column vector of class labels (-1/+1) for margin, error, reserve and unlearned vectors
global model;



if size(X_new,2) ~= size(y_new,1)
    error('X and Y dont have right dimensions or the same number of samples');
end

uy = unique(y_new);
if length(uy)>2
    error('more than 2 classes not supported at this point');
end
% if uy(1)~=-1 || (length(uy)==uy(2)~=1
%     error('class labels must be -1 and 1');
% end

if (new_model)
    model = struct();
    % initialize variables
    model.deps = 1e-3;
    model.max_reserve_vectors = 3000;    
      num_examples = size(X_new,2);       
   
   model.a = zeros(num_examples,1);          
   model.b = 0;                              
   model.C = C_new;                          
   model.g = zeros(num_examples,1);
   model.ind = cell(4,1);
   model.ind{UNLEARNED} = 1:num_examples;
   model.kernel_evals = 0;
   model.perturbations = 0;
   model.Q = y_new';
   model.Rs = Inf;
   model.scale = scale_new;
   model.type = type_new;
   model.uind = uind_new;
   model.X = X_new;                          
   model.y = y_new;

else   
   num_examples = size(model.X,2);
   num_new_examples = size(X_new,2);
   
   model.a = [model.a ; zeros(num_new_examples,1)];
   model.C = [model.C ; C_new];
   model.g = [model.g ; zeros(num_new_examples,1)];
   model.ind{UNLEARNED} = (1:num_new_examples) + num_examples;
   
   % assumes currently that there are no duplicate examples in the data - may not necessarily be true!
   Q_new = [y_new' ; (model.y(model.ind{MARGIN})*y_new').*kernel(model.X(:,model.ind{MARGIN}),X_new,model.type,model.scale)];
   
   model.Q = [model.Q Q_new];  
   model.uind = [model.uind ; uind_new];
   model.X = [model.X X_new];
   model.y = [model.y ; y_new];
   
   num_examples = num_examples + num_new_examples;
   
end;   
   
% begin incremental learning - enforce all constraints on each iteration
num_learned = 1;

while (any(model.ind{UNLEARNED}))
   
   % randomly select example
   i = round(rand*(length(model.ind{UNLEARNED})-1)) + 1;
   indc = model.ind{UNLEARNED}(i);
%  indc = ind{UNLEARNED}(1);

	% learn example
   learn(indc,1);
   
   if (mod(num_learned,50) == 0)
      s = sprintf('Learned %d examples.',num_learned);
   end;
   num_learned = num_learned + 1;
   
end;
if (mod(num_learned-1,50) ~= 0)
   s = sprintf('Learned %d examples.',num_learned-1);
end;

% begin incremental learning - perform multiple passes through the data 
% until all of the examples are learned
%while (any(ind{UNLEARNED}))
%   while (any(ind{UNLEARNED}))
%   
%      % select example
%      indc = ind{UNLEARNED}(1);
%      
%      % learn example
%      s = sprintf('\nLearning example %d...',indc);
%      disp(s);
%      learn(indc,0);
%   
%   end;
%
%   % check to see if any reserve vectors are incorrectly classified
%   % if so, change their status to unlearned
%   ind_temp = find(g(ind{RESERVE}) < 0);
%   [ind{RESERVE},ind{UNLEARNED}] = move_ind(ind{RESERVE},ind{UNLEARNED},ind{RESERVE}(ind_temp));
%   
%end;

% remove all but the closest reserve vectors from the dataset if necessary
if (length(model.ind{RESERVE}) == model.max_reserve_vectors)
   ind_keep = [model.ind{MARGIN} model.ind{ERROR} model.ind{RESERVE}];
   model.a = model.a(ind_keep);
   model.g = model.g(ind_keep);
   model.Q = model.Q(:,ind_keep);   
   model.uind = model.uind(ind_keep);
   model.X = model.X(:,ind_keep);
   model.y = model.y(ind_keep);
   model.ind{MARGIN} = 1:length(model.ind{MARGIN});
   model.ind{ERROR} = length(model.ind{MARGIN}) + (1:length(model.ind{ERROR}));
   model.ind{RESERVE} = length(model.ind{MARGIN}) + length(model.ind{ERROR}) + (1:length(model.ind{RESERVE}));
end;



