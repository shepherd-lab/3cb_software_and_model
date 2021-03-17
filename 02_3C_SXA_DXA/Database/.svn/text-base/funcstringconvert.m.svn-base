%convert s1 that can be a number or a string into a string of number
%characteres
function s2=funcstringconvert(s1,number);

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

s1=strcat(s1,'');
strsize=size(s1,2);
s2=strcat(s1,funcblank(number-strsize));
