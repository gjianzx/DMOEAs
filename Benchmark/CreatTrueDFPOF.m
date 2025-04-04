function CreatTrueDFPOF()
clc
clear
close all
warning('off')
con=configure();
T_parameter=con.T_parameter;
functions=con.TestFunctions;

    cnt = 1000; %对于而目标函数，生成1000个个体，对于三目标，则按需要分配
    for func = 4:size(functions,2)
        funcName=functions{func};
        for group = 1:size(T_parameter,1)
            for T = 1:floor(T_parameter(group,3)/T_parameter(group,2))
                %if mod(T+1,T_parameter(group,2))==0
                    dirPath='./pof/';
                    mkdir(dirPath);
                    filename = [dirPath 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' funcName '-' num2str(T) '.txt'];
                    %t = 1/T_parameter(group,1)*(T-1);
%                     t = 1/T_parameter(group,1)*T;
                    t=0
                    switch funcName 
                        case 'DF1'
                            %% DF1
                            N = 10;
                            G = abs(sin(pi*t/2));
                            H = 0.75*sin(pi*t/2)+1.25;
                            PS=[];
                            PS(:,1) = linspace(0,1,cnt);
                            PS(:,2:N) = G;                         
                            PF = zeros(cnt,2);      
                            for i = 1:cnt
                                [PF(i,:),~] = DF1(PS(i,:),t);
                            end
%                               plot(PF(:,1),PF(:,2),'.')
%                               hold on
                            PF = rm_dominated(PF);
                            
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y           
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF2'
                            %% DF2
                            N = 10;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            G = abs(sin(pi*t/2));
                            r=1+floor((N-1)*G);
                            %f1 = X(r);
                            PS(:,r) = linspace(0,1,cnt);
                            for i=1:size(PS,2)
                                if i~=r
                                    PS(:,i) =G;
                                end
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = DF2(PS(i,:),t);
                            end
%                              plot(PF(:,1),PF(:,2),'.')
%                              hold on
                            PF = rm_dominated(PF);
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF3'
                        %% DF3
                       
                             N = 10;
                            G = (sin(pi*t/2));
                            H = G+1.5;
                            PS=[];
                            PS(:,1) = linspace(0,1,cnt);
                            for i=2:N
                                PS(:,i) = G+PS(:,1).^H;    
                            end
                                                 
                            PF = zeros(cnt,2);      
                            for i = 1:cnt
                                [PF(i,:),~] = DF3(PS(i,:),t);
                            end
%                             plot(PS(:,1),PS(:,2),'.')
%                             hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                             
                        case 'DF4'
                            %% DF4
                            N = 10;
                            a = (sin(pi*t/2));
                            b=1+abs(cos(pi*t/2));
                            H=1.5+a;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(a,a+b,cnt);
                            for i=2:N
                                PS(:,i)=a.*PS(:,1).^2./i;
                            end
                            
                            for i = 1:cnt
                                [PF(i,:),~] = DF4(PS(i,:),t);
                            end
                              plot(PS(:,1),PS(:,2),'.')
                              hold on

                            PF = rm_dominated(PF);
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF5'
                            %% DF5
                            G=(sin(pi*t/2));
                            N = 10;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(0,1,cnt);
                            PS(:,2:N) = G;
                            for i = 1:cnt
                                [PF(i,:),~] = DF5(PS(i,:),t);
                            end
%                              plot(PF(:,1),PF(:,2),'.')
%                              hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF6'
                            %% DF6
                            G=(sin(pi*t/2));
                            N = 10;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(0,1,cnt);
                            PS(:,2:N) = G;
                            for i = 1:cnt
                                [PF(i,:),~] = DF6(PS(i,:),t);
                            end
                             plot(PF(:,1),PF(:,2),'.')
                             hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF7'
                            %% DF7
                            
                            N = 10;
                          
                             a=5*cos(0.5*pi*t);
                            
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(1,4,cnt);
                            for i = 1:cnt
                                for j = 2:N
                                    PS(i,j) =1/(1+exp(a*(PS(i,1)-2.5))); 
                                end
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = DF7(PS(i,:),t);
                            end
%                             plot(PS(:,1),PS(:,2),'.')
%                             hold on
%                             PF = rm_dominated(PF);
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF8'
                            %% DF8
                            N = 10;
                            PS(:,1) = linspace(0,1,cnt);
                            G=sin(0.5*pi*t);
                            b=100*G^2;
                            
                            for i = 1:cnt
                                for j = 2:N
                                    PS(i,j) =G*sin(4*pi*PS(i,1)^b)/(1+abs(G));% b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = DF8(PS(i,:),t);
                            end
%                             plot(PS(:,1),PS(:,2),'.')
%                             hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF9'
                            %% DF9
                            N = 10;
                            PS(:,1) = linspace(0,1,cnt);
                            
                            
                            for i = 1:cnt
                                for j = 2:N
                                    PS(i,j) =cos(4*t+PS(i,1)+PS(i,j-1));% b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = DF9(PS(i,:),t);
                            end
                            rowsToDelete = PF(:,2) > 1 - PF(:,1); 
                            PF(rowsToDelete, :) = [];   % 删除满足条件的行
                            %PF = rm_dominated(PF);
%                              plot(PF(:,1)+2*t,PF(:,2)+2*t,'.')
%                              hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF10'
                            %% DF10
                            
                            N = 10;
                            G=sin(0.5*pi*t);
                            PF = zeros(cnt,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                for j = 3:N
                                    PS(i,j) = sin(2*pi*(PS(i,1)+PS(i,2)))/(1+abs(G))  ;%b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:size(PS,1)
                                [PF(i,:),~] = DF10(PS(i,:),t);
                            end
%                               plot3(PF(:,1),PF(:,2),PF(:,3),'.')
%                              hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF11'
                            %% DF11
                           N = 10;
                            G=abs(sin(0.5*pi*t));
                            PF = zeros(cnt,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                for j = 3:N
                                    PS(i,j) = 0.5*G*PS(i,1) ;%b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                             for i = 1:size(PS,1)
                                [PF(i,:),~] = DF11(PS(i,:),t);
                            end
%                              plot3(PF(:,1),PF(:,2),PF(:,3),'.')
%                              hold on
                          %  PF = rm_dominated(PF);
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF12'
                            %% DF12
                            N = 10;
                            G=abs(sin(0.5*pi*t));
                            PF = zeros(cnt,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                
                                for j = 3:N
                                    PS(i,j) = sin(t*PS(i,1)) ;%b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:size(PS,1)
                                [PF(i,:),~] = DF12(PS(i,:),t);
                            end
                            rowsToDelete = any(PF > 1, 2); 
                            PF(rowsToDelete, :) = [];   % 删除满足条件的行
                            plot3(PF(:,1),PF(:,2),PF(:,3),'.')
                            hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF13'
                            %% DF13
                            
                           N = 10;
                            G=(sin(0.5*pi*t));
                            PF = zeros(100,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                for j = 3:N
                                    PS(i,j) = G ;%b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:size(PS,1)
                                [PF(i,:),~] = DF13(PS(i,:),t);
                            end
                            PF=find_non_dominated_solutions(PF);
%                            PF = rm_dominated(PF);
%                              plot3(PF(:,1),PF(:,2),PF(:,3),'.')
%                              hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'DF14'
                            %% DF14
                            N = 10;
                            G=(sin(0.5*pi*t));
                            PF = zeros(cnt,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                for j = 3:N
                                    PS(i,j) = G ;%b+1-(abs(PS(i,1)-a)).^(H+j/N);
                                end
                            end
                            for i = 1:size(PS,1)
                                [PF(i,:),~] = DF14(PS(i,:),t);
                            end
                            plot3(PF(:,1),PF(:,2),PF(:,3),'.')
                            hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'UDF5'
                            %% UDF5
                            N = 10;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(0,1,cnt);
                            G = sin(0.5*pi*t);
                            for j = 2:N
                               PS(:,j) = PS(:,1).^(0.5*(2+3*((j-2)/(N-2))+G))+G;
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = UDF5(PS(i,:),t);
                            end
%                             plot(PF(:,1),PF(:,2),'.')
%                             hold on
                            PF = rm_dominated(PF);
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                        case 'UDF6'
                            %% UDF6
                            N = 10;
                            PS = zeros(cnt,N);
                            PF = zeros(cnt,2);
                            PS(:,1) = linspace(0,1,cnt);
                            G = sin(0.5*pi*t);
                            for j = 2:N
                               PS(:,j) = sin(6*pi*PS(:,1)+j*pi/N);
                            end
                            for i = 1:cnt
                                [PF(i,:),~] = UDF6(PS(i,:),t);
                            end
                            PF = rm_dominated(PF);
%                             plot(PF(:,1),PF(:,2),'.')
%                             hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                            
                        case 'UDF7'
                            %% UDF7
                            N = 10;
                            PS = zeros(100,N);
                            PF = zeros(cnt,3);
                            [X,Y] = meshgrid(0:.01:1, 0:.01:1);
                            PS = [];
                            for i = 1:size(X,1)
                                PS = [PS
                                    [X(:,i) Y(:,i)]];
                            end
                            for i = 1:size(PS,1)
                                for j = 3:N
                                    PS(i,j) = 2*PS(i,2)*sin(2*pi*PS(i,1)+j*pi/N);
                                end
                            end
                            for i = 1:size(PS,1)
                                [PF(i,:),~] = UDF7(PS(i,:),t);
                            end
%                             plot3(PF(:,1),PF(:,2),PF(:,3),'.')
%                             hold on
                            [X,Y] = size(PF);
                            fid = fopen(filename,'w');
                            for i = 1:X
                               for j = 1:Y
                                   fprintf(fid,'%f\t',PF(i,j));
                               end
                               fprintf(fid,'\r\n');
                            end
                            fclose(fid);
                    end
                %end
            end
        end
    end


end

%% test functions
function [F,V] = DF1(X,t)
    %% DF1
    N = 10;
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;
    G = abs(sin(pi*t/2));
    f1 = X(1);
    g = 1+sum((X(2:end)-G).^2);
    h = 1-(f1/g)^H;    
    F = [f1
        g*h];    
    V = 0.0;
    
end



function [F,V] = DF2(X,t)
    %% DF2
    n = 10;
    Fn = 2;
    G = abs(sin(pi*t/2));
    r=1+floor((n-1)*G);
    f1 = X(r);
    g=1;
    for i=1:n
        if i==r
            continue
        else
            g=g+(X(i)-G)^2;
        end
    end
    h = 1-sqrt(f1/g);
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = DF3(X,t)
%% DF3
    N = 10;
    M = 2;
    f1=X(1);
    G = (sin(pi*t/2));
    H=1.5+G;
    x1H=X(1)^H;
    g=1;
    for i=2:N
        g=g+(X(i)-G-x1H)^2;
    end
    h = 1-(f1/g)^H;
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = DF4(X,t)
%% DF4
    N = 10;
    M = 2;
    g=1;
    a = (sin(pi*t/2));
    for i=2:N
        g=g+(X(i)-(a*X(1)^2/i))^2;
    end
    b=1+abs(cos(pi*t/2));
    
    H=1.5+a;
    f1=g*abs(X(1)-a)^H;
    f2=g*abs(X(1)-a-b)^H;
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = DF5(X,t)
%% DF5
    N = 10;
    M = 2;
    G=(sin(pi*t/2));
    g=1;
    for i=2:N
        g=g+(X(i)-G)^2;
    end
    w=floor(10*G);
    f1=g*(X(1)+0.02*sin(w*pi*X(1)));
    f2=g*(1-X(1)+0.02*sin(w*pi*X(1)));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = DF6(X,t)
%% DF6
    N = 10;
    M = 2;
    G=(sin(pi*t/2));
    g=1;
    a=0.2+2.8*abs(G);
    Y=X-G;
    for i=2:N
        g=g+(abs(G)*Y(i)^2-10*cos(2*pi*Y(i))+10);
    end
    f1=g*(X(1)+0.1*sin(3*pi*X(1)))^a;
    f2=g*(1-X(1)+0.1*sin(3*pi*X(1)))^a;
    F = [f1
        f2];
    V = 0.0;
end

% function [F,V]  = DF6(X,t)
% %% DF6
%     N = 10;
%     M = 2;
%     G=(sin(pi*t/2));
%     g=1;
%     a=0.2+2.8*abs(G);
%     Y=X-G;
%     for i=2:N
%         g=g+(abs(G)*Y(i)^2-10*cos(2*pi*Y(i))+10);
%     end
%     f1=g*(X(1)+0.1*sin(3*pi*X(1)))^a;
%     f2=g*(1-X(1)+0.1*sin(3*pi*X(1)))^a;
%     F = [f1
%         f2];
%     V = 0.0;
% end


function [F,V]  = DF7(x,t)
%% DF7
    N = 10;
    M = 2;
    a=5*cos(0.5*pi*t);
        tmp=1/(1+exp(a*(x(1)-2.5)));
        g=1+sum(power(x(2:end)-tmp,2));
        f1=g*(1+t)/x(1);
        f2=g*x(1)/(1+t) ;  
        
  
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = DF8(x,t)
%% DF8
    N = 10;
    M = 2;
    G=sin(0.5*pi*t);
    a=2.25+2*cos(2*pi*t);
    b=100*G^2;
    tmp=G*sin(4*pi*power(x(1),b))/(1+abs(G));
    g=1+sum((x(2:end)-tmp).^2);
    f1=g*(x(1)+0.1*sin(3*pi*x(1)));
    f2=g*power(1-x(1)+0.1*sin(3*pi*x(1)),a);   
    F = [f1
        f2];
    V = 0.0;
end


function [F,V]  = DF9(x,t)
%% DF9
    n=10;
    N=1+floor(10*abs(sin(0.5*pi*t)));
    g=1;
    for i=2:n
        tmp=x(i)-cos(4*t+x(1)+x(i-1));
        g=g+tmp^2;
    end
        f1=g*(x(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(1))));
        f2=g*(1-x(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(1))))  ; 
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = DF10(x,t)
%% DF10
    n=10;
    G=sin(0.5*pi*t);
        H=2.25+2*cos(0.5*pi*t);
        tmp=sin(2*pi*(x(1)+x(2)))/(1+abs(G));
        g=1+sum((x(3:end)-tmp).^2);
        f0=g*power(sin(0.5*pi*x(1)),H);
        f1=g*power(sin(0.5*pi*x(2)),H)*power(cos(0.5*pi*x(1)),H);
        f2=g*power(cos(0.5*pi*x(2)),H)*power(cos(0.5*pi*x(1)),H);
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = DF11(x,t)
%% DF11
    G=abs(sin(0.5*pi*t));
        g=1+G+sum((x(3:end)-0.5*G*x(1)).^2);
       
        y1=pi*G/6.0+(pi/2-pi*G/3.0)*x(1);
        y2=pi*G/6.0+(pi/2-pi*G/3.0)*x(2);
        f0=g*sin(y1) ;
        f1=g*sin(y2)*cos(y1);
        f2=g*cos(y2)*cos(y1);
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = DF12(x,t)
%% DF12
    k=10*sin(pi*t);
        tmp1=x(3:end)-sin(t*x(1));
        tmp2=abs(sin(floor(k*(2*x(1)-1))*pi/2)*sin(floor(k*(2*x(2)-1))*pi/2));
        g=1+sum(tmp1.^2)+tmp2;
        f0=g*cos(0.5*pi*x(2))*cos(0.5*pi*x(1));
        f1=g*sin(0.5*pi*x(2))*cos(0.5*pi*x(1));
        f2=g*sin(0.5*pi*x(1));
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = DF13(x,t)
%% DF13
   G=sin(0.5*pi*t);
        p=floor(6*G);
        g=1+sum((x(3:end)-G).^2);
        f0=g*cos(0.5*pi*x(1))^2;
        f1=g*cos(0.5*pi*x(2))^2;
        f2=g*sin(0.5*pi*x(1))^2+sin(0.5*pi*x(1))*cos(p*pi*x(1))^2+sin(0.5*pi*x(2))^2+sin(0.5*pi*x(2))*cos(p*pi*x(2))^2;
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = DF14(x,t)
%% DF14
    n=10;
    G=sin(0.5*pi*t);
        g=1+sum((x(3:end)-G).^2);
        y=0.5+G*(x(1)-0.5);
        f0=g*(1-y+0.05*sin(6*pi*y));
        f1=g*(1-x(2)+0.05*sin(6*pi*x(2)))*(y+0.05*sin(6*pi*y));
        f2=g*(x(2)+0.05*sin(6*pi*x(2)))*(y+0.05*sin(6*pi*y));
    F = [f0
        f1
        f2];
    V = 0.0;
end


function [non_dominated_solutions] = find_non_dominated_solutions(data)
% 输入：
%   data: 1000*3 的数组，每一行代表一个解，包含三个目标函数的值
% 输出：
%   non_dominated_solutions: 包含所有非支配解的数组

    num_solutions = size(data, 1);
    non_dominated_solutions = []; % 初始化非支配解数组

    % 遍历每个解
    for i = 1:num_solutions
        is_dominated = false; % 初始化是否被支配标志

        % 与其他解进行比较
        for j = 1:num_solutions
            % 如果当前解在所有目标函数上都劣于另一个解，则被支配
            if all(data(j, :) <= data(i, :)) && any(data(j, :) < data(i, :))
                is_dominated = true;
                break; % 如果被支配，则跳出循环
            end
        end

        % 如果没有被支配，则将其添加到非支配解数组中
        if ~is_dominated
            non_dominated_solutions = [non_dominated_solutions; data(i, :)];
        end
    end
end