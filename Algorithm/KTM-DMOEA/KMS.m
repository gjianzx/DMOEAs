function GD_population = KMS(CurrentPOS, n, d, Problem,LastPOS)
%Elite_sols: POS of previous environment
%n: num of individual
%d: num of decision variable

LastPOS_center = mean(LastPOS,2);
CurrentPOS_center = mean(CurrentPOS,2);

lamda = CurrentPOS_center - LastPOS_center;

if n > size(CurrentPOS, 2)
    error("Nini is large");
end
VarMin=Problem.XLow;
VarMax=Problem.XUpp;

Sort_Population = zeros(n,d);
Indexs = randperm(size(CurrentPOS, 2), n);
for i=1:n
     Sort_Population(i,:) = CurrentPOS(:,Indexs(i));
end

Elist_PopX = Sort_Population;
if size(Elist_PopX,1) >1
    mu = mean(Elist_PopX) + lamda';
    Sigma = cov(Elist_PopX) + (10e-6)*eye(size(Elist_PopX,2));
    GD_population = mvnrnd(mu,Sigma,n)'; 
else
    mu = Elist_PopX + lamda';
    Sigma = cov(Elist_PopX) + (10e-6)*eye(size(Elist_PopX,2));
    GD_population = mvnrnd(mu,Sigma,n)'; 
end


for j=1:n
    for i=1:d
        GD_population(i,j) = min(max(GD_population(i,j),VarMin(i)), VarMax(i));
    end
end


end

