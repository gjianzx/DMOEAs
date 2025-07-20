classdef DF4 < handle
% <problem> <DF>
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
        function obj = DF4(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                [N, D] = size(Dec);
                obj(1,N) = DF4;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
                a = sin(0.5*pi*t);
                b = 1 + abs(cos(0.5*pi*t));
                H = 1.5 + a;
                No = 2:D;
                g = 1 + sum(((Dec(:,2:end).*No - a * Dec(:,1).^2)./No).^2,2);
                Obj(:,1) = g .* (abs(Dec(:,1)-a).^H) ;
                Obj(:,2) = g .* (abs(Dec(:,1)-a-b).^H);
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
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                t  = (i-1) / nt;
                a = sin(0.5*pi*t);
                H = 1.5+a;
                b = 1 + abs((1-a^2)^0.5);
                P1 = (0:(b^H)/(1000-1):b^H)';
                P2 = (b - P1.^(H^(-1))).^H;
                pf(:,1) = P1;
                pf(:,2) = P2 ;
                pf = real(pf);
                P(i) = struct('PF',pf);
            end 
        end
    end
end