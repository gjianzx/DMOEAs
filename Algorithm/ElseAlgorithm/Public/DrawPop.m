function DrawPop(Data,Problem,ft,nt)
% Display the population

    [N,M] = size(Data);
    
    %% The size of the figure
    set(gca,'Unit','pixels');
    if get(gca,'Position') <= [inf inf 400 300]
        Size = [3 5 .8 8];
    else
        Size = [12 15 2 13];
    end
    
    %% The styple of the figure
    if M == 2
        varargin = {'ok','MarkerSize',Size(1),'Marker','.','Markerfacecolor',[.7 .7 .7],'Markeredgecolor','b'};
    elseif M == 3
        varargin = {'ok','MarkerSize',Size(2),'Marker','.','Markerfacecolor',[.7 .7 .7],'Markeredgecolor','b'};
    elseif M > 3
        varargin = {'Color',[.5 .5 .5],'LineWidth',Size(3)};
    end
    
    %% Draw the figure
    set(gca,'NextPlot','replacechildren','Box','on','Fontname','Times New Roman','FontSize',Size(4));
    if M == 2
        figure(2)
        plot(Data(:,1),Data(:,2),varargin{:});
        xlabel('\it f\rm_1'); ylabel('\it f\rm_2');
        title(['Population of ',Problem, '   ft=',num2str(ft),' nt=',num2str(nt)]);
        set(gca,'XTickMode','auto','YTickMode','auto','View',[0 90]);
        axis tight;
        drawnow;
    elseif M == 3
        figure(2)
        plot3(Data(:,1),Data(:,2),Data(:,3),varargin{:});
        xlabel('\it f\rm_1'); ylabel('\it f\rm_2'); zlabel('\it f\rm_3');
        title(['Population of ',Problem, '   ft=',num2str(ft),' nt=',num2str(nt)]);
        set(gca,'XTickMode','auto','YTickMode','auto','ZTickMode','auto','View',[135 30]);
        axis tight;
        drawnow;
    elseif M > 3
        Label = repmat([0.99,2:M-1,M+0.01],N,1);
        Data(2:2:end,:)  = fliplr(Data(2:2:end,:));
        Label(2:2:end,:) = fliplr(Label(2:2:end,:));
        Data  = Data';
        Label = Label';
        plot(Label(:),Data(:),varargin{:});
        xlabel('Dimension No.'); ylabel('Value');
        set(gca,'XTick',1:ceil(M/10):M,'XLim',[1,M],'YTickMode','auto','View',[0 90]);
    end
end