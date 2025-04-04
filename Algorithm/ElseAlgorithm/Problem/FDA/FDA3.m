classdef FDA3 < handle
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
        function obj = FDA3(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = FDA3;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
                G = abs(sin(0.5*pi*t));
                g = 1 + G + sum((Dec(:,2:end)-G).^2,2);
                F = 10^(2*sin(0.5*pi*t));
                Obj(:,1) = Dec(:,1).^F;
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
        function P = PF(ft,nt,maxgen,preEvolution) %several PF with t  % PF changes, PS unchanges
            P1 = (0:1/(2000-1):1)';
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                t  = (i-1) * 1/nt;
                F = 10^(2*sin(0.5*pi*t));
                PP = P1.^F;
                G = abs(sin(0.5*pi*t));
                g = 1 + G;
                h = 1 - (PP./g).^0.5;
                P2 = g.*h;
                pf(:,1) = PP;
                pf(:,2) = P2;
                P(i) = struct('PF',pf);
            end 
        end
    end
end