function res=getPopEle(pop,fname)
   for i=1:length(pop)
       res(i,:)=pop(i).(fname);
   end
end