%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA124
% Project Title: Implementation of MOEA/D
% Muti-Objective Evolutionary Algorithm based on Decomposition
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
%均匀生成参考向量

function sp=CreateSubProblems(nObj,nPop,T)

    empty_sp.lambda=[];
    empty_sp.Neighbors=[];

    sp=repmat(empty_sp,nPop,1);

    if nObj == 2
        for i=1:nPop   
            lambda = [i/nPop; 1-i/nPop];
            sp(i).lambda=lambda;
        end
        LAMBDA=[sp.lambda]';
        D=pdist2(LAMBDA,LAMBDA);
        for i=1:nPop
            [~, SO]=sort(D(i,:));
            sp(i).Neighbors=SO(1:T);
        end
    end
    
    if nObj == 3
        lambda = initialWeight3obj(16, nObj);
        it = 1;
        for i=1:size(lambda,1)
            if i ~= 51 && i ~= 101 && i ~= 151
               sp(it).lambda = lambda(i,:)'; 
               it = it + 1;
            end
        end
        LAMBDA=[sp.lambda]';
        D=pdist2(LAMBDA,LAMBDA);
        for i=1:nPop
            [~, SO]=sort(D(i,:));
            sp(i).Neighbors=SO(1:T);
        end
    end
  
end
%{
function sp=CreateSubProblems(nObj,nPop,T)

    empty_sp.lambda=[];
    empty_sp.Neighbors=[];

    sp=repmat(empty_sp,nPop,1);%重复数组副本，100个lambda【】 100个Neighbors【】
    
    %theta=linspace(0,pi/2,nPop);
    
    for i=1:nPop
        lambda=rand(nObj,1);%随机生成lambda的值
        lambda=lambda/norm(lambda); %norm（lambda）得出的是lambda的最大奇异值
        sp(i).lambda=lambda;
        
        %sp(i).lambda=[cos(theta(i))
        %              sin(theta(i))];
    end

    LAMBDA=[sp.lambda]';

    D=pdist2(LAMBDA,LAMBDA);%算LAMBDA之间的距离
    %算出T个邻居LAMBDA的编号（权重向量）
    for i=1:nPop
        [~, SO]=sort(D(i,:));%对向量距离进行排序，用SO记住下标
        sp(i).Neighbors=SO(1:T);%把距离最近的T个另据存储到sp中
    end

end
%}