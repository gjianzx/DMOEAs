classdef DF12 < handle
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
        function obj = DF12(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = DF12;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
              Kt = 10*sin(pi*t);
              g = 1 + sum((Dec(:,3:end)- sin(t*Dec(:,1))).^2,2) + abs(sin(floor(Kt*(2*Dec(:,1)-1))*pi/2).*sin(floor(Kt*(2*Dec(:,2)-1))*pi/2));

                Obj(:,1) = g.* (cos(0.5*pi*Dec(:,2)).*cos(0.5*pi*Dec(:,1))) ;
                Obj(:,2) = g.* (sin(0.5*pi*Dec(:,2)).*cos(0.5*pi*Dec(:,1)));
                Obj(:,3) = g.* (sin(0.5*pi*Dec(:,1)));
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
            X = UniformPoint(1000,3);
            X = X./repmat(sqrt(sum(X.^2,2)),1,3);
            X1 = asin(X(:,3))*2/pi;
            X2 = asin(X(:,2)./cos(0.5*pi*X1))*2/pi;
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                pf = [];
                t  = (i-1) / nt;
                Kt = 10*sin(pi*t); 
                g = 1+ abs(sin(floor(Kt*(2*X1-1))*pi/2).*sin(floor(Kt*(2*X2-1))*pi/2));
                pf   = X.*g ;
                pf(NDSort(pf,1)~=1,:) = [];
                P(i) = struct('PF',pf);
            end 
        end
    end
end