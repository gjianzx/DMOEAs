function ind = polynomial_mutate(ind, minvalue, maxvalue)
%polynomial mutation
if isstruct(ind)
    x = ind.parameter;
else
    x  = ind;
end
[N,D] = size(x');
rate_m = 1/D;
para_m =20;

k=rand(N,D);
miu=rand(N,D);
minvalue = repmat(minvalue, [N 1]);
maxvalue = repmat(maxvalue, [N 1]);

temp=(k<=rate_m & miu<0.5);
offspring = x';
offspring(temp)=offspring(temp)+(maxvalue(temp)-minvalue(temp)).*((2.*miu(temp)+(1-2.*miu(temp)).*(1-(offspring(temp)-minvalue(temp))./(maxvalue(temp)-minvalue(temp))).^(para_m+1)).^(1/(para_m+1))-1);
temp=(k<=rate_m & miu>=0.5);
offspring(temp)=offspring(temp)+(maxvalue(temp)-minvalue(temp)).*(1-(2.*(1-miu(temp))+2.*(miu(temp)-0.5).*(1-(maxvalue(temp)-offspring(temp))./(maxvalue(temp)-minvalue(temp))).^(para_m+1)).^(1/(para_m+1)));


for i = 1:D
    outidx = [find(offspring(:,i) < minvalue(1,i)); find(offspring(:,i) > maxvalue(1,i))];
    offspring(outidx, i) = minvalue(1,i) + (maxvalue(1,i) - minvalue(1,i))*rand(length(outidx), 1);
end
if isstruct(ind)
    ind.parameter = offspring';
else
    ind = offspring';
end