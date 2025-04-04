function Dvalue = DrawMetric(gen,Data,pf,Dvalue)

ScoreIGD = IGD(Data,pf);
Dvalue(1,gen) = gen;
Dvalue(2,gen) = ScoreIGD;
figure(5)
plot(Dvalue(1,:),Dvalue(2,:),'-.',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
xlabel('Generation'); ylabel('IGD value');
title('Metric value of ');
set(gca,'XTickMode','auto','YTickMode','auto','View',[0 90]);
axis tight;
% hold on;
end