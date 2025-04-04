function [n, Fn, Ft] = getFunc( funcname )
switch funcname
case 'FDA4'
    %% FDA4
    n = 12;
    Fn = 3;
    M = 3;

    G = @(t)abs(sin(pi*t/2));
    g = @(x,t)sum((x-G(t)).^2);
    Fhandles = {@(x,t)(1+g(x(M:n),t))*prod(cos(x(1:M-1)*pi/2)), ...
        @(x,t)(1+g(x(M:n),t))*prod(cos(x(1:M-2)*pi/2))*sin(x(M-1)*pi/2), ...
        @(x,t)(1+g(x(M:n),t))*sin(x(1)*pi/2)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'FDA5'
    %% FDA5
    n = 12;
    Fn = 3;
    M = 3;

    G = @(t)abs(sin(pi*t/2));
    g = @(x,t)G(t)+sum((x-G(t)).^2);
    F = @(t)1+100*sin(pi*t/2)^4;
    y = @(x,t)x.^F(t);
    Fhandles = {@(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-1), t)*pi/2)), ...
        @(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-2), t)*pi/2))*sin(y(x(M-1), t)*pi/2), ...
        @(x,t)(1+g(x(M:n),t))*sin(y(x(1),t)*pi/2)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'FDA5_iso'
    %% FDA5_iso
    n = 12;
    Fn = 3;
    M = 3;

    G = @(t)abs(sin(pi*t/2));
    B = .001;
    C = .05;
    g = @(x,t)G(t)+sum((min(0, floor(x-B)).*(G(t)*(B-x)/B-min(0,floor(C-x))*(1-G(t)).*(x-C)/(1-C))).^2);
    K = @(t)1+100*sin(pi*t/2)^4;
    y = @(x,t)x.^K(t);
    Fhandles = {@(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-1), t)*pi/2)), ...
        @(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-2), t)*pi/2))*sin(y(x(M-1), t)*pi/2), ...
        @(x,t)(1+g(x(M:n),t))*sin(y(x(1),t)*pi/2)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'FDA5_dec'
    %% FDA5_dec
    n = 12;
    Fn = 3;
    M = 3;

    G = @(t)abs(sin(pi*t/2));
    B = .001;
    C = .05;
    g = @(x,t)G(t)+sum(((floor(x-G(t)+B)*(1-C+(G(t)-B)/B)/(G(t)-B)+1/B+floor(G(t)+B-x)*(1-C+(1-G(t)-B)/B)/(1-G(t)-B)).*(abs(x-G(t))-B)+1).^2);
    K = @(t)1+100*sin(pi*t/2)^4;
    y = @(x,t)x.^K(t);
    Fhandles = {@(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-1), t)*pi/2)), ...
        @(x,t)(1+g(x(M:n),t))*prod(cos(y(x(1:M-2), t)*pi/2))*sin(y(x(M-1), t)*pi/2), ...
        @(x,t)(1+g(x(M:n),t))*sin(y(x(1),t)*pi/2)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'DIMP2'
    %% DIMP2   <--- [-2,2]
    n = 10;
    Fn = 2;

    G = @(i,t)sin(pi*t/2+2*pi*(i/(n+1))).^2;
    f = @(x)x;
    g = @(x, t)1+2*(n-1)+sum((4*x-2-G(2:n,t)).^2-2*cos(3*pi*(4*x-2-G(2:n,t))));
    h = @(f,g)1-sqrt(f/g);
    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t))};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'dMOP2'
    %% dMOP2
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    G = @(t)sin(pi*t/2);
    f = @(x)x;
    g = @(x, t)1+9*sum((x-G(t)).^2);
    h = @(f,g,t)1-(f/g)^H(t);
    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'dMOP2_iso'
    %% dMOP2_iso
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    B = .001;
    C = .05;
    G = @(t)sin(pi*t/2);
    f = @(x)x;
    g = @(x,t)1+9*sum((min(0, floor(x-B)).*(G(t)*(B-x)/B-min(0,floor(C-x))*(1-G(t)).*(x-C)/(1-C))).^2);
    h = @(f,g,t)1-(f/g)^H(t);
    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'dMOP2_dec'
    %% dMOP2_dec
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    B = .001;
    C = .05;
    G = @(t)sin(pi*t/2);
    f = @(x)x;
%   g = @(x,t)1+9*sum(((floor(x-G(t)+B)*(1-C+(G(t)-B)/B)/(G(t)-B)+1/B+floor(G(t)+B-x)*(1-C+(1-G(t)-B)/B)/(1-G(t)-B)).*(abs(x-G(t))-B)+1).^2);
    g = @(x,t)1+9*sum((((floor(x-G(t)+B)*(1-C+(G(t)-B)/B)/(G(t)-B)+1/B+floor(G(t)+B-x)*(1-C+(1-G(t)-B)/B)/(1-G(t)-B)).*(abs(x-G(t))-B)+1)-G(t)).^2);
    h = @(f,g,t)1-(f/g)^H(t);
    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'dMOP3'
    %% dMOP3
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    G = @(t)sin(pi*t/2);
    f = @(x)x;
    g = @(x, t)1+9*sum((x-G(t)).^2);
    h = @(f,g,t)1-sqrt(f/g);
    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);


case 'HE2'
    %% HE2
    n = 30;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    f = @(x)x;
    g = @(x, t)1+9*sum(x)/(n-1);
    h = @(f,g,t)1-sqrt(f/g)^H(t)-(f/g)^H(t)*sin(10*pi*f);

    Fhandles = {@(x,t)f(x(1)), ...
        @(x,t)g(x(2:end),t)*h(f(x(1)), g(x(2:end), t), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);
    F = @(x)Ft(x,t);


case 'HE7'
    %% HE7 <---- [-1,1]
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    f = @(x)x(1)+2/numel(3:2:n)*sum((2*x(3:2:n)-1-(0.3*x(1)^2*cos(24*pi*x(1)+4*(3:2:n)*pi/n)+0.6*x(1)).*cos(6*pi*x(1)+(3:2:n)*pi/n)).^2);      
    g = @(x)2-sqrt(x(1))+2/numel(2:2:n)*sum((2*x(2:2:n)-1-(0.3*x(1)^2*cos(24*pi*x(1)+4*(2:2:n)*pi/n)+0.6*x(1)).*sin(6*pi*x(1)+(2:2:n)*pi/n)).^2);
    
    h = @(f,g,t)1-(f/g)^H(t);

    Fhandles = {@(x,t)f(x), ...
        @(x,t)g(x)*h(f(x), g(x), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);

    
case 'HE9'
    %% HE9
    n = 10;
    Fn = 2;

    H = @(t)0.75*sin(pi*t/2)+1.25;
    f = @(x)x(1)+2/numel(3:2:n)*sum((x(3:2:n)-sin(6*pi*x(1)+(3:2:n)*pi/n)).^2);
    g = @(x)2-x(1)^2+2/numel(2:2:n)*sum((x(2:2:n)-sin(6*pi*x(1)+(2:2:n)*pi/n)).^2);
    h = @(f,g,t)1-(f/g)^H(t);

    Fhandles = {@(x,t)f(x), ...
        @(x,t)g(x)*h(f(x), g(x), t)};
    Ft = @(x,t)cellfun(@(c)c(x,t), Fhandles);

    
otherwise
    disp([funcname ' Not Found!'])
end
