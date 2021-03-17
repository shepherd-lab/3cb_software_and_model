function result = sumAvg(sumVec)
%sumAvg computes Sum Average
%Notation described in 'Feature Definition and Algorithm.docx'

n = length(sumVec);
result = 0;

for i = 1:n
    result = result + (i+1)*sumVec(i);
end
