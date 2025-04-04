% PERTS - Returns the number of perturbations 
%
% Syntax: perturbations = perts();
%
function perturbations = perts();

global perturbations;

if (isempty(perturbations))
   perturbations = 0;
end;
