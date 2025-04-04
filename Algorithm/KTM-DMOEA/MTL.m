function [Xs,Xt] = MTL(Xs,Xt)
options.d = 2;
options.rho = 1.0;
options.p = 10;
options.lambda = 10.0;
options.eta = 0.1;
options.T = 10;
%% Load algorithm options
    if ~isfield(options,'p')
        options.p = 10;
    end
    if ~isfield(options,'eta')
        options.eta = 0.1;
    end
    if ~isfield(options,'lambda')
        options.lambda = 1.0;
    end
    if ~isfield(options,'rho')
        options.rho = 1.0;
    end
    if ~isfield(options,'T')
        options.T = 10;
    end
    if ~isfield(options,'d')
        options.d = 2;
    end

    % Manifold feature learning
    [Xs_new,Xt_new,~] = GFK_Map(Xs,Xt,options.d);
    Xs = double(Xs_new);
    Xt = double(Xt_new);
end