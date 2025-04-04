classdef DF5 < handle
% <problem> <DF>
% Dynamic MOP benchmark JY
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
        function obj = DF5(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = DF5;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
                G      = sin(0.5*pi*t);
                W      = floor(10*G);
                g      = 1 + sum((Dec(:,2:end)-G).^2,2);
                Obj(:,1) = g.*(Dec(:,1)+0.02*sin(W*pi*Dec(:,1)));
                Obj(:,2) = g.*(1-Dec(:,1)+0.02*sin(W*pi*Dec(:,1)));
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
            Dec = (0:1/(1000-1):1)';
            A      = 0.02;
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                t  = (i-1) / nt;
                G      = sin(0.5*pi*t);
                W      = floor(10*G);
                pf(:,1) = Dec(:,1) +A*sin(W*pi*Dec(:,1));
                pf(:,2) = 1-Dec(:,1)+A*sin(W*pi*Dec(:,1));
                P(i) = struct('PF',pf);
            end 
        end
    end
end