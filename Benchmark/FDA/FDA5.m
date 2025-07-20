classdef FDA5 < handle
% <problem> <FDA>
% Dynamic MOP benchmark
% ft --- --- frequency of change
% nt --- --- severity of change

    properties(SetAccess = private)
        obj;  % the objective value
        dec;  % the decision vector
        con;  % the constraint violations
        add;  % Additional properties of the individual
    end
    methods
        %% Initialization
        function obj = FDA5(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = FDA5;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
                M      = 3;
                F = 1 + 100 * (sin(0.5*pi*t))^4;
                y = Dec(:,1:M-1).^F;
                G = abs(sin(0.5*pi*t));
                g = G + sum((Dec(:,M:end)-G).^2,2);
                Obj = repmat(1+g,1,M).*fliplr(cumprod([ones(size(g,1),1),cos(y(:,1:M-1)*pi/2)],2)).*[ones(size(g,1),1),sin(y(:,M-1:-1:1)*pi/2)];
              %% calculate constraint violations
                Con = zeros(size(Dec,1),1);
              %% generate population
                for i = 1 : length(obj)
                    obj(i).dec = Dec(i,:);
                    obj(i).obj = Obj(i,:);
                    obj(i).con = Con(i,:);
                end
                if nargin > 5
                    for i = 1 : length(obj)
                        obj(i).add = AddProper(i,:);
                    end
                end
            end
        end
          %% Get the matrix of decision variables of the population
        function value = decs(obj)
        %decs - Get the matrix of decision variables of the population.
            value = cat(1,obj.dec);
        end
        %% Get the matrix of objective values of the population
        function value = objs(obj)
        %objs - Get the matrix of objective values of the population.
            value = cat(1,obj.obj);
        end
        %% Get the matrix of constraint violations of the population
        function value = cons(obj)
        %cons - Get the matrix of constraint violations of the population.
            value = cat(1,obj.con);
        end
        function value = adds(obj,AddProper)
        %adds - Get the matrix of additional properties of the population.
            for i = 1 : length(obj)
                if isempty(obj(i).add)
                    obj(i).add = AddProper(i,:);
                end
            end
            value = cat(1,obj.add);
        end
    end
    methods (Static)
        %% Sample reference points on Pareto front
        function P = PF(ft,nt,maxgen,preEvolution)
            X = UniformPoint(1500,3);
            X = X./repmat(sqrt(sum(X.^2,2)),1,3);
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                t  = (i-1) * 1/nt;
                G = abs(sin(0.5*pi*t));
                g = 1 + G;
                pf = g.*X;
                P(i) = struct('PF',pf);
            end
        end
    end
end