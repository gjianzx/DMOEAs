function PopX_repair = Repair(PopX,Problem)
    m =Problem.NObj;            %num of objective Variables
    d = size(Problem.XLow,1);   %num of decision Variables
    VarMin = Problem.XLow;
    VarMax = Problem.XUpp;
    %%对Xs_learn,Xt_learn修复,边界检查
            for j=1:size(PopX,1)
                for i=1:d
                    if PopX(i,j)<VarMin(i)||PopX(i,j)>VarMax(i)
                    PopX(i,j) = VarMin(i)+(VarMax(i)-VarMin(i))*rand(1,1);
                    end
                end
            end
end