function [BS,BF]=getBoundary(pos,pof)
index=1;
for i=1:size(pof,1)
[~,position]=min(pof(i,:));
BS(:,index)=pos(:,position);
BF(:,index)=pof(:,position);
index=index+1;
end