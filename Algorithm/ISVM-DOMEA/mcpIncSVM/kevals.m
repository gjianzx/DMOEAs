% KEVALS - Returns the number of kernel evaluations 
%
% Syntax: kernel_evals = kevals();
%


function kernel_evals = kevals();

%global kernel_evals;
global model;

if (isempty(model))
   kernel_evals = 0;
else
    kernel_evals = model.kernel_evals;
end;
