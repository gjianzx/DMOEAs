function [Population,boundary,V,N] = Individual(Problem,ft,nt,gen,N,preEvolution,Dec,AddProper)
% Generate Population of various problems
% Problem list: FDA  DMOP  JY  UDF
    switch Problem
        case 'FDA1'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,zeros(1,D-1)-1];
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = FDA1(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = FDA1(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = FDA1(ft,nt,gen,Dec,preEvolution);
            end
        case 'FDA2'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,zeros(1,D-1)-1];
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = FDA2(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = FDA2(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = FDA2(ft,nt,gen,Dec,preEvolution);
            end
        case 'FDA3'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,zeros(1,D-1)-1];
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = FDA3(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = FDA3(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = FDA3(ft,nt,gen,Dec,preEvolution);
            end
        case 'FDA4'  
            M = 3;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = FDA4(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = FDA4(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = FDA4(ft,nt,gen,Dec,preEvolution);
            end
        case 'FDA5'
            M = 3;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = FDA5(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = FDA5(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = FDA5(ft,nt,gen,Dec,preEvolution);
            end
        case 'DMOP1'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,zeros(1,D-1)-1];
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DMOP1(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DMOP1(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DMOP1(ft,nt,gen,Dec,preEvolution);
            end
        case 'DMOP2'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,zeros(1,D-1)-1];
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DMOP2(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DMOP2(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DMOP2(ft,nt,gen,Dec,preEvolution);
            end
        case 'DMOP3'
            M = 2;      D = 12;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DMOP3(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DMOP3(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DMOP3(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF1'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
%             boundary.lower  = [0,zeros(1,D-1)-1];
%             boundary.upper  = ones(1,D);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DF1(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF1(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF1(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF2'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DF2(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF2(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF2(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF3'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,1*(zeros(1,D-1)-1)];
            boundary.upper  = [1,2*ones(1,D-1)];
            if nargin == 7
                Population = DF3(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF3(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF3(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF4'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D)-2;
            boundary.upper  = 2*ones(1,D);
            if nargin == 7
                Population = DF4(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF4(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF4(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF5'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,1*(zeros(1,D-1)-1)];
            boundary.upper  = [1,1*ones(1,D-1)];
            if nargin == 7
                Population = DF5(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF5(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF5(ft,nt,gen,Dec,preEvolution);
            end  
        case 'DF6'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,1*(zeros(1,D-1)-1)];
            boundary.upper  = [1,1*ones(1,D-1)];
            if nargin == 7
                Population = DF6(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF6(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF6(ft,nt,gen,Dec,preEvolution);
            end  
        case 'DF7'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [1,zeros(1,D-1)];
            boundary.upper  = [4,ones(1,D-1)];
            if nargin == 7
                Population = DF7(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF7(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF7(ft,nt,gen,Dec,preEvolution);
            end  
        case 'DF8'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,1*(zeros(1,D-1)-1)];
            boundary.upper  = [1,1*ones(1,D-1)];
            if nargin == 7
                Population = DF8(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF8(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF8(ft,nt,gen,Dec,preEvolution);
            end  
        case 'DF9'
            M = 2;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,1*(zeros(1,D-1)-1)];
            boundary.upper  = [1,1*ones(1,D-1)];
            if nargin == 7
                Population = DF9(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF9(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF9(ft,nt,gen,Dec,preEvolution);
            end  
        case 'DF10'
            M = 3;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,0,1*(zeros(1,D-2)-1)];
            boundary.upper  = [1,1,1*ones(1,D-2)];
            if nargin == 7
                Population = DF10(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF10(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF10(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF11'
            M = 3;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = zeros(1,D);
            boundary.upper  = ones(1,D);
            if nargin == 7
                Population = DF11(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF11(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF11(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF12'
            M = 3;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,0,1*(zeros(1,D-2)-1)];
            boundary.upper  = [1,1,1*ones(1,D-2)];
            if nargin == 7
                Population = DF12(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF12(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF12(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF13'
            M = 3;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,0,1*(zeros(1,D-2)-1)];
            boundary.upper  = [1,1,1*ones(1,D-2)];
            if nargin == 7
                Population = DF13(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF13(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF13(ft,nt,gen,Dec,preEvolution);
            end
        case 'DF14'
            M = 3;      D = 10;
            [V,N] = UniformPoint(N,M);
            boundary.lower  = [0,0,1*(zeros(1,D-2)-1)];
            boundary.upper  = [1,1,1*ones(1,D-2)];
            if nargin == 7
                Population = DF14(ft,nt,gen,Dec,preEvolution);
            elseif nargin == 8
                Population = DF14(ft,nt,gen,Dec,preEvolution,AddProper);
            else
                % Generate initial population
                Dec = unifrnd(repmat(boundary.lower,N,1),repmat(boundary.upper,N,1));
                Population = DF14(ft,nt,gen,Dec,preEvolution);
            end
    end
end