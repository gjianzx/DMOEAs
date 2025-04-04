function ws = initialWeight3obj(H, m)
%INITIALWEIGHT3OBJ 此处显示有关此函数的摘要
%   此处显示详细说明
sequence = [];
for i=1:H
   sequence = [sequence 0]; 
end
for i=1:m-1
   sequence = [sequence 1]; 
end
ws = [];
pe_seq = perm(sequence);
for i=1:size(pe_seq,1)
    s = -1;
    wei = [];
    for j=1:size(pe_seq(i,:),2)
       if pe_seq(i,j)==1
           w = (j-1-s-1)/H;
           s = j-1;
           wei = [wei w];
       end
    end
    nw = (H+m-2-s)/H;
    wei = [wei nw];
    ws = [ws ; wei];

end

end

