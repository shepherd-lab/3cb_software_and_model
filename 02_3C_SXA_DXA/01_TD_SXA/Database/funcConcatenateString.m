%create a string that will be used in MenuOperator
function s=funcConcatenateString(Field);

tempstring='';
s='';
for index=1:size(Field,2);
   tempstring=funcstringconvert(Field(1,index),cell2mat(Field(2,index)));
   s=[s,tempstring];
end