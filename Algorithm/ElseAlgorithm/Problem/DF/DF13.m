classdef DF13 < handle
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
        function obj = DF13(ft,nt,gen,Dec,preEvolution,AddProper)
            if nargin > 0
                N = size(Dec,1);
                obj(1,N) = DF13;
              %% calculate objective value
              if gen < preEvolution
                t = 0;
              else
                t = floor((gen-preEvolution)/ft+1)* 1/nt;
              end
              G = sin(0.5*pi*t);
              pt = floor(6*G);
              g = 1 +  sum((Dec(:,3:end)- G).^2,2); 
            Obj(:,1) = g.* (cos(0.5*pi*Dec(:,1)).^2)  ;
            Obj(:,2) = g.* (cos(0.5*pi*Dec(:,2)).^2)  ;
            Obj(:,3) = g.* (sin(0.5*pi*Dec(:,1)).^2 + sin(0.5*pi*Dec(:,1)).*cos(pt*pi*Dec(:,1)).^2) + (sin(0.5*pi*Dec(:,2)).^2 + sin(0.5*pi*Dec(:,2)).*cos(pt*pi*Dec(:,2)).^2) ;
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
            Dec = (0:1/(45-1):1)';
            X=[];
            for i = 1 : length(Dec)
                Reform=[];
                Reform(:,1) = repmat(Dec(i),length(Dec),1);
                Reform(:,2) = Dec;
                X = [X;Reform];
            end
            for i = 1 : ceil((maxgen-preEvolution)/ft+1)
                pf = [];
                t  = (i-1) / nt;
                G = sin(0.5*pi*t);
                pt = floor(6*G);
                pf(:,1) = (cos(0.5*pi*X(:,1)).^2) ;
                pf(:,2) = (cos(0.5*pi*X(:,2)).^2) ;
                pf(:,3) = (sin(0.5*pi*X(:,1)).^2 + sin(0.5*pi*X(:,1)).*cos(pt*pi*X(:,1)).^2) + (sin(0.5*pi*X(:,2)).^2 + sin(0.5*pi*X(:,2)).*cos(pt*pi*X(:,2)).^2) ;
                pf(NDSort(pf,1)~=1,:) = [];    
                P(i) = struct('PF',pf);
            end 
        end
    end
end