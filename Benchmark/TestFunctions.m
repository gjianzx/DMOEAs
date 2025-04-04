function Problem=TestFunctions(testfunc)
con=configure();
DEC=con.dec;
switch testfunc
    case  'DF1'
        Problem.Name    = 'DF1';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(DEC,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(DEC,1);   % upper boundary of decision variables
        Problem.FObj    = @DF1;          % Objective function, please read the definition
    case 'DF2'
        Problem.Name    = 'DF2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(DEC,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(DEC,1);   % upper boundary of decision variables
        Problem.FObj    = @DF2;          % Objective function, please read the definition
    case  'DF3'
        Problem.Name    = 'DF3';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = [zeros(1,1) ;-ones(DEC-1,1)];  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(1,1) ;2*ones(DEC-1,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF3;          % Objective function, please read the definition
    case  'DF4'
        Problem.Name    = 'DF4';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = -2*ones(DEC,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = 2*ones(DEC,1);   % upper boundary of decision variables
        Problem.FObj    = @DF4;          % Objective function, please read the definition
    case 'DF5'
        Problem.Name    = 'DF5';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = [zeros(1,1) ;-ones(DEC-1,1)];   % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(1,1) ;ones(DEC-1,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF5;          % Objective function, please read the definition
    case 'DF6'
        Problem.Name    = 'DF6';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    =  [zeros(1,1) ;-zeros(DEC-1,1)];  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(1,1) ;ones(DEC-1,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF6;          % Objective function, please read the definition
    case 'DF7'
        Problem.Name    = 'DF7';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = [ones(1,1) ;zeros(DEC-1,1)];  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [4*ones(1,1) ;ones(DEC-1,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF6;          % Objective function, please read the definition
    case  'DF8'
        Problem.Name    = 'DF8';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = [zeros(1,1) ;-1*ones(DEC-1,1)];  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(1,1) ;ones(DEC-1,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF8;          % Objective function, please read the definition
    case  'DF9'
        Problem.Name    = 'DF9';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = [zeros(1,1) ;-1*ones(DEC-1,1)];  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(1,1) ;ones(DEC-1,1)];     % upper boundary of decision variables
        Problem.FObj    = @DF9;          % Objective function, please read the definition
    case 'DF10'
        Problem.Name    = 'DF10';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = [zeros(2,1) ;-1*ones(DEC-2,1)];   % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(2,1) ;ones(DEC-2,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF10;          % Objective function, please read the definition
    case  'DF11'
        Problem.Name    = 'DF11';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(DEC,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(DEC,1);   % upper boundary of decision variables
        Problem.FObj    = @DF11;          % Objective function, please read the definition
    case 'DF12'
        Problem.Name    = 'DF12';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
       Problem.XLow    = [zeros(2,1) ;-1*ones(DEC-2,1)];   % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(2,1) ;ones(DEC-2,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF12;          % Objective function, please read the definition
    case  'DF13'
        Problem.Name    = 'DF13';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
     Problem.XLow    = [zeros(2,1) ;-1*ones(DEC-2,1)];   % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(2,1) ;ones(DEC-2,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF13;          % Objective function, please read the definition
    case 'DF14'
        Problem.Name    = 'DF14';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
       Problem.XLow    = [zeros(2,1) ;-1*ones(DEC-2,1)];   % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = [ones(2,1) ;ones(DEC-2,1)];   % upper boundary of decision variables
        Problem.FObj    = @DF14;          % Objective function, please read the definition
    case  'FDA4'
        Problem.Name    = 'FDA4';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA4;          % Objective function, please read the definition
    case 'FDA5'
        Problem.Name    = 'FDA5';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA5;          % Objective function, please read the definition
    case  'FDA5_iso'
        Problem.Name    = 'FDA5_iso';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA5_iso;          % Objective function, please read the definition
    case  'FDA5_dec'
        Problem.Name    = 'FDA5_dec';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA5_dec;          % Objective function, please read the definition
    case 'DIMP2'
        Problem.Name    = 'DIMP2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @DIMP2;          % Objective function, please read the definition
    case 'dMOP2'
        Problem.Name    = 'dMOP2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @dMOP2;          % Objective function, please read the definition
    case 'dMOP2_iso'
        Problem.Name    = 'dMOP2_iso';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @dMOP2_iso;          % Objective function, please read the definition
    case 'dMOP2_dec'
        Problem.Name    = 'dMOP2_dec';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @dMOP2_dec;          % Objective function, please read the definition
    case 'dMOP3'
        Problem.Name    = 'dMOP3';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @dMOP3;          % Objective function, please read the definition
    case  'HE2'
        Problem.Name    = 'HE2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(30,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(30,1);   % upper boundary of decision variables
        Problem.FObj    = @HE2;          % Objective function, please read the definition
    case  'HE7'
        Problem.Name    = 'HE7';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @HE7;          % Objective function, please read the definition
    case 'HE9'
        Problem.Name    = 'HE9';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @HE9;          % Objective function, please read the definition
    case  'FDA1'
        Problem.Name    = 'FDA1';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(11,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(11,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA1;          % Objective function, please read the definition
    case 'FDA2'
        Problem.Name    = 'FDA2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(13,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(13,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA2;          % Objective function, please read the definition
    case  'FDA3'
        Problem.Name    = 'FDA3';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @FDA3;          % Objective function, please read the definition
    case 'dMOP1'
        Problem.Name    = 'dMOP1';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @dMOP1;          % Objective function, please read the definition
    case 'F5'
        Problem.Name    = 'F5';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @F5;          % Objective function, please read the definition
    case  'F6'
        Problem.Name    = 'F6';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(11,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(11,1);   % upper boundary of decision variables
        Problem.FObj    = @F6;          % Objective function, please read the definition
    case 'F7'
        Problem.Name    = 'F7';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(11,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(11,1);   % upper boundary of decision variables
        Problem.FObj    = @F7;          % Objective function, please read the definition
    case 'F8'
        Problem.Name    = 'F8';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(12,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.FObj    = @F8;          % Objective function, please read the definition
    case 'F9'
        Problem.Name    = 'F9';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(11,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(11,1);   % upper boundary of decision variables
        Problem.FObj    = @F9;          % Objective function, please read the definition
    case  'F10'
        Problem.Name    = 'F10';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(11,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(11,1);   % upper boundary of decision variables
        Problem.FObj    = @F10;          % Objective function, please read the definition
    case 'UDF1'
        Problem.Name    = 'UDF1';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF1;          % Objective function, please read the definition
    case 'UDF2'
        Problem.Name    = 'UDF2';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF2;          % Objective function, please read the definition
    case  'UDF3'
        Problem.Name    = 'UDF3';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF3;          % Objective function, please read the definition
    case  'UDF4'
        Problem.Name    = 'UDF4';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF4;          % Objective function, please read the definition
    case 'UDF5'
        Problem.Name    = 'UDF5';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF5;          % Objective function, please read the definition
    case  'UDF6'
        Problem.Name    = 'UDF6';        % name of test problem
        Problem.NObj    = 2;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF6;          % Objective function, please read the definition
    case 'UDF7'
        Problem.Name    = 'UDF7';        % name of test problem
        Problem.NObj    = 3;            % number of objectives                               
        Problem.XLow    = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.XUpp    = ones(10,1);   % upper boundary of decision variables
        Problem.FObj    = @UDF7;          % Objective function, please read the definition
end
end
               

%% test functions

%% test functions
function [F,V] = DF1(X,t)
    %% DF1
    
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;
    G = abs(sin(pi*t/2));
    f1 = X(1);
    g = 1+sum((X(2:end)-G).^2);
    h = 1-(f1/g)^H;    
    F = [f1
        g*h];  
    F=real(F);
    V = 0.0;
    
end



function [F,V] = DF2(X,t)
    %% DF2
    n = size(X,2);
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
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF3(X,t)
%% DF3
    N = size(X,2);
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
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF4(X,t)
%% DF4
    N = size(X,2);
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
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF5(X,t)
%% DF5
    N = size(X,2);
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
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF6(X,t)
%% DF6
    N = size(X,2);
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
    F=real(F);
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
    N = size(x,2);
    M = 2;
    a=5*cos(0.5*pi*t);
        tmp=1/(1+exp(a*(x(1)-2.5)));
        g=1+sum(power(x(2:end)-tmp,2));
        f1=g*(1+t)/x(1);
        f2=g*x(1)/(1+t) ;  
        
  
    F = [f1
        f2];
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF8(x,t)
%% DF8
    N = size(x,2);
    M = 2;
    G=sin(0.5*pi*t);
    a=2.25+2*cos(2*pi*t);
    b=100*G^2;
    tmp=G*sin(power(4*pi*x(1),b))/(1+abs(G));
    g=1+sum((x(2:end)-tmp).^2);
    f1=g*(x(1)+0.1*sin(3*pi*x(1)));
    f2=g*power(1-x(1)+0.1*sin(3*pi*x(1)),a);   
    F = [f1
        f2];
    F=real(F);
    V = 0.0;
end


function [F,V]  = DF9(x,t)
%% DF9
    n=size(x,2);
    N=1+floor(10*abs(sin(0.5*pi*t)));
    g=1;
    for i=2:n
        tmp=x(i)-cos(4*t+x(1)+x(i));
        g=g+tmp^2;
    end
        f1=g*(x(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(1))));
        f2=g*(1-x(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(1))))  ; 
    F = [f1
        f2];
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF10(x,t)
%% DF10
 
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
    F=real(F);
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
    F=real(F);
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
        f2=g*sin(0.5*pi*x(2));
    F = [f0
        f1
        f2];
    F=real(F);
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
    F=real(F);
    V = 0.0;
end

function [F,V]  = DF14(x,t)
%% DF14
   
    G=sin(0.5*pi*t);
        g=1+sum((x(3:end)-G).^2);
        y=0.5+G*(x(1)-0.5);
        f0=g*(1-y+0.05*sin(6*pi*y));
        f1=g*(1-x(2)+0.05*sin(6*pi*x(2)))*(y+0.05*sin(6*pi*y));
        f2=g*(x(2)+0.05*sin(6*pi*x(2)))*(y+0.05*sin(6*pi*y));
    F = [f0
        f1
        f2];
    F=real(F);
    V = 0.0;
end


function [F,V]  = FDA1(X,t)
%% FDA1
    N = 11;
    M = 2;
    X(2:N) = X(2:N)*2-1;    %X[2:N]属于区间[-1,1]
    f1 = X(1);
    G = sin(0.5*pi*t);
    g = 1 + sum((X(2:N) - G).^2);
    h = 1-sqrt(f1/g);
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = FDA2(X,t)
%% FDA2
    N = 13;
    M = 2;
    X(2:end) = X(2:end)*2-1;
    f1 = X(1);
    g = 1+sum(X(2:N-8).^2);
    H = 2*sin(0.5*pi*(t-1));
    h = 1-(f1/g)^(2^(H+sum((X(N-7:end)-H/4).^2)));
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = FDA3(X,t)
%% FDA3
    N = 10;
    M = 2;
    X(3:N) = X(3:N)*2-1;    %X[3:N]属于区间[-1,1]
    F = 10^(2*sin(0.5*pi*t));
    f1 = sum(X(1:2).^F)/2;
    G = abs(sin(0.5*pi*t));
    g = 1 + G +sum((X(3:N)-G).^2);
    h = 1 - sqrt(f1/g);
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = FDA4(X,t)
%% FDA4
    N = 12;
    M = 3;
    G = abs(sin(pi*t/2));
    g = sum((X(M:N) - G).^2);
    F = [(1+g)*prod(cos(X(1:M-1)*pi/2))
        (1+g)*prod(cos(X(1:M-2)*pi/2))*sin(X(M-1)*pi/2)
        (1+g)*sin(X(1)*pi/2)];
    V = 0.0;

end
function [F,V] = FDA5(X,t)
%% FDA5
    N = 12;
    M = 3;    
    G = abs(sin(pi*t/2));
    g = G+sum((X(M:N)-G).^2);
    F = 1+100*sin(pi*t/2)^4;
    y1 = X(1:M-1).^F;
    y2 = X(1:M-2).^F;
    y3 = X(M-1).^F;
    y4 = X(1).^F;
    F = [(1+g)*prod(cos(y1.*pi/2))
        (1+g)*prod(cos(y2*pi/2))*sin(y3*pi/2)
        (1+g)*sin(y4*pi/2)];        
    V = 0.0;
end

function [F,V] = FDA5_iso(X,t)
    %% FDA5_iso
    N = 12;
    M = 3;
    G = abs(sin(pi*t/2));
    B = .001;
    C = .05;
    g = G+sum((min(0, floor(X(M:N)-B)).*(G*(B-X(M:N))/B-min(0,floor(C-X(M:N)))*(1-G).*(X(M:N)-C)/(1-C))).^2);    
    K = 1+100*sin(pi*t/2)^4;
    y1 = X(1:M-1).^K;
    y2 = X(1:M-2).^K;
    y3 = X(M-1).^K;
    y4 = X(1).^K;
    F = [(1+g)*prod(cos(y1*pi/2))
        (1+g)*prod(cos(y2*pi/2))*sin(y3*pi/2)
        (1+g)*sin(y4*pi/2)];
    V = 0.0;

end
function [F,V] = FDA5_dec(X,t)    
 % FDA5_dec
    N = 12;
    Fn = 3;
    M = 3;
    G = abs(sin(pi*t/2));
    B = .001;
    C = .05;
    g = G+sum((((floor(X(M:N)-G+B)*(1-C+(G-B)/B)/(G-B)+1/B+floor(G+B-X(M:N))*(1-C+(1-G-B)/B)/(1-G-B)).*(abs(X(M:N)-G)-B)+1)-G).^2);
    K = 1+100*sin(pi*t/2)^4;
%     y = @(x,t)x.^K(t);
    y1 = X(1:M-1).^K;
    y2 = X(1:M-2).^K;
    y3 = X(M-1).^K;
    y4 = X(1).^K;
    
    F = [(1+g)*prod(cos(y1*pi/2))
        (1+g)*prod(cos(y2*pi/2))*sin(y3*pi/2)
        (1+g)*sin(y4*pi/2)];
    V = 0.0;
end

function [F,V] = DIMP2(X,t)
% DIMP2   <--- [-2,2]
    N = 10;
    Fn = 2;
    G = sin(pi*t/2+2*pi*((2:N)/(N+1))).^2;
    G = G';
    f = X(1);
    g = 1+2*(N-1)+sum((4*X(2:end)-2-G).^2-2*cos(3*pi*(4*X(2:end)-2-G)));    
    h = 1-sqrt(f/g);
    
    F = [f
        g*h];
    V = 0.0;
end

function [F,V] = dMOP1(X,t)
%% dMOP1
    N = 10;
    Fn = 2;
    f1 = X(1);
    H = 1.25 + 0.75*sin(0.5*pi*t);
    g = 1+9*sum(X(2:end).^2)/(N-1);
    h = 1-(f1/g)^H;
    F = [f1
        g*h];
    V = 0.0;
    
end

function [F,V] = dMOP2(X,t)
    %% dMOP2
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

function [F,V] = dMOP2_iso(X,t)
     %% dMOP2_iso
    N = 10;
    Fn = 2;

    H = 0.75*sin(pi*t/2)+1.25;
    B = .001;
    C = .05;
    G = sin(pi*t/2);
    f = X(1);
    g = 1+9*sum((min(0, floor(X(2:end)-B)).*(G*(B-X(2:end))/B-min(0,floor(C-X(2:end)))*(1-G).*(X(2:end)-C)/(1-C))).^2);
    h = 1-(f/g)^H;
    
    F = [f
        g*h];
    V = 0.0;

end

function [F,V] = dMOP2_dec(X,t)
%% dMOP2_dec
    n = 10;
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;
    B = .001;
    C = .05;
    G = sin(pi*t/2);
    f = X(1);
    g = 1+9*sum((((floor(X(2:end)-G+B)*(1-C+(G-B)/B)/(G-B)+1/B+floor(G+B-X(2:end))*(1-C+(1-G-B)/B)/(1-G-B)).*(abs(X(2:end)-G)-B)+1)-G).^2);    
    h = 1-(f/g)^H;    
    F = [f
        g*h];
    V = 0.0;
end

function [F,V] = dMOP3(X,t)
    %% dMOP3
    n = 10;
    Fn = 2;
    G = abs(sin(pi*t/2));
    f1 = X(1);
    g = 1+sum((X(2:end)-G).^2);
    h = 1-sqrt(f1/g);
    
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V] = HE2(X,t)
     %% HE2
    N = 30;
    Fn = 2;

    H = 0.75*sin(pi*t/2)+1.25;
    f = X(1);
    g = 1+9*sum(X(2:end))/(N-1);
    h = 1-sqrt(f/g)^H-(f/g)^H*sin(10*pi*f);
    F = [f
        g*h];
    V = 0.0;
end

function [F,V] = HE7(X,t)
%% HE7 <---- [-1,1]
    X = X';
    N = 10;
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;

    f = X(1)+2/numel(3:2:N)*sum((2*X(3:2:N)-1-(0.3*X(1)^2*cos(24*pi*X(1)+4*(3:2:N)*pi/N)+0.6*X(1)).*cos(6*pi*X(1)+(3:2:N)*pi/N)).^2);
    g = 2-sqrt(X(1))+2/numel(2:2:N)*sum((2*X(2:2:N)-1-(0.3*X(1)^2*cos(24*pi*X(1)+4*(2:2:N)*pi/N)+0.6*X(1)).*sin(6*pi*X(1)+(2:2:N)*pi/N)).^2);
    h = 1-(f/g)^H;

    F = [f
        g*h];
    V = 0.0;
end

function [F,V] = HE9(X,t)
%% HE9
    X = X';
    N = 10;
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;
    f = X(1)+2/numel(3:2:N)*sum((X(3:2:N)-sin(6*pi*X(1)+(3:2:N)*pi/N)).^2);
    g = 2-X(1)^2+2/numel(2:2:N)*sum((X(2:2:N)-sin(6*pi*X(1)+(2:2:N)*pi/N)).^2);
    h = 1-(f/g)^H;

    F = [f
        g*h];
    V = 0.0;
end

function [F,V] = F5(X,t)
%% F5
%      X = X';
    N = 12;
    Fn = 2;
    X = X*5;%X取值范围是[0,5]
    H = 0.75*sin(pi*t)+1.25;
    a = 2*cos(pi*t)+2;
    b = 2*sin(pi*t)+2;
    Y(2:N) = X(2:N)-b-1+(abs(X(1)-a)).^(H+(2:N)/N);
    f1 = (abs(X(1)-a))^H+sum(Y(1:2:N).^2);
    f2 = (abs(X(1)-a-1))^H+sum((Y(2:2:N).^2));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = F6(X,t)
%% F6
%     X = X';
    N = 11;
    Fn = 2;
    X = X*5;%X取值范围是[0,5]
    H = 0.75*sin(pi*t)+1.25;
    a = 2*cos(1.5*pi*t)*sin(0.5*pi*t)+2;
    b = 2*cos(1.5*pi*t)*cos(0.5*pi*t)+2;
    Y(2:N) = X(2:N)-b-1+abs(X(1)-a).^(H+(2:N)/N);
    f1 = abs(X(1)-a)^H+sum(Y(1:2:end).^2);
    f2 = abs(X(1)-a-1)^H+sum((Y(2:2:end).^2));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = F7(X,t)
%% F7
%     X = X';
    N = 11;
    Fn = 2;
    X = X*5;%X取值范围是[0,5]
    H = 0.75*sin(pi*t)+1.25;
    a = 1.7*(1-sin(pi*t))*sin(pi*t)+3.4;
    b = 1.4*(1-sin(pi*t))*cos(pi*t)+2.1;
    Y(2:N) = X(2:N)-b-1+abs(X(1)-a).^(H+(2:N)/N);
    f1 = abs(X(1)-a)^H+sum(Y(1:2:end).^2);
    f2 = abs(X(1)-a-1)^H+sum((Y(2:2:end).^2));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = F8(X,t)
%% F8
%     X = X';
    N = 12;
    Fn = 3;
    X(3:end) = X(3:end)*3-1;%X(3:N)取值范围是[-1,2]
    G = sin(0.5*pi*t);
    H = 1.25+0.75*sin(pi*t);
    g = sum((X(3:end)-((X(1)+X(2))/2)^H-G).^2);
    f1 = (1+g)*cos(0.5*pi*X(1))*cos(0.5*pi*X(2));
    f2 = (1+g)*cos(0.5*pi*X(1))*sin(0.5*pi*X(2));
    f3 = (1+g)*sin(0.5*pi*X(1));
    F = [f1
        f2
        f3];
    V = 0.0;
end

function [F,V] = F9(X,t)
%% F9
%     X = X';
    N = 11;
    Fn = 2;
    X = X*5;%X取值范围是[0,5]
    H = 0.75*sin(pi*t)+1.25;
    a = 2*cos(pi*(t-floor(t)))+2;
    b = 2*sin(2*pi*(t-floor(t)))+2;
    Y(2:N) = X(2:N)-b-1+abs(X(1)-a).^(H+(2:N)/N);
    f1 = abs(X(1)-a)^H+sum(Y(1:2:end).^2);
    f2 = abs(X(1)-a-1)^H+sum((Y(2:2:end).^2));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = F10(X,t)
%% F10
%caculate T through t and the T_parameter
%因为在实验中的所有配置的nt只为10，因此只需要用t除以0.1就知道当时的T
    T = round(t*10);
%     X = X';
    N = 11;
    Fn = 2;
    X = X*5;%X取值范围是[0,5]
    H = 0.75*sin(pi*t)+1.25;
    a = 2*cos(pi*t)+2;
    b = 2*sin(2*pi*t)+2;
    if mod(T,2) == 0
        Y(2:N) = X(2:N)-b-1+abs(X(1)-a).^(H+(2:N)/N);
    else
        Y(2:N) = X(2:N)-b+abs(X(1)-a).^(H+(2:N)/N);
    end
    f1 = abs(X(1)-a)^H+sum(Y(1:2:end).^2);
    f2 = abs(X(1)-a-1)^H+sum((Y(2:2:end).^2));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF1(X,t)
    %% UDF1
    X = X';
    X(2:end) = X(2:end)*4-2;%X(2:N)取值范围是[-2,2]
    N = 10;
    Fn = 2;
    G = sin(0.5*pi*t);
    J1 = (3:2:N);J2 = (2:2:N);
    f1 = X(1)+2/length(J1)*sum((X(J1)-sin(6*pi*X(1)+J1*pi/N)-G).^2)+abs(G);
    f2 = 1-X(1)+abs(G)+2/length(J2)*sum((X(J2)-sin(6*pi*X(1)+J2*pi/N)-G).^2);
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF2(X,t)
    %% UDF2
    X = X';
    X(2:end) = X(2:end)*3-1;%X(2:N)取值范围是[-1,2]
    N = 10;
    Fn = 2;
    G = sin(0.5*pi*t);
    J1 = (3:2:N);J2 = (2:2:N);
    Y(2:N) = X(2:N)-X(1).^(0.5*(2+3*((2:N)-2)/(N-2)+G))-G;
    f1 = X(1)+abs(G)+2/length(J1)*sum(Y(J1).^2);
    f2 = 1-X(1)+abs(G)+2/length(J2)*sum(Y(J2).^2);
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF3(X,t)
    %% UDF3
    X = X';
    X(1)=0;
    N = 10;
    X(2:end) = X(2:end)*2-1;  %X(2:N)取值范围是[-1,1]
    j=2:1:N;
    X(2:end)=sin(6*pi*X(1)+j.*pi/N)
    
    Fn = 2;
    G = sin(0.5*pi*t);
    J1 = (3:2:N);J2 = (2:2:N);
    Y(2:N) = X(2:N)'-sin(6*pi*X(1)+(2:N)*pi/N);
  %  f1 = X(1)+max(0,(1/(2*N)+0.1)*(sin(2*N*pi*X(1)))) +2/length(J1)*(4*sum(2*Y(J1).^2)-2*prod(cos(20*pi*Y(J1)./sqrt(J1)))+2)
   % +abs(G);
    f1=X(1)+max(0,(1/2/N+0.1)*(sin(2*N*pi*X(1))-2*N*abs(G))) + 2/length(J1)*(4*sum(2*Y(J1).^2)-2*prod(cos(20*pi*Y(J1)./sqrt(J1)))+2).^2;
    f2 = 1-X(1)+max(0,(1/(2*N)+0.1)*(sin(2*N*pi*X(1))-2*N*abs(G)))+2/length(J2)*(4*sum(2*Y(J2).^2)-2*prod(cos(20*pi*Y(J2)./sqrt(J2)))+2).^2;
 %   f2 = 1-X(1)+max(0,(1/(2*N)+0.1)*(sin(2*N*pi*X(1))))+2/length(J2)*(4*sum(2*Y(J2).^2)-2*prod(cos(20*pi*Y(J2)./sqrt(J2)))+2)+abs(G);
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF4(X,t)
    %% UDF4
    X = X';
    X(2:end) = X(2:end)*2-1;  %X(2:N)取值范围是[-1,1]
    N = 10;
    Fn = 2;
    G = sin(0.5*pi*t);
    K = ceil(N*G);
    H = 0.5+abs(G);
    J1 = (3:2:N);J2 = (2:2:N);
    Y(2:N) = X(2:N)-sin(6*pi*X(1)+((2:N)+K)*pi/N)-G;
    f1 = X(1)+2/length(J1)*sum(Y(J1).^2);
    f2 = 1-H*X(1)^H+2/length(J2)*sum(Y(J2).^2);
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF5(X,t)
    %% UDF5
    X = X';
    X(2:end) = X(2:end)*3-1;  %X(2:N)取值范围是[-1,2]
    N = 10;
    Fn = 2;
    G = sin(0.5*pi*t);
    H = 0.5+abs(G);
    J1 = (3:2:N);J2 = (2:2:N);
    Y(2:N) = X(2:N)-X(1).^(0.5*(2+3*((2:N)-2)/(N-2)+G))-G;
    f1 = X(1)+2/length(J1)*sum(Y(J1).^2);
    f2 = 1-H*X(1)^H+2/length(J2)*sum(Y(J2).^2);
    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF6(X,t)

    %% UDF6
    X = X';
    X(1)=1;
    N = 10;
    X(2:end) = X(2:end)*2-1;  %X(2:N)取值范围是[-1,1]
    j=2:1:N;
    X(2:end)=sin(6*pi*X(1)+j.*pi/N)
   
    Fn = 2;
    G = sin(0.5*pi*t);
    H = 0.5+abs(G);
    J1 = (3:2:N);J2 = (2:2:N);
    Y(2:N) = X(2:N)'-sin(6*pi*X(1)+(2:N)*pi/N);
     f1=X(1)+(1/2/N+0.1)*abs((sin(2*N*pi*X(1))-2*N*abs(G))) + 2/length(J1)*sum((((2*Y(J1)).^2)-cos(4*pi*Y(J1))+1).^2);
%     f2 = 1-X(1)+max(0,(1/(2*N)+0.1)*(sin(2*N*pi*X(1))-2*N*abs(G)))+2/length(J2)*(4*sum(2*Y(J2).^2)-2*prod(cos(20*pi*Y(J2)./sqrt(J2)))+2).^2;
%     f1 = X(1)+(1/(2*N)+0.1)*abs(sin(2*N*pi*X(1)))+abs(G)+2/length(J1)*sum(2*Y(J1).^2-cos(4*pi*Y(J1))+1).^2;
  %  f2 = 1-X(1)+(1/(2*N)+0.1)*abs(sin(2*N*pi*X(1)))+abs(G)+2/length(J2)*sum(2*Y(J2).^2-cos(4*pi*Y(J2))+1).^2;
       f2 = 1-X(1)*(0.5+abs(G))+(1/(2*N)+0.1)*abs(sin(2*N*pi*X(1))-2*N*abs(G))+2/length(J2)*sum((((2*Y(J2)).^2)-cos(4*pi*Y(J2))+1).^2);

    F = [f1
        f2];
    V = 0.0;
end

function [F,V] = UDF7(X,t)
    %% UDF7
    X = X';
    X(3:end) = X(3:end)*4-2;  %X(3:N)取值范围是[-2,2]
    N = 10;
    Fn = 3;
    G = sin(0.5*pi*t);
    R = 1+abs(G);
    J1 = (5:3:N);J2 = (3:3:N);J3 = (4:3:N);
    Y(3:N) = X(3:N)-2*X(2)*sin(2*pi*X(1)+(3:N)*pi/N);
    f1 = R*cos(0.5*pi*X(1))*cos(0.5*pi*X(2))+G+2/length(J1)*sum(Y(J1)).^2;
    f2 = R*cos(0.5*pi*X(1))*sin(0.5*pi*X(2))+G+2/length(J2)*sum(Y(J2)).^2;
    f3 = R*sin(0.5*pi*X(1))+G+2/length(J3)*sum(Y(J3)).^2;
    F = [f1
        f2
        f3];
    V = 0.0;
end