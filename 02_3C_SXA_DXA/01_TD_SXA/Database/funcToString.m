%convert everything into a string
function s1=funcToString(s1);

if isa(s1,'cell')
    if iscellstr(s1)
       s1=char(s1);
    else 
       s1=cell2mat(s1);
   end
end
if isa(s1,'numeric')
   s1=num2str(s1);
end

