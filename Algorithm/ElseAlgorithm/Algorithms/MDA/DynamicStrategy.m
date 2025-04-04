function [P] = DynamicStrategy(OMatrix,GMatrix,N,D,lower,upper,Problem,ft,nt,gen,preEvolution)

    Np = min(size(OMatrix,1),size(GMatrix,1));
    [~,OMatrixDelIdx] = Truncation(OMatrix,Np);
    [~,GMatrixDelIdx] = Truncation(GMatrix,Np);
    % Re-form the new sets O and G
    OMatrix(OMatrixDelIdx,:) = [];
    GMatrix(GMatrixDelIdx,:) = [];
    OMatrix = OMatrix';
    GMatrix = GMatrix';
    % Obtain the population Pl
    % Equation 3
    M = (OMatrix*GMatrix')*pinv(GMatrix*GMatrix');
    % Equation 13
    Pl = M*OMatrix;
    
    % Obtain the population Pnl
    % Equation 5
    Mk = (OMatrix*KernelMatrix('rbf',GMatrix,GMatrix)')*pinv(KernelMatrix('rbf',GMatrix,GMatrix)*KernelMatrix('rbf',GMatrix,GMatrix)');
    % Equation 14
    Pnl = Mk*KernelMatrix('rbf',OMatrix,OMatrix);
    
    % Obtain the population Pbeta
    flag2 = false(1,D);
    % Mann-Whitney U test
    for i=1:D
        if ranksum(OMatrix(i,:),GMatrix(i,:))<0.05
            flag2(i) = true;
        end
    end
    % Equation 16
    delta = mean(OMatrix-GMatrix,2);
    % Equation 15
    Pbeta = zeros(D,Np);
    for i=1:D
        if flag2
            Pbeta(i,:) = OMatrix(i,:)+delta(i,:);
        else
            Pbeta(i,:) = OMatrix(i,:)+delta(i,:).*(-1+2*rand(1,Np));
        end
    end
    
    PDec = [Pl';Pnl';Pbeta'];
    PNum = size(PDec,1);
    PDec = RepairBoundary(PDec,PNum,lower,upper);
    if PNum<N
        PDec = [PDec;lower+(upper-lower).*rand(N-PNum,D)];
        P = Individual(Problem,ft,nt,gen,[],preEvolution,PDec);
    else
        P = Individual(Problem,ft,nt,gen,[],preEvolution,PDec);
        % Environmental selection method
        [P,~,~] = DNSGAIIEnvironment(P,N);
    end

end

