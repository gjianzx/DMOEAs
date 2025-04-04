function subp=init_weights(popsize, niche, objDim)
% init_weights function initialize a pupulation of subproblems structure
% with the generated decomposition weight and the neighbourhood
% relationship.                     %%初始权重函数用生成的分解权和邻域关系初始化子问题结构的一个规定。 
    subp=[];
%         if objDim==0
%             for i=0:popsize
%                 p=struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'optCV',[],'curpoint',[]);
%                 weight=zeros(2,1);
%                 weight(1)=i/popsize;
%                 weight(2)=(popsize-i)/popsize;
%                 p.weight=weight;
%                 subp=[subp p];
%             end
%           else
            [weight] = UniformPoint(popsize,objDim);   %%%调用UniformPoint  134，3
            %plot3(weight(:,1),weight(:,2),weight(:,3),'b.');
            for i = 0 : length(weight)-1 %popsize        %%%把uniformpoint产生的weight值一个一个的加载到subp
                 p=struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'optCV',[],'curpoint',[]);
                 pt=weight(i+1,:);
                 p.weight = pt';
                 subp=[subp p];
            end
%         end

    %Set up the neighbourhood.
    leng=length(subp);
 
    for i = 1 : leng  %%将1：leng（1：120组）权重再赋给W
       WT = subp(i).weight;
       W(i,:) = WT';
    end
    B = pdist2(W,W);%%返回n*n的距离矩阵，pdist计算两个向量之间的距离矩阵   计算出的B是一个左右对称的对角矩阵
    [~,B] = sort(B,2); 
    for i = 1 : leng
      subp(i).neighbour = B(i,1:niche);
    end
   
end