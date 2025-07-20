classdef DMOP3 < handle
% <problem> <DMOP>
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
        function obj = DMOP3(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = DMOP3;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
                G = abs(sin(0.5*pi*t));
                Obj(:,1) = Dec(:,1);
                g = 1 + sum((Dec(:,2:end)-G).^2,2);  %%have problem
                h = 1 - (Obj(:,1)./g).^0.5;
                Obj(:,2) = g.*h;
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
        function P = PF(ft,nt,maxgen)  % PF unchanges, PS changes 
            pf(:,1) = (0:1/(1000-1):1)';
            pf(:,2) = 1 - pf(:,1).^0.5;
            P(1) = struct('PF',pf);
        end
    end
end