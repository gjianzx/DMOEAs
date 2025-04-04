function DrawPF(DATA,Problem)
%Draw - Display PF of problem.
    PF = DATA(1).PF;
    if size(DATA,2) > 1
        for i = 2 : size(DATA,2)
            PF = [PF;DATA(i).PF];
        end
    end
    [N,M] = size(PF);
    
    %% The size of the figure
    set(gca,'Unit','pixels');
    if get(gca,'Position') <= [inf inf 400 300]
        Size = [3 5 .8 8];
    else
        Size = [12 20 2 13];
    end
    
    %% The styple of the figure
    if M == 2
%         varargin = {'ok','MarkerSize',Size(1),'Marker','o','Markerfacecolor',[.7 .7 .7],'Markeredgecolor',[.4 .4 .4]};
        varargin = {'ok','MarkerSize',Size(1),'Marker','.','Markerfacecolor',[.7 .7 .7],'Markeredgecolor','r'};
    elseif M == 3
        varargin = {'ok','MarkerSize',Size(2),'Marker','.','Markerfacecolor',[.7 .7 .7],'Markeredgecolor','r'};
    elseif M > 3
        varargin = {'Color',[.5 .5 .5],'LineWidth',Size(3)};
    end
    
    %% Draw the figure
    set(gca,'NextPlot','add','Box','on','Fontname','Times New Roman','FontSize',Size(4));
    if M == 2
        figure(2)
        plot(PF(:,1),PF(:,2),varargin{:});
        xlabel('\it f\rm_1'); ylabel('\it f\rm_2');
        title(['True PF of ',Problem]);
        set(gca,'XTickMode','auto','YTickMode','auto','View',[0 90]);
        axis tight;
        drawnow;
    elseif M == 3
        figure(2)
        plot3(PF(:,1),PF(:,2),PF(:,3),varargin{:});
        xlabel('\it f\rm_1'); ylabel('\it f\rm_2'); zlabel('\it f\rm_3');
        title(['True PF on ',Problem]);
        set(gca,'XTickMode','auto','YTickMode','auto','ZTickMode','auto','View',[135 30]);
        axis tight;
        drawnow;
    elseif M > 3
        Label = repmat([0.99,2:M-1,M+0.01],N,1);
        PF(2:2:end,:)  = fliplr(PF(2:2:end,:));
        Label(2:2:end,:) = fliplr(Label(2:2:end,:));
        PF  = PF';
        Label = Label';
        plot(Label(:),PF(:),varargin{:});
        xlabel('Dimension No.'); ylabel('Value');
        set(gca,'XTick',1:ceil(M/10):M,'XLim',[1,M],'YTickMode','auto','View',[0 90]);
    end
end