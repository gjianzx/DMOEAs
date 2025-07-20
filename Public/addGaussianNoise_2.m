function newPopulation = addGaussianNoise_2(init_population, Nini, n, Problem)
%ADDGAUSSIANNOISE 此处显示有关此函数的摘要
%   此处显示详细说明
if Nini > size(init_population, 2)
    error("Nini is large");
end
VarMin=Problem.XLow;
VarMax=Problem.XUpp;

newPopulation = zeros(Nini,n);
Indexs = randperm(size(init_population, 2), Nini);
for i=1:Nini
     newPopulation(i,:) = init_population(:,Indexs(i));
end

mean_values = mean(newPopulation);
std_values = std(newPopulation);

for i=1:Nini
    %noise = mean_values + std_values.*randn(1,n);
    noise = 0 + std_values.*randn(1,n);
    newPopulation(i,:) = newPopulation(i,:) + noise;
end
newPopulation = newPopulation';
for j=1:Nini
    for i=1:n
        newPopulation(i,j) = min(max(newPopulation(i,j),VarMin(i)), VarMax(i));
    end
end

end

