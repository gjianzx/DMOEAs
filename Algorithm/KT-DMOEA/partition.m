function [posArr,pofArr]=partition(POS,POF,partNum,boundary)
tempPof=POF;
tempPos=POS;
[~,index]=sort(POF(1,:));
% size(POF)
% size(POS)
% index
for i=1:length(index)
    POF(:,i)=tempPof(:,index(i));
%     fprintf('index %d,',i)
    POS(:,i)=tempPos(:,index(i));
end

spaceSize=ceil(size(POF,2)/partNum);
lowBoundary=1;
for partNo=1:partNum
    if partNo~=partNum
        pofArr{partNo}=POF(:,lowBoundary:lowBoundary+spaceSize);
        posArr{partNo}=POS(:,lowBoundary:lowBoundary+spaceSize);
    else
        pofArr{partNum}=POF(:,lowBoundary:end);
        posArr{partNum}=POS(:,lowBoundary:end);
    end
    lowBoundary=lowBoundary+spaceSize-1;
end
