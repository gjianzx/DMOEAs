function [kneeS,kneeF]=getKnees(POS,POF)
[boudaryS,boudaryF]=getBoundary(POS,POF);
distance=getToHDistance(POF,boudaryF);
[~,index]=max(distance);
kneeS=POS(:,index);
kneeF=POF(:,index);