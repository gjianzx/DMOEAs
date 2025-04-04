function r=normalize(m)
%normalize (sum of values is 1) column vector in a matrix
% Usage: 
%    r=normalize(m)

summ=sum(m);
summ=repmat(summ,size(m,1),1);
r=m./summ;

%end